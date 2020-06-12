defmodule ServerWeb.MessageView do
  use ServerWeb, :view
  alias ServerWeb.MessageView

  def render("index.json", %{messages: data}) do
    %{data: render_many(data, MessageView, "message.json")}
  end

  def render("show.json", %{messages: data}) do
    %{data: render_one(data, MessageView, "message.json")}
  end

  def render("message.json", %{message: data}) do
    %{
      body:       data.body,
      user: %{
        first_name:   data.user.first_name,
        middle_name: data.user.middle_name,
        last_name:     data.user.last_name
      }
    }
  end
end
