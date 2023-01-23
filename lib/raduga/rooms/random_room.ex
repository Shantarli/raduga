defmodule Raduga.Rooms.RandomRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "random_rooms" do
    field :name, :string
    field :owner, :string
    field :colors, {:array, :map}
    timestamps()
  end

  @doc false
  def changeset(random_room, attrs) do
    random_room
    |> cast(attrs, [:name, :owner, :colors])
    |> validate_required([:name, :owner, :colors])
    |> validate_length(:name, min: 3, max: 64)
    |> validate_length(:owner, min: 3, max: 64)
    |> validate_length(:colors, min: 1, max: 7)
    |> unique_constraint(:name)
  end

  def colors_changeset(random_room, attrs) do
    random_room
    |> cast(attrs, [:colors])
    |> validate_required(:colors)
    |> validate_length(:colors, min: 1, max: 7)
  end
end
