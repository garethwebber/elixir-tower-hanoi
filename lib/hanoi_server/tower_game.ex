defmodule Hanoi.TowerGame do
  use Supervisor

  @moduledoc """
  The main entry point for the Hanoi game. Runs as a supervisor and starts
  a GenServer to process work and an ETS instance to hold state. 
  """

  @doc false
  def child_spec(opts) do
    %{
      id: (opts[:name] || raise ArgumentError, "Cache name is required"),
      start: {__MODULE__, :start_link, [opts]},
    }
  end

  @doc """
  Call this function to start up the module. Name and Stones must be provided. 
  """
  def start_link(opts) do
    name = opts[:name] || raise ArgumentError, "Cache name is required"
    stones = opts[:stones] || raise ArgumentError, "Number of stones required"
    Supervisor.start_link(__MODULE__, opts, [name: name, stones: stones])
  end
  
  @doc """
  Function returning the current state of the hanoi board
  """
  def get_state(name) do
    Hanoi.TowerState.get_state(storage_name(name))
  end

  @doc """
  Debug function returning current state of hanoi board in a textual
  representation.
  """
  def get_state_as_text(name) do
    Hanoi.TowerState.get_state_as_text(storage_name(name))
  end

  @doc """
  Function returning the number of moves that have been played.
  """
  def get_number_moves(name) do
    Hanoi.TowerState.get_number_moves(storage_name(name))
  end

  @doc """
  Function that returns the number of stones on the board.
  """
  def get_number_stones(name) do
     Hanoi.TowerState.get_number_stones(storage_name(name))
  end
  
  @doc """
  Funtion that moves a stone between piles. 
  Will error if the stone is bigger than the one at the top of the pile.
  Increments moves taken.
  """
  def move_stone(name, from, to) do
    Hanoi.TowerState.move_stone(storage_name(name), from, to)
  end

  @doc """
  Function that for a board with all stones on left pile will move them
  in a legal way (no big stone on small stone) to the right hand pile
  """
  def get_moves(name) do
    Hanoi.TowerState.get_moves(storage_name(name))
  end

  @doc false
  def init(opts) do
    name = opts[:name]
    stones = opts[:stones]
    _table = :ets.new(storage_name(name), [:named_table, :public, :set])

    children = [
      {Hanoi.TowerState, [name: storage_name(name), stones: stones]},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp storage_name(name) do
    :"#{name}.Storage"
  end
end
