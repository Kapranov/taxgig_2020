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
    Accounts.seed!()
    Landing.seed!()
    Localization.seed!()
    :ok
  end
end
