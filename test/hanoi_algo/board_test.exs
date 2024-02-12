defmodule BoardTest do
  use ExUnit.Case

  require Hanoi.Board

  test "Test loaded stack created with 4 stones" do
    expected_end = [1, 2, 3, 4]

    output = Hanoi.Board.create_loaded_stack(4)
    assert output == expected_end
  end

  test "Test board is set up with three stones" do
    expected_end = %Hanoi.Board{left: [1, 2, 3]}

    output = Hanoi.Board.create_board(3)
    assert output == expected_end
  end

  test "Failed complete test" do
    test = Hanoi.Board.create_board(3)

    assert Hanoi.Board.is_complete(test, 3) == false 
  end

  test "Passed complete test" do
    test = %Hanoi.Board{right: [1, 2, 3]}

    assert Hanoi.Board.is_complete(test, 3) == true 
  end


    
end
