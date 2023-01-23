defmodule RadugaWeb.IndexLive do
  # use Phoenix.LiveView, layout: {RadugaWeb.LayoutView, "index.html"}
  use RadugaWeb, :live_view
  alias Raduga.Rooms
  require Logger

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("create-random-room", _params, socket) do
    user_id = socket.assigns.user_id

    case Rooms.create_random_room(user_id) do
      {:ok, room} ->
        Logger.info("User #{user_id} created room: #{room.name}")

        {:noreply,
         socket
         |> redirect(to: "/#{room.name}")}

      _ ->
        {:noreply, socket |> put_flash(:error, "Something went wrong")}
    end
  end

  def handle_event("open-last-room", _params, %{assigns: %{last_room: last_room}} = socket) do
    {:noreply, socket |> redirect(to: "/#{last_room.name}")}
  end
end
