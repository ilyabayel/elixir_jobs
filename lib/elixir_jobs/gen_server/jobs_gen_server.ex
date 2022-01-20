defmodule ElixirJobs.JobsGenServer do
  use GenServer

  @spec get_by_location({float(), float(), float()}) :: list(ElixirJobs.Job.t())

  # Client
  def start_link(initial_jobs) do
    GenServer.start_link(__MODULE__, initial_jobs, name: {:global, :JobsGenServer})
  end

  def get_by_location({latitude, longitude, radius}) do
    GenServer.call({:global, :JobsGenServer}, {:get, latitude, longitude, radius})
  end

  # Server
  @impl true
  def init(initial_jobs) do
    {:ok, initial_jobs}
  end

  @impl true
  def handle_call({:get, latitude, longitude, radius}, _from, jobs) do
    {:reply, ElixirJobs.Utils.Jobs.find_by_location(jobs, {latitude, longitude, radius}), jobs}
  end
end
