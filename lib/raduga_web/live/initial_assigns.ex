defmodule RadugaWeb.InitialAssigns do
  @moduledoc """
  Initial assignments, user_id and his last visited room.
  """
  import Phoenix.LiveView
  alias Raduga.Rooms

  def on_mount(_, _params, session, socket) do
    socket =
      socket
      |> assign_new(:user_id, fn -> Map.get(session, "user_id") end)
      |> assign_new(:last_room, fn %{user_id: user_id} ->
        Rooms.get_random_room_by_owner(user_id)
      end)

    {:cont, socket}
  end
end
