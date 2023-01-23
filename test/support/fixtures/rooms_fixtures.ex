defmodule Raduga.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Raduga.Rooms` context.
  """

  @doc """
  Generate a random_room.
  """
  def random_room_fixture(attrs \\ %{}) do
    {:ok, random_room} =
      attrs
      |> Enum.into(%{
        name: "some name",
        owner: "some owner"
      })
      |> Raduga.Rooms.create_random_room()

    random_room
  end
end
