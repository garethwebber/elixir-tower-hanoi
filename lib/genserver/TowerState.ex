defmodule Hanoi.TowerState do
  @moduledoc false
  use GenServer
  require Logger

  def child_spec(opts) do
    %{
      id: opts[:name] || __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
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

  def move_stone(server, from, to) do
    GenServer.call(server, {:move_stone, from, to})
  end
 
  def init(opts) do
    {:ok, %{table: opts[:name], stones: opts[:stones]}, {:continue, :load}}
  end

  def handle_continue(:load, data) do
    true = :ets.insert(data.table, {:state, Hanoi.Board.create_board(data.stones)})
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
  
  def handle_call({:move_stone, from, to}, _sender, data) do
    with [{_key, state}] <- :ets.lookup(data.table, :state),
         {:ok, newstate} <- Hanoi.Naive.move_stone(state, from, to, false),
         true            <- :ets.insert(data.table, {:state, newstate})
    do 
      {:reply, :ok, data}
    else _ ->
      Logger.error("Move stone from #{from} to #{to} failed.")
      {:reply, :error, data}
    end
  end
end
