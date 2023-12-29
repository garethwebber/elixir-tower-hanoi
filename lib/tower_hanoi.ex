defmodule TowerHanoi do
  import Hanoi.CLI
  import Hanoi.Board
  import Hanoi.Naive

  def main(argv) do
    IO.puts "Tower of Hanoi"
    process(parse_args(argv))   
  end

  def process(:help) do
    IO.puts "Usage: tower_hanoi <stones>\n"
    IO.puts "Remember not to go to high. 20 takes 20 seconds and each extra"
    IO.puts "doubles that. Results are recorded in hanoi.log.\n"
  end

  def process(stones) do
     timer = System.system_time(:second)
     
     create_board(stones)
     |> move_stones()
     
     runtime = System.system_time(:second) - timer
     IO.puts "#{stones} took #{runtime} seconds"
  end

end
