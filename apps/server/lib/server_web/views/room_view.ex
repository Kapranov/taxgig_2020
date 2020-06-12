defmodule ServerWeb.RoomView do
  use ServerWeb, :view
  alias ServerWeb.RoomView

  def render("index.json", %{rooms: data}) do
    %{data: render_many(data, RoomView, "room.json")}
  end

  def render("show.json", %{rooms: data}) do
    %{data: render_one(data, RoomView, "room.json")}
  end

  def render("room.json", %{room: data}) do
    %{
      descrption: data.description,
      name:              data.name,
      topic:            data.topic,
      user_id:        data.user_id
    }
  end
end
