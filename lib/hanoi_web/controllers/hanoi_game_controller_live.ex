defmodule HanoiWeb.HanoiGameControllerLive do
  use HanoiWeb, :html
  use Phoenix.LiveView
  import HanoiWeb.HanoiGameView

  @moduledoc """
  Controller that renders the main Hanoi game page

  Receives liveview events from the page and updates state accordingly

  Main page furniture is rendered here. The main board visual rendering 
  functions are in RenderBoard.
  """

  @doc "Set up initial liveview state"
  def mount(_params, _, socket) do
    state = Hanoi.TowerGame.get_state(:hanoi)
    number_moves = Hanoi.TowerGame.get_number_moves(:hanoi)
    number_stones = Hanoi.TowerGame.get_number_stones(:hanoi)

    {:ok,
     assign(socket,
       state: state,
       number_moves: number_moves,
       number_stones: number_stones,
       error_text: nil,
       auto_mode: false
     )}
  end

  @doc "Render the page based on current state"
  def render(assigns) do
    ~H"""
        <.flash_group flash={@flash} />
        <main class="px-4 py-4 sm:px-6 lg:px-8">
          <div class="mx-auto max-w-xl lg:mx-0 flex justify-between">
            <div class="h-10 p-4"><.header>Hanoi</.header></div>
            <div class="flex flex-row h-4 w-64"><.render_reset_block/></div>
          </div>
          <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 max-w-xl">
            <div>
              <p>Hanoi games with <%= @number_stones %> stones.</p>

              <.render_error_text error_text={@error_text} />
              <.render_css number_stones={@number_stones}/>
              <.render_board board={@state} number_stones={@number_stones}/>

              <%= if @auto_mode == false do %>
                <.render_number_moves number_moves={@number_moves} />
                <.render_game_controls />
              <% end %>

              <%= if (@number_moves == 0) and (@auto_mode == false) do %>
                <.render_automode_control />
              <% end %>              

            </div>
          </div>
        </main>
    """
  end

  @doc "Handle the auto_mode, move_stone and reset clicks from the page"
  def handle_event("move_stone", %{"from" => from, "to" => to}, socket) do
    value = Hanoi.TowerGame.move_stone(:hanoi, stone_name(from), stone_name(to))

    error_text =
      case value do
        :ok -> nil
        :error -> "Invalid move #{from} -> #{to}"
      end

    {:noreply,
     assign(socket,
       state: Hanoi.TowerGame.get_state(:hanoi),
       number_moves: Hanoi.TowerGame.get_number_moves(:hanoi),
       error_text: error_text
     )}
  end

  # Creates a new board with X stones, and resets error_text and move_counter
  def handle_event("reset", %{"stone" => stone}, socket) do
    {new_stones, _rest} = Integer.parse(stone)
    Hanoi.TowerGame.reset(:hanoi, new_stones)

    {:noreply,
     assign(socket,
       state: Hanoi.TowerGame.get_state(:hanoi),
       number_moves: Hanoi.TowerGame.get_number_moves(:hanoi),
       number_stones: new_stones,
       error_text: nil,
       auto_mode: false
     )}
  end

  # Demo auto-mode: disables manual controls then moves stones automatically
  def handle_event("auto_mode", _params, socket) do
    live_view_pid = self()

    socket
    |> start_async(:running_task, fn ->
      moves = Hanoi.TowerGame.get_moves(:hanoi)

      Enum.map(moves, fn {from, to} ->
        :timer.sleep(250)
        Hanoi.TowerGame.move_stone(:hanoi, from, to)
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
  def handle_info(:refresh_board, socket) do
    {:noreply,
     assign(socket,
       state: Hanoi.TowerGame.get_state(:hanoi)
     )}
  end

  defp stone_name(name) do
    :"#{name}"
  end
end
