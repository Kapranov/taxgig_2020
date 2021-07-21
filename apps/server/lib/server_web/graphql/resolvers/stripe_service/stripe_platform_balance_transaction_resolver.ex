defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformBalanceTransactionResolver do
  @moduledoc """
  The StripeBalanceTransaction GraphQL resolvers.
  """

  alias Core.Accounts.User

  alias Stripy.{
    Payments.StripeAccount,
    Repo,
    StripeService.StripePlatformBalanceTransactionService
  }

  @type t :: StripeAccount.t()
  @type reason :: any
  @type success_list :: {:ok, [t]}
  @type empty_list :: {:ok, []}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_list | empty_list | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    case current_user.role do
      true ->
        case Repo.get_by(StripeAccount, %{user_id: current_user.id}) do
          nil -> {:ok, %{error: "stripeAccount not found"}}
          account ->
            with {:ok, struct} <- StripePlatformBalanceTransactionService.list(account.id_from_stripe) do
              {:ok, struct}
            else
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
                  } -> {:ok, %{error: "HTTP Status: #{http_status}, external account bank invalid request error. #{message}"}}
                end
            end
        end
      false ->
        {:ok, %{error: "permission denied"}}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def list(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}

  @spec retrieve(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def retrieve(_parent, _args, %{context: %{current_user: current_user}}) do
    case current_user.role do
      true ->
        case Repo.get_by(StripeAccount, %{user_id: current_user.id}) do
          nil -> {:ok, %{error: "stripeAccount not found"}}
          account ->
            with {:ok, struct} <- StripePlatformBalanceTransactionService.retrieve([], %{"Stripe-Account": account.id_from_stripe}) do
              {:ok, struct}
            else
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
                  } -> {:ok, %{error: "HTTP Status: #{http_status}, external account bank invalid request error. #{message}"}}
                end
            end
        end
      false ->
        {:ok, %{error: "permission denied"}}
    end
  end

  @spec retrieve(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def retrieve(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}
end
