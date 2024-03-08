defmodule TowerGameTest do
  use ExUnit.Case
  require Hanoi.TowerGame
  
  test "does server create board correctly" do
    name = :create_board
    Hanoi.TowerGame.addGame(name, 3)
    expected_state = %Hanoi.Board{left: [1, 2, 3], centre: [], right: []}
    expected_string = "\nL 3 2 1\nC\nR"

    output = Hanoi.TowerGame.get_state(name)
    assert output == expected_state

    output_string = Hanoi.TowerGame.get_state_as_text(name)
    assert output_string == expected_string
  end

  test "does server move stone correctly" do
    name = :move_stone
    Hanoi.TowerGame.addGame(name, 4)
    before_string = "\nL 4 3 2 1\nC\nR"
    after_string = "\nL 4 3 2\nC\nR 1"

    before = Hanoi.TowerGame.get_state_as_text(name)
    assert before == before_string
    before_moves = Hanoi.TowerGame.get_number_moves(name)

    :ok = Hanoi.TowerGame.move_stone(name, :left, :right)

    after_s = Hanoi.TowerGame.get_state_as_text(name)
    assert after_s == after_string

    after_moves = Hanoi.TowerGame.get_number_moves(name) 
    assert after_moves == (before_moves + 1)

    # This should fail
    assert Hanoi.TowerGame.move_stone(name, :left, :right) == :error
  end

  test "does server run get moves correctly" do
    name = :get_moves
    Hanoi.TowerGame.addGame(name, 3)
 
    expected = [
      {:left, :right},
      {:left, :centre},
      {:right, :centre},
      {:left, :right},
      {:centre, :left},
      {:centre, :right},
      {:left, :right}
    ]

    assert Hanoi.TowerGame.get_moves(name) == expected 
  end

  test "does server reset board correctly" do
    name = :server_reset
    Hanoi.TowerGame.addGame(name, 3)
    :ok = Hanoi.TowerGame.move_stone(name, :left, :right)
    
    expected_state = %Hanoi.Board{left: [2, 3], centre: [], right: [1]}
    assert Hanoi.TowerGame.get_state(name) == expected_state
    assert Hanoi.TowerGame.get_number_moves(name) == 1
    assert Hanoi.TowerGame.get_number_stones(name) == 3

    Hanoi.TowerGame.reset(name, 4)
 
    reset_state = %Hanoi.Board{left: [1, 2, 3, 4], centre: [], right: []}
    assert Hanoi.TowerGame.get_state(name) == reset_state
    assert Hanoi.TowerGame.get_number_moves(name) == 0
    assert Hanoi.TowerGame.get_number_stones(name) == 4
  end

  test "Does server failed complete test correctly" do
    name = :complete_fail
    Hanoi.TowerGame.addGame(name, 3)

    assert Hanoi.TowerGame.is_complete(name) == false 
  end

  test "Does server pass complete test correctly" do
    name = :complete_pass 
    Hanoi.TowerGame.addGame(name, 3)
    moves = Hanoi.TowerGame.get_moves(name) 

    Enum.map(moves, fn {from, to} ->
        Hanoi.TowerGame.move_stone(name, from, to)
    end)
    
    assert Hanoi.TowerGame.is_complete(name) == true 
  end

end
