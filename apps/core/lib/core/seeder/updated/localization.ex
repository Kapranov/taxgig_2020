defmodule Core.Seeder.Updated.Localization do
  @moduledoc """
  An update are seeds whole localizations.
  """

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_language()
  end

  @spec update_language() :: Ecto.Schema.t()
  defp update_language do
  end
end
