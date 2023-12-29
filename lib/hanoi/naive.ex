defmodule Hanoi.Naive do
  require Logger
  require Hanoi.Render

  def move_stones(board) do
    disk_numbers = length(board.left)
    Logger.info Hanoi.Render.render_to_string(board) 
    algo(board, disk_numbers, :left, :centre, :right)
  end

  defp algo(board, disk_numbers, source, auxilary, destination) do
   cond do 
     disk_numbers == 1 -> 
        move_stone(board, source, destination) 
     true ->
       intboard = algo(board, disk_numbers - 1, source, destination, auxilary)
       newboard = move_stone(intboard, source, destination)
       algo(newboard, disk_numbers - 1, auxilary, source, destination)
    end
  end

  
  defp move_stone(board, from, to) do
    {:ok, [head|tail]} = Map.fetch(board, from) 
    {:ok, to_contents} = Map.fetch(board, to)

    Logger.info "Moving #{head} from  #{from} -> #{to}" 
    
    intboard = Map.put(board, from, tail)
    newboard = Map.put(intboard, to, [head|to_contents])

    Logger.info Hanoi.Render.render_to_string(newboard)
    newboard
  end

end
