# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :raduga,
  ecto_repos: [Raduga.Repo]

# Configures the endpoint
config :raduga, RadugaWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RadugaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Raduga.PubSub,
  live_view: [signing_salt: "C1xjyiEV"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/index.js js/room.js --bundle --target=es2017 --minify --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :dart_sass,
  version: "1.54.5",
  default: [
    args: ~w(scss/main.scss ../priv/static/assets/main.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  level: :notice,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
