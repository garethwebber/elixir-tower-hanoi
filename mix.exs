defmodule TowerHanoi.MixProject do
  use Mix.Project

  @version "0.2.0" 
  @repo_url "https://github.com/garethwebber/elixir-tower-hanoi"

  def project do
    [
      app: :tower_hanoi,
      escript: escript_config(),
      version: @version,
      elixir: "~> 1.16",
      name: "Towers of Hanoi",
      source_url: @repo_url,
      start_permanent: Mix.env() == :prod,
      test_coverage: [summary: [threshhold: 80],  ignore_modules: [TowerHanoi]],
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :logger_file_backend]
    ]
  end

  defp package do
    [
      description: "Towers of Hanoi library",
      maintainers: ["Gareth Webber"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @repo_url},
      files: ~w(lib mix.exs *.md)
    ]
  end

  defp deps do
    [
      {:logger_file_backend, "~> 0.0.10"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp escript_config do
    [
      main_module: TowerHanoi
    ]
  end

  defp docs do
    [
      extras: ["README.md", "LICENSE"]
    ]
  end
end
