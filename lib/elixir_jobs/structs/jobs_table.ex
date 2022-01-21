defmodule ElixirJobs.JobsTable do
  defstruct header: [], body: []

  @type t :: %__MODULE__{
          header: list(String.t()),
          body: list(list(binary() | integer()))
        }

  @spec prettify(t()) :: String.t()
  @spec create() :: t()

  def prettify(table) do
    TableRex.quick_render!(table.body, table.header, "Available jobs overview")
  end

  def create() do
    jobs_stats = ElixirJobs.JobsStats.create()

    %__MODULE__{
      header: header(jobs_stats),
      body: body(jobs_stats)
    }
  end

  defp header(jobs_stats) do
    ["", "Total"] ++ Map.keys(jobs_stats["Unknown"])
  end

  defp body(jobs_stats) do
    jobs_stats
    |> Map.keys()
    |> build_lines_per_continents(jobs_stats)
    |> prepend_totals_line
  end

  defp build_lines_per_continents(continents, jobs_stats) do
    continents
    |> Enum.map(fn continent ->
      Map.values(jobs_stats[continent])
      |> prepend_total_counter
      |> build_line(continent)
    end)
  end

  defp prepend_total_counter(counters) do
    [Enum.sum(counters)] ++ counters
  end

  defp build_line(counters, name) do
    [name] ++ counters
  end

  defp prepend_totals_line(lines_per_continents) do
    [build_totals_line(lines_per_continents)] ++ lines_per_continents
  end

  defp build_totals_line(lines_per_continents) do
    Enum.zip(lines_per_continents)
    |> Enum.drop(1)
    |> Enum.map(fn counters_tuple ->
      counters_tuple
      |> Tuple.to_list()
      |> Enum.sum()
    end)
    |> build_line("Total")
  end
end
