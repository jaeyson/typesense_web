defmodule TypesenseWeb.Repo do
  use Ecto.Repo,
    otp_app: :typesense_web,
    adapter: Ecto.Adapters.Postgres
end
