defmodule HanoiWeb.HanoiGameControllerLive do
  use HanoiWeb, :html
  use Phoenix.LiveView
  import HanoiWeb.HanoiGameView

  @moduledoc """
  Controller that renders the main Hanoi game page

  Receives liveview events from the page and updates state accordingly

  Main page furniture is rendered here. The main board visual rendering 
  functions are in RenderBoard.

  <div class="mermaid">
  %%{init: {'theme':'dark'}}%%
  graph LR;
  classDef server fill:#709421,stroke:#AD9121,stroke-width:1px;
  classDef supervision fill:#D000FF,stroke:#D0B441,stroke-width:1px;
  classDef topic fill:#0059DF,stroke:#312378,stroke-width:1px;
  classDef db fill:#9E74BE,stroke:#4E1C74,stroke-width:1px;
  subgraph App
  T0(Application):::supervision
  end
  subgraph Session
  S1(IdPlug):::topic
  S2(Purger):::server
  end
  subgraph Web
  T2(Hanoi_GameControllerLive):::topic
  T3(Hanoi_GameView):::topic
  T4(CoreComponents):::topic
  end
  subgraph Server
  G1(TowerGame):::supervision;
  G2(TowerState):::server;
  end
  subgraph Algo
  T5(Board):::topic;
  T6(Algo):::topic;
  end
  T0(Application):::supervision --> T1{{Phoenix Webserver}}:::topic;
  T0(Application):::supervision --> S2(Purger):::server;
  T1{{Phoenix Webserver}}:::topic -- Controller --> T2(hanoi_game_controller_live):::topic;
  T1{{Phoenix Webserver}}:::topic --> S1(IdPlug):::topic
  T2(Hanoi_GameControllerLive):::topic -- View --> T3(HanoiGameView):::topic;
  T3(Hanoi_GameView):::topic --> T4(CoreComponents):::topic;
  T2(Hanoi_GameControllerLive):::topic -- Model --> G1(TowerGame):::supervision;
  S2(Purger):::server --> G1(TowerGame)
  G1(TowerGame):::supervision -- per game --> G2(TowerState):::server; 
  G2(TowerState):::server --> DB[("ETS#nbsp;")]:::db;
  G2(TowerState):::server --> T5(Board):::topic;
  G2(TowerState):::server --> T6(Algo):::topic;
  </div>
  """
alias Agent.Server
alias Logger.App
alias Agent.Server

  @doc "Set up initial liveview state"
  @spec mount(params :: Phoenix.LiveView.unsigned_params(), session :: map(), socket :: Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()} 
  def mount(_params, session, socket) do
    session_id = session["session_id"]
    Hanoi.TowerGame.add_game(session_id, 3)
    
    state = Hanoi.TowerGame.get_state(session_id)
    number_moves = Hanoi.TowerGame.get_number_moves(session_id)
    number_stones = Hanoi.TowerGame.get_number_stones(session_id)

    {:ok,
     assign(socket,
       session_id: session_id,
       state: state,
       number_moves: number_moves,
       number_stones: number_stones,
       error_text: nil,
       auto_mode: false,
       completed: false
     )}
  end

  @doc "Render the page based on current state"
  @spec render(assigns :: Phoenix.LiveView.Socket.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    %{active: concurrent_games, workers: _w, supervisors: _s, specs: _p} = Hanoi.TowerGame.count_games()
    ~H"""
        <.flash_group flash={@flash} />
        <main class="min-h-screen bg-slate-400 flex items-center justify-center">
          <div class="bg-white shadow-md rounded px-4 py-4 max-w-xl">
          <div class="flex justify-between">
            <div class="h-20 py-3"><.header>Towers of Hanoi</.header></div>
            <div class="flex flex-row w-48 h-20"><.render_reset_block/></div>
          </div>
          <div>
              <span class="prose">
                <p>Hanoi games with <%= @number_stones %> stones.</p>
              </span>

              <.render_error_text error_text={@error_text} />
              <.render_css number_stones={@number_stones}/>
              <.render_board board={@state} number_stones={@number_stones}/>

              <.render_number_moves completed={@completed} number_moves={@number_moves} />
              <.render_game_controls completed={@completed} auto_mode={@auto_mode} />

              <.render_automode_control 
                number_moves={@number_moves} 
                completed={@completed}
                auto_mode={@auto_mode}/>

              <.render_help_modal/>
              <p align="right">Current games:  <%= concurrent_games %></p>
            </div>
          </div>
        </main>
    """
  end

  @doc "Handle the auto_mode, move_stone & reset clicks from page"
  @spec handle_event(event :: binary(), Phoenix.LiveView.unsigned_params(), socket :: Phoenix.LiveView.Socket.t()) :: {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("move_stone", %{"from" => from, "to" => to}, socket) do
    session_id = socket.assigns()[:session_id]
    value = Hanoi.TowerGame.move_stone(session_id, stone_name(from), stone_name(to))

    error_text =
      case value do
        :ok -> nil
        :error -> "Invalid move #{from} -> #{to}"
      end

    {:noreply,
     assign(socket,
       state: Hanoi.TowerGame.get_state(session_id),
       number_moves: Hanoi.TowerGame.get_number_moves(session_id),
       completed: Hanoi.TowerGame.is_complete(session_id),
       error_text: error_text
     )}
  end

  # Creates a new board with X stones, and resets error_text and move_counter
  def handle_event("reset", %{"stone" => stone}, socket) do
    session_id = socket.assigns()[:session_id]
    {new_stones, _rest} = Integer.parse(stone)
    Hanoi.TowerGame.reset(session_id, new_stones)

    {:noreply,
     assign(socket,
       state: Hanoi.TowerGame.get_state(session_id),
       number_moves: Hanoi.TowerGame.get_number_moves(session_id),
       number_stones: new_stones,
       error_text: nil,
       completed: false,
       auto_mode: false
     )}
  end

  # Demo auto-mode: disables manual controls then moves stones automatically
  def handle_event("auto_mode", _params, socket) do
    session_id = socket.assigns()[:session_id]
    live_view_pid = self()

    socket
    |> start_async(:running_task, fn ->
      moves = Hanoi.TowerGame.get_moves(session_id)

      Enum.map(moves, fn {from, to} ->
        :timer.sleep(250)
        Hanoi.TowerGame.move_stone(session_id, from, to)
        send(live_view_pid, :refresh_board)
      end)
    end)

    {:noreply,
     assign(socket,
       error_text: "Running auto-mode",
       auto_mode: true
     )}
  end

  @doc "Handle the refresh_board messages triggered by auto_mode"
  @spec handle_info(msg :: term(), socket :: Phoenix.LiveView.Socket.t()) :: {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_info(:refresh_board, socket) do
    session_id = socket.assigns()[:session_id]
    {:noreply,
     assign(socket,
       state: Hanoi.TowerGame.get_state(session_id),
       number_moves: Hanoi.TowerGame.get_number_moves(session_id)
     )}
  end

  defp stone_name(name) do
    :"#{name}"
  end
end
