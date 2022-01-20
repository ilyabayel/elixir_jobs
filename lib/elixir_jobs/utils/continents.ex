defmodule ElixirJobs.Utils.Continents do
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
  @unknown "Unknown"

  @africa_geo @continents |> Map.get(@africa, %{}) |> Geo.JSON.decode!()
  @antarctica_geo @continents |> Map.get(@antarctica, %{}) |> Geo.JSON.decode!()
  @asia_geo @continents |> Map.get(@asia, %{}) |> Geo.JSON.decode!()
  @australia_geo @continents |> Map.get(@australia, %{}) |> Geo.JSON.decode!()
  @europe_geo @continents |> Map.get(@europe, %{}) |> Geo.JSON.decode!()
  @north_america_geo @continents |> Map.get(@north_america, %{}) |> Geo.JSON.decode!()
  @oceania_geo @continents |> Map.get(@oceania, %{}) |> Geo.JSON.decode!()
  @south_america_geo @continents |> Map.get(@south_america, %{}) |> Geo.JSON.decode!()

  @spec get_by_location({float(), float()}) :: String.t()
  def get_by_location({latitude, longitude}) do
    approximated_location = %Geo.Polygon{
      coordinates: [
        [
          {longitude - 0.05, latitude + 0.05},
          {longitude + 0.05, latitude + 0.05},
          {longitude + 0.05, latitude - 0.05},
          {longitude - 0.05, latitude - 0.05}
        ]
      ]
    }

    cond do
      Topo.intersects?(@africa_geo, approximated_location) -> @africa
      Topo.intersects?(@antarctica_geo, approximated_location) -> @antarctica
      Topo.intersects?(@asia_geo, approximated_location) -> @asia
      Topo.intersects?(@australia_geo, approximated_location) -> @australia
      Topo.intersects?(@europe_geo, approximated_location) -> @europe
      Topo.intersects?(@north_america_geo, approximated_location) -> @north_america
      Topo.intersects?(@oceania_geo, approximated_location) -> @oceania
      Topo.intersects?(@south_america_geo, approximated_location) -> @south_america
      true -> "Unknown"
    end
  end

  def continents do
    [@africa, @antarctica, @asia, @australia, @europe, @north_america, @oceania, @south_america, @unknown]
  end
end
