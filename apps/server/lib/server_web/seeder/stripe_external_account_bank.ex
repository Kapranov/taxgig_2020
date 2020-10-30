defmodule ServerWeb.Seeder.StripeExternalAccountBank do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountBank` context.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeBankAccountToken,
    Payments.StripeExternalAccountBank,
    Payments.StripeExternalAccountCard,
    StripeService.StripePlatformExternalAccountBankService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeExternalAccountBank)
  end

  @doc """
  Used to create a remote `Stripe.ExternalAccount` record as well as
  an associated local `StripeExternalAccountBank` record.
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_external_account_bank()
  end

  @spec seed_stripe_external_account_bank() :: [Ecto.Schema.t()]
  defp seed_stripe_external_account_bank do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    account = StripyRepo.get_by(StripeAccount, %{user_id: user_attrs["user_id"]})
    token = StripyRepo.get_by(StripeBankAccountToken, %{user_id: user_attrs["user_id"]})

    attrs = %{
      account: account.id_from_stripe,
      token: token.id_from_stripe
    }

    platform_external_account_bank(attrs, user_attrs)
  end

  @spec platform_external_account_bank(map, map) :: {:ok, StripeExternalAccountBank.t} |
                                                    {:error, Ecto.Changeset.t} |
                                                    {:error, :not_found}
  defp platform_external_account_bank(attrs, user_attrs) do
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
          with {:ok, %StripeExternalAccountBank{} = data} <- StripePlatformExternalAccountBankService.create(attrs, user_attrs) do
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
