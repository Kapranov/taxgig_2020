defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    Accounts,
    Contracts,
    Landing,
    Localization,
    Lookup,
    Media,
    Services,
    Skills,
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
    Contracts.seed!()
    Skills.seed!()
    Media.seed!()
    Talk.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.Accounts.start!()
    Updated.Services.start!()
    Updated.Contracts.start!()
    :ok
  end
end
