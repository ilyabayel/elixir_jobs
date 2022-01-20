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
    {:ok, professions} = ElixirJobs.Parser.parse_professions("data/technical-test-professions.csv")
    {:ok, jobs} = ElixirJobs.Parser.parse_jobs("data/technical-test-jobs-test.csv")

    ElixirJobs.JobsTable.create(jobs, professions)
  end
end
