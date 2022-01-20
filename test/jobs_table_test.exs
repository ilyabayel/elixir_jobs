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
      ["Antarctica", 0, 0, 0, 0, 0, 0, 0, 0, 0],
      ["Asia", 0, 0, 0, 0, 0, 0, 0, 0, 0],
      ["Australia", 0, 0, 0, 0, 0, 0, 0, 0, 0],
      ["Europe", 36, 3, 9, 0, 1, 6, 6, 11, 0],
      ["North America", 1, 0, 0, 0, 0, 0, 1, 0, 0],
      ["Oceania", 0, 0, 0, 0, 0, 0, 0, 0, 0],
      ["South America", 0, 0, 0, 0, 0, 0, 0, 0, 0],
      ["Unknown", 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  }

  test "creates a table with test data" do
    table = ElixirJobs.JobsTable.create()
    assert(@expected_test_table == table)
  end

  test "prettifies a table" do
    table =
      ElixirJobs.JobsTable.create()
      |> ElixirJobs.JobsTable.prettify()

    assert(is_bitstring(table))
  end
end

# Manual calculations
#                 Total   Admin   Business    Conseil   Créa    Marketing / Comm'   Retail    Tech    Unknown
# Total           38      4       9           0         1       6                   7         11      0
# Africa          1       1       0           0         0       0                   0         0       0
# Europe          36      3       9           0         1       6                   6         11      0
# North America   1       0       0           0         0       0                   1         0       0
