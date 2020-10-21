defmodule Stripy.Seeder.Repo do
  @moduledoc """
  Seeds for `Stripy.Seeder.Repo` repository.
  """

  alias Stripy.Seeder.{
    StripeCard,
    Updated
  }

  @spec seed!() :: :ok
  def seed! do
    StripeCard.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.StripeCard.start!()
    :ok
  end
end
