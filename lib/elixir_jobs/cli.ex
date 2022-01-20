defmodule ElixirJobs.CLI do
  def main(_) do
    professions = ElixirJobs.Utils.Parser.parse_professions(professions_path())
    jobs = ElixirJobs.Utils.Parser.parse_jobs(jobs_path())

    ElixirJobs.JobsTable.create(jobs, professions)
    |> ElixirJobs.JobsTable.prettify
    |> IO.puts()
  end

  defp jobs_path, do: Application.get_env(:elixir_jobs, :jobs_path, "")
  defp professions_path, do: Application.get_env(:elixir_jobs, :professions_path, "")
end
