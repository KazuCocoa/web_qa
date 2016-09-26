use Mix.Config

config :web_qa_vote,
  ecto_repos: [WebQaVote.Repo]

# Configures the endpoint
config :web_qa_vote, WebQaVote.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "5P+jBjV/Tg7Ty5Ip8CSgufyY1qIv3/iuirP353LK2T7Kq5yqT3vgNrlhxlY3YLuK",
  render_errors: [accepts: "html"],
  pubsub: [name: WebQaVote.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :web_qa_vote, WebQaVote.Gettext,
  default_locale: "jp"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :guardian, Guardian,
  issuer: "WebQaVote",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "EPROIUELKJSDOIUEWORIJWLEKJFSODIojwoeirjsldkfjwoerijowkjflsef",
  serializer: WebQaVote.GuardianSerializer,
  permissions: %{
    default: [:read_profile, :write_profile]
  }

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

config :sentry,
  dsn: "https://2a43292fbcf24b5485a8d671f7305e72:da064eecf1a34c0ba9c989c135c7d2a1@sentry.io/101378",
  tags: %{
    env: "production"
  },
  included_environments: ~w(prod)a
