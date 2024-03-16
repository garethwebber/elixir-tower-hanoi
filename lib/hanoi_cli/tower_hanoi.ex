defmodule TowerHanoi do
  import Hanoi.CLI
  import Hanoi.Board
  import Hanoi.Algo

  @moduledoc """
  Command Line application version of the Tower of Hanoi.

  Sets up a board and then runs the algorithm. Just uses the domain model
  and alorithm, avoiding OTP.

  An alternative to the OTP Phoenix application

  <div class="mermaid">
  graph TD;
  classDef server fill:#D0B441,stroke:#AD9121,stroke-width:1px;
  classDef supervision fill:#D000FF,stroke:#D0B441,stroke-width:1px;
  classDef topic fill:#B5ADDF,stroke:#312378,stroke-width:1px;
  classDef db fill:#9E74BE,stroke:#4E1C74,stroke-width:1px;
  subgraph CLI
  G1(TowerHanoi):::supervision; 
  T1(CLI):::topic; 
  end
  subgraph Algo
  T2(Board):::topic;
  T3(Algo):::topic;
  T4(Render):::topic; 
  end
  G1(TowerHanoi):::supervision ==> T1(CLI):::topic; 
  G1(TowerHanoi):::supervision ==> T2(Board):::topic;
  G1(TowerHanoi):::supervision ==> T3(Algo):::topic;
  G1(TowerHanoi):::supervision ==> T4(Render):::topic; 
  </div>
  """

  @doc """
  Main command-line entry point. Gets arguments parsed responds accordingly. 
  """
  @spec main(argv :: list(String.t())) :: :ok
  def main(argv) do
    IO.puts("Tower of Hanoi")
    process(parse_args(argv))
  end

  @spec process(stones :: atom() | pos_integer()) :: :ok
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

  @spec start_timer(unit :: atom()) :: {atom(), integer()}
  defp start_timer(time_period) do
    {time_period, System.system_time(time_period)}
  end

  @spec get_runtime({time_period :: atom(), start_time :: integer()}) :: String.t()
  defp get_runtime(timer) do
     {time_period, start_time} = timer
    
    "#{System.system_time(time_period) - start_time} #{time_period}(s)"
  end
end
