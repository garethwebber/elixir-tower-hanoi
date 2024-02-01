defmodule Hanoi.Render do
  @moduledoc """
  Functions for converting the internal data representation to a 
  text-based human-readable format.

  Generally used by the command line application
  """
  
  @doc """
  Renders a board <struct> as a <String>. 
  """
  def render_to_string(board) do
    "\n" <>
      "L" <> reverse_to_string(board.left) <> "\n" <>
      "C" <> reverse_to_string(board.centre) <> "\n" <>
      "R" <> reverse_to_string(board.right)
  end

  defp reverse_to_string([]) do "" end 

  defp reverse_to_string(input) do
    [head | tail] = input
    reverse_to_string(tail) <> " #{head}"
  end
end
