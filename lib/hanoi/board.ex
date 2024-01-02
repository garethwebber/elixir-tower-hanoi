defmodule Hanoi.Board do
  alias Hanoi.Board

  defstruct left: [],
            centre: [],
            right: []

  def create_board(stones) do
    %Board{left: create_loaded_stack(stones)}
  end

  def create_loaded_stack(stones) do
    create_stack_int([], stones)
  end

  defp create_stack_int(stack, 0) do
    stack
  end

  defp create_stack_int(stack, stonesleft) do
    create_stack_int([stonesleft | stack], stonesleft - 1)
  end
end
