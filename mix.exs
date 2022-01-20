defmodule ElixirJobs.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_jobs,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirJobs.Application, []}
    ]
  end

  defp escript do
    [main_module: ElixirJobs.CLI]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_csv, "~> 1.1"},
      {:jason, "~> 1.2"},
      {:table_rex, "~> 3.1.1"},
      {:topo, "~> 0.4.0"},
      {:plug_cowboy, "~> 2.5.2"},
      {:geocalc, "~> 0.8"},
      {:castore, "~> 0.1.0"},
      {:mint, "~> 1.0"}
    ]
  end
end
