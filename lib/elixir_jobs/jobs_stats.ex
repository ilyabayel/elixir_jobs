defmodule ElixirJobs.JobsStats do
  alias ElixirJobs.Utils.Parser
  alias ElixirJobs.Utils.Continents

  @type t :: %{binary => %{binary => integer()}}

  @spec create :: t()
  @spec get_continents_professions_stats(Parser.jobs(), Parser.professions_dict()) :: t()
  @spec empty_continent_profession_map(Parser.professions_dict()) :: t()
  @spec increment_job_counter(t(), {binary(), binary()}) :: t()

  def create do
    professions = ElixirJobs.Utils.Parser.parse_professions(professions_path())
    jobs = ElixirJobs.Utils.Parser.parse_jobs(jobs_path())

    get_continents_professions_stats(jobs, professions)
  end

  @doc """
    Calculates number of jobs for Continent/Profession
  """
  def get_continents_professions_stats(jobs, professions) do
    jobs
    |> Enum.reduce(
      empty_continent_profession_map(professions),
      fn job, map ->
        continent = Continents.get_name_by_location({job.office_latitude, job.office_longitude})

        map
        |> increment_job_counter({continent, professions[job.profession_id]})
      end
    )
  end

  @doc """
    Creates empty [continent][profession] map
  """
  def empty_continent_profession_map(professions) do
    ElixirJobs.Utils.Continents.continents()
    |> Map.new(fn continent ->
      {continent,
       professions
       |> Map.values()
       |> Map.new(fn profession ->
         {profession, 0}
       end)}
    end)
  end

  @doc """
    Increments job counter inside JobsStats
  """
  def increment_job_counter(map, {continent, profession}) do
    map
    |> Map.update!(continent, fn counters_by_profession ->
      counters_by_profession
      |> Map.update!(profession, fn counter -> counter + 1 end)
    end)
  end

  defp jobs_path, do: Application.get_env(:elixir_jobs, :jobs_path, "")
  defp professions_path, do: Application.get_env(:elixir_jobs, :professions_path, "")
end
