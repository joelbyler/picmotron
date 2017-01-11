# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"

config :user_interface, UserInterface.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  secret_key_base: "Q8bCLHDz9QAcJ8ZRA2fWwUWSbglcYv3YxiLhBB2ZlRoqJydRyIWrtkllBPXtdaPp",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub]

config :logger, level: :debug

config :user_interface,
  image_path: "pic_images/",
  image_location: "/root/images"

config :nerves_leds, names: [ red: "led0", green: "led1" ]

config :nerves, :firmware,
  rootfs_additions: "config/rootfs-additions"
