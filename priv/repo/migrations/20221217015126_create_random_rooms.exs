defmodule Raduga.Repo.Migrations.CreateRandomRooms do
  use Ecto.Migration

  def change do
    create table(:random_rooms) do
      add :name, :string
      add :owner, :string
      add :colors, {:array, :map}

      timestamps()
    end

    create unique_index(:random_rooms, [:name])
  end
end
