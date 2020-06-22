defmodule Core.Seeder.Updated.Landing do
  @moduledoc """
  An update are seeds whole landings.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_faq()
    update_faq_category()
    update_press_article()
    update_vacancy()
  end

  @spec update_faq() :: Ecto.Schema.t()
  defp update_faq do
  end

  @spec update_faq_category() :: Ecto.Schema.t()
  defp update_faq_category do
  end

  @spec update_press_article() :: Ecto.Schema.t()
  defp update_press_article do
  end

  @spec update_vacancy() :: Ecto.Schema.t()
  defp update_vacancy do
  end
end
