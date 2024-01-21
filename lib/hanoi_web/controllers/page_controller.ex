defmodule HanoiWeb.ControllerLive do
  use Phoenix.LiveView
  require Logger

  def mount(_params, _, socket) do
    state = Hanoi.TowerGame.get_state(:hanoi) 
    {:ok, assign(socket, :state, state)}
  end

  def render(assigns) do
    Logger.info("Render")
    ~H"""
       <div class="lg:block">
        <pre>
          <%= Hanoi.Render.render_to_string(@state)  %>
        </pre>
        <button phx-click="move_stone" phx-value-from="left" phx-value-to="centre">Left to centre</button>
        <button phx-click="move_stone" phx-value-from="left" phx-value-to="right">Left to right</button>
      </div>
    """
  end
  
  def handle_event("move_stone", %{"from" => from, "to" => to}, socket) do
    Hanoi.TowerGame.move_stone(:hanoi, stone_name(from), stone_name(to))
    {:noreply, assign(socket, :state, Hanoi.TowerGame.get_state(:hanoi))}
  end

  defp stone_name(name) do
    :"#{name}"
  end

end
