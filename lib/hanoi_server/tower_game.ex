defmodule Hanoi.TowerGame do
  use DynamicSupervisor

  @moduledoc """
  The Hanoi game as a public API & state.

  Runs as a supervisor and starts a GenServer to process work and an
  ETS instance to hold state. Usually run as part of an OTP application.

  Instances are removed by an independent periodic purger process.
  """

  @doc """
  Call this function to start up the module. Name and Stones must be provided. 
  """
  @spec start_link(opts :: list()) :: {:error, any()} | {:ok, pid()}
  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Function returning the current state of the hanoi board
  """
  @spec get_board_state(name :: atom()) :: Hanoi.Board.t()
  def get_board_state(name) do
    Hanoi.TowerState.get_board_state(storage_name(name))
  end

  @doc """
  Debug function returning current state of hanoi board in a textual
  representation.
  """
  @spec get_board_state_as_text(name :: atom()) :: String.t()
  def get_board_state_as_text(name) do
    Hanoi.TowerState.get_board_state_as_text(storage_name(name))
  end

  @doc """
  Function returning the number of moves that have been played.
  """
  @spec get_number_moves(name :: atom()) :: non_neg_integer()
  def get_number_moves(name) do
    Hanoi.TowerState.get_number_moves(storage_name(name))
  end

  @doc """
  Function that returns the number of stones on the board.
  """
  @spec get_number_stones(name :: atom()) :: non_neg_integer()
  def get_number_stones(name) do
    Hanoi.TowerState.get_number_stones(storage_name(name))
  end

  @doc """
  Funtion that moves a stone between piles. 
  Will error if the stone is bigger than the one at the top of the pile.
  Increments moves taken.
  """
  @spec move_stone(name :: atom(), from :: atom(), to :: atom()) :: :ok | :error
  def move_stone(name, from, to) do
    Hanoi.TowerState.move_stone(storage_name(name), from, to)
  end

  @doc """
  Funtion returns true if game is complete
  That is all stones in correct order on right hand pile
  """
  @spec is_complete(name :: atom()) :: boolean() | :error
  def is_complete(name) do
    Hanoi.TowerState.is_complete(storage_name(name))
  end

  @doc """
  Function that for a board with all stones on left pile will move them
  in a legal way (no big stone on small stone) to the right hand pile
  """
  @spec get_moves_to_win(name :: atom()) :: list() | :error
  def get_moves_to_win(name) do
    Hanoi.TowerState.get_moves_to_win(storage_name(name))
  end

  @doc """
  Restarts a game with a new number of stones on the board.
  Resets move count
  """
  @spec reset_game(name :: atom(), new_stones :: pos_integer()) :: :ok
  def reset_game(name, new_stones) do
    Hanoi.TowerState.reset_game(storage_name(name), new_stones)
  end

  @doc false
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Functions that adds another game
  A game is an ETS table and a genserver under supervision
  """
  @spec add_game(name :: atom, stones :: pos_integer()) :: atom() | tuple()
  def add_game(name, stones) do
    game_name = storage_name(name)

    child_spec = {Hanoi.TowerState, [id: game_name, name: game_name, stones: stones]}

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Function that terminates a session. Called by Session Purger for games where no move
  has been made for a while
  """
  @spec delete_game(pid :: pid()) :: :ok | {:error, :not_found}
  def delete_game(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  @doc """
  Functions that returns information on the games currently running

      [
        [class: Hanoi.TowerState, name: :Hanoi_91924B39, pid: #PID<0.486.0>, stones: 7, moves: 0, age: 152],
        [class: Hanoi.TowerState, name: :Hanoi_31148637, pid: #PID<0.515.0>, stones: 6, moves: 32, age: 83]
      ]
  """
  @spec show_games_state() :: Keyword.t()
  def show_games_state() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.map(fn {_a, pid, _type, _list} -> Hanoi.TowerState.get_game_state(pid) end)
  end

  @doc """
  Functions that returns how many games are currently running
  """
  @spec count_games() :: non_neg_integer()
  def count_games() do
  %{active: games, workers: _b, supervisors: _c, specs: _d} = DynamicSupervisor.count_children(__MODULE__)
    games
  end

  defp storage_name(name) do
    :"Hanoi_#{name}"
  end
end
