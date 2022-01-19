defmodule ElixirJobs.Profession do
  defstruct id: "", name: "", category_name: ""

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          category_name: String.t()
        }
end
