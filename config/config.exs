# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

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
