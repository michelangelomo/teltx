defmodule Teltx.Repo do
  use Ecto.Repo,
    otp_app: :teltx,
    adapter: Ecto.Adapters.Postgres
end
