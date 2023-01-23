defmodule Raduga.Color do
  @moduledoc """
  Color validations
  """
  import Ecto.Changeset

  defstruct id: 1, hex: "FAFAFA", speed: 0.5
  @types %{id: :integer, hex: :string, speed: :float}

  def changeset(%__MODULE__{} = color, attrs) do
    {color, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required(Map.keys(@types))
    |> validate_number(:id, greater_than_or_equal_to: 1)
    |> validate_length(:hex, is: 6)
    |> validate_number(:speed, greater_than_or_equal_to: 0.10, less_than_or_equal_to: 0.90)
  end
end
