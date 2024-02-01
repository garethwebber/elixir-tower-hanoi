defmodule Hanoi.Application do
  @moduledoc """
  OTP Application that runs phoenix web app.

  Currently also loads HanoiGame supervision tree & Genserver. This may move to
  being started by the web app to allow multiple games to run in parallel.

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
      {Hanoi.TowerGame, name: :hanoi, stones: 3},
      # Start a worker by calling: Hanoi.Worker.start_link(arg)
      # {Hanoi.Worker, arg},
      # Start to serve requests, typically the last entry
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
