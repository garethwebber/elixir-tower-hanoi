defmodule TowerGameTest do
  use ExUnit.Case

  require Hanoi.TowerGame

  test "does the server check its arguments" do
    # No name
    assert_raise ArgumentError, fn ->
      Hanoi.TowerGame.start_link(%{stones: 3})
    end

    # No stones
    assert_raise ArgumentError, fn ->
      Hanoi.TowerGame.start_link(%{name: :testname})
    end
  end

  test "does server create board correctly" do
    name = :test_tower
    {:ok, _pid} = Hanoi.TowerGame.start_link(%{name: name, stones: 3})
    expected_state = %Hanoi.Board{left: [1, 2, 3], centre: [], right: []}
    expected_string = "\nL 3 2 1\nC\nR"

    output = Hanoi.TowerGame.get_state(name)
    assert output == expected_state

    output_string = Hanoi.TowerGame.get_state_as_text(name)
    assert output_string == expected_string
  end

  test "does server move stone correctly" do
    name = :test_tower2
    {:ok, _pid} = Hanoi.TowerGame.start_link(%{name: name, stones: 4})
    before_string = "\nL 4 3 2 1\nC\nR"
    after_string = "\nL 4 3 2\nC\nR 1"

    before = Hanoi.TowerGame.get_state_as_text(name)
    assert before == before_string

    :ok = Hanoi.TowerGame.move_stone(name, :left, :right)

    after_s = Hanoi.TowerGame.get_state_as_text(name)
    assert after_s == after_string

    # This should fail
    value = Hanoi.TowerGame.move_stone(name, :left, :right)
    assert value = :error
  end

  test "does server run get moves correctly" do
    name = :test_tower3
    {:ok, _pid} = Hanoi.TowerGame.start_link(%{name: name, stones: 3})

    expect = [
      {:left, :right},
      {:left, :centre},
      {:right, :centre},
      {:left, :right},
      {:centre, :left},
      {:centre, :right},
      {:left, :right}
    ]

    moves = Hanoi.TowerGame.get_moves(name)
    assert expected = moves
  end
end
