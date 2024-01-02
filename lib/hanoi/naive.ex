defmodule Hanoi.Naive do
  require Logger
  require Hanoi.Render

  @moduledoc """
  An algorithm solving the Towers of Hanoi problem by recursion. 
  """

  @doc """
  An algorithm to move stones between stacks by recursion 
  """
  def run_algo(board) do
    disk_numbers = length(board.left)
    IO.puts(Hanoi.Render.render_to_string(board))
    algo(board, disk_numbers, :left, :centre, :right)
  end

  defp algo(board, disk_numbers, source, auxilary, destination) do
    cond do
      disk_numbers == 1 ->
        {:ok, newboard} = move_stone(board, source, destination)
        newboard

      true ->
        intboard = algo(board, disk_numbers - 1, source, destination, auxilary)
        {:ok, newboard} = move_stone(intboard, source, destination)
        algo(newboard, disk_numbers - 1, auxilary, source, destination)
    end
  end

  @doc """
  Returns a new board with stone moved, or an error if an invalid move 
  """
  def move_stone(board, from, to) do
    case is_valid_move(board, from, to) do
      false ->
        Logger.error("Invalid move #{from}->#{to}")
        {:error, board}

      true ->
        {:ok, [head | tail]} = Map.fetch(board, from)
        {:ok, to_contents} = Map.fetch(board, to)

        intboard = Map.put(board, from, tail)
        newboard = Map.put(intboard, to, [head | to_contents])

        IO.puts(Hanoi.Render.render_to_string(newboard))
        {:ok, newboard}
    end
  end

  @doc """
  A move is valid if the stack moved to is empty, or has a larger stone on it
  """
  def is_valid_move(board, from, to) do
    case Map.fetch(board, to) == {:ok, []} do
      true ->
        true

      false ->
        {:ok, [from_head | _tail]} = Map.fetch(board, from)
        {:ok, [to_head | _tail]} = Map.fetch(board, to)

        from_head < to_head
    end
  end
end
