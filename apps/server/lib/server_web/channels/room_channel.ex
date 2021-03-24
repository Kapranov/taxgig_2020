defmodule ServerWeb.RoomChannel do
  @moduledoc false

  use ServerWeb, :channel

  import Ecto.Query

  require Logger

  alias Core.{
    Accounts.User,
    Repo,
    Talk,
    Talk.Message,
    Talk.Room
  }

  alias ServerWeb.{
    Endpoint,
    ErrorView,
    MessageView,
    Presence,
    RoomView
  }

  def join("rooms:lobby", _payload, socket) do
    {:ok, "Joined to TaxGig Channel", socket}
  end

  def join("rooms:" <> room_id, _params, socket) do
    send(self(), :after_join)
    {:ok, %{messages: Talk.list_by_room_id(room_id)}, assign(socket, :room_id, room_id)}
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

  def handle_in("message:list", payload, socket) do
    cond do
      is_nil(payload["room_id"]) ->
        {:reply, {:error, ErrorView.render("404.json")}, socket}
      true ->
        case Repo.get(Room, payload["room_id"]) do
          nil ->
            {:reply, {:error, ErrorView.render("404.json")}, socket}
          room ->
            messages = Talk.list_by_room_id(room.id)
            response = MessageView.render("index.json", messages: messages)
            broadcast socket, "index", response
            {:reply, {:ok, response}, socket}
        end
    end
  end

  def handle_in("message:add", %{"message" => body}, socket) do
    room = Talk.get_room!(socket.assigns[:room_id])
    user = get_user(socket)

    case Talk.create_message(user, room, %{body: body}) do
      {:ok, message} ->
        message = Repo.preload(message, :user)
        message_template = %{
          body: message.body,
          user: %{
            username: "#{message.user.first_name} #{message.user.middle_name} #{message.user.last_name}"}}
        response = MessageView.render("show.json", %{messages: message})
        broadcast!(socket, "room:#{room.id}:new_message", message_template)
        {:reply, {:ok, response}, socket}
      {:error, _} ->
        {:reply, :error, socket}
    end
  end

  def handle_in("get_scores", _payload, socket) do
    reply_success(retrieve_scores(), socket)
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))

    user = get_user(socket)
    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      typing: false,
      typing_token: nil,
      user_id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      middle_name: user.middle_name
    })

    {:noreply, socket}
  end

  def handle_info({:after_join, "rooms:lobby"}, socket) do
    response =
      Talk.list_room
      |> Enum.map(&%{
        description: &1.description,
        name: &1.name,
        topic: &1.topic,
        user_id: &1.user_id
      })

    broadcast!(socket, "rooms:lobby", %{data: response})
    Endpoint.broadcast("rooms:lobby", "index", %{data: response})
    {:reply, {:ok, response}, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  defp get_user(socket)  do
    user_id = Repo.get(Room, socket.assigns[:room_id]).user_id
    Repo.get(User, user_id)
  end

  defp reply_success(data, socket), do: {:reply, {:ok, %{data: data}}, socket}
  defp retrieve_scores(), do: retrieve_scores(100)
  defp retrieve_scores(limit) when is_integer(limit) do
    Repo.all from s in Message,
      limit:  ^limit,
      select: %{message: s.body}
  end
end
