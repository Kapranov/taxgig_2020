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
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: success_list() | error_tuple()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :user_id, message: "An User not found! or Unauthenticated"]]}
    else
      case Accounts.by_role(current_user.id) do
        true ->
          struct = Queries.by_list(StripeExternalAccountBank, :user_id, current_user.id)
          {:ok, struct}
        false -> {:error, :not_found}
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

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
    if is_nil(args[:token]) do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        false ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
        true ->
          count_bank =
            try do
              Queries.by_value(StripeExternalAccountBank, :user_id, current_user.id)
            rescue
              ArgumentError -> :error
            end

          count_card =
            try do
              Queries.by_value(StripeExternalAccountCard, :user_id, current_user.id)
            rescue
              ArgumentError -> :error
            end

          case Accounts.by_role(current_user.id) do
            true ->
              if (Repo.aggregate(count_bank, :count, :id) + Repo.aggregate(count_card, :count, :id)) < 10 do
                with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
                    {:ok, struct} <- StripePlatformExternalAccountBankService.create(%{
                      account: account.id_from_stripe,
                      token: args[:token]
                    }, %{"user_id" => current_user.id})
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
              else
                {:error, %Ecto.Changeset{}}
              end
            false -> {:error, %Ecto.Changeset{}}
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
            with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
                 {:ok, struct} <- StripePlatformExternalAccountBankService.delete(id_from_stripe, %{account: account.id_from_stripe})
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
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeExternalAccountBank #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end
end
