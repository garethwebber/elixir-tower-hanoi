defmodule TowerHanoiTest do
  use ExUnit.Case
  doctest TowerHanoi

  test "greets the world" do
    assert TowerHanoi.hello() == :world
  end
end
