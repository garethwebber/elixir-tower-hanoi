defmodule TowerHanoi.MixProject do
  use Mix.Project

  @version "0.6.0"
  @repo_url "https://github.com/garethwebber/elixir-tower-hanoi"

  def project do
    [
      app: :hanoi,
      escript: escript_config(),
      version: @version,
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Towers of Hanoi",
      source_url: @repo_url,
      start_permanent: Mix.env() == :prod,
      test_coverage: [summary: [threshhold: 80], ignore_modules: test_exclusions()],
      package: package(),
      aliases: aliases(),
      deps: deps(),
      docs: docs()
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      # This is the main module for the OTP application
      mod: {Hanoi.Application, []},
      extra_applications: [:logger, :logger_file_backend, :runtime_tools]
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
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:phoenix, "~> 1.7.10"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:plug_cowboy, "~> 2.5"}
    ]
  end

  defp escript_config do
    [
      # This is the run module for command-line
      main_module: TowerHanoi
    ]
  end

  defp test_exclusions do
    [
      # remove phx.new created files from test coverage stats 
      TowerHanoi,
      HanoiWeb,
      HanoiWeb.CoreComponents,
      HanoiWeb.ErrorHTML,
      HanoiWeb.Gettext,
      HanoiWeb.Layouts,
      HanoiWeb.Router,
      HanoiWeb.Endpoint,
      HanoiWeb.Telemetry
    ]
  end

  defp docs do
    [
      # Add the following files into the documents create by mix docs
      extras: ["README.md", "HOWTORUN.md", "LICENSE"],
      before_closing_body_tag: fn
        :html ->
          """
          <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
          <script>mermaid.initialize({startOnLoad: true})</script>
          """
        _ -> ""
      end
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
