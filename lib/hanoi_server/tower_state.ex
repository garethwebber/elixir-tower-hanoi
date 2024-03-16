defmodule Hanoi.TowerState do
  use GenServer
  require Logger
  @moduledoc """
  Private API: GenServer providing the business logic for the game. Created by TowerGame along with 
  ETS table to hold state.
  """

  def child_spec(opts) do
    %{
      id: opts[:name] || __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end
  
  @doc """
  Call this function to start up the module. Name and Stones must be provided. 
  """
  @spec start_link(opts :: list()) :: {:error, any()} | {:ok, pid()}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  @doc """
  Returns the current state of the game, board, moves etc.
  """
  @spec get_game_state(name :: atom()) :: tuple()
  def get_game_state(server) do
    GenServer.call(server, {:get_game_state})
  end

  @doc """
  Function returning the current state of the hanoi board
  """
  @spec get_board_state(name :: atom()) :: Hanoi.Board.t()
  def get_board_state(server) do
    GenServer.call(server, {:get_board_state})
  end

  @doc """
  Debug function returning current state of hanoi board in a textual
  representation.
  """
  @spec get_board_state_as_text(name :: atom()) :: String.t()
  def get_board_state_as_text(server) do
    GenServer.call(server, {:get_board_state_as_text})
  end

  @doc """
  Function returning the number of moves that have been played.
  """
  @spec get_number_moves(name :: atom()) :: non_neg_integer()
  def get_number_moves(server) do
    GenServer.call(server, {:get_number_moves})
  end

  @doc """
  Function that returns the number of stones on the board.
  """
  @spec get_number_stones(name :: atom()) :: non_neg_integer()
  def get_number_stones(server) do
    GenServer.call(server, {:get_number_stones})
  end

  @doc """
  Funtion that moves a stone between piles. 
  Will error if the stone is bigger than the one at the top of the pile.
  Increments moves taken.
  """
  @spec move_stone(name :: atom(), from :: atom(), to :: atom()) :: :ok | :error
  def move_stone(server, from, to) do
    GenServer.call(server, {:move_stone, from, to})
  end

  @doc """
  Funtion returns true if game is complete
  That is all stones in correct order on right hand pile
  """
  @spec is_complete(name :: atom()) :: boolean() | :error
  def is_complete(server) do
    GenServer.call(server, {:is_complete})
  end

  @doc """
  Function that for a board with all stones on left pile will move them
  in a legal way (no big stone on small stone) to the right hand pile
  """
  @spec get_moves_to_win(name :: atom()) :: list() | :error
  def get_moves_to_win(server) do
    GenServer.call(server, {:get_moves_to_win})
  end

  @doc """
  Restarts a game with a new number of stones on the board.
  Resets move count
  """
  @spec reset_game(name :: atom(), new_stones :: pos_integer()) :: :ok
  def reset_game(server, new_stones) do
    GenServer.call(server, {:reset_game, new_stones})
  end

  @doc """
  Sets up basic state. Most of work completed in continuation asynchronously.
  """
  def init(opts) do
    _table = :ets.new(opts[:name], [:named_table, :public, :set])

    {:ok, %{table: opts[:name], stones: opts[:stones]}, {:continue, :load}}
  end

  @doc """
  Completes work of init asynchronously
  """
  def handle_continue(:load, data) do
    true = :ets.insert(data.table, {:state, Hanoi.Board.create_board(data.stones)})
    true = :ets.insert(data.table, {:moves, 0})
    true = :ets.insert(data.table, {:stones, data.stones})
    true = :ets.insert(data.table, {:created, DateTime.utc_now()})
    Logger.info("Placed #{data.stones} stones onto #{data.table} board")
    {:noreply, data}
  end

  @doc """
  Handles events
  """
  def handle_call({:get_game_state}, _sender, data) do
    with [{_key, stones}] <- :ets.lookup(data.table, :stones),
         [{_key, moves}] <- :ets.lookup(data.table, :moves),
         [{_key, created}] <- :ets.lookup(data.table, :created) do
      age = DateTime.diff(DateTime.utc_now(), created)

      {:reply,
       [class: __MODULE__, name: data.table, pid: self(), stones: stones, moves: moves, age: age],
       data}
    else
      _ -> {:reply, :error, data}
    end
  end

  def handle_call({:get_board_state}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state) do
      {:reply, state, data}
    else
      _ ->
        {:reply, :error, data}
    end
  end

  def handle_call({:get_board_state_as_text}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state) do
      {:reply, Hanoi.Render.render_to_string(state), data}
    else
      _ ->
        {:reply, :error, data}
    end
  end

  def handle_call({:get_number_moves}, _sender, data) do
    with [{_key, moves}] <- :ets.lookup(data.table, :moves) do
      {:reply, moves, data}
    else
      _ ->
        {:reply, :error, data}
    end
  end

  def handle_call({:get_number_stones}, _sender, data) do
    with [{_key, stones}] <- :ets.lookup(data.table, :stones) do
      {:reply, stones, data}
    else
      _ ->
        {:reply, :error, data}
    end
  end

  def handle_call({:move_stone, from, to}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state),
         {:ok, newstate} <- Hanoi.Algo.move_stone(state, from, to, false),
         true <- :ets.insert(data.table, {:state, newstate}),
         [{_key2, moves}] <- :ets.lookup(data.table, :moves),
         true <- :ets.insert(data.table, {:moves, moves + 1}),
         true <- :ets.insert(data.table, {:created, DateTime.utc_now()}) do
      {:reply, :ok, data}
    else
      _ ->
        Logger.error("Move stone from #{from} to #{to} failed.")
        {:reply, :error, data}
    end
  end

  def handle_call({:is_complete}, _sender, data) do
    with [{_key, board}] <- :ets.lookup(data.table, :state),
         [{_key, stones}] <- :ets.lookup(data.table, :stones) do
      {:reply, Hanoi.Board.is_complete(board, stones), data}
    else
      _ ->
        Logger.error("Failed to carry out complete check.")
        {:reply, :error, data}
    end
  end

  def handle_call({:reset_game, new_stones}, _sender, data) do
    true = :ets.insert(data.table, {:state, Hanoi.Board.create_board(new_stones)})
    true = :ets.insert(data.table, {:moves, 0})
    true = :ets.insert(data.table, {:stones, new_stones})
    Logger.info("Placed #{new_stones} stones onto #{data.table} board")
    {:reply, :ok, data}
  end

  def handle_call({:get_moves_to_win}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state),
         {:ok, moves} <- Hanoi.Algo.get_moves(state) do
      {:reply, moves, data}
    else
      _ ->
        Logger.error("Move algorithm failed.")
        {:reply, :error, data}
    end
  end
end
