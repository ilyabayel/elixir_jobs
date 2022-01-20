defmodule ElixirJobs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    {:ok, jobs} = ElixirJobs.Utils.Parser.parse_jobs(jobs_path())

    children = [
      {Plug.Cowboy, scheme: :http, plug: ElixirJobs.Router, options: [port: cowboy_port()]},
      {ElixirJobs.JobsGenServer, jobs}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirJobs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:elixir_jobs, :cowboy_port, 8080)
  defp jobs_path, do: Application.get_env(:elixir_jobs, :jobs_path, "")
end
