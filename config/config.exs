# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Authorize the device to receive firmware using your public key.
# See https://hexdocs.pm/nerves_firmware_ssh/readme.html for more information
# on configuring nerves_firmware_ssh.

keys =
  [
    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
  ]
  |> Enum.filter(&File.exists?/1)

if keys == [], do: Mix.raise("No SSH keys found. Please generate an SSH key.")

config :nerves_firmware_ssh,
  authorized_keys: Enum.map(keys, &File.read!/1)

# Configure nerves_init_gadget.
# See https://hexdocs.pm/nerves_init_gadget/readme.html for more information.

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcpd,
  mdns_domain: "buscam.local",
  node_name: "buscam",
  node_host: :mdns_domain

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.target()}.exs"

config :nerves_network, regulatory_domain: "US"

config :nerves_network, :default,
   wlan0: [
    networks: [
      [
        priority: 3,
        ssid: System.get_env("HOME_SSID"),
        psk: System.get_env("HOME_PSK"),
        key_mgmt: :"WPA-PSK"
      ],
      [
        priority: 2,
        ssid: System.get_env("WORK_SSID"),
        psk: System.get_env("WORK_PSK"),
        key_mgmt: :"WPA-PSK"
      ],
      [
        priority: 1,
        ssid: System.get_env("PHONE_SSID"),
        psk: System.get_env("PHONE_PSK"),
        key_mgmt: :"WPA-PSK"
      ]
    ]
  ]