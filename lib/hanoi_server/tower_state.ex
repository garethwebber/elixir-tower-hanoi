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

  def get_state(server) do
    GenServer.call(server, {:get_state})
  end

  def get_state_as_text(server) do
    GenServer.call(server, {:get_state_as_text})
  end

  def get_number_moves(server) do
    GenServer.call(server, {:get_number_moves})
  end

  def get_number_stones(server) do
    GenServer.call(server, {:get_number_stones})
  end

  def move_stone(server, from, to) do
    GenServer.call(server, {:move_stone, from, to})
  end

  def get_moves(server) do
    GenServer.call(server, {:get_moves})
  end

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
    case :ets.lookup(data.table, :state) do
      [{_key, state}] ->
        {:reply, state, data}

      [] ->
        {:reply, :error, data}
    end
  end

  def handle_call({:get_state_as_text}, _sender, data) do
    case :ets.lookup(data.table, :state) do
      [{_key, state}] ->
        {:reply, Hanoi.Render.render_to_string(state), data}

      [] ->
        {:reply, :error, data}
    end
  end

  def handle_call({:get_number_moves}, _sender, data) do
    case :ets.lookup(data.table, :moves) do
      [{_key, moves}] ->
        {:reply, moves, data}

      [] ->
        {:reply, :error, data}
    end
  end

  def handle_call({:get_number_stones}, _sender, data) do
    case :ets.lookup(data.table, :stones) do
      [{_key, stones}] ->
        {:reply, stones, data}

      [] ->
        {:reply, :error, data}
    end
  end

  def handle_call({:move_stone, from, to}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state),
         {:ok, newstate} <- Hanoi.Naive.move_stone(state, from, to, false),
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

  def handle_call({:reset, new_stones}, _sender, data) do
    true = :ets.insert(data.table, {:state, Hanoi.Board.create_board(new_stones)})
    true = :ets.insert(data.table, {:moves, 0})
    true = :ets.insert(data.table, {:stones, new_stones})
    Logger.info("Placed #{new_stones} stones onto #{data.table} board")
    {:reply, :ok, data}
  end

  def handle_call({:get_moves}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state),
         {:ok, moves} <- Hanoi.Naive.get_moves(state) do
      {:reply, moves, data}
    else
      _ ->
        Logger.error("Move algorithm failed.")
        {:reply, :error, data}
    end
  end
end
