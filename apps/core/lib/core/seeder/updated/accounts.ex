defmodule Core.Seeder.Updated.Accounts do
  @moduledoc """
  An update are seeds whole an accounts.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_profile()
    update_subscriber()
    update_user()
  end

  @spec update_profile() :: Ecto.Schema.t()
  defp update_profile do
  end

  @spec update_subscriber() :: Ecto.Schema.t()
  defp update_subscriber do
  end

  @spec update_user() :: Ecto.Schema.t()
  defp update_user do
  end
end
