use Mix.Config

config :teltx, tcp_port: System.get_env("TCP_PORT")

config :teltx,
  ecto_repos: [Teltx.Repo]

config :teltx, Teltx.Repo,
  database: "teltx",
  username: "teltx",
  password: "teltx",
  hostname: "postgresql"
