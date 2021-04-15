defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCustomerResolver do
  @moduledoc """
  The StripeCustomer GraphQL resolvers.
  """

  alias Core.Accounts.User

  alias Stripy.{
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    Queries,
    Repo,
    StripeService.StripePlatformCustomerService
  }

  @type t :: StripeCustomer.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    querty =
      try do
        Queries.by_count(StripeCardToken, :user_id, current_user.id)
      rescue
        ArgumentError -> :error
      end

    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) do
          true ->
            case Repo.aggregate(querty, :count, :id) do
              0 ->
                with {:ok, struct} <- StripePlatformCustomerService.delete(id_from_stripe) do
                  {:ok, struct}
                else
                  nil -> {:error, :not_found}
                  failure -> failure
                end
              _ ->
                {:error, "delete customer has been canceled"}
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCustomer #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end
end
