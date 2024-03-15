defmodule Hanoi.Board do
  alias Hanoi.Board

  @moduledoc """
  The domain model.

  The type and functions that define and create the domain data model
  """

  @typedoc """
  A hanoi board formed of three piles of stones.
  """
  defstruct left: [],
            centre: [],
            right: []

  @type t() :: %__MODULE__{
          left: list(),
          centre: list(),
          right: list()
        }

  @doc """
  Recommended way to set up the inital board with stones on left
  """
  @spec create_board(stones :: pos_integer()) :: Board.t()
  def create_board(stones) do
    %Board{left: create_loaded_stack(stones)}
  end

  @doc """
  Generally used by test code, set up stack of stones. You are required
  to set up your own board still.
  """
  @spec create_loaded_stack(stones :: pos_integer()) :: list()
  def create_loaded_stack(stones) do
    create_stack_int([], stones)
  end

  @doc """
  Returns true if the game is complete.
  That is all the stones are on the right pile in correct order
  """
  @spec is_complete(board :: Board.t(), stones :: pos_integer()) :: boolean()
  def is_complete(board, stones) do
    complete_board = %Board{right: create_loaded_stack(stones)}

    board == complete_board
  end

  defp create_stack_int(stack, 0) do
    stack
  end

  defp create_stack_int(stack, stonesleft) do
    create_stack_int([stonesleft | stack], stonesleft - 1)
  end
end
