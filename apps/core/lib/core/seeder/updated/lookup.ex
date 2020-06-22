defmodule Core.Seeder.Updated.Lookup do
  @moduledoc """
  An update are seeds whole lookups.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_state()
    update_us_zipcode()
  end

  @spec update_state() :: Ecto.Schema.t()
  defp update_state do
  end

  @spec update_us_zipcode() :: Ecto.Schema.t()
  defp update_us_zipcode do
  end
end
