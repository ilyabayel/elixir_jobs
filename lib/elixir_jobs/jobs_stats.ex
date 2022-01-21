defmodule ElixirJobs.JobsStats do
  alias ElixirJobs.Utils.Parser
  alias ElixirJobs.Utils.Continents

  @type t :: %{binary => %{binary => integer()}}

  @spec create :: t()
  @spec count_jobs_stats(t(), Parser.jobs(), Parser.professions_dict()) :: t()
  @spec init_jobs_stats(Parser.professions_dict()) :: t()
  @spec increment_job_counter(t(), {binary(), binary()}) :: t()

  @doc """
    Creates and counts JobsStats
    JobsStats[continent][profession] = JobCounter
    %{
      "Continent" => %{
        "Profession" => 0
      }
    }
  """
  def create do
    professions_by_ids = ElixirJobs.Utils.Parser.parse_professions(professions_path())
    jobs = ElixirJobs.Utils.Parser.parse_jobs(jobs_path())

    init_jobs_stats(professions_by_ids)
    |> count_jobs_stats(jobs, professions_by_ids)
  end

  @doc """
    Counts Jobs and add to stats
  """
  def count_jobs_stats(initial_state, jobs, professions_by_ids) do
    jobs
    |> Enum.reduce(
      initial_state,
      fn job, current_state ->
        continent = Continents.get_by_location({job.office_latitude, job.office_longitude})
        profession = professions_by_ids[job.profession_id]

        increment_job_counter(current_state, {continent, profession})
      end
    )
  end

  @doc """
    Creates JobsStats with zero counters
  """
  def init_jobs_stats(professions_by_ids) do
    Continents.continents()
    |> Map.new(fn continent ->
      {continent,
       professions_by_ids
       |> Map.values()
       |> Map.new(fn profession ->
         {profession, 0}
       end)}
    end)
  end

  @doc """
    Increments Continent/Profession job counter
  """
  def increment_job_counter(current_state, {continent, profession}) do
    current_state
    |> Map.update!(continent, fn counters_by_profession ->
      counters_by_profession
      |> Map.update!(profession, fn counter -> counter + 1 end)
    end)
  end

  defp jobs_path, do: Application.get_env(:elixir_jobs, :jobs_path, "")
  defp professions_path, do: Application.get_env(:elixir_jobs, :professions_path, "")
end
