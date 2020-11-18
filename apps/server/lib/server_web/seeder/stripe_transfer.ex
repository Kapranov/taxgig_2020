defmodule ServerWeb.Seeder.StripeTransfer do
  @moduledoc """
  Seeds for `Stripy.StripeTransfer` context.
  """

  import Ecto.Query

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.Project
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
  Used to create a remote `Stripe.Transfer` record as well as
  an associated local `StripeTransfer` record.

  To send funds from your Stripe account to a connected account, you create a new
  transfer object. Your Stripe balance must be able to cover the transfer amount,
  or you’ll receive an Insufficient Funds error.

  frontend - []
  backend  - [:amount, :destination, :currency]

  1. For create a new `StripeTransfer` check field's `id_drom_stripe_transfer`
     by `Core.Project` it must be null, it will take field's `project_price`
     by `Core.Project` and create new value:
     (amount = (project.project_price * 0.8 * 100)), result write in field's
     `amount` by `StripeTransfer`. If Trasfer has been successful to update it.
     Transfer can be performed once per Project.
  2. If no data, show error
  """
  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_stripe_transfer()
  end

  @spec seed_stripe_transfer() :: [Ecto.Schema.t()]
  defp seed_stripe_transfer do
    user = CoreRepo.get_by(User, %{email: "op@taxgig.com"})
    user_attrs = %{"user_id" => user.id}
    account = StripyRepo.get_by(StripeAccount, %{user_id: user_attrs["user_id"]})
    querty = CoreRepo.all(from p in Project, where: p.assigned_pro == ^user.id) |> List.last
    attrs = %{amount: amount(1000), currency: "usd", destination: account.id_from_stripe}

    if is_nil(querty.id_from_stripe_transfer) do
      platform_transfer(attrs, user_attrs, querty.id)
    else
      {:error, %Ecto.Changeset{}}
    end
  end

  @spec platform_transfer(map, map, String.t()) ::
          {:ok, StripeTransfer.t}
          | {:error, Ecto.Changeset.t}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  defp platform_transfer(attrs, user_attrs, id) do
    case Accounts.by_role(user_attrs["user_id"]) do
      true ->
        with project <- CoreRepo.get_by(Project, %{id: id}),
             {:ok, %StripeTransfer{} = data} <- StripePlatformTransferService.create(attrs, user_attrs)
        do
          {:ok, %Project{}} = Contracts.update_project(project, %{id_from_stripe_transfer: data.id_from_stripe})
          {:ok, data}
        else
          nil -> {:error, :not_found}
          failure -> failure
        end
      false -> {:error, %Ecto.Changeset{}}
    end
  end

  @spec amount(integer) :: integer
  defp amount(value) do
    sum =
      (value * 0.8 * 100)
      |> :erlang.float_to_binary(decimals: 0)
      |> String.to_integer

    sum
  end
end
