defmodule ServerWeb.RoomView do
  use ServerWeb, :view
  alias ServerWeb.RoomView

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, RoomView, "room.json")}
  end

  def render("show.json", %{rooms: rooms}) do
    %{data: render_one(rooms, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{
      descrption: room.description,
      name:              room.name,
      topic:            room.topic,
      user_id:        room.user_id
    }
  end
end
