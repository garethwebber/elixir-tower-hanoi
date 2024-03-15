defmodule TowerSessionTest do
  use ExUnit.Case
  require Hanoi.TowerGame
  
  test "does purge work correctly" do
    before = Hanoi.TowerGame.count_games()
   
    # This one will be purged, along with others holding on
    Hanoi.TowerGame.add_game("purger1", 4)
    intermediate = Hanoi.TowerGame.count_games()
    assert intermediate = before + 1

    # Allow age to be at least 1
    :timer.sleep(1000)

    # This one should survive purge
    Hanoi.TowerGame.add_game("purger2", 6)
 
    # Run the purge
    {return, pid} = GenServer.start_link(HanoiWeb.Session.Purge, 
                                         [purge_time: 0])
    assert :ok = return
    Process.send_after(pid, :run_purge, 0)
    # Allow message to process
    :timer.sleep(100)
    
    last = Hanoi.TowerGame.count_games()
    assert 1 = last
  end
end
