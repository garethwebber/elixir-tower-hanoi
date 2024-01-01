defmodule NaiveTest do
  use ExUnit.Case
  doctest TowerHanoi

  require Hanoi.Board
  require Hanoi.Naive

  test "left column moves to right column" do
    start = %Hanoi.Board{ left: [1, 2, 3] } 
    expected_end = %Hanoi.Board{ right: [1, 2, 3] }

    output = Hanoi.Naive.move_stones(start)
    assert output == expected_end 
  end
end
