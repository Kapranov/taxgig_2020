import Config

try do
  import_config "dev.secret.exs"
rescue
  Mix.Config.LoadError -> IO.puts "No secret file for #{Mix.env}"
end
