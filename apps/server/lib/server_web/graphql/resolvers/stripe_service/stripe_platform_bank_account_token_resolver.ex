defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformBankAccountTokenResolver do
  @moduledoc """
  The StripeBankAccountToken GraphQL resolvers.
  """

  alias Core.{
    Accounts.User,
    Repo,
    Queries
  }

  alias Stripy.{
    Payments.StripeBankAccountToken,
    StripeService.StripePlatformBankAccountTokenService
  }

  @type t :: StripeBankAccountToken.t()
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:ok, %{error: String.t()}}
  @type result :: success_tuple | error_tuple

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    querty = Queries.by_value(StripeBankAccountToken, :user_id, current_user.id)
    case current_user.role do
      false -> {:ok, %{error: "permission denied"}}
      true  ->
        case Repo.aggregate(querty, :count, :id) < 10 do
          false -> {:ok, %{error: "permission denied"}}
          true ->
            case StripePlatformBankAccountTokenService.create(%{bank_account: %{
                account_holder_name: args[:account_holder_name],
                account_holder_type: args[:account_holder_type],
                account_number: args[:account_number],
                country: args[:country],
                currency: args[:currency],
                routing_number: args[:routing_number]
              }}, %{"user_id" => current_user.id})
            do
              {:ok, struct} -> {:ok, struct}
            end
        end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}
end
