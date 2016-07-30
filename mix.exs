defmodule WebQaVote.Mixfile do
  use Mix.Project

  def project do
    [app: :web_qa_vote,
     version: "0.0.1",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {WebQaVote, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy,
                    :logger, :gettext, :phoenix_ecto, :postgrex, :comeonin]]
  end

  defp aliases do
    [
      "test": ["ecto.create --quiet", "ecto.migrate", "test --stale"]
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:comeonin, "~>2.5"},
      {:phoenix, "~> 1.2.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:phoenix_pubsub, "~> 1.0.0"},
      {:postgrex, "~> 0.11.2"},
      {:phoenix_haml, github: "KazuCocoa/phoenix_haml", branch: "update_deps"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0"},
      {:guardian, "~> 0.12"},
      {:gettext, "~> 0.11"},
      {:logger_file_backend, "~> 0.0.1"},
      {:revision_plate_ex, "~> 0.1.0"},
      {:credo, "~> 0.3", only: [:dev, :test]}
    ]
  end
end
