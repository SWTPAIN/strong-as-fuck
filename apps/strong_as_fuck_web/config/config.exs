# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :strong_as_fuck_web,
  ecto_repos: [StrongAsFuckWeb.Repo]

# Configures the endpoint
config :strong_as_fuck_web, StrongAsFuckWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lYFXEO3BuefcgIm5kgdm1Ck5LY/7zg7OCZtz3nwEMaovmmEVNDIBE/TXGgkwnkbo",
  render_errors: [view: StrongAsFuckWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: StrongAsFuckWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
