defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountResolver do
  @moduledoc """
  The StripeAccount GraphQL resolvers.
  """

  alias Core.Accounts.User

  alias Stripy.{
    Payments.StripeAccount,
    StripeService.StripePlatformAccountService,
  }

  @type t :: StripeAccount.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    try do
      case current_user.role do
        true ->
          with {:ok, struct} <- StripePlatformAccountService.delete(id_from_stripe) do
            {:ok, struct}
          else
            nil -> {:ok, %{error: "The StripeAccount #{id_from_stripe} not found!"}}
            failure ->
              case failure do
                {:error, %Stripe.Error{code: _, extra: %{
                      card_code: _,
                      http_status: http_status,
                      raw_error: _
                    },
                    message: message,
                    request_id: _,
                    source: _,
                    user_message: _
                  }
                } -> {:ok, %{error: "HTTP Status: #{http_status}, account invalid request error. #{message}"}}
                {:error, %Ecto.Changeset{}} -> {:ok, %{error: "The StripeAccount #{id_from_stripe} not found!"}}
              end
          end
        false -> {:ok, %{error: "wrong type of user"}}
      end
    rescue
      Ecto.NoResultsError ->
        {:ok, %{error: "The StripeAccount #{id_from_stripe} not found!"}}
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:ok, %{error: "unauthenticated"}}
  end
end
