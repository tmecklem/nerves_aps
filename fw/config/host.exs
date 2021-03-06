use Mix.Config

config :logger, level: :debug

config :fw, host_mode: true

import_config Path.expand("../aps/config/config.exs")

config :ui, InfinityAPS.UI.Endpoint,
  http: [port: 4000],
  url: [host: "localhost", port: 4000],
  secret_key_base: "9w9MI64d1L8mjw+tzTmS3qgJTJqYNGJ1dNfn4S/Zm6BbKAmo2vAyVW7CgfI3CpII",
  root: Path.dirname(__DIR__),
  server: true,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: InfinityAPS.UI.PubSub, adapter: Phoenix.PubSub.PG2],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "../../ui/assets/node_modules/brunch/bin/brunch",
      "watch",
      "--stdin",
      cd: Path.expand("../../ui/assets", __DIR__)
    ]
  ],
  live_reload: [
    patterns: [
      ~r{../../ui/priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{../../ui/priv/gettext/.*(po)$},
      ~r{../../ui/lib/ui_web/views/.*(ex)$},
      ~r{../../ui/lib/ui_web/templates/.*(eex)$}
    ]
  ]
