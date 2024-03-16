defmodule Hanoi.Application do
  @moduledoc """
  OTP Application supervises the game. 

  It starts 
  - the phoenix liveview web app
  - the TowerGame dynamic supervisor that creates and deletes individual games
  - the Session Purger that removes uused games after an hour

  Alternative entrypoint to the CLI module
  """

  use Application

  @doc "Application entrypoint"
  @impl true
  def start(_type, _args) do
    children = [
      HanoiWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:hanoi, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Hanoi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Hanoi.Finch},
      # Game server, session purger then page serving
      Hanoi.TowerGame,
      {HanoiWeb.Session.Purge, purge_time: 3600},
      HanoiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hanoi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HanoiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
