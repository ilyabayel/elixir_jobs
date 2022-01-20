defmodule ElixirJobs.Utils.Jobs do
  @type jobs :: list(ElixirJobs.Job.t())

  @doc """
    Find all jobs which office location matches area.
    latitude(deg), longitude (deg), radius (meters)

    ## Examples

      iex> all_jobs = [
      ...>    %ElixirJobs.Job{office_latitude: 90, office_longitude: 90},
      ...>    %ElixirJobs.Job{},
      ...>    %ElixirJobs.Job{}
      ...> ]
      iex> {latitiude, longitude, radius} = {0, 0, 10}
      iex> jobs_in_area = ElixirJobs.Utils.Jobs.find_by_location(all_jobs, {latitiude, longitude, radius})
      [%ElixirJobs.Job{}, %ElixirJobs.Job{}]
  """
  @spec find_by_location(jobs, {number(), number(), number()}) :: jobs
  def find_by_location(jobs, {latitude, longitude, radius}) do
    area = %Geocalc.Shape.Circle{latitude: latitude, longitude: longitude, radius: radius}

    jobs
    |> Enum.filter(fn job ->
      point = %{lat: job.office_latitude, lng: job.office_longitude}
      Geocalc.in_area?(area, point)
    end)
  end
end
