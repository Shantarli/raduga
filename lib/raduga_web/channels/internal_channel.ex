defmodule RadugaWeb.InternalChannel do
  @moduledoc """
  Channel for UI synchronization in `RadugaWeb.RoomLive`
  """
  use RadugaWeb, :channel

  @impl true
  def join("internal:" <> room_id, _params, socket) do
    {:ok, socket}
  end
end
