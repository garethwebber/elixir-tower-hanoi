defmodule TowerHanoi do
  require Logger
  import Hanoi.Board

  def main(_argv) do
    IO.puts "Tower of Hanoi\n"
    start = System.system_time(:second) 
    board = create_board(5)
    Logger.info "State: #{inspect board}"
    runtime = System.system_time(:second) - start
    IO.puts "5 plates took #{runtime} seconds"
  end
end
