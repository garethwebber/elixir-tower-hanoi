defmodule BoardTest do
  use ExUnit.Case
  doctest TowerHanoi

  require Hanoi.Board

  test "Test loaded stack created with 4 stones" do
    expected_end = [1, 2, 3, 4] 

    output = Hanoi.Board.create_loaded_stack(4)
    assert output == expected_end
  end

  test "Test board is set up with three stones" do
    expected_end = %Hanoi.Board{ left: [1, 2, 3] }

    output = Hanoi.Board.create_board(3)
    assert output == expected_end 
  end
end
