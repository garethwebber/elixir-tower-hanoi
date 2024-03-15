defmodule TowerSessionTest do
  use ExUnit.Case
  require Hanoi.TowerGame
  
  test "does purge work correctly" do
    before = Hanoi.TowerGame.count_games()
    IO.inspect(before, label: "before")
    
    Hanoi.TowerGame.add_game("first", 3)
    intermediate = Hanoi.TowerGame.count_games()
    assert intermediate = before + 1

    {return, pid} = GenServer.start_link(HanoiWeb.Session.Purge, 
                                         [purge_time: 0])
    assert :ok = return

    Process.send_after(pid, :run_purge, 0)
    :timer.sleep(100)
    last = Hanoi.TowerGame.count_games()
    IO.inspect(last, label: "last")
  end
end
