use Mix.Config

if Mix.target() != :host do

  config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

  # Use shoehorn to start the main application. See the shoehorn
  # docs for separating out critical OTP applications such as those
  # involved with firmware updates.

  config :shoehorn,
    init: [:nerves_runtime, :nerves_init_gadget],
    app: Mix.Project.config()[:app]

  config :logger, backends: [RingLogger]

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

  config :nerves_init_gadget,
    ifname: "wlan0",
    address_method: :dhcpd,
    mdns_domain: "buscam.local",
    node_name: "buscam",
    node_host: :mdns_domain


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
end

import_config("../../camweb/config/config.exs")
