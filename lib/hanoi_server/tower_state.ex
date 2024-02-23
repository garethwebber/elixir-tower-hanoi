defmodule Hanoi.TowerState do
  @moduledoc false
  use GenServer
  require Logger

  def child_spec(opts) do
    %{
      id: opts[:name] || __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  @spec get_state(name :: atom()) :: Hanoi.Board.t()
  def get_state(server) do
    GenServer.call(server, {:get_state})
  end

  @spec get_state_as_text(name :: atom()) :: String.t()
  def get_state_as_text(server) do
    GenServer.call(server, {:get_state_as_text})
  end

  @spec get_number_moves(name :: atom()) :: non_neg_integer()
  def get_number_moves(server) do
    GenServer.call(server, {:get_number_moves})
  end

  @spec get_number_stones(name :: atom()) :: non_neg_integer()
  def get_number_stones(server) do
    GenServer.call(server, {:get_number_stones})
  end

  @spec move_stone(name :: atom(), from :: atom(), to :: atom()) :: :ok | :error
  def move_stone(server, from, to) do
    GenServer.call(server, {:move_stone, from, to})
  end

  @spec is_complete(name :: atom()) :: boolean() | :error
  def is_complete(server) do
   GenServer.call(server, {:is_complete}) 
  end

  @spec get_moves(name :: atom()) :: list() | :error
  def get_moves(server) do
    GenServer.call(server, {:get_moves})
  end

  @spec reset(name :: atom(), new_stones :: pos_integer()) :: :ok
  def reset(server, new_stones) do
    GenServer.call(server, {:reset, new_stones})
  end

  def init(opts) do
    {:ok, %{table: opts[:name], stones: opts[:stones]}, {:continue, :load}}
  end

  def handle_continue(:load, data) do
    true = :ets.insert(data.table, {:state, Hanoi.Board.create_board(data.stones)})
    true = :ets.insert(data.table, {:moves, 0})
    true = :ets.insert(data.table, {:stones, data.stones})
    Logger.info("Placed #{data.stones} stones onto #{data.table} board")
    {:noreply, data}
  end

  def handle_call({:get_state}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state) do
        {:reply, state, data}
    else
     _ ->
        {:reply, :error, data}
    end
  end

def handle_call({:get_state_as_text}, _sender, data) do
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
         true <- :ets.insert(data.table, {:moves, moves + 1}) do
      {:reply, :ok, data}
    else
      _ ->
        Logger.error("Move stone from #{from} to #{to} failed.")
        {:reply, :error, data}
    end
  end

  def handle_call({:is_complete}, _sender, data) do
    with [{_key, board}]  <- :ets.lookup(data.table, :state),
         [{_key, stones}] <- :ets.lookup(data.table, :stones) do  
      {:reply, Hanoi.Board.is_complete(board, stones), data}
    else
      _ -> 
        Logger.error("Failed to carry out complete check.")
        {:reply, :error, data}
    end
  end

  def handle_call({:reset, new_stones}, _sender, data) do
    true = :ets.insert(data.table, {:state, Hanoi.Board.create_board(new_stones)})
    true = :ets.insert(data.table, {:moves, 0})
    true = :ets.insert(data.table, {:stones, new_stones})
    Logger.info("Placed #{new_stones} stones onto #{data.table} board")
    {:reply, :ok, data}
  end

  def handle_call({:get_moves}, _sender, data) do
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
