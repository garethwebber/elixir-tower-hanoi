defmodule HanoiWeb.Session.Purge do
  use GenServer
  require Logger
  @moduledoc """
  The game creates a TowerState GenServer process and ETS table per user-session.

  To make sure these don't build up over time, we check for last used time (created, or last move). Every
  purge_gap, a process runs looking for old sessions - that is last used > purge_time - and deletes them.
  """
alias Code.Identifier

  @purge_gap 600000

  @doc false
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @doc """
  Stores :purge_time in GenServer state. 
  Sends first message to :run_purge, starting the continuous purging cycle.
  """
  def init(opts) do
    purge_time = opts[:purge_time]
    Process.send_after(self(), :run_purge, @purge_gap)
    {:ok, purge_time}
  end

  @doc """
  Function collects all the current game sessions, filters by age and deletes old ones.
  It then calls itself creating continuous loop of purging.
  """
  def handle_info(:run_purge, purge_time) do
    Hanoi.TowerGame.show_games()
    |> Enum.filter(&filter_age(&1, purge_time))
    |> Enum.map(&purge_session(&1))

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
    Hanoi.TowerGame.delete_game(pid)
  end
end
