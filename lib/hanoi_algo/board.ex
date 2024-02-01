defmodule Hanoi.Board do
  alias Hanoi.Board
  
  @moduledoc """
  The domain model.

  The type and functions that define and create the domain data model
  """

  defstruct left: [],
            centre: [],
            right: []
  @doc """
  Recommended way to set up the inital board with stones on left
  """
  def create_board(stones) do
    %Board{left: create_loaded_stack(stones)}
  end

  @doc """
  Generally used by test code, set up stack of stones. You are required
  to set up your own board still.
  """
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
