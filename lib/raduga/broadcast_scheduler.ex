defmodule Raduga.BroadcastScheduler do
  @moduledoc """
  This module is responsible for broadcasting color to the room.
  """

  use GenServer
  alias Raduga.Rooms
  alias RadugaWeb.Endpoint
  require Logger

  @name __MODULE__
  @time_mult 5000

  # Client API
  def start_link(room) do
    GenServer.start_link(@name, room)
  end

  # GenServer callbacks
  def init(room) do
    Logger.info("Broadcast Scheduler started for #{room.name}")
    Process.send(self(), {:iterate, room.colors}, [:noconnect])
    {:ok, room}
  end

  def handle_info({:iterate, []}, room) do
    updated_room = Rooms.get_random_room_by_name(room.name)

    case updated_room do
      nil ->
        internal_topic = "internal:" <> room.name
        Endpoint.broadcast(internal_topic, "room-deleted", %{})
        Logger.info("Broadcast Scheduler for #{room.name} was terminated")
        Raduga.BroadcastSupervisor.terminate_child(self())

      room ->
        Process.send(self(), {:iterate, room.colors}, [:noconnect])
        {:noreply, updated_room}
    end
  end

  def handle_info({:iterate, colors}, room) do
    [color | tail] = colors
    time = round((1 - color["speed"]) * @time_mult)

    broadcast_color(room, color)

    Process.send_after(self(), {:iterate, tail}, time)
    {:noreply, room}
  end

  def broadcast_color(room, color) do
    topic = "random_room:" <> room.name

    Endpoint.broadcast(topic, "set-color", %{
      color: color
    })
  end
end
