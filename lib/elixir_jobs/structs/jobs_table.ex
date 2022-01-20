defmodule ElixirJobs.JobsTable do
  defstruct header: [], body: []

  @type t :: %__MODULE__{
          header: list(String.t()),
          body: list(list(any))
        }

  @spec create() :: t()
  @spec prettify(t()) :: String.t()

  def create() do
    jobs_stats = ElixirJobs.JobsStats.create()

    %__MODULE__{
      header: ["", "Total"] ++ Map.keys(jobs_stats["Unknown"]),
      body: create_table_body(jobs_stats)
    }
  end

  def prettify(table) do
    TableRex.quick_render!(table.body, table.header, "Available jobs overview")
  end

  defp create_table_body(jobs_dict) do
    rows_by_continents =
      jobs_dict
      |> Map.keys()
      |> Enum.map(fn continent ->
        create_row(jobs_dict, continent)
      end)

    case length(rows_by_continents) do
      0 ->
        rows_by_continents

      _ ->
        total_row = create_total_row(rows_by_continents)
        [total_row] ++ rows_by_continents
    end
  end

  defp create_total_row(rows_by_continents) do
    [_ | values_by_categories] = Enum.zip(rows_by_continents)

    ["Total"] ++
      (values_by_categories
       |> Enum.map(fn values ->
         Enum.reduce(
           Tuple.to_list(values),
           0,
           fn v, acc -> acc + v end
         )
       end))
  end

  defp create_row(jobs_dict, continent) do
    [
      continent,
      jobs_dict[continent]
      |> Map.values()
      |> Enum.reduce(fn value, acc -> acc + value end)
    ] ++ Map.values(jobs_dict[continent])
  end
end
