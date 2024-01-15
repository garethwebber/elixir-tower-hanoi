defmodule CLITest do
  use ExUnit.Case

  import Hanoi.CLI

  test ":help returned when option passed" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "Integer returned when number passed" do
    assert parse_args(["15"]) == 15
  end

  test ":help returned when malformed input is passed" do
    assert parse_args(["--qq"]) == :help
  end
end
