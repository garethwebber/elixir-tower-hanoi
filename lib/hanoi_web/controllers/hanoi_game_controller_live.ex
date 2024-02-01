defmodule HanoiWeb.HanoiGameControllerLive do
  use HanoiWeb, :html
  use Phoenix.LiveView
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
        <main class="px-4 py-4 sm:px-6 lg:px-8">
          <.header>Hanoi</.header>
          <.flash_group flash={@flash} />
          <div class="mx-auto max-w-xl lg:mx-0">
            <p>Hanoi games with <%= @number_stones %> stones.</p>
            <%= render_error_text(assigns) %>
            <%= render_stones(assigns) %>
            <%= render_number_moves(assigns) %>
            <.render_buttons />
          </div>
        </main>
    """
  end
  
  @doc "Renders any error messages"
  def render_error_text(%{error_text: error_text} = assigns) do
    cond do
      error_text == nil -> ~H"""
                              <p>&nbsp</p><br/>
                            """

      true  ->
            ~H"""
               <p align="center"><span style="color: #c51244; border: 1px solid #c51244 !important;">
                 &nbsp; <%= @error_text  %> &nbsp;
               </span></p><br />
             """
      end
  end

  @doc "Renders the piles of stones on the page"
  def render_stones(assigns) do
    ~H"""
       <%= Phoenix.HTML.raw(HanoiWeb.HanoiGameRenderSupport.render_css(@number_stones)) %>
       <%= Phoenix.HTML.raw(HanoiWeb.HanoiGameRenderSupport.render_board(@state, @number_stones)) %>
    """
  end

  @doc "Renders the current move count"
  def render_number_moves(assigns) do
    ~H"""
         <p>Number of moves: <%= @number_moves  %></p>
    """
  end

  @doc "Renders the controls for moving stones"
  def render_buttons(assigns) do
      ~H"""
        <table border="10">
        <tr><td>
        <.button phx-click="move_stone" phx-value-from="left" phx-value-to="centre">Left to centre</.button>
        </td><td>
        <.button phx-click="move_stone" phx-value-from="centre" phx-value-to="left">Centre to left</.button>
        </td><td>
        <.button phx-click="move_stone" phx-value-from="centre" phx-value-to="right">Centre to right</.button>
        </td><td>
        <.button phx-click="move_stone" phx-value-from="right" phx-value-to="centre">Right to centre</.button>
        </td></tr>
        <tr><td>
        <.button phx-click="move_stone" phx-value-from="left" phx-value-to="right">Left to right</.button>
        </td>
        <td></td><td></td>
        <td>
        <.button phx-click="move_stone" phx-value-from="right" phx-value-to="left">Right to Left</.button>
        </td></tr>
        </table>
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

  defp stone_name(name) do
    :"#{name}"
  end

end
