import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :squid_goats, SquidGoatsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ZG3778u3OADGezpQN6iJNfkd1BjfKu9Tfc7GAmE2ldb1jhcNxkR1lCIqiHQHxKo7",
  server: false

# In test we don't send emails.
config :squid_goats, SquidGoats.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
