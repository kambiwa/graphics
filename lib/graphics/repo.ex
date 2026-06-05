defmodule Graphics.Repo do
  use Ecto.Repo,
    otp_app: :graphics,
    adapter: Ecto.Adapters.Postgres
end
