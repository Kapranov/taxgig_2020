defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCustomerResolver do
  @moduledoc """
  The StripeCustomer GraphQL resolvers.
  """

  alias Stripy.{
    Payments.StripeCustomer,
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

  @spec delete(any, %{id_from_stripe: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) do
          true ->
            with {:ok, struct} <- StripePlatformCustomerService.delete(id_from_stripe) do
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
          {:error, "The StripeCustomer #{id_from_stripe} not found!"}
      end
    end
  end
end
