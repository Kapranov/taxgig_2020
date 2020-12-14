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
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
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

            with {:ok, %Stripe.Token{} = bank_account_token} = Stripe.Token.create(%{bank_account: args}),
                 {:ok, params} <- StripePlatformBankAccountTokenAdapter.to_params(bank_account_token, %{"user_id" => current_user.id})
            do
              case Repo.aggregate(querty, :count, :id) < 10 do
                false -> {:error, %Ecto.Changeset{}}
                true ->
                  case Payments.create_stripe_bank_account_token(params) do
                    {:error, error} -> {:error, error}
                    {:ok, data} -> {:ok, data}
                  end
              end
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
      end
    end
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
              failure -> failure
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
end
