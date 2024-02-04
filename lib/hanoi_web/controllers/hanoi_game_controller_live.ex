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
    {:ok, assign(socket, 
        state: state,
        number_moves: number_moves,
        number_stones: number_stones,
        error_text: nil
        )}
  end

  @doc "Render the page based on current state"
  def render(assigns) do
    ~H"""
        <.flash_group flash={@flash} />
        <main class="px-4 py-4 sm:px-6 lg:px-8">
          <div class="mx-auto max-w-xl lg:mx-0 flex justify-between">
            <div class="h-4"><.header>Hanoi</.header></div>
            <div class="flex flex-row h-4 w-64"><.render_reset_block/></div>
          </div>
          <div class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4 max-w-xl">
            <div>
              <p>Hanoi games with <%= @number_stones %> stones.</p>
              <.render_error_text error_text={@error_text} />
              <.render_css number_stones={@number_stones}/>
              <.render_board board={@state} number_stones={@number_stones}/>
              <.render_number_moves number_moves={@number_moves} />
              <.render_game_controls />
            </div>
          </div>
        </main>
    """
  end
  
  @doc "Handle the page clicks from the page"
  def handle_event("move_stone", %{"from" => from, "to" => to}, socket) do
    value = Hanoi.TowerGame.move_stone(:hanoi, 
                                        stone_name(from), stone_name(to))
    error_text= case value do
      :ok    -> nil
      :error -> "Invalid move #{from} -> #{to}"
    end

    {:noreply, assign(socket, 
        state: Hanoi.TowerGame.get_state(:hanoi),
        number_moves: Hanoi.TowerGame.get_number_moves(:hanoi),
        error_text: error_text 
        )}
  end

  def handle_event("reset", %{"stone" => stone}, socket) do

      {new_stones, _rest} = Integer.parse(stone) 
      Hanoi.TowerGame.reset(:hanoi, new_stones)

      {:noreply, assign(socket,
        state: Hanoi.TowerGame.get_state(:hanoi),
        number_moves: Hanoi.TowerGame.get_number_moves(:hanoi),
        error_text: nil 
        )}         
  end

  defp stone_name(name) do
    :"#{name}"
  end

end
