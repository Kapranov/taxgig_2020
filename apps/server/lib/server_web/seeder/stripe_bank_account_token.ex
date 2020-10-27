defmodule ServerWeb.Seeder.StripeBankAccountToken do
  @moduledoc """
  Seeds for `Stripy.StripeBankAccountToken` context.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeBankAccountToken,
    StripeService.StripePlatformBankAccountTokenService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @account_holder_type "individual"

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeBankAccountToken)
  end

  @doc """
  Used to create a remote `Stripe.Token` record as well as
  an associated local `StripeBankAccountToken` record.
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_bank_account_token()
  end

  @spec seed_stripe_bank_account_token() :: [Ecto.Schema.t()]
  defp seed_stripe_bank_account_token do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_full_name = Accounts.by_full_name(user.id)
    user_attrs = %{"user_id" => user.id}
    attrs = %{
      account_holder_name: user_full_name,
      account_holder_type: @account_holder_type,
      account_number: "000123456789",
      country: "US",
      currency: "usd",
      routing_number: 110000000
    }

    platform_bank_account_token(attrs, user_attrs)
  end

  @spec platform_bank_account_token(map, map) :: {:ok, StripeBankAccountToken.t} |
                                                 {:error, Ecto.Changeset.t} |
                                                 {:error, :not_found}
  defp platform_bank_account_token(attrs, user_attrs) do
    case Accounts.by_role(user_attrs["user_id"]) do
      false -> {:error, %Ecto.Changeset{}}
      true ->
        with {:ok,  %StripeBankAccountToken{} = data} <- StripePlatformBankAccountTokenService.create(attrs, user_attrs) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
    end
  end
end
