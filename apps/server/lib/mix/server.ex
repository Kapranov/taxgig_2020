defmodule Mix.Server do
  @doc "Common functions to be reused in mix tasks"
  def start_server do
    Mix.Task.run("app.start")
    Application.put_env(:phoenix, :serve_endpoints, false, persistent: true)

    if Core.Config.get(:env) != :test do
      Application.put_env(:logger, :console, level: :debug)
    end

    {:ok, _} = Application.ensure_all_started(:server)

    if Core.Config.get(:env) not in [:test, :benchmark] do
      server_rebooted?()
    end
  end

  defp server_rebooted? do
    if Restarter.Server.rebooted?() do
      :ok
    else
      Process.sleep(10)
      server_rebooted?()
    end
  end

  def load_server do
    Application.load(:server)
  end

  def get_option(options, opt, prompt, defval \\ nil, defname \\ nil) do
    Keyword.get(options, opt) || shell_prompt(prompt, defval, defname)
  end

  def shell_prompt(prompt, defval \\ nil, defname \\ nil) do
    prompt_message = "#{prompt} [#{defname || defval}] "

    input =
      if mix_shell?(),
        do: Mix.shell().prompt(prompt_message),
        else: :io.get_line(prompt_message)

    case input do
      "\n" ->
        case defval do
          nil ->
            shell_prompt(prompt, defval, defname)
          defval ->
            defval
        end

      input ->
        String.trim(input)
    end
  end

  def shell_yes?(message) do
    if mix_shell?(),
      do: Mix.shell().yes?("Continue?"),
      else: shell_prompt(message, "Continue?") in ~w(Yn Y y)
  end

  def shell_info(message) do
    if mix_shell?(),
      do: Mix.shell().info(message),
      else: IO.puts(message)
  end

  def shell_error(message) do
    if mix_shell?(),
      do: Mix.shell().error(message),
      else: IO.puts(:stderr, message)
  end

  @doc "Performs a safe check whether `Mix.shell/0` is available (does not raise if Mix is not loaded)"
  def mix_shell?, do: :erlang.function_exported(Mix, :shell, 0)

  def escape_sh_path(path) do
    ~S(') <> String.replace(path, ~S('), ~S(\')) <> ~S(')
  end
end
