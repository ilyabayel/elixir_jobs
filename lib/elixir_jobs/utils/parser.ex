defmodule ElixirJobs.Utils.Parser do
  alias NimbleCSV.RFC4180, as: CSV

  @type professions_dict :: %{binary() => ElixirJobs.Profession.t()}
  @type jobs :: list(ElixirJobs.Job.t())

  @spec parse_jobs(binary()) :: jobs()
  @spec parse_professions(binary()) :: professions_dict()

  def parse_jobs(path) do
    File.read!(path)
    |> CSV.parse_string()
    |> Enum.map(fn [profession_id, contract_type, name, office_latitude, office_longitude] ->
      %ElixirJobs.Job{
        profession_id: profession_id,
        contract_type: contract_type,
        name: name,
        office_latitude: parse_float(office_latitude),
        office_longitude: parse_float(office_longitude)
      }
    end)
  end

  def parse_professions(path) do
    File.read!(path)
    |> CSV.parse_string()
    |> Map.new(fn [id, name, category_name] ->
      {id,
       %ElixirJobs.Profession{
         id: id,
         name: name,
         category_name: category_name
       }}
    end)
  end

  defp parse_float(string) do
    with {float, _} <- Float.parse(string) do
      float
    else
      _ -> 0.0
    end
  end
end
