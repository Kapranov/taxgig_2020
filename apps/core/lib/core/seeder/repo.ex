defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.Landing
  alias Core.Seeder.Localization

  def seed! do
    Landing.seed!()
    Localization.seed!()
    :ok
  end
end
