defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformBalanceTransactionResolver do
  @moduledoc """
  The StripeBalanceTransaction GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeAccount,
    Repo,
    StripeService.StripePlatformBalanceTransactionService
  }

  @type t :: StripeAccount.t()
  @type reason :: any
  @type success_list :: {:ok, []}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_list | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :user_id, message: "An User not found! or Unauthenticated"]]}
    else
      case Accounts.by_role(current_user.id) do
        true ->
          with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
               {:ok, struct} <- StripePlatformBalanceTransactionService.list(account.id_from_stripe)
          do
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
                } -> {:ok, %{error: "HTTP Status: #{http_status}, balance transaction invalid, invalid request error. #{message}"}}
                {:error, %Ecto.Changeset{}} -> {:ok, %{error: "balance transaction not found!"}}
              end
          end
        false -> {:error, :not_found}
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end
end
