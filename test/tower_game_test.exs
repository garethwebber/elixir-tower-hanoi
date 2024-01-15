defmodule TowerGameTest do
  use ExUnit.Case

  require Hanoi.TowerGame

  test "does server create board correctly" do
    name = :test_tower
    {:ok, _pid} = Hanoi.TowerGame.start_link(%{name: name, stones: 3})
    expected_state = %Hanoi.Board{left: [1,2,3], centre: [], right: []}
    expected_string = "\nL 3 2 1\nC\nR"

    output = Hanoi.TowerGame.get_state(name) 
    assert output == expected_state

    output_string = Hanoi.TowerGame.get_state_as_text(name)
    assert output_string == expected_string
  end
end
