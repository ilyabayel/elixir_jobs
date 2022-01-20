defmodule Utils.JobsTest do
  use ExUnit.Case
  doctest ElixirJobs.Utils.Jobs

  test "should avoid zero or negative radius" do
    expected_jobs_names = ["[Louis Vuitton North America] Team Manager, RTW - NYC"]
    jobs = ElixirJobs.Utils.Parser.parse_jobs("data/technical-test-jobs-test.csv")

    jobs_in_area =
      ElixirJobs.Utils.Jobs.find_by_location(jobs, {40.7630463, -73.973527, 0})
      |> Enum.map(fn job -> job.name end)

    assert jobs_in_area == expected_jobs_names
  end

  test "should avoid negative radius value" do
    expected_jobs_names = ["[Louis Vuitton North America] Team Manager, RTW - NYC"]
    jobs = ElixirJobs.Utils.Parser.parse_jobs("data/technical-test-jobs-test.csv")

    jobs_in_area =
      ElixirJobs.Utils.Jobs.find_by_location(jobs, {40.7630463, -73.973527, -10})
      |> Enum.map(fn job -> job.name end)

    assert jobs_in_area == expected_jobs_names
  end

  test "should avoid bad arithmetic expressions #1" do
    expected_jobs_names = ["[Louis Vuitton North America] Team Manager, RTW - NYC"]
    jobs = ElixirJobs.Utils.Parser.parse_jobs("data/technical-test-jobs-test.csv")

    jobs_in_area =
      ElixirJobs.Utils.Jobs.find_by_location(jobs, {360 + 40.7630463, 360 - 73.973527, 0})
      |> Enum.map(fn job -> job.name end)

    assert jobs_in_area == expected_jobs_names
  end
end
