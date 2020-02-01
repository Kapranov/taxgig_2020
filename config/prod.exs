use Mix.Config

config :logger, level: :info

if File.exists?("./config/prod.secret.exs") do
  import_config "prod.secret.exs"
else
  File.write("./config/prod.secret.exs", """
  use Mix.Config

  # For additional configuration outside of environmental variables
  """)
end
