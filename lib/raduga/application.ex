defmodule Raduga.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Raduga.PeriodicRoomKiller

  use Application

  @impl true
  def start(_type, _args) do
    # Run migrations
    Raduga.Release.migrate()

    children = [
      # Start the Ecto repository
      Raduga.Repo,
      # Start the Telemetry supervisor
      RadugaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Raduga.PubSub},
      # Start the Endpoint (http/https)
      RadugaWeb.Endpoint,

      # Start a worker by calling: Raduga.Worker.start_link(arg)
      # {Raduga.Worker, arg}
      {Registry, keys: :unique, name: SchedulersRegistry},
      {Raduga.BroadcastSupervisor, name: BroadcastSupervisor},
      {Raduga.PeriodicRoomKiller, name: PeriodicRoomKiller}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Raduga.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def start_phase(:start_broadcast_schedulers, :normal, _opts) do
    for room <- Raduga.Rooms.list_random_rooms() do
      Raduga.BroadcastSupervisor.start_child(room)
    end

    :ok
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RadugaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
