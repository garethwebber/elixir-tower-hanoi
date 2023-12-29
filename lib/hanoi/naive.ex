defmodule Hanoi.Naive do
  require Logger
  require Hanoi.Render

  def move_stones(board) do
    disk_numbers = length(board.left)
    Logger.info "Processing #{disk_numbers} stones"
    Logger.info Hanoi.Render.render_to_string(board) 
    algo(board, disk_numbers, :left, :centre, :right)
  end

  defp algo(board, disk_numbers, source, auxilary, destination) do
   cond do 
     disk_numbers == 1 -> move_stone(board, source, destination) 
     true ->
       algo(board, disk_numbers - 1, source, destination, auxilary)
       move_stone(board, source, destination)
       algo(board, disk_numbers - 1, auxilary, source, destination)
    end
  end
  
  defp move_stone(board, from, to) do
    Logger.info "#{from} -> #{to}" 
    Logger.info Hanoi.Render.render_to_string(board)
  end

end
