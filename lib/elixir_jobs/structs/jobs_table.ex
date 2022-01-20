defmodule ElixirJobs.JobsTable do
  defstruct header: [], body: []

  @type t :: %__MODULE__{
          header: list(String.t()),
          body: list(list(any))
        }

  @spec create(list(ElixirJobs.Job.t()), ElixirJobs.Utils.Parser.professions_dict()) :: t()
  @spec prettify(t()) :: String.t()

  def create(jobs, professions) do
    profession_categories =
      Map.values(professions)
      |> Enum.map(& &1.category_name)
      |> Enum.uniq()
      |> Enum.sort()
      |> Enum.concat(["Unknown"])

    profession_categories = profession_categories

    jobs_dict =
      jobs
      |> Enum.reduce(
        %{},
        &increment_job_counters(&1, &2, professions, profession_categories)
      )

    header = ["", "Total"] ++ profession_categories
    body = create_table_body(jobs_dict, profession_categories)

    %__MODULE__{
      header: header,
      body: body
    }
  end

  def prettify(table) do
    TableRex.quick_render!(table.body, table.header, "Available jobs overview")
  end

  defp create_table_body(jobs_dict, profession_categories) do
    rows_by_continents =
      jobs_dict
      |> Map.keys()
      |> Enum.map(fn continent ->
        create_row(jobs_dict, continent, profession_categories)
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

  defp create_row(jobs_dict, continent, profession_categories) do
    [continent] ++
      [get_total(jobs_dict, continent, profession_categories)] ++
      Enum.map(profession_categories, fn prof_category_name ->
        jobs_dict[continent][prof_category_name]
      end)
  end

  defp get_total(jobs_dict, continent, profession_categories) do
    Enum.reduce(profession_categories, 0, fn cat, acc ->
      acc + jobs_dict[continent][cat]
    end)
  end

  defp increment_job_counters(
         job,
         job_stats_by_continent,
         professions,
         profession_categories
       ) do
    continent =
      ElixirJobs.Utils.Continents.get_name_by_location({job.office_latitude, job.office_longitude})

    profession =
      Map.get(
        professions,
        job.profession_id,
        %ElixirJobs.Profession{category_name: "Unknown"}
      )

    jobs_counters_by_category =
      Map.get(
        job_stats_by_continent,
        continent,
        init_jobs_by_categories_dict(profession_categories)
      )

    Map.put(
      job_stats_by_continent,
      continent,
      increment_job_counter_by_category(jobs_counters_by_category, profession.category_name)
    )
  end

  defp init_jobs_by_categories_dict(profession_categories) do
    profession_categories
    |> Enum.reduce(%{}, fn category, acc -> Map.put(acc, category, 0) end)
  end

  defp increment_job_counter_by_category(jobs_counters_by_category, category) do
    old_job_counter = jobs_counters_by_category[category]

    jobs_counters_by_category
    |> Map.put(
      category,
      old_job_counter + 1
    )
  end
end
