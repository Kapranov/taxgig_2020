defmodule ServerWeb.Channels.RoomChannelTest do
  use ServerWeb.ChannelCase
  alias ServerWeb.UserSocket

  setup do
    {:ok, socket} = connect(UserSocket, %{})
    {:ok, socket: socket}
  end

  test "send welcome message when join topic successfully", %{socket: socket} do
    {:ok, msg, _socket} = subscribe_and_join(socket, "rooms:lobby", %{})
    assert msg == "Joined to TaxGig Channel"
  end
end
