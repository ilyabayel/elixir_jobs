defmodule ElixirJobs.CLI do
  def main(args \\ []) do
    args
    |> parse_args()
    |> response()
    |> IO.puts()
  end

  defp parse_args(args) do
    {opts, word, _} =
      args
      |> OptionParser.parse(switches: [upcase: :boolean])

    {opts, List.to_string(word)}
  end

  defp response(_args) do
    {:ok, professions} = ElixirJobs.Parser.parse_professions()
    {:ok, jobs} = ElixirJobs.Parser.parse_jobs()

    ElixirJobs.JobsTable.create(jobs, professions)
    |> ElixirJobs.JobsTable.prettify
  end
end
