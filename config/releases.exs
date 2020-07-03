import Config

config :boss_click, BossClickWeb.Endpoint,
  server: true,
  http: [port: {:system, "PORT"}],
  url: [host: "bossclick.madlep.com", port: 443],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  live_view: [signing_salt: System.get_env("LIVE_VIEW_SIGNING_SALT")]
