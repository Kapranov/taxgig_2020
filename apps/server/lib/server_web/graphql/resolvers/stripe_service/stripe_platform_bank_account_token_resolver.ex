defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformBankAccountTokenResolver do
  @moduledoc """
  The StripeBankAccountToken GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments,
    Payments.StripeBankAccountToken,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformBankAccountTokenAdapter,
    StripeService.StripePlatformBankAccountTokenService
  }

  @type t :: StripeBankAccountToken.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:account_holder_name]) ||
       is_nil(args[:account_holder_type]) ||
       is_nil(args[:account_number]) ||
       is_nil(args[:country]) ||
       is_nil(args[:currency]) ||
       is_nil(args[:routing_number])
    do
      {:error, [
          [field: :account_holder_name, message: "Can't be blank"],
          [field: :account_holder_type, message: "Can't be blank"],
          [field: :account_number, message: "Can't be blank"],
          [field: :country, message: "Can't be blank"],
          [field: :currency, message: "Can't be blank"],
          [field: :routing_number, message: "Can't be blank"]
        ]
      }
    else
      case Accounts.by_role(current_user.id) do
        false ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
        true ->
          querty =
            try do
              Queries.by_count(StripeBankAccountToken, :user_id, current_user.id)
            rescue
              ArgumentError -> :error
            end

          case Repo.aggregate(querty, :count, :id) < 10 do
            true ->
              with {:ok, %Stripe.Token{} = bank_account_token} = Stripe.Token.create(%{bank_account: args}),
                   {:ok, params} <- StripePlatformBankAccountTokenAdapter.to_params(bank_account_token, %{"user_id" => current_user.id}),
                   {:ok, struct} <- Payments.create_stripe_bank_account_token(params)
              do
                {:ok, struct}
              else
                nil -> {:error, :not_found}
                {:error, %Stripe.Error{code: :invalid_request_error, extra: %{card_code: :account_number_invalid, http_status: http_status, param: :"bank_account[account_number]", raw_error: %{"code" => "account_number_invalid", "doc_url" => "https://stripe.com/docs/error-codes/account-number-invalid", "message" => "You must use a test bank account number in test mode. Try 000123456789 or see more options at https://stripe.com/docs/connect/testing#account-numbers.", "param" => "bank_account[account_number]", "type" => "invalid_request_error"}}, message: "You must use a test bank account number in test mode. Try 000123456789 or see more options at https://stripe.com/docs/connect/testing#account-numbers.", request_id: nil, source: :stripe, user_message: nil}} ->
                  {:ok, %{error: "HTTP Status: #{http_status}, bank account token invalid, invalid request error. #{http_status}"}}
                {:error, %Ecto.Changeset{}} -> {:ok, %{error: "bank account token not found!"}}
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
            with {:ok, struct} <- StripePlatformBankAccountTokenService.delete(id_from_stripe) do
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
                  } -> {:ok, %{error: "HTTP Status: #{http_status}, bank account token invalid, invalid request error. #{message}"}}
                  {:error, %Ecto.Changeset{}} -> {:ok, %{error: "bank account token not found!"}}
                end
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeBankAccountToken #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end
end
