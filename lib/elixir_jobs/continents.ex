defmodule ElixirJobs.Continents do
  @continents File.read!("data/continents.geo.json")
              |> Jason.decode!()
              |> Map.get("features", [])
              |> Map.new(fn continent_info ->
                continent_name =
                  continent_info
                  |> Map.get("properties", %{})
                  |> Map.get("CONTINENT", "")

                geometry = continent_info |> Map.get("geometry", %{})

                {continent_name, geometry}
              end)

  @africa "Africa"
  @antarctica "Antarctica"
  @asia "Asia"
  @australia "Australia"
  @europe "Europe"
  @north_america "North America"
  @oceania "Oceania"
  @south_america "South America"

  @africa_geo @continents |> Map.get(@africa, %{}) |> Geo.JSON.decode!()
  @antarctica_geo @continents |> Map.get(@antarctica, %{}) |> Geo.JSON.decode!()
  @asia_geo @continents |> Map.get(@asia, %{}) |> Geo.JSON.decode!()
  @australia_geo @continents |> Map.get(@australia, %{}) |> Geo.JSON.decode!()
  @europe_geo @continents |> Map.get(@europe, %{}) |> Geo.JSON.decode!()
  @north_america_geo @continents |> Map.get(@north_america, %{}) |> Geo.JSON.decode!()
  @oceania_geo @continents |> Map.get(@oceania, %{}) |> Geo.JSON.decode!()
  @south_america_geo @continents |> Map.get(@south_america, %{}) |> Geo.JSON.decode!()

  @spec get_continent_by_point(Geo.Point.t()):: String.t()
  def get_continent_by_point(point) do
    cond do
      Topo.contains?(@africa_geo, point) -> @africa
      Topo.contains?(@antarctica_geo, point) -> @antarctica
      Topo.contains?(@asia_geo, point) -> @asia
      Topo.contains?(@australia_geo, point) -> @australia
      Topo.contains?(@europe_geo, point) -> @europe
      Topo.contains?(@north_america_geo, point) -> @north_america
      Topo.contains?(@oceania_geo, point) -> @oceania
      Topo.contains?(@south_america_geo, point) -> @south_america
      true -> "Unknown"
    end
  end
end
