os_exclude = if :os.type() == {:unix, :darwin},
  do: [skip_on_mac: true], else: []

ExUnit.configure(exclude: [pending: true],
  formatters: [JUnitFormatter, ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start(exclude: [:skip | os_exclude], trace: true)

defmodule WebSocketClient do
  use WebSockex

  require Logger

  @name __MODULE__

  @spec connect_to(String.t, forward_to: pid) :: :ok
  def connect_to(endpoint, forward_to: pid) do
    _extra_headers = [{"Authorization", "Bearer xxx"}]
    WebSockex.start_link(endpoint, @name, pid, extra_headers: [])
  end

  @spec send_as_text(pid, String.t) :: :ok
  def send_as_text(client, msg) do
    Logger.info("Sending message: #{msg}")
    WebSockex.send_frame(client, {:text, msg})
  end

  def handle_connect(_conn, state) do
    Logger.info("Connected!")
    {:ok, state}
  end

  def handle_frame({:text, "Can you please reply yourself?" = msg}, test_process) do
    Logger.info("Received Message: #{msg}")
    msg = "Sure can!"
    Logger.info("Sending message: #{msg}")
    {:reply, {:text, msg}, test_process}
  end

  def handle_frame({:text, "Close the things!" = msg}, test_process) do
    Logger.info("Received Message: #{msg}")
    {:close, test_process}
  end

  def handle_frame({:text, msg}, test_process) do
    Logger.info("Received Message: #{msg}")
    IO.puts "Received Message - Type: #{inspect :text} -- Message: #{inspect msg}"
    send test_process, msg;
    {:ok, test_process}
  end

  def handle_cast({:send, {:text, msg} = frame}, test_process) do
    IO.puts "Sending #{:text} frame with payload: #{msg}"
    {:reply, frame, test_process}
  end

  def handle_cast(:close, test_process), do: {:close, test_process}

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect reason}")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end
end

defmodule NullProcess do
  @name __MODULE__

  def start, do: spawn(@name, :loop, [])

  def loop do
    receive do _ -> loop() end
  end
end
