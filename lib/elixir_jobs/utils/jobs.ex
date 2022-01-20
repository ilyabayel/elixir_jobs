defmodule ElixirJobs.Utils.Jobs do
  @type jobs :: list(ElixirJobs.Job.t())

  @doc """
    Find all jobs which office location matches area.
    latitude(deg), longitude (deg), radius (km)

    ## Examples

      iex> all_jobs = [
      ...>    %ElixirJobs.Job{office_latitude: 90, office_longitude: 90},
      ...>    %ElixirJobs.Job{},
      ...>    %ElixirJobs.Job{}
      ...> ]
      iex> {latitiude, longitude, radius} = {0, 0, 10}
      iex> ElixirJobs.Utils.Jobs.find_by_location(all_jobs, {latitiude, longitude, radius})
      [%ElixirJobs.Job{}, %ElixirJobs.Job{}]
  """
  @spec find_by_location(jobs, {float(), float(), float()}) :: jobs
  def find_by_location(jobs, {latitude, longitude, radius}) do
    area =
      if radius > 0 do
        %Geocalc.Shape.Circle{latitude: latitude, longitude: longitude, radius: radius * 1000}
      else
        %Geocalc.Shape.Circle{latitude: latitude, longitude: longitude, radius: 0.1}
      end

    jobs
    |> Enum.filter(fn job ->
      point = %{lat: job.office_latitude, lng: job.office_longitude}
      Geocalc.in_area?(area, point)
    end)
  end
end
