defmodule Raduga.Repo do
  use Ecto.Repo,
    otp_app: :raduga,
    adapter: Ecto.Adapters.SQLite3
end
