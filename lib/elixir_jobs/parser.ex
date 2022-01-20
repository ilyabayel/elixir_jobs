defmodule ElixirJobs.Parser do
  alias NimbleCSV.RFC4180, as: CSV

  @type professions_dict :: %{String.t() => ElixirJobs.Profession.t()}
  @type jobs :: list(ElixirJobs.Job.t())

  @spec parse_jobs(String.t()) :: {:error, atom} | {:ok, jobs()}
  @spec parse_professions(String.t()) :: {:error, atom} | {:ok, professions_dict()}

  def parse_jobs(path) do
    with {:ok, data} <- File.read(path) do
      jobs =
        CSV.parse_string(data)
        |> Enum.map(fn csv_record ->
          [profession_id, contract_type, name, office_latitude, office_longitude] = csv_record

          %ElixirJobs.Job{
            profession_id: profession_id,
            contract_type: contract_type,
            name: name,
            office_latitude: parse_float(office_latitude),
            office_longitude: parse_float(office_longitude)
          }
        end)
      {:ok, jobs}
    end
  end

  def parse_professions(path_to_professions) do
    with {:ok, data} <- File.read(path_to_professions) do
      professions_dict =
        CSV.parse_string(data)
        |> Map.new(fn profession_csv_record ->
          [id, name, category_name] = profession_csv_record

          profession = %ElixirJobs.Profession{
            id: id,
            name: name,
            category_name: category_name
          }

          {id, profession}
        end)

      {:ok, professions_dict}
    end
  end

  defp parse_float(string) do
    with {float, _} <- Float.parse(string) do
      float
    else
      _ -> 0.0
    end
  end
end
