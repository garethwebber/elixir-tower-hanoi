defmodule HanoiWeb.HanoiGameRenderSupport do
   @moduledoc """
   Supporing functions for the main page rendering controller
   """

   @doc "Define the CSS needed to render the stones board"
   def render_css (stones) do
     height = (stones * 20) + 40

     """
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
          height:           #{height}px;
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
   def render_board(board, stones) do
      width = div(100, stones)

      "<div name=\"board\" class=\"board\">" <>
      
      "<div name=\"left\" class=\"pile\">"   <>
      render_pile(board.left, width)         <> 
      "</div>"                               <>

      "<div name=\"centre\" class=\"pile\">" <>
      render_pile(board.centre, width)       <> 
      "</div>"                               <>

      "<div name=\"right\" class=\"pile\">"  <>
      render_pile(board.right, width)        <> 
      "</div>"                               <>

      "</div>"
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
end
