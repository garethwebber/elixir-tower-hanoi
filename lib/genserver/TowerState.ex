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
    {:ok, %{state: Hanoi.Board.create_board(3), opts: opts}}
  end

  def handle_call({:get_state}, _sender, data) do
    {:reply, data.state, data}
  end

  def handle_call({:get_state_as_text}, _sender, data) do
    {:reply, Hanoi.Render.render_to_string(data.state), data}
  end

  def handle_call({:move_stone, from, to}, _sender, data) do
    with {:ok, newstate} <- Hanoi.Naive.move_stone(data.state, from, to) do 
      newdata = %{data | :state => newstate}
      {:reply, :ok, newdata}
    else _ ->
      Logger.error("Move stone from #{from} to #{to} failed.")
      {:reply, :error, data}
    end
  end
end
