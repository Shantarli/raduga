defmodule RadugaWeb.RoomLive do
  use RadugaWeb, :live_view
  alias Raduga.Rooms
  alias RadugaWeb.Endpoint

  defguard is_owner?(room, user_id)
           when room.owner == user_id

  def mount(%{"room_name" => room_name}, _session, socket) do
    room = Rooms.get_random_room_by_name!(room_name)

    # is_owner assign used in template to show/hide controls
    is_owner = room.owner == socket.assigns.user_id

    internal_topic = "internal:" <> room.name
    room_topic = "random_room:" <> room.name

    if connected?(socket), do: Endpoint.subscribe(internal_topic)

    {:ok,
     socket
     |> assign(:room, room)
     |> assign(:is_owner, is_owner)
     |> assign(:internal_topic, internal_topic)
     |> assign(:room_topic, room_topic)}
  end

  def handle_event("go-home", _, socket) do
    {:noreply, socket |> redirect(to: "/")}
  end

  def handle_event("add-color", _, %{assigns: %{room: room, user_id: user_id}} = socket)
      when is_owner?(room, user_id) do
    case Rooms.add_color_to_random_room(room) do
      {:ok, updated_room} ->
        Endpoint.broadcast(
          socket.assigns.internal_topic,
          "colors-update",
          %{colors: updated_room.colors}
        )

        {:noreply,
         socket
         |> assign(:room, updated_room)
         |> push_event("is-loaded", %{loaded: true})}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event(
        "delete-color",
        %{"color_id" => color_id},
        %{assigns: %{room: room, user_id: user_id}} = socket
      )
      when is_owner?(room, user_id) do
    case Rooms.delete_color_random_room(room, color_id) do
      {:ok, updated_room} ->
        Endpoint.broadcast(socket.assigns.internal_topic, "colors-update", %{
          colors: updated_room.colors
        })

        {:noreply,
         socket
         |> assign(:room, updated_room)
         |> push_event("is-loaded", %{loaded: true})}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> assign(:message, "Something went wrong")}
    end
  end

  def handle_event(
        "update-color",
        params,
        %{assigns: %{room: room, user_id: user_id}} = socket
      )
      when is_owner?(room, user_id) do
    case Rooms.update_color_random_room(room, params) do
      {:ok, updated_room} ->
        Endpoint.broadcast(
          socket.assigns.internal_topic,
          "colors-update",
          %{colors: updated_room.colors}
        )

        {:noreply,
         socket
         |> assign(:room, updated_room)
         |> push_event("is-loaded", %{loaded: true})}

      {:error, _changeset} ->
        {:noreply,
         socket
         |> assign(:message, "Something went wrong")}
    end
  end

  def handle_info(
        %{event: "colors-update", payload: %{colors: colors}},
        %{assigns: %{room: room}} = socket
      ) do
    new_room = %{room | colors: colors}
    {:noreply, socket |> assign(:room, new_room)}
  end

  def handle_info(%{event: "room-deleted"}, socket) do
    {:noreply, socket |> assign(:message, "This room was closed")}
  end
end
