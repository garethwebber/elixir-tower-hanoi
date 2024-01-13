defmodule Hanoi.TowerGame do
  use Supervisor

  def child_spec(opts) do
    %{
      id: (opts[:name] || raise ArgumentError, "Cache name is required"),
      stones: (opts[:stones] || raise ArgumentError, "Number of stones required"),
      start: {__MODULE__, :start_link, [opts]},
    }
  end

  def start_link(opts) do
    name = opts[:name] || raise ArgumentError, "Cache name is required"
    stones = opts[:stones] || raise ArgumentError, "Number of stones required"
    Supervisor.start_link(__MODULE__, opts, [name: name, stones: stones])
  end

  def get_state(name) do
    Hanoi.TowerState.get_state(storage_name(name))
  end

  def get_state_as_text(name) do
    Hanoi.TowerState.get_state_as_text(storage_name(name))
  end
  
  def move_stone(name, from, to) do
    Hanoi.TowerState.move_stone(storage_name(name), from, to)
  end

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
