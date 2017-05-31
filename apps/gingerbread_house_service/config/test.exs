use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure database
config :gingerbread_house_service, GingerbreadHouse.Service.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "postgres",
    password: "postgres",
    database: "gingerbread_house_service_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
