defmodule HanoiWeb.HanoiGameView do
  use HanoiWeb, :html
  use Phoenix.LiveView

  @moduledoc """
  Supporing functions for the main page rendering controller
  """

  @doc "Define the CSS needed to render the stones board"
  @spec render_css(assigns :: map()) :: struct() 
  def render_css(assigns) do
    ~H"""
     <style>
     .stone {
        margin:            0 auto;
        height:            20px;
        background-color:  --var(color2)
        justify-content:   center;
     }
     .pile {
        display:           inline;
        width:             33%;
        margin-top:        auto;
     }     
     .board {
        display:          flex;
        flex-direction:   row;
        width:            100%;
        height:           <%= (@number_stones * 20) + 40 %>px;
        border-bottom:    solid;
        padding:          0;
     }
      :root {
         --color1: #155263; 
         --color2: #ff6f3c; 
         --color3: #ff9a3c; 
         --color4: #ffc93c; 
      }
     </style>
    """
  end

  @doc "Show game instructions"
  @spec render_help_modal(assigns :: map()) :: struct() 
  def render_help_modal(assigns) do
     ~H"""
       <.modal id="help_modal">
         <span class="text:lg font-bold">
         <p>Rules of Towers of Hanoi</p></span>
         <span class="prose">
         <p>There are three piles of stones. You start with all the stones
         on the left pile. The goal is to move all the stones to the right
         pile.</p>
         <ul class="list-disc list-inside">
           <li>Stones must be moved one at a time.</li>
           <li>A larger stone cannot be placed on a smaller one.</li>
         </ul>
         <p>The goal is to complete the task in the smallest number
         of moves.</p>
         </span>
       </.modal>
     """
  end 

  @doc "Renders the board as a pile of stones"
  @spec render_board(assigns :: map()) :: struct() 
  def render_board(assigns) do
    ~H"""
      <!--<%= width = div(100, @number_stones) %>-->
      <div name="board" class="board">
      
      <div name="left" class="pile">   
      <%= Phoenix.HTML.raw(render_pile(@board.left, width)) %>       
      </div>                               

      <div name="left" class="pile">   
      <%= Phoenix.HTML.raw(render_pile(@board.centre, width)) %>       
      </div>                               

      <div name="left" class="pile">   
      <%= Phoenix.HTML.raw(render_pile(@board.right, width)) %>       
      </div>                               

      </div>
    """
  end

  @doc "Render each individual pile on the board"
  @spec render_pile(list(), pos_integer()) :: String.t()
  def render_pile([], _width) do
    "\n"
  end

  def render_pile(pile, width) do
    [head | tail] = pile
    render_stone(head, width) <> render_pile(tail, width)
  end

  @doc "Render an individual stone in a pile"
  @spec render_stone(integer(), pos_integer()) :: String.t()
  def render_stone(stone, width) do
    color = Integer.mod(stone, 4)
    stone_width = stone * width
    "<div name=\"st#{stone}\" class=\"stone\" 
              style=\"width:#{stone_width}%; background: var(--color#{color + 1})\"></div>"
  end

  @doc "Renders reset dropdown and button"
  @spec render_reset_block(assigns :: map()) :: struct() 
  def render_reset_block(assigns) do
    form = to_form(%{"stone" => 3})

    ~H"""
     <.form for={form} phx-update="ignore" phx-submit="reset">
       <div class="flex items-end items-center">
         <span>Stones:&nbsp;</span>
         <.input field={form[:stone]} 
                name="stone"
                type="select"
                options={["3", "4", "5", "6", "7", "8"]} /> 
        <.button>Reset</.button>
        </div>
      </.form>
    """
  end

  @doc "Renders any error messages"
  @spec render_error_text(assigns :: map()) :: struct() 
  def render_error_text(%{error_text: error_text} = assigns) do
    cond do
      error_text == nil ->
        ~H"""
          <p>&nbsp</p>
        """

      true ->
        ~H"""
          <p class="text-center">
            <span class="prose border border-red-500"> 
              &nbsp; 
              <.icon name="hero-exclamation-circle-mini" class="py-2.5 h-4 w-4 text-red-500"/>
              <%= @error_text  %>
              &nbsp;
            </span>
          </p>
        """
    end
  end

  @doc "Renders the current move count"
  @spec render_number_moves(assigns :: map()) :: struct() 
  def render_number_moves(%{completed: completed, number_moves: number_moves} = assigns) do
    case completed do
      false ->
        ~H"""
           <span class="prose">
             Number of moves: <%= @number_moves  %>
           </span>
        """
      true ->
        ~H"""
           <span class="prose border border-green-500">
             Congratulations you completed the game in <%= @number_moves  %> moves.
           </span>
        """
    end
  end

  @doc "Renders the controls for moving stones"
  @spec render_game_controls(assigns :: map()) :: struct() 
  def render_game_controls(%{auto_mode: auto_mode, completed: completed} = assigns) do
    ~H"""
     <hr class="h-px my-2 bg-gray-200 border-0 dark:bg-gray-700">

     <div class="flex py-1 gap-x-2 justify-between">
       <.button 
         disabled={@auto_mode || @completed}  
         class="disabled:bg-slate-200"
         phx-click="move_stone" phx-value-from="left" phx-value-to="centre"
         >Left to centre</.button>
       <.button 
         disabled={@auto_mode || @completed}  
         class="disabled:bg-slate-200"
         phx-click="move_stone" phx-value-from="centre" phx-value-to="left"
         >Centre to left</.button>
       <.button 
         disabled={@auto_mode || @completed}  
         class="disabled:bg-slate-200"
         phx-click="move_stone" phx-value-from="centre" phx-value-to="right"
         >Centre to right</.button>
       <.button 
         disabled={@auto_mode || @completed}  
         class="disabled:bg-slate-200"
         phx-click="move_stone" phx-value-from="right" phx-value-to="centre"
         >Right to centre</.button>
       </div>
       <div class="flex py-1 justify-between">
       <.button 
         disabled={@auto_mode || @completed}  
         class="disabled:bg-slate-200"
         phx-click="move_stone" phx-value-from="left" phx-value-to="right"
         >Left to right</.button>
       <.button 
         disabled={@auto_mode || @completed}  
         class="disabled:bg-slate-200"
         phx-click="move_stone" phx-value-from="right" phx-value-to="left"
         >Right to Left</.button>
     </div>
    """
  end

  @doc "Renders the demo automode block"
  @spec render_automode_control(assigns :: map()) :: struct() 
  def render_automode_control(%{auto_mode: auto_mode, 
                                completed: completed,
                                number_moves: number_moves} = assigns) do
    ~H"""
      <hr class="h-px my-2 bg-gray-200 border-0 dark:bg-gray-700">
      <div class="flex py-1 justify-between">
        <.button 
          disabled={@auto_mode || @completed || @number_moves > 0}  
          class="disabled:bg-slate-200"
          phx-click="auto_mode"
          >Auto mode</.button>
        <.button
          phx-click={show_modal("help_modal")}
          >Help</.button>
      </div>
    """
  end
end
