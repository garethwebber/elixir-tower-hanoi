defmodule TowerHanoi.MixProject do
  use Mix.Project

  def project do
    [
      app: :tower_hanoi,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.16",
      name: "Towers of Hanoi",
      source_url: "ihttps://github.com/garethwebber/elixir-tower-hanoi",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :logger_file_backend ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:logger_file_backend, "~> 0.0.10"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
    ]
  end
  defp escript_config do
    [
      main_module: TowerHanoi
    ]
  end
end
