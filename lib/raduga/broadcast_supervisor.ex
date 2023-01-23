defmodule Raduga.BroadcastSupervisor do
  @moduledoc """
  Supervisor for `Raduga.BroadcastSheduler` GenServer
  """
  use DynamicSupervisor
  alias Raduga.BroadcastScheduler
  require Logger

  @name __MODULE__

  def start_link(room) do
    Logger.info("Starting Broadcast Supervisor")
    DynamicSupervisor.start_link(@name, room, name: @name)
  end

  @impl true
  def init(_room) do
    DynamicSupervisor.init(restart: :transient, strategy: :one_for_one)
  end

  def start_child(room) do
    spec = {BroadcastScheduler, room}
    DynamicSupervisor.start_child(@name, spec)
  end

  def terminate_child(pid) do
    DynamicSupervisor.terminate_child(@name, pid)
  end
end
