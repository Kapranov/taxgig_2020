defmodule ServerWeb.Seeder.StripeTransfer do
  @moduledoc """
  Seeds for `Stripy.StripeTransfer` context.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeTransfer,
    StripeService.StripePlatformTransferService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeTransfer)
  end

  @doc """
  Used to create a remote `Stripe.ExternalAccount` record as well as
  an associated local `StripeTransfer` record.
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer()
  end

  @spec seed_stripe_transfer() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    destination = StripyRepo.get_by(StripeAccount, %{user_id: user_attrs["user_id"]})
    attrs = %{amount: 1000, currency: "usd", destination: destination.id_from_stripe}

    platform_transfer(attrs, user_attrs)
  end

  @spec platform_transfer(map, map) :: {:ok, StripeTransfer.t} |
                                       {:error, Ecto.Changeset.t} |
                                       {:error, :not_found}
  defp platform_transfer(attrs, user_attrs) do
    case Accounts.by_role(user_attrs["user_id"]) do
      true ->
        with {:ok, %StripeTransfer{} = data} <- StripePlatformTransferService.create(attrs, user_attrs) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end
