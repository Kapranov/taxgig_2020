defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformExternalAccountBankResolver do
  @moduledoc """
  The StripeExternalAccountBank GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeExternalAccountBank,
    Payments.StripeExternalAccountCard,
    Repo,
    StripeService.StripePlatformExternalAccountBankService
  }

  @type t :: StripeExternalAccountBank.t()
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:ok, %{error: String.t()}}
  @type result :: success_tuple | success_list | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: success_list() | error_tuple()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    case current_user.role do
      true ->
        struct = Queries.by_list(StripeExternalAccountBank, :user_id, current_user.id)
        {:ok, struct}
      false ->
        {:ok, %{error: "permission denied"}}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def list(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}

  @spec list_by_stripe(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: success_list() | error_tuple()
  def list_by_stripe(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :user_id, message: "An User not found! or Unauthenticated"]]}
    else
      case Accounts.by_role(current_user.id) do
        true ->
          with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
               {:ok, struct} <- StripePlatformExternalAccountBankService.list(:bank_account, %{account: account.id_from_stripe})
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
                } -> {:ok, %{error: "HTTP Status: #{http_status}, external account bank invalid request error. #{message}"}}
                {:error, %Ecto.Changeset{}} -> {:ok, %{error: "external account bank not found!"}}
              end
          end
        false -> {:error, :not_found}
      end
    end
  end

  @spec list_by_stripe(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list_by_stripe(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    case current_user.role do
      false ->
        {:ok, %{error: "permission denied"}}
      true ->
        count_bank = Queries.by_value(StripeExternalAccountBank, :user_id, current_user.id)
        count_card = Queries.by_value(StripeExternalAccountCard, :user_id, current_user.id)

        case current_user.role do
          true ->
            if (Repo.aggregate(count_bank, :count, :id) + Repo.aggregate(count_card, :count, :id)) < 10 do
              case Repo.get_by(StripeAccount, %{user_id: current_user.id}) do
                nil -> {:ok, %{error: "stripeAccount not found"}}
                account ->
                  with {:ok, struct} <- StripePlatformExternalAccountBankService.create(%{
                        account: account.id_from_stripe,
                        token: args[:token]
                      }, %{"user_id" => current_user.id})
                  do
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
                        {:error, %Ecto.Changeset{}} -> {:ok, %{error: "cannot be created locally due to server error"}}
                      end
                  end
              end
            else
              {:ok, %{error: "Limit reached - count_bank: #{count_bank} and count_card: #{count_card}. No more than 10 payouts permitted per user"}}
            end
          false ->
            {:ok, %{error: "permission denied"}}
        end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    case Repo.get_by(StripeAccount, %{user_id: current_user.id}) do
      nil -> {:ok, %{error: "stripeExternalAccountBank not found"}}
      account ->
        with {:ok, struct} <- StripePlatformExternalAccountBankService.delete(id_from_stripe, %{account: account.id_from_stripe}) do
          {:ok, struct}
        else
          nil -> {:ok, %{error: "The StripeExternalAccountBank not found!"}}
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
              {:error, %Ecto.Changeset{}} -> {:ok, %{error: "delete failed due to local error"}}
            end
        end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}
end
