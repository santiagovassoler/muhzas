defmodule Muhzas.Repo do
  use Ecto.Repo,
    otp_app: :muhzas,
    adapter: Ecto.Adapters.Postgres
end
