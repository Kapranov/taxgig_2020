defmodule ServerWeb.Seeder.StripeCharge do
  @moduledoc """
  Seeds for `Stripy.StripeCharge` context.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeCardToken,
    Payments.StripeCharge,
    StripeService.StripePlatformChargeService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeCharge)
  end

  @doc """
  frontend: [:amount, :currency, :description, :capture]
  backend:  [:customer, :source]

  1. Charge can be performed infinite number of times and can charge the same card
  2. If no data, show error

  ## Example

  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_charge()
  end

  @spec seed_stripe_charge() :: [Ecto.Schema.t()]
  defp seed_stripe_charge do
    user1 = CoreRepo.get_by(User, %{email: "v.kobzan@gmail.com"})
    card_ids = Enum.map(StripyRepo.all(StripeCardToken), fn(data) -> data end)
    [sct01] = Enum.filter(card_ids, &(&1.user_id == user1.id))

    charge01_attrs = %{amount: 2000, currency: "usd", customer: sct01.id_from_customer, source: sct01.id_from_stripe, description: "charge card 01 by user1", capture: false }
    # charge02_attrs = %{ amount: 2000, currency: "usd", customer: sct02.id_from_customer, source: sct02.id_from_stripe, description: "charge card 01 by user2", capture: false }
    # charge03_attrs = %{ amount: 2000, currency: "usd", customer: sct03.id_from_customer, source: sct03.id_from_stripe, description: "charge card 02 by user2", capture: false }
    # charge04_attrs = %{ amount: 2000, currency: "usd", customer: sct04.id_from_customer, source: sct04.id_from_stripe, description: "charge card 03 by user2", capture: false }
    # charge05_attrs = %{ amount: 2000, currency: "usd", customer: sct05.id_from_customer, source: sct05.id_from_stripe, description: "charge card 04 by user2", capture: false }
    # charge06_attrs = %{ amount: 2000, currency: "usd", customer: sct06.id_from_customer, source: sct06.id_from_stripe, description: "charge card 05 by user2", capture: false }
    # charge07_attrs = %{ amount: 2000, currency: "usd", customer: sct07.id_from_customer, source: sct07.id_from_stripe, description: "charge card 06 by user2", capture: false }
    # charge08_attrs = %{ amount: 2000, currency: "usd", customer: sct08.id_from_customer, source: sct08.id_from_stripe, description: "charge card 07 by user2", capture: false }
    # charge09_attrs = %{ amount: 2000, currency: "usd", customer: sct09.id_from_customer, source: sct09.id_from_stripe, description: "charge card 08 by user2", capture: false }
    # charge10_attrs = %{ amount: 2000, currency: "usd", customer: sct10.id_from_customer, source: sct10.id_from_stripe, description: "charge card 09 by user2", capture: false }
    # charge11_attrs = %{ amount: 2000, currency: "usd", customer: sct11.id_from_customer, source: sct11.id_from_stripe, description: "charge card 10 by user2", capture: false }

    [
      platform_charge(charge01_attrs, %{"user_id" => sct01.user_id, "id_from_card" => sct01.id_from_stripe})
    ]
  end

  @spec platform_charge(map, map) ::
          {:ok, StripeCharge.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_charge(attrs, user_attrs) do
    case Accounts.by_role(user_attrs["user_id"]) do
      true -> {:error, %Ecto.Changeset{}}
      false ->
        with {:ok,  %StripeCharge{} = data} <- StripePlatformChargeService.create(attrs, user_attrs) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
    end
  end
end
