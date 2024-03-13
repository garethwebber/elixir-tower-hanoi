defmodule HanoiWeb.Session.Purge do
  use GenServer
  require Logger

  @purge_gap 600000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
     purge_time = opts[:purge_time]
     Process.send_after(self(), :run_purge, @purge_gap)
     {:ok, purge_time}
  end

  def handle_info(:run_purge, purge_time) do
    games = Hanoi.TowerGame.show_games()
   
    old = games
          |> Enum.filter(&(filter_age(&1, purge_time)))
          |> Enum.map(&(purge_session(&1)))

    Process.send_after(self(), :run_purge, @purge_gap)

    {:noreply, purge_time}
  end

  defp filter_age(game_info, age_limit) do
    age = game_info[:age]
    cond do
      age > age_limit -> true
      true            -> false
    end
  end

  defp purge_session(game_info) do
    name = game_info[:name]
    pid = game_info[:pid] 
    Logger.info("Purging session #{name}")
    games = Hanoi.TowerGame.delete_game(pid)
  end

end
