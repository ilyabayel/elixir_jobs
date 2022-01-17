defmodule ElixirJobsTest do
  use ExUnit.Case
  doctest ElixirJobs

  test "greets the world" do
    assert ElixirJobs.hello() == :world
  end
end
