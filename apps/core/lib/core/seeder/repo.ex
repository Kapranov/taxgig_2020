defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  alias Core.Seeder.Landing

  def seed! do
    Landing.seed!()
    :ok
  end
end
