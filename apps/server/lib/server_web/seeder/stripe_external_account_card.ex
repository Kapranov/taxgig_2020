defmodule ServerWeb.Seeder.StripeExternalAccountCard do
  @moduledoc """
  Seeds for `Stripy.StripeExternalAccountCard` context.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeCardToken,
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

  @spec platform_external_account_card(map, map) :: {:ok, StripeExternalAccountCard.t} |
                                                    {:error, Ecto.Changeset.t} |
                                                    {:error, :not_found}
  defp platform_external_account_card(attrs, user_attrs) do
    case Accounts.by_role(user_attrs["user_id"]) do
      true ->
        with {:ok, %StripeExternalAccountCard{} = data} <- StripePlatformExternalAccountCardService.create(attrs, user_attrs) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end
