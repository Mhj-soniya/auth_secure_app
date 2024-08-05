defmodule AuthSecure.Repo do
  use Ecto.Repo,
    otp_app: :auth_secure,
    adapter: Ecto.Adapters.Postgres
end
