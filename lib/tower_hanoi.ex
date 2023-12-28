defmodule TowerHanoi do
  import Hanoi.Board

  def main(_argv) do
    IO.puts "Tower of Hanoi"
    IO.inspect create_board(5)
  end
end
