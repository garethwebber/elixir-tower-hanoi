defmodule Hanoi.Naive do
  require Logger
  require Hanoi.Render

  @moduledoc """
  An algorithm solving the Towers of Hanoi problem by recursion. 
  """

  @doc """
  An algorithm to get the list of moves to transfer stones by recursion
  """
  def get_moves(board) do
    disk_numbers = length(board.left)
    {_board, moves} = moves_algo(board, [], disk_numbers, :left, :centre, :right)
    {:ok, Enum.reverse(moves)}
  end

  defp moves_algo(board, moves, disk_numbers, source, auxilary, destination) do
    cond do
      disk_numbers == 1 ->
        {:ok, newboard, newmoves} = record_stone_move(board, moves, source, destination)
        {newboard, newmoves}

      true ->
        {intboard, intmoves} = moves_algo(board, moves, disk_numbers - 1, source, destination, auxilary)
        {:ok, newboard, newmoves} = record_stone_move(intboard, intmoves, source, destination)
        moves_algo(newboard, newmoves, disk_numbers - 1, auxilary, source, destination)
    end
  end

  defp record_stone_move(board, moves, from, to) do
    case is_valid_move(board, from, to) do
      false ->
        Logger.error("Invalid move #{from}->#{to}")
        {:error, board, moves}

      true ->
        {:ok, [head | tail]} = Map.fetch(board, from)
        {:ok, to_contents} = Map.fetch(board, to)

        intboard = Map.put(board, from, tail)
        newboard = Map.put(intboard, to, [head | to_contents])
        
        {:ok, newboard, [{from, to} | moves]}
    end
  end

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
        {:ok, newboard} = move_stone(board, source, destination, true)
        newboard

      true ->
        intboard = algo(board, disk_numbers - 1, source, destination, auxilary)
        {:ok, newboard} = move_stone(intboard, source, destination, true)
        algo(newboard, disk_numbers - 1, auxilary, source, destination)
    end
  end

  @doc """
  Returns a new board with stone moved, or an error if an invalid move 
  """
  def move_stone(board, from, to, debug) do
    case is_valid_move(board, from, to) do
      false ->
        Logger.error("Invalid move #{from}->#{to}")
        {:error, board}

      true ->
        {:ok, [head | tail]} = Map.fetch(board, from)
        {:ok, to_contents} = Map.fetch(board, to)

        intboard = Map.put(board, from, tail)
        newboard = Map.put(intboard, to, [head | to_contents])

        if debug do
          IO.puts(Hanoi.Render.render_to_string(newboard))
        end
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
