import Config

config :logger,
  backends: [{LoggerFileBackend, :error_log}],
  format: "[$level] $message\n"

config :logger, :error_log,
  path: "hanoi.log",
  level: :debug
