defmodule HanoiWeb.Session.IdPlug do
  @behaviour Plug
  import Plug.Conn
  @moduledoc """
  This module plugs into the phoenix request handling and checks is a session_id exists. If it doesn't
  it creates one based on a 4-digit hexadecimal random number.

  A TowerState GenServer and ETS table are created per-session and use this id as their unique name.
  """

  @doc false
  @impl true
  def init(default), do: default

  @doc """
  Check session for an :session_id variable and create one if missing.
  """
  @impl true
  def call(conn, _config) do
    case get_session(conn, :session_id) do
      nil ->
        session_id = unique_session_id()
        put_session(conn, :session_id, session_id)

      _session_id ->
        conn
    end
  end

  defp unique_session_id() do
    :crypto.strong_rand_bytes(4) |> Base.encode16()
  end
end
