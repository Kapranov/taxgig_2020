defmodule Core.Seeder.Ptin do
  @moduledoc """
  Seeds for `Core.Seeder.Ptin` repository.
  """

  alias Core.Seeder.Landing

  def seed! do
    Landing.seed!()
  end
end
