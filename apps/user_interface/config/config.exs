# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :user_interface,
  namespace: UserInterface,
  env: Mix.env

# Configures the endpoint
config :user_interface, UserInterfaceWeb.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  secret_key_base: "zZu+KElJRRLi0pNoL1NAMlN1SUTMyVnNN6NnCuhEaNXj1UVpojYK4iGnGo6m8O7C",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [view: UserInterfaceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UserInterface.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :camera,
  adapter: Picam,
  image_path: "pic_images/",
  image_location: "/root/images",
  timelapse_period: 3 * 60 * 1000 # 3 minutes


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
