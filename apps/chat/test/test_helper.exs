ExUnit.start([trace: true, exclude: :ignore])

defmodule WebSocketClient do
  use WebSockex

  @name __MODULE__

  def connect_to(endpoint, forward_to: pid) do
    _extra_headers = [{"Authorization", "Bearer xxx"}]
    WebSockex.start_link(endpoint, @name, pid, extra_headers: [])
  end

  def send_as_text(client, message) do
    WebSockex.send_frame(client, {:text, message})
  end

  def handle_frame({:text, message}, test_process) do
    send test_process, message;
    {:ok, test_process}
  end
end

defmodule NullProcess do
  @name __MODULE__

  def start, do: spawn(@name, :loop, [])

  def loop do
    receive do _ -> loop() end
  end
end
