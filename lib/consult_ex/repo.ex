defmodule ConsultEx.Repo do
  use Ecto.Repo,
    otp_app: :consult_ex,
    adapter: Ecto.Adapters.Postgres
end
