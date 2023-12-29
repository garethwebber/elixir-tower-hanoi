defmodule TowerHanoi do
  import Hanoi.Board
  import Hanoi.Naive

  def main(_argv) do
    IO.puts "Tower of Hanoi\n"
    start = System.system_time(:second) 
   
    create_board(3)
    |> move_plates()
    
    runtime = System.system_time(:second) - start
    IO.puts "3 plates took #{runtime} seconds"
  end
end
