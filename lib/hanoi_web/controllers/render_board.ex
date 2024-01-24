defmodule HanoiWeb.RenderBoard do

   def render_css (stones) do
     height = (stones * 20) + 40

     """
       <style>
       .stone {
          margin:            0 auto;
          height:            20px;
          background-color:  black;
          justify-content:   center
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
       </style>
      """
   end

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

   def render_pile([], width) do
     "\n"
   end

   def render_pile(pile, width) do
     [head|tail] = pile
     render_stone(head, width) <> render_pile(tail, width) 
   end

   def render_stone(stone, width) do
      stone_width = stone*width
      "<div name=\"st#{stone}\" class=\"stone\" style=\"width:#{stone_width}%\">aa</div>"
   end
end
