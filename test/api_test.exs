defmodule ApiTest do
  use ExUnit.Case, async: true

  test "should get two jobs" do
    expected_response_body =
      Jason.encode!([
        %ElixirJobs.Job{
          contract_type: "FULL_TIME",
          name: "Compliance Manager",
          office_latitude: 48.8867578,
          office_longitude: 2.3253786,
          profession_id: "17"
        },
        %ElixirJobs.Job{
          contract_type: "FULL_TIME",
          name: "Software Engineer based in Paris/Marseille",
          office_latitude: 48.8867578,
          office_longitude: 2.3253786,
          profession_id: "17"
        }
      ])

    {:ok, conn} = Mint.HTTP.connect(:http, "localhost", cowboy_port())

    {:ok, conn, _request_ref} =
      Mint.HTTP.request(
        conn,
        "GET",
        "/jobs?latitude=48.8867578&longitude=2.3253786&radius=0.001",
        [],
        ""
      )

    receive do
      message ->
        {:ok, _conn, res} = Mint.HTTP.stream(conn, message)
        [_, _, data, _] = res
        {:data, _ref, body} = data

        assert expected_response_body == body
    end
  end

  test "should get no jobs" do
    expected_response_body = Jason.encode!([])

    {:ok, conn} = Mint.HTTP.connect(:http, "localhost", cowboy_port())

    {:ok, conn, _request_ref} =
      Mint.HTTP.request(
        conn,
        "GET",
        "/jobs?latitude=0&longitude=0&radius=1",
        [],
        ""
      )

    receive do
      message ->
        {:ok, _conn, res} = Mint.HTTP.stream(conn, message)
        [_, _, data, _] = res
        {:data, _ref, body} = data

        assert expected_response_body == body
    end
  end

  test "should get Bad Request on zero radius" do
    {:ok, conn} = Mint.HTTP.connect(:http, "localhost", cowboy_port())

    {:ok, conn, _request_ref} =
      Mint.HTTP.request(
        conn,
        "GET",
        "/jobs?latitude=48.8867578&longitude=2.3253786&radius=0",
        [],
        ""
      )

    receive do
      message ->
        {:ok, _conn, res} = Mint.HTTP.stream(conn, message)
        [{:status, _ref, status}, _, _, _] = res
        assert status == 400
    end
  end

  test "should get Bad Request on negative radius" do
    {:ok, conn} = Mint.HTTP.connect(:http, "localhost", cowboy_port())

    {:ok, conn, _request_ref} =
      Mint.HTTP.request(
        conn,
        "GET",
        "/jobs?latitude=48.8867578&longitude=2.3253786&radius=-10",
        [],
        ""
      )

    receive do
      message ->
        {:ok, _conn, res} = Mint.HTTP.stream(conn, message)
        [{:status, _ref, status}, _, _, _] = res
        assert status == 400
    end
  end

  defp cowboy_port, do: Application.get_env(:elixir_jobs, :cowboy_port)
end
