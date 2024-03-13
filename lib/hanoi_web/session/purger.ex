defmodule HanoiWeb.Session.Purge do
  use GenServer
  require Logger

  @purge_gap 6000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
     purge_time = opts[:purge_time]
     Process.send_after(self(), :run_purge, @purge_gap)
     {:ok, purge_time}
  end

  def handle_info(:run_purge, state) do
    games = Hanoi.TowerGame.show_games()
    IO.inspect(games)

    Process.send_after(self(), :run_purge, @purge_gap)

    {:noreply, state}
  end

end
