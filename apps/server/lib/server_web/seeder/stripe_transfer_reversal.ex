defmodule ServerWeb.Seeder.StripeTransferReversal do
  @moduledoc """
  Seeds for `Stripy.StripeTransferReversal` context.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeTransfer,
    Payments.StripeTransferReversal,
    StripeService.StripePlatformTransferReversalService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    StripyRepo.delete_all(StripeTransferReversal)
  end

  @doc """
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer_reversal()
  end

  @spec seed_stripe_transfer_reversal() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer_reversal do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    transfer = StripyRepo.get_by(StripeTransfer, %{user_id: user_attrs["user_id"]})
    attrs = %{amount: 900}

    platform_transfer_reversal(transfer.id_from_stripe, attrs, user_attrs)
  end

  @spec platform_transfer_reversal(String.t(), map, map) :: {:ok, StripeTransferReversal.t} |
                                                            {:error, Ecto.Changeset.t} |
                                                            {:error, :not_found}
  defp platform_transfer_reversal(transfer_id, attrs, user_attrs) do
    case Accounts.by_role(user_attrs["user_id"]) do
      true ->
        with {:ok, %StripeTransferReversal{} = data} <- StripePlatformTransferReversalService.create(transfer_id, attrs, user_attrs) do
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end
end
