defmodule RadugaWeb.RandomRoomChannel do
  use RadugaWeb, :channel
  alias Raduga.Rooms

  @impl true
  def join("random_room" <> room_id, _, socket) do
    {:ok, socket}
  end
end
