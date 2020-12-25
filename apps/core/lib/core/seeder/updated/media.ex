defmodule Core.Seeder.Updated.Media do
  @moduledoc """
  An update are seeds whole media.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_picture()
    update_pro_doc()
    update_tp_doc()
  end

  @spec update_picture() :: Ecto.Schema.t()
  defp update_picture do
  end

  @spec update_pro_doc() :: Ecto.Schema.t()
  defp update_pro_doc do
  end

  @spec update_tp_doc() :: Ecto.Schema.t()
  defp update_tp_doc do
  end
end
