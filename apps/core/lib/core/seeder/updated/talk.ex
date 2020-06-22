defmodule Core.Seeder.Updated.Talk do
  @moduledoc """
  An update are seeds whole talks.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_message()
    update_room()
  end

  @spec update_message() :: Ecto.Schema.t()
  defp update_message do
  end

  @spec update_room() :: Ecto.Schema.t()
  defp update_room do
  end
end
