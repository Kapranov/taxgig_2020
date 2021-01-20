defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformTransferReversalResolver do
  @moduledoc """
  The StripeTransferReversal GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeTransfer,
    Payments.StripeTransferReversal,
    Queries,
    Repo,
    StripeService.StripePlatformTransferReversalService
  }

  @type t :: StripeTransferReversal.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:id_from_transfer]) ||
       is_nil(args[:amount])
    do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          transfer = Repo.get_by(StripeTransfer, %{id_from_stripe: args[:id_from_transfer]})
          if transfer.amount >= args[:amount] do
            case Queries.by_sum(StripeTransfer, StripeTransferReversal, :id_from_stripe, :id_from_transfer, :user_id, :amount, transfer.id_from_stripe) do
              [true] ->
                with {:ok, struct} <- StripePlatformTransferReversalService.create(transfer.id_from_stripe, %{amount: args[:amount]}, %{"user_id" => current_user.id}) do
                  {:ok, struct}
                else
                  nil -> {:error, :not_found}
                  failure -> failure
                end
              [false] -> {:error, %Ecto.Changeset{}}
              [nil] ->
                with {:ok, struct} <- StripePlatformTransferReversalService.create(transfer.id_from_stripe, %{amount: args[:amount]}, %{"user_id" => current_user.id}) do
                  {:ok, struct}
                else
                  nil -> {:error, :not_found}
                  failure -> failure
                end
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
            with {:ok, struct} <- StripePlatformTransferReversalService.delete(id_from_stripe) do
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
          {:error, "The StripeTransferReversal #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end
end
