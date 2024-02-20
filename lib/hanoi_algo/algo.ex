defmodule Hanoi.Algo do
  require Logger
  require Hanoi.Render

  @moduledoc """
  An algorithm solving the Towers of Hanoi problem by recursion. 
  """

  @doc """
  An algorithm to get the list of moves to transfer stones by recursion
  """
  @spec get_moves(board :: Hanoi.Board.t()) :: {:ok, list()}
  def get_moves(board) do
    disk_numbers = length(board.left)
    {_board, moves} = moves_algo(board, [], disk_numbers, :left, :centre, :right, false)
    {:ok, Enum.reverse(moves)}
  end

  @doc """
  An algorithm to move stones between stacks by recursion 
  """
  @spec run_algo(board :: Hanoi.Board.t()) :: Hanoi.Board.t() 
  def run_algo(board) do
    disk_numbers = length(board.left)
    IO.puts(Hanoi.Render.render_to_string(board))
    {board, _moves} = moves_algo(board, [], disk_numbers, :left, :centre, :right, true)
    board
  end

  @doc """
  Returns a new board with stone moved, or an error if an invalid move 
  """
  @spec move_stone(board :: Hanoi.Board.t(), from :: atom(), to :: atom(), debug :: boolean()) :: { :ok | :error, Hanoi.Board.t()}
  def move_stone(board, from, to, debug) do
    with {:ok, newboard, _moves} <- record_stone_move(board, [], from, to, debug) do
      {:ok, newboard}
    else
      _ ->
        {:error, board}
    end
  end

  defp moves_algo(board, moves, disk_numbers, source, auxilary, destination, debug) do
    cond do
      disk_numbers == 1 ->
        {:ok, newboard, newmoves} = record_stone_move(board, moves, source, destination, debug)
        {newboard, newmoves}

      true ->
        {intboard, intmoves} =
          moves_algo(board, moves, disk_numbers - 1, source, destination, auxilary, debug)

        {:ok, newboard, newmoves} =
          record_stone_move(intboard, intmoves, source, destination, debug)

        moves_algo(newboard, newmoves, disk_numbers - 1, auxilary, source, destination, debug)
    end
  end

  defp record_stone_move(board, moves, from, to, debug) do
    case is_valid_move(board, from, to) do
      false ->
        Logger.error("Invalid move #{from}->#{to}")
        {:error, board, moves}

      true ->
        {:ok, [head | tail]} = Map.fetch(board, from)
        {:ok, to_contents} = Map.fetch(board, to)

        intboard = Map.put(board, from, tail)
        newboard = Map.put(intboard, to, [head | to_contents])

        if debug do
          IO.puts(Hanoi.Render.render_to_string(newboard))
        end

        {:ok, newboard, [{from, to} | moves]}
    end
  end

  @doc """
  A move is valid if the stone exists, the stack moved to is empty, 
  or has a larger stone on it
  """
  @spec is_valid_move(board :: Hanoi.Board.t(), from :: atom(), to :: atom()) :: boolean()
  def is_valid_move(board, from, to) do
    case Map.fetch(board, from) == {:ok, []} do
      # Stone doesn't exist
      true ->
        false

      false ->
        case Map.fetch(board, to) == {:ok, []} do
          # Move to enpty pile
          true ->
            true

          # Not empty but larger
          false ->
            {:ok, [from_head | _tail]} = Map.fetch(board, from)
            {:ok, [to_head | _tail]} = Map.fetch(board, to)

            from_head < to_head
        end
    end
  end
end
