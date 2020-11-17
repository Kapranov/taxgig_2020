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
        true -> {:error, :not_found}
        false ->
          with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
               {:ok, struct} <- StripePlatformExternalAccountBankService.list(:bank_account, %{account: account.id_from_stripe})
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
      end
    end
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:token]) do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        false -> {:error, %Ecto.Changeset{}}
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
                  failure -> failure
                end
              else
                {:error, %Ecto.Changeset{}}
              end
            false -> {:error, %Ecto.Changeset{}}
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
            with account <- Repo.get_by(StripeAccount, %{user_id: current_user.id}),
                 {:ok, struct} <- StripePlatformExternalAccountBankService.delete(id_from_stripe, %{account: account.id_from_stripe})
            do
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
          {:error, "The StripeExternalAccountBank #{id_from_stripe} not found!"}
      end
    end
  end
end
