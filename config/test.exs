use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web_qa_vote, WebQaVote.Endpoint,
  http: [port: 4001],
  server: false

# Configure your database
config :web_qa_vote, WebQaVote.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "phoenix",
  password: "phoenix",
  database: "web_qa_vote_test",
  pool: Ecto.Adapters.SQL.Sandbox, # Use a sandbox for transactional testing
  size: 1

config :logger, :console,
  level: :error

config :sentry,
  environment_name: :test,
  client: Sentry.TestClient
