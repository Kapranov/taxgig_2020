defmodule ServerWeb.RoomChannel do
  @moduledoc false

  use ServerWeb, :channel

  alias Core.{
    Accounts.User,
    Repo,
    Talk,
    Talk.Room
  }

  alias ServerWeb.{
    ErrorView,
    RoomView
  }

  def join("rooms:lobby", _payload, socket) do
    {:ok, "Joined to TaxGig Channel", socket}
  end

  def handle_in("index", _payload, socket) do
    rooms = Talk.list_room()
    response = RoomView.render("index.json", rooms: rooms)
    broadcast socket, "index", response
    {:reply, {:ok, response}, socket}
  end

  def handle_in("show", payload, socket) do
    if is_nil(payload["id"]) do
      {:reply, {:error, ErrorView.render("404.json")}, socket}
    else
      case Repo.get(Room, payload["id"]) do
        nil ->
          {:reply, {:error, ErrorView.render("404.json")}, socket}
        msg ->
          response = RoomView.render("show.json", rooms: msg)
          {:reply, {:ok, response}, socket}
      end
    end
  end

  def handle_in("create", payload, socket) do
    user = Repo.get(User, payload["user_id"])
    changeset =
      user
      |> Ecto.build_assoc(:rooms)
      |> Room.changeset(payload)

    cond do
      is_nil(payload["name"]) ->
        {:reply, {:error, ErrorView.render("404.json")}, socket}
      is_nil(payload["description"]) ->
        {:reply, {:error, ErrorView.render("404.json")}, socket}
      is_nil(payload["topic"]) ->
        {:reply, {:error, ErrorView.render("404.json")}, socket}
      is_nil(payload["user_id"]) ->
        {:reply, {:error, ErrorView.render("404.json")}, socket}
      true ->
        if changeset.valid? do
          room = Repo.insert!(changeset)
          response = RoomView.render("show.json", %{rooms: room})
          broadcast socket, "create", response
          {:reply, {:ok, response}, socket}
        else
          response = ServerWeb.ChangesetView.render("error.json", %{changeset: changeset})
          {:reply, {:error, response}, socket}
        end
    end
  end

  def handle_in("update", payload, socket) do
    params = %{
      name:               payload["name"],
      description: payload["description"],
      topic:             payload["topic"],
      user_id:         payload["user_id"]
    }

    cond do
      is_nil(payload["id"]) ->
        {:reply, {:error, ErrorView.render("404.json")}, socket}
      true ->
        try do
          room = Repo.get!(Room, payload["id"])
          case Repo.update(Room.changeset(room, params)) do
            {:ok, struct} ->
              response = RoomView.render("show.json", %{rooms: struct})
              {:reply, {:ok, response}, socket}
            {:error, changeset} ->
              {:reply, {:error, changeset}, socket}
          end
        rescue
          Ecto.NoResultsError ->
            {:reply, {:error, ErrorView.render("404.json")}, socket}
        end
    end
  end

  def handle_in("delete", payload, socket) do
    cond do
      is_nil(payload["id"]) ->
        {:reply, {:error, ErrorView.render("404.json")}, socket}
      true ->
        case Repo.get(Room, payload["id"]) do
          nil ->
            {:reply, {:error, ErrorView.render("404.json")}, socket}
          room ->
            case Repo.delete(room) do
              {:ok, struct} ->
                response = RoomView.render("show.json", %{rooms: struct})
                {:reply, {:ok, %{deleted: response}}, socket}
              {:error, changeset} ->
                {:reply, {:error, changeset}, socket}
            end
        end
    end
  end

#  def handle_info({:after_join, "rooms:lobby"}, socket) do
#    response =
#      Talk.list_room
#      |> Enum.map(&%{
#        description: &1.description,
#        name: &1.name,
#        topic: &1.topic,
#        user_id: &1.user_id
#      })
#
#    broadcast!(socket, "rooms:lobby", %{data: response})
#    Endpoint.broadcast("rooms:lobby", "index", %{data: response})
#    {:reply, {:ok, response}, socket}
#  end

#  def handle_out(event, payload, socket) do
#    push(socket, event, payload)
#    {:noreply, socket}
#  end

#  def join("room:lobby", _message, socket) do
#    {:ok, socket}
#  end
#
#  def handle_in("new_message", %{"body" => body, "room_id" => room_id, "user_id" => user_id}, socket) do
#    user = Repo.get(User, user_id)
#    room = Talk.get_room!(room_id)
#    spawn(fn -> Talk.create_message(user, room, %{body: body}) end)
#    broadcast!(socket, "new_message", %{body: body})
#    {:noreply, socket}
#  end

# socket_opts = [url: "ws://localhost:4000/socket/websocket"]
# {:ok, socket} = PhoenixClient.Socket.start_link(socket_opts)
# {:ok, _response, channel} = PhoenixClient.Channel.join(socket, "rooms:lobby")
# {:ok, data} = PhoenixClient.Channel.push(channel, "index", %{})
# {:ok, data} = PhoenixClient.Channel.push(channel, "show", %{"id" => "9vsgUj0rX2aH8Iosgi"})
# payload = %{"name" => "proba", "description" => "proba", "topic" => "proba", "user_id" => "9vwwJYHquq8GG7wkyW"}
# {:ok, data} = PhoenixClient.Channel.push(channel, "create", payload)
# payload = %{"id" => "9vwwcPdhuzhHAaqr4K", "name" => "updated", "description" => "updated", "topic" => "updated", "user_id" => "9vwwJYHquq8GG7wkyW"}
# {:ok, data} = PhoenixClient.Channel.push(channel, "update", payload)
# {:ok, data} = PhoenixClient.Channel.push(channel, "delete", %{"id" => "9vsgUj0rX2aH8Iosgi"})
# ServerWeb.Endpoint.broadcast("room:lobby", "index", data)
end
