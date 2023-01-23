defmodule Raduga.Rooms do
  @moduledoc """
  The Rooms context.
  """
  import Ecto.Query, warn: false
  alias Raduga.BroadcastSupervisor
  alias Raduga.Repo
  alias Raduga.Rooms.RandomRoom
  alias Raduga.Color
  import Raduga.Utils
  require Logger

  @doc """
  Returns the list of random_rooms.

  ## Examples

      iex> list_random_rooms()
      [%RandomRoom{}, ...]

  """
  def list_random_rooms do
    Repo.all(RandomRoom)
  end

  @doc """
  List rooms that have not been updated for a certain time, as well as rooms with one color inside.
  """
  def list_abandoned_rooms(time \\ 259_200) do
    date_cutoff = NaiveDateTime.utc_now() |> NaiveDateTime.add(-time)

    from(
      room in RandomRoom,
      where:
        room.updated_at < ^date_cutoff or
          fragment("json_array_length(?)", room.colors) == 1
    )
    |> Repo.all()
  end

  @doc """
  Deletes rooms that have not been updated for a certain time, as well as rooms with one color inside
  """
  def delete_abandoned_rooms(time \\ 259_200) do
    date_cutoff = NaiveDateTime.utc_now() |> NaiveDateTime.add(-time)

    from(
      room in RandomRoom,
      where:
        room.updated_at < ^date_cutoff or
          fragment("json_array_length(?)", room.colors) == 1
    )
    |> Repo.delete_all()
  end

  @doc """
  Gets a single random_room.

  Raises `Ecto.NoResultsError` if the Random room does not exist.

  ## Examples

      iex> get_random_room!(123)
      %RandomRoom{}

      iex> get_random_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_random_room!(id), do: Repo.get!(RandomRoom, id)

  @doc """
  Gets a single random_room by owner_id

  ## Examples

      iex> get_random_room_by_owner(123)
      %RandomRoom{}

      iex> get_random_room_by_owner(456)
      nil
  """
  def get_random_room_by_owner(owner_id) do
    from(
      room in RandomRoom,
      where: room.owner == ^owner_id,
      order_by: [desc: room.inserted_at],
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Gets a single random_room by it's name.

  Raises `Ecto.NoResultsError` if the Random room does not exist.

  ## Examples

      iex> get_random_room_by_name!(123)
      %RandomRoom{}

      iex> get_random_room!(456)
      ** (Ecto.NoResultsError)
  """
  def get_random_room_by_name!(name) do
    from(
      room in RandomRoom,
      where: room.name == ^name
    )
    |> Repo.one!()
  end

  @doc """
  Gets a single random_room by it's name

  ## Examples

      iex> get_random_room_by_name(123)
      %RandomRoom{}

      iex> get_random_room(456)
      nil
  """
  def get_random_room_by_name(name) do
    from(
      room in RandomRoom,
      where: room.name == ^name
    )
    |> Repo.one()
  end

  @doc """
  Creates a random_room.

  ## Examples

      iex> create_random_room(%{field: value})
      {:ok, %RandomRoom{}}

      iex> create_random_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_random_room(user_id) do
    slug = generate_slug()

    default_colors = [%{"id" => 1, "hex" => "FAFAFA", "speed" => 0.5}]
    default_room = %{"name" => slug, "owner" => user_id, "colors" => default_colors}

    {:ok, room} =
      %RandomRoom{}
      |> RandomRoom.changeset(default_room)
      |> Repo.insert()

    BroadcastSupervisor.start_child(room)

    {:ok, room}
  end

  @doc """
  Updates a random_room.

  ## Examples

      iex> update_random_room(random_room, %{field: new_value})
      {:ok, %RandomRoom{}}

      iex> update_random_room(random_room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_random_room(%RandomRoom{} = random_room, attrs) do
    random_room
    |> RandomRoom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Add a new color to Colors List of a room
  """
  def add_color_to_random_room(%RandomRoom{} = random_room) do
    new_id = List.last(random_room.colors)["id"] + 1
    new_colors = random_room.colors ++ [default_color(new_id)]
    new_room = Map.put(random_room, :colors, new_colors)

    attrs = %{colors: new_room.colors}

    random_room
    |> RandomRoom.colors_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates the selected color in the room
  """
  def update_color_random_room(%RandomRoom{} = random_room, params) do
    id = String.to_integer(params["color_id"])
    {speed, _} = Float.parse(params["speed"])
    hex = String.trim(params["hex"], "#")

    updated_color = %{id: id, speed: speed, hex: hex}

    changeset = Color.changeset(%Color{}, updated_color)

    case changeset.valid? do
      true ->
        new_colors =
          random_room.colors
          |> Enum.map(fn
            %{"id" => ^id} = color ->
              %{color | "hex" => hex, "speed" => speed}

            other ->
              other
          end)

        new_room = Map.put(random_room, :colors, new_colors)
        attrs = %{colors: new_room.colors}

        random_room
        |> RandomRoom.colors_changeset(attrs)
        |> Repo.update()

      false ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a random_room.

  ## Examples

      iex> delete_random_room(random_room)
      {:ok, %RandomRoom{}}

      iex> delete_random_room(random_room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_random_room(%RandomRoom{} = random_room) do
    Logger.info("Room #{random_room.name} was deleted")
    Repo.delete(random_room)
  end

  @doc """
  Removes the specified color from the room
  """
  def delete_color_random_room(%RandomRoom{} = random_room, color_id) do
    color_id = String.to_integer(color_id)
    new_colors = random_room.colors |> Enum.reject(fn %{"id" => id} -> id == color_id end)
    new_room = Map.put(random_room, :colors, new_colors)

    attrs = %{colors: new_room.colors}

    random_room
    |> RandomRoom.colors_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking random_room changes.

  ## Examples

      iex> change_random_room(random_room)
      %Ecto.Changeset{data: %RandomRoom{}}

  """
  def change_random_room(%RandomRoom{} = random_room, attrs \\ %{}) do
    RandomRoom.changeset(random_room, attrs)
  end
end
