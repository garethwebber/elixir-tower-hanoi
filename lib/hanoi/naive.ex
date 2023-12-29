defmodule Hanoi.Naive do
  require Logger
  
  def move_stones(_board, stones) do
    algo(stones, :left, :centre, :right)
  end

  defp algo(disk_numbers, source, auxilary, destination) do
   cond do 
     disk_numbers == 1 -> Logger.info "#{source} -> #{destination}"
     true ->
       algo(disk_numbers - 1, source, destination, auxilary)
        Logger.info "#{source} -> #{destination}"
       algo(disk_numbers - 1, auxilary, source, destination)
    end
  end

end
