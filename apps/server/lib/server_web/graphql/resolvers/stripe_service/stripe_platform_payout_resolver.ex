defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformPayoutResolver do
  @moduledoc """
  The StripePayout GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeAccount,
    Repo,
    StripeService.StripePlatformPayoutService
  }

  @type t :: Stripe.Payout.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    case Accounts.by_role(current_user.id) do
      false -> {:error, %Ecto.Changeset{}}
      true ->
        case args[:type] do
          "bank" ->
            with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
                 {:ok, struct} <- StripePlatformPayoutService.create_bank(%{
                   amount: args[:amount],
                   destination: args[:destination],
                   currency: args[:currency]
                 }, account.id_from_stripe)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
          "card" ->
            with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
                 {:ok, struct} <- StripePlatformPayoutService.create_card(%{
                   amount: args[:amount],
                   destination: args[:destination],
                   currency: args[:currency]
                 }, account.id_from_stripe)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
          _ -> {:error, %Ecto.Changeset{}}
        end
    end
  end
end
