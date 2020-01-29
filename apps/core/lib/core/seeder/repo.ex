defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.{
    Accounts,
    Landing,
    Localization
  }

  def seed! do
    Localization.seed!()
    Accounts.seed!()
    Landing.seed!()
    :ok
  end
end
