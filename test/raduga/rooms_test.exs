defmodule Raduga.RoomsTest do
  use Raduga.DataCase

  alias Raduga.Rooms

  describe "random_rooms" do
    alias Raduga.Rooms.RandomRoom

    import Raduga.RoomsFixtures

    @invalid_attrs %{name: nil, owner: nil}

    test "list_random_rooms/0 returns all random_rooms" do
      random_room = random_room_fixture()
      assert Rooms.list_random_rooms() == [random_room]
    end

    test "get_random_room!/1 returns the random_room with given id" do
      random_room = random_room_fixture()
      assert Rooms.get_random_room!(random_room.id) == random_room
    end

    test "create_random_room/1 with valid data creates a random_room" do
      valid_attrs = %{name: "some name", owner: "some owner"}

      assert {:ok, %RandomRoom{} = random_room} = Rooms.create_random_room(valid_attrs)
      assert random_room.name == "some name"
      assert random_room.owner == "some owner"
    end

    test "create_random_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_random_room(@invalid_attrs)
    end

    test "update_random_room/2 with valid data updates the random_room" do
      random_room = random_room_fixture()
      update_attrs = %{name: "some updated name", owner: "some updated owner"}

      assert {:ok, %RandomRoom{} = random_room} = Rooms.update_random_room(random_room, update_attrs)
      assert random_room.name == "some updated name"
      assert random_room.owner == "some updated owner"
    end

    test "update_random_room/2 with invalid data returns error changeset" do
      random_room = random_room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_random_room(random_room, @invalid_attrs)
      assert random_room == Rooms.get_random_room!(random_room.id)
    end

    test "delete_random_room/1 deletes the random_room" do
      random_room = random_room_fixture()
      assert {:ok, %RandomRoom{}} = Rooms.delete_random_room(random_room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_random_room!(random_room.id) end
    end

    test "change_random_room/1 returns a random_room changeset" do
      random_room = random_room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_random_room(random_room)
    end
  end
end
