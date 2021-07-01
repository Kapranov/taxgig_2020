defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountResolver do
  @moduledoc """
  The StripeAccount GraphQL resolvers.
  """

  alias Core.{
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeAccountToken,
    Repo,
    StripeService.StripePlatformAccountService,
  }

  @type t :: StripeAccount.t()
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:ok, %{error: String.t()}}
  @type result :: success_tuple | error_tuple

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe, user_id: user_id}, %{context: %{current_user: current_user}}) do
    case current_user.admin do
      true ->
        with query <- Queries.by_value(StripeAccountToken, :user_id, user_id),
             true <- Repo.exists?(query),
             {:ok, struct} <- StripePlatformAccountService.delete(id_from_stripe),
             {_, _} <- Repo.delete_all(query)
        do
          {:ok, struct}
        else
          nil -> {:ok, %{error: "The StripeAccount not found!"}}
          false -> {:ok, %{error: "The StripeAccountToken not found!"}}
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
      false -> {:ok, %{error: "permission denied"}}
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}
end
