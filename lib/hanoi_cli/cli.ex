defmodule Hanoi.CLI do
  @moduledoc """
  Command line application processing for CLI application 
  """

  @doc """
  Parses command like argumennts and returns number of stones, or help. 
  """
  @spec parse_args(argv :: list(String.t())) :: pos_integer() | atom()
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> process_args()
  end

  defp process_args([stones]) do
    case Integer.parse(stones) do
      :error -> :help
      {value, _remainder} -> value
    end
  end

  defp process_args(_) do
    :help
  end
end
