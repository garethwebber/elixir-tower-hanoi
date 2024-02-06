defmodule TowerHanoi do
  import Hanoi.CLI
  import Hanoi.Board
  import Hanoi.Algo

  @moduledoc """
  Command Line application version of the Tower of Hanoi.

  Sets up a board and then runs the algorithm. Just uses the domain model
  and alorithm, avoiding OTP.

  An alternative to the OTP Phoenix application
  """

  @doc """
  Main command-line entry point. Gets arguments parsed responds accordingly. 
  """
  def main(argv) do
    IO.puts("Tower of Hanoi")
    process(parse_args(argv))
  end

  defp process(:help) do
    IO.puts("Usage: tower_hanoi <stones>\n")
    IO.puts("Remember not to go to high. 20 takes 20 seconds and each extra")
    IO.puts("doubles that. Results are recorded in hanoi.log.\n")
  end

  defp process(stones) do
    timer = start_timer(:millisecond)

    create_board(stones)
    |> run_algo()

    IO.puts("\n#{stones} stones took #{get_runtime(timer)}.")
  end

  defp start_timer(time_period) do
    {time_period, System.system_time(time_period)}
  end

  defp get_runtime(timer) do
    {time_period, start_time} = timer

    "#{System.system_time(time_period) - start_time} #{time_period}(s)"
  end
end
