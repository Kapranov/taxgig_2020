defmodule ServerWeb.MessageView do
  use ServerWeb, :view
  alias ServerWeb.MessageView

  def render("show.json", %{messages: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      body:       message.body,
      room_id: message.room_id,
      user_id: message.user_id
    }
  end
end

