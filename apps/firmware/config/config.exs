# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize the firmware. Uncomment all or parts of the following
# to add files to the root filesystem or modify the firmware
# archive.

config :nerves, :firmware, rootfs_overlay: "config/rootfs_overlay"

# Use bootloader to start the main application. See the bootloader
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :bootloader,
  # init: [:nerves_runtime, :nerves_init_gadget, :nerves_network, :nerves_ntp],
  init: [:nerves_runtime, :nerves_init_gadget, :nerves_ntp],
  app: Mix.Project.config()[:app]

config :nerves_firmware_ssh,
  authorized_keys: [
    File.read!(Path.join(System.user_home!(), ".ssh/nerves/id_rsa.pub"))
  ]

config :nerves_init_gadget,
  ifname: "usb0",
  address_method: :linklocal,
  mdns_domain: "nerves.local",
  node_name: nil,
  node_host: :mdns_domain

# ntpd binary to use
config :nerves_ntp, :ntpd, "/usr/sbin/ntpd"

# servers to sync time from
config :nerves_ntp, :servers, [
  "0.pool.ntp.org",
  "1.pool.ntp.org",
  "2.pool.ntp.org",
  "3.pool.ntp.org"
]

config :user_interface, UserInterface.Endpoint,
  http: [port: 80],
  url: [host: "localhost", port: 80],
  secret_key_base: "Q8bCLHDz9QAcJ8ZRA2fWwUWSbglcYv3YxiLhBB2ZlRoqJydRyIWrtkllBPXtdaPp",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
