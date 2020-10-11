use Mix.Config

try do
  import_config "#{Mix.env()}.exs"
rescue
  Mix.Config.LoadError -> IO.puts "No env file for #{Mix.env}"
end
