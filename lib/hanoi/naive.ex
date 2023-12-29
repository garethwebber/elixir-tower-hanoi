defmodule Hanoi.Naive do
  require Logger
  
  def move_stones(board) do
    disk_numbers = length(board.left)
    Logger.info "Processing #{disk_numbers} stones"
    Logger.info "State: #{inspect board}"
    algo(board, disk_numbers, :left, :centre, :right)
  end

  defp algo(board, disk_numbers, source, auxilary, destination) do
   cond do 
     disk_numbers == 1 -> Logger.info "#{source} -> #{destination}"
     true ->
       algo(board, disk_numbers - 1, source, destination, auxilary)
       Logger.info "#{source} -> #{destination}"
       algo(board, disk_numbers - 1, auxilary, source, destination)
    end
  end

end
