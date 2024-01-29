defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountResolver do
  @moduledoc """
  The StripeAccount GraphQL resolvers.
  """

  alias Core.{
    Accounts,
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

  @spec update(any, %{id_from_stripe: bitstring, stripe_account: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_root, %{id_from_stripe: id, stripe_account: attrs}, %{context: %{current_user: current_user}}) do
    try do
      case Accounts.by_role(current_user.id) do
        false -> {:error, :not_found}
        true ->
          with {:ok, struct} <- StripePlatformAccountService.update(id, attrs) do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
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
                } -> {:ok, %{error: "HTTP Status: #{http_status}, account request error. #{message}"}}
                {:error, %Ecto.Changeset{}} -> {:ok, %{error: "account not found!"}}
              end
          end
      end
    rescue
      Ecto.NoResultsError ->
        {:error, "The StripeAccount #{id} not found!"}
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

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
