import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, {:awscli, "default", 30}],
  secret_access_key: [
    {:system, "AWS_SECRET_ACCESS_KEY"},
    {:awscli, "default", 30}
  ],
  http_client: ExAws.Request.Req,
  json_codec: Jason

config :trike,
  listen_port: 8001,
  kinesis_client: Fakes.FakeKinesisClient,
  clock: DateTime,
  stale_timeout_ms: 5 * 60 * 1_000,
  health_check_interval_ms: 60 * 1_000

import_config "#{config_env()}.exs"
