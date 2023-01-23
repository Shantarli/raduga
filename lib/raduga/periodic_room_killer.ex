defmodule Raduga.PeriodicRoomKiller do
  @moduledoc """
  Module that periodically removes abandoned rooms. The default period is 72 hours.
  """
  use GenServer
  alias Raduga.Rooms
  require Logger

  @name __MODULE__

  @hours3 10_800 * 1000

  # Client API
  def start_link(args) do
    GenServer.start_link(@name, args, name: @name)
  end

  def init(state) do
    Logger.info("Periodic Room Killer started")
    Process.send_after(self(), :kill_abandoned_rooms, @hours3)
    # Process.send(self(), :kill_abandoned_rooms, [:noconnect])
    {:ok, state}
  end

  def handle_info(:kill_abandoned_rooms, state) do
    {n_of_rooms, _} = Rooms.delete_abandoned_rooms()
    Logger.info("Periodic Room Killer deleted #{n_of_rooms} rooms")

    Process.send_after(self(), :kill_abandoned_rooms, @hours3)
    {:noreply, state}
  end
end
