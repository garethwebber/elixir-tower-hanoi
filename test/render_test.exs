defmodule RenderTest do
  use ExUnit.Case
  doctest TowerHanoi

  require Hanoi.Board
  require Hanoi.Render

  test "Test we can render state correctly" do
    board = %Hanoi.Board{ left: [1, 2], centre: [3] }
    expected_string = "State:\nL 2 1\nC 3\nR"

    output = Hanoi.Render.render_to_string(board)
    assert output == expected_string 
  end

end
