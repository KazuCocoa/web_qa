use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web_qa, WebQa.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :web_qa, WebQa.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "phoenix_psql",
  password: "phoenix",
  database: "web_qa_test",
  pool: Ecto.Adapters.SQL.Sandbox, # Use a sandbox for transactional testing
  size: 1
