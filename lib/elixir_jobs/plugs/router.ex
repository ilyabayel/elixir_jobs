defmodule ElixirJobs.Router do
  use Plug.Router
  alias ElixirJobs.Plug.VerifyRequest

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])
  plug(VerifyRequest, fields: ["latitude", "longitude", "radius"], paths: ["/jobs"])
  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome!")
  end

  get "/jobs" do
    with {lat, _} <- Float.parse(conn.params["latitude"]),
         {lng, _} <- Float.parse(conn.params["longitude"]),
         {rad, _} when rad > 0 <- Float.parse(conn.params["radius"]) do
      jobs = ElixirJobs.JobsGenServer.get_by_location({lat, lng, rad})
      send_resp(conn, 201, Jason.encode!(jobs))
    else
      _ -> send_resp(conn, 400, "Some parameters are incorrect!")
    end
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
