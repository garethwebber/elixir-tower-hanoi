defmodule HanoiWeb.HanoiGameControllerLive do
  use HanoiWeb, :html
  use Phoenix.LiveView
  import HanoiWeb.HanoiGameRenderSupport, only: [render_css: 1, render_board: 1]
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
          <div class="mx-auto max-w-xl lg:mx-0 flex justify-between border">
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
  
  @doc "Renders reset options"
  def render_reset_block(assigns) do
    form = to_form(%{"stone" => 3})

    ~H"""
     <.simple_form for={form} phx-update="ignore" phx-submit="reset">
       <div class="flex items-end justify-between">
         <span>Stones:&nbsp;</span>
         <.input field={form[:stone]} 
                name="stone"
                type="select"
                options={["3", "4", "5", "6", "7", "8"]} /> 
        <.button>Reset</.button>
        </div>
      </.simple_form>
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
                 &nbsp; 
                 <.icon name="hero-exclamation-circle-mini" class="py-2.5 h-4 w-4 text-rose-500"/>
                 <%= @error_text  %>
                 &nbsp;
               </span></p><br />
             """
      end
  end

  @doc "Renders the current move count"
  def render_number_moves(assigns) do
    ~H"""
         <p>Number of moves: <%= @number_moves  %></p>
    """
  end

  @doc "Renders the controls for moving stones"
  def render_game_controls(assigns) do
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
