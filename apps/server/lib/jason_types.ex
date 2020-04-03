Postgrex.Types.define(
  Server.PostgresTypes,
  [] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
