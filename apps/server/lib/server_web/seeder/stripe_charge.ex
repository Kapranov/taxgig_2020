defmodule ServerWeb.Seeder.StripeCharge do
  @moduledoc """
  Seeds for `Stripy.StripeCharge` context.
  """

  alias Core.Accounts
  alias Stripy.{
    Payments.StripeCardToken,
    Payments.StripeCharge,
    StripeService.StripePlatformChargeService,
    Repo
  }

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(StripeCharge)
  end

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_charge()
  end

  @spec seed_stripe_charge() :: [Ecto.Schema.t()]
  defp seed_stripe_charge do
    card_ids = Enum.map(Repo.all(StripeCardToken), fn(data) -> data end)

    {
      sct01,
      _sct02,
      _sct03,
      _sct04,
      _sct05,
      _sct06,
      _sct07,
      _sct08,
      _sct09,
      _sct10,
      _sct11,
      _sct12
    } = {
      Enum.at(card_ids, 0),
      Enum.at(card_ids, 1),
      Enum.at(card_ids, 2),
      Enum.at(card_ids, 3),
      Enum.at(card_ids, 4),
      Enum.at(card_ids, 5),
      Enum.at(card_ids, 6),
      Enum.at(card_ids, 7),
      Enum.at(card_ids, 8),
      Enum.at(card_ids, 9),
      Enum.at(card_ids, 10),
      Enum.at(card_ids, 11)
    }

    charge01_attrs = %{ amount: 2000, currency: "usd", customer: sct01.id_from_customer, source: sct01.id_from_stripe, description: "charge card 01 by user1", capture: false }
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
    # charge12_attrs = %{ amount: 2000, currency: "usd", customer: sct12.id_from_customer, source: sct12.id_from_stripe, description: "charge card 01 by user3", capture: false }

    [
      platform_charge(charge01_attrs, %{"user_id" => sct01.user_id, "id_from_card" => sct01.id_from_stripe})
    ]
  end

  @spec platform_charge(map, map) :: {:ok, StripeCharge.t} |
                                     {:error, Ecto.Changeset.t} |
                                     {:error, :not_found}
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
