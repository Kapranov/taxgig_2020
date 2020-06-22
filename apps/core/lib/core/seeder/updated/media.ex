defmodule Core.Seeder.Updated.Media do
  @moduledoc """
  An update are seeds whole media.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_file()
    update_picture()
  end

  @spec update_file() :: Ecto.Schema.t()
  defp update_file do
  end

  @spec update_picture() :: Ecto.Schema.t()
  defp update_picture do
  end
end
