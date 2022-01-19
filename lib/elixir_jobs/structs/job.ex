defmodule ElixirJobs.Job do
  defstruct profession_id: "",
            contract_type: "",
            name: "",
            office_latitude: 0.0,
            office_longitude: 0.0

  @type t :: %__MODULE__{
          profession_id: String.t(),
          contract_type: String.t(),
          name: String.t(),
          office_latitude: float(),
          office_longitude: float()
        }
end
