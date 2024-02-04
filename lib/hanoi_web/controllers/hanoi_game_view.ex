defmodule HanoiWeb.HanoiGameView do
   use HanoiWeb, :html
   use Phoenix.LiveView
   @moduledoc """
   Supporing functions for the main page rendering controller
   """

   @doc "Define the CSS needed to render the stones board"
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

   @doc "Renders the board as a pile of stones" 
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
   def render_pile([], _width) do
     "\n"
   end

   def render_pile(pile, width) do
     [head|tail] = pile
     render_stone(head, width) <> render_pile(tail, width) 
   end
   
   @doc "Render an individual stone in a pile"
   def render_stone(stone, width) do
      color = Integer.mod(stone, 4)
      stone_width = stone*width
      "<div name=\"st#{stone}\" class=\"stone\" 
              style=\"width:#{stone_width}%; background: var(--color#{color + 1})\"></div>"
   end
  
  @doc "Renders reset dropdown and button"
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

  @doc "Renders the demo automode block"
  def render_automode_control(assigns) do
    ~H"""
      <hr class="h-px my-8 bg-gray-200 border-0 dark:bg-gray-700">
      <.button class="bg-rose-700 hover:bg-rose-500" phx-click="auto_mode">Auto mode</.button>
    """
  end

end
