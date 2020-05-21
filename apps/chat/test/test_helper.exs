os_exclude = if :os.type() == {:unix, :darwin},
  do: [skip_on_mac: true], else: []

ExUnit.configure(exclude: [pending: true],
  formatters: [JUnitFormatter, ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start(exclude: [:skip | os_exclude], trace: true)

 defmodule WebSocketClient do
  use WebSockex

  @name __MODULE__

  def connect_to(endpoint, forward_to: pid) do
    _extra_headers = [{"Authorization", "Bearer xxx"}]
    WebSockex.start_link(endpoint, @name, pid, extra_headers: [])
  end

  def send_as_text(client, msg) do
    WebSockex.send_frame(client, {:text, msg})
  end

  def handle_frame({:text, msg}, test_process) do
    IO.puts "Received Message - Type: #{inspect :text} -- Message: #{inspect msg}"
    send test_process, msg;
    {:ok, test_process}
  end

  def handle_cast({:send, {:text, msg} = frame}, test_process) do
    IO.puts "Sending #{:text} frame with payload: #{msg}"
    {:reply, frame, test_process}
  end
end

defmodule NullProcess do
  @name __MODULE__

  def start, do: spawn(@name, :loop, [])

  def loop do
    receive do _ -> loop() end
  end
end
