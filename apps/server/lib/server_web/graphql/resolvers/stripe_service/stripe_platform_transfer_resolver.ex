defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformTransferResolver do
  @moduledoc """
  The StripeTransfer GraphQL resolvers.
  """

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

  @type t :: StripeTransfer.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple


  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:id_from_project]) ||
       is_nil(args[:currency])
    do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          project = CoreRepo.get_by(Project, %{id: args[:id_from_project]})
          if is_nil(project.id_from_stripe_transfer) do
            with account <- StripyRepo.get_by(StripeAccount, %{user_id: project.assigned_id}),
                 {:ok, struct} <- StripePlatformTransferService.create(%{
                    amount: amount(project.offer_price, project.addon_price),
                    currency: args[:currency],
                    destination: account.id_from_stripe
                  },
                  %{"user_id" => current_user.id}
                 )
            do
              {:ok, %Project{}} = Contracts.update_project(project, %{id_from_stripe_transfer: struct.id_from_stripe})
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
          else
            {:error, %Ecto.Changeset{}}
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) do
          true ->
            with {:ok, struct} <- StripePlatformTransferService.delete(id_from_stripe) do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeTransfer #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec amount(integer, integer) :: integer
  defp amount(offer_price, addon_price) do
    val1 =
      (Decimal.to_float(offer_price) * 100)
      |> :erlang.float_to_binary(decimals: 0)
      |> String.to_integer

    ((val1 + addon_price) * 0.8)
    |> :erlang.float_to_binary(decimals: 0)
    |> String.to_integer
  end
end
