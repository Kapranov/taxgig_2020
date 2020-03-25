defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    Accounts,
    Landing,
    Localization,
    Lookup
  }

  @spec seed!() :: :ok
  def seed! do
    Localization.seed!()
    Accounts.seed!()
    Landing.seed!()
    Lookup.seed!()
    :ok
  end
end
