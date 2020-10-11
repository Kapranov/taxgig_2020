use Mix.Config

try do
  import_config "test.secret.exs"
rescue
  Mix.Config.LoadError -> IO.puts "No secret file for #{Mix.env}"
end
