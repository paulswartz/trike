import Config

config :trike,
  listen_port: System.get_env("LISTEN_PORT", "8001") |> String.to_integer(),
  kinesis_stream: System.get_env("KINESIS_STREAM", "console")
