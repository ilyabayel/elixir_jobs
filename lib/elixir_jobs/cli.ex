defmodule ElixirJobs.CLI do
  def main(args \\ []) do
    args
    |> parse_args
    |> response
    |> IO.inspect
  end

  defp parse_args(args) do
    {opts, word, _} =
      args
      |> OptionParser.parse(switches: [upcase: :boolean])

    {opts, List.to_string(word)}
  end

  defp response(_args) do
    {:ok, professions} = ElixirJobs.Utils.Parser.parse_professions(professions_path())
    {:ok, jobs} = ElixirJobs.Utils.Parser.parse_jobs(jobs_path())

    ElixirJobs.JobsTable.create(jobs, professions)
    |> ElixirJobs.JobsTable.prettify
  end

  defp jobs_path, do: Application.get_env(:elixir_jobs, :jobs_path, "")
  defp professions_path, do: Application.get_env(:elixir_jobs, :professions_path, "")
end
