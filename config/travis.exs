use Mix.Config

# for travis test

config :web_qa_vote, WebQaVote.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :web_qa_vote, WebQaVote.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "web_qa_vote_travis_test",
  pool: Ecto.Adapters.SQL.Sandbox, # Use a sandbox for transactional testing
  size: 1

config :sentry,
  environment_name: :test,
  client: Sentry.TestClient
