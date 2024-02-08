defmodule NaiveTest do
  use ExUnit.Case

  require Hanoi.Board
  require Hanoi.Algo

  test "does is_valid_mode allow a small on a large" do
    start = %Hanoi.Board{left: [2], centre: [3]}

    output = Hanoi.Algo.is_valid_move(start, :left, :centre)
    assert output == true
  end

  test "does is_valid_mode allow a stone on empty" do
    start = %Hanoi.Board{left: [2], centre: []}

    output = Hanoi.Algo.is_valid_move(start, :left, :centre)
    assert output == true
  end

  test "does is_valid_mode stop stacking large on small" do
    start = %Hanoi.Board{left: [3], centre: [2]}

    output = Hanoi.Algo.is_valid_move(start, :left, :centre)
    assert output == false
  end

  test "does is_valid_mode stop me moving a non-existant stone" do
    start = %Hanoi.Board{left: [], centre: [2]}

    output = Hanoi.Algo.is_valid_move(start, :left, :centre)
    assert output == false
  end

  test "does move_stone move a stone correctly" do
    start = %Hanoi.Board{left: [1, 3], centre: [2]}
    expected_end = %Hanoi.Board{left: [3], centre: [1, 2]}

    {:ok, output} = Hanoi.Algo.move_stone(start, :left, :centre, false)
    assert output == expected_end
  end

  test "does move_stone error on an incorrect move" do
    start = %Hanoi.Board{left: [3], centre: [2]}

    {value, _board} = Hanoi.Algo.move_stone(start, :left, :centre, false)
    assert value == :error
  end

  test "left column moves to right column" do
    start = %Hanoi.Board{left: [1, 2, 3]}
    expected_end = %Hanoi.Board{right: [1, 2, 3]}

    output = Hanoi.Algo.run_algo(start)
    assert output == expected_end
  end
end
