defmodule JobsTableTest do
  use ExUnit.Case

  @expected_test_table %ElixirJobs.JobsTable{
    header: [
      "",
      "Total",
      "Admin",
      "Business",
      "Conseil",
      "Créa",
      "Marketing / Comm'",
      "Retail",
      "Tech",
      "Unknown"
    ],
    body: [
      ["Total", 38, 4, 9, 0, 1, 6, 7, 11, 0],
      ["Africa", 1, 1, 0, 0, 0, 0, 0, 0, 0],
      ["Europe", 36, 3, 9, 0, 1, 6, 6, 11, 0],
      ["North America", 1, 0, 0, 0, 0, 0, 1, 0, 0]
    ]
  }

  @expected_empty_table %ElixirJobs.JobsTable{
    header: [
      "",
      "Total",
      "Admin",
      "Business",
      "Conseil",
      "Créa",
      "Marketing / Comm'",
      "Retail",
      "Tech",
      "Unknown"
    ],
    body: []
  }

  test "creates an empty table" do
    {:ok, jobs} = ElixirJobs.Parser.parse_jobs("data/technical-test-jobs-empty.csv")

    {:ok, professions} =
      ElixirJobs.Parser.parse_professions("data/technical-test-professions.csv")

    table = ElixirJobs.JobsTable.create(jobs, professions)
    assert(@expected_empty_table == table)
  end

  test "creates a table with test data" do
    {:ok, jobs} = ElixirJobs.Parser.parse_jobs("data/technical-test-jobs-test.csv")

    {:ok, professions} =
      ElixirJobs.Parser.parse_professions("data/technical-test-professions.csv")

    table = ElixirJobs.JobsTable.create(jobs, professions)
    assert(@expected_test_table == table)
  end

  test "prettifies a table" do
    {:ok, jobs} = ElixirJobs.Parser.parse_jobs("data/technical-test-jobs-test.csv")

    {:ok, professions} =
      ElixirJobs.Parser.parse_professions("data/technical-test-professions.csv")

    table =
      ElixirJobs.JobsTable.create(jobs, professions)
      |> ElixirJobs.JobsTable.prettify()

    assert(is_bitstring(table))
  end
end

# Manual calculations
#                 Total   Admin   Business    Conseil   Créa    Marketing / Comm'   Retail    Tech    Unknown
# Total           36      4       9           0         1       6                   7         11      0
# Africa          1       1       0           0         0       0                   0         0       0
# Europe          36      3       9           0         1       6                   6         11      0
# North America   1       0       0           0         0       0                   1         0       0
