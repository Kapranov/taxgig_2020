defmodule ServerWeb.Seeder.StripeExternalAccountCard do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountCard` context.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeCardToken,
    Payments.StripeExternalAccountBank,
    Payments.StripeExternalAccountCard,
    StripeService.StripePlatformExternalAccountCardService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeExternalAccountCard)
  end

  @doc """
  Used to create a remote `Stripe.ExternalAccount` record as well as
  an associated local `StripeExternalAccountCard` record.

  fronend - []
  backend - [:account, :token]

  1. if none or one and not more 10 records, it will created only `StripeExternalAccountCard`
     Afterwards, update attr's `token` for `StripeCardToken` this performs only for pro.
  2. If `StripeExternalAccountCard` creation fails, return an error
  3. If `StripeExternalAccountCard` creation succeeds, return created `StripeExternalAccountCard`
  6. If create 11 and more items for `StripeExternalAccountCard` return error

  ## Example

  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_card()
  end

  @spec seed_stripe_external_account_card() :: [Ecto.Schema.t()]
  defp seed_stripe_external_account_card do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    account = StripyRepo.get_by(StripeAccount, %{user_id: user_attrs["user_id"]})
    token = StripyRepo.get_by(StripeCardToken, %{user_id: user_attrs["user_id"]})

    attrs = %{
      account: account.id_from_stripe,
      token: token.token
    }

    platform_external_account_card(attrs, user_attrs)
  end

  @spec platform_external_account_card(map, map) ::
          {:ok, StripeExternalAccountCard.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_external_account_card(attrs, user_attrs) do
    count_bank =
      try do
        Queries.by_value(StripeExternalAccountBank, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    count_card =
      try do
        Queries.by_value(StripeExternalAccountCard, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    case Accounts.by_role(user_attrs["user_id"]) do
      true ->
        if (StripyRepo.aggregate(count_bank, :count, :id) + StripyRepo.aggregate(count_card, :count, :id)) < 10 do
          with {:ok, %StripeExternalAccountCard{} = data} <- StripePlatformExternalAccountCardService.create(attrs, user_attrs) do
            {:ok, data}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
        else
          {:error, %Ecto.Changeset{}}
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end
