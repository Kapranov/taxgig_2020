defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    Accounts,
    Landing,
    Localization,
    Lookup,
    Services,
    Talk,
    Updated
  }

  @spec seed!() :: :ok
  def seed! do
    Localization.seed!()
    Accounts.seed!()
    Landing.seed!()
    Lookup.seed!()
    Services.seed!()
    Talk.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.start!()
    :ok
  end
end
