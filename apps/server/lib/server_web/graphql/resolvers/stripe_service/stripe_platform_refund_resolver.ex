defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformRefundResolver do
  @moduledoc """
  The StripeRefund GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeCharge,
    Payments.StripeRefund,
    Queries,
    Repo,
    StripeService.StripePlatformRefundService
  }

  @type t :: StripeRefund.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:amount]) || is_nil(args[:id_from_stripe]) do
      {:error, [[field: :stripe_refund, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with charge <- Repo.get_by(StripeCharge, %{id_from_stripe: args[:id_from_stripe]}) do
            if charge.captured == true and charge.amount >= args[:amount] do
              case Queries.by_sum(StripeCharge, StripeRefund, :id_from_stripe, :id_from_charge, :user_id, :amount, charge.id_from_stripe) do
                [true] ->
                  with {:ok, struct} <- StripePlatformRefundService.create(%{amount: args[:amount], charge: args[:id_from_stripe]}, %{"user_id" => current_user.id}) do
                    {:ok, struct}
                  else
                    nil -> {:error, :not_found}
                    failure -> failure
                  end
                [false] -> {:error, %Ecto.Changeset{}}
                [nil] ->
                  with {:ok, struct} <- StripePlatformRefundService.create(%{amount: args[:amount], charge: args[:id_from_stripe]}, %{"user_id" => current_user.id}) do
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
  end

  @spec delete(any, %{id_from_charge: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_charge: id_from_charge}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_charge) do
      {:error, [[field: :id_from_charge, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) do
          true ->
            with {:ok, struct} <- StripePlatformRefundService.delete(id_from_charge) do
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
          {:error, "The StripeRefund #{id_from_charge} not found!"}
      end
    end
  end
end
