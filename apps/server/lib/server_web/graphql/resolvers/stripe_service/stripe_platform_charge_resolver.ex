defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver do
  @moduledoc """
  The StripeCharge GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeCharge,
    Payments.StripeCustomer,
    Repo,
    StripeService.StripePlatformChargeService
  }

  @type t :: StripeCharge.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:amount]) ||
       is_nil(args[:capture]) ||
       is_nil(args[:currency]) ||
       is_nil(args[:description]) ||
       is_nil(args[:id_from_card])
    do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with customer <- Repo.get_by(StripeCustomer, %{user_id: current_user.id}),
                {:ok, struct} <- StripePlatformChargeService.create(%{
                  amount: Decimal.to_integer(Decimal.round(args[:amount], 0, :down)),
                  capture: args[:capture],
                  currency: args[:currency],
                  customer: customer.id_from_stripe,
                  description: args[:description],
                  source: args[:id_from_card]
                },
                %{"user_id" => current_user.id, "id_from_card" => args[:id_from_card]}
               )
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
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
            with {:ok, struct} <- StripePlatformChargeService.delete(id_from_stripe) do
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
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end
end
