defmodule ElixirJobs.CLI do
  def main(_) do
    ElixirJobs.JobsTable.create()
    |> ElixirJobs.JobsTable.prettify
    |> IO.puts()
  end
end
