defmodule Hanoi.Render do
  
  def render_to_string(board) do
    "State:\n" <>
    "L" <> reverse_to_string(board.left) <>"\n" <>
    "C" <> reverse_to_string(board.centre) <> "\n" <>
    "R" <> reverse_to_string(board.right) 
  end
  
  defp reverse_to_string([]) do "" end
  defp reverse_to_string(input) do
   [head|tail] = input 
   " #{head}" <> reverse_to_string(tail)
  end
end

