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
    Deleted,
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
    Updated.Landing.start!()
    Updated.Localization.start!()
    Updated.Lookup.start!()
    Updated.Services.start!()
    Updated.Contracts.start!()
    Updated.Media.start!()
    Updated.Talk.start!()
    :ok
  end

  @spec deleted!() :: :ok
  def deleted! do
    Deleted.Accounts.start!()
    Deleted.Contracts.start!()
    Deleted.Media.start!()
    Deleted.Talk.start!()
    :ok
  end
end
