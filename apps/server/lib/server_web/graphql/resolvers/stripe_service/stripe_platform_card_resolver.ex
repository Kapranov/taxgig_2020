defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCardResolver do
  @moduledoc """
  The StripeCardToken GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments,
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    StripeService.StripePlatformCardService,
    StripeService.StripePlatformCustomerService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @type t :: StripeCardToken.t()
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
          struct = Queries.by_list(Accounts.Platform, :user_id, current_user.id)
          if struct == [] or Map.get(List.last(struct), :payment_active) == false do
            {:ok, []}
          else
            with customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}),
                 {:ok, struct} <- StripePlatformCardService.list_card(%{customer: customer.id_from_stripe})
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
          end
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:currency]) ||
       is_nil(args[:cvc]) ||
       is_nil(args[:exp_month]) ||
       is_nil(args[:exp_year]) ||
       is_nil(args[:name]) ||
       is_nil(args[:number])
    do
      {:error, [[field: :stripe_card_token, message: "Can't be blank"]]}
    else
      querty =
        try do
          Queries.by_value(StripeCardToken, :user_id, current_user.id)
        rescue
          ArgumentError -> :error
        end

      case Accounts.by_role(current_user.id) do
        true ->
          case CoreRepo.aggregate(querty, :count, :id) < 10 do
            true ->
              with {:ok, struct} <- StripePlatformCardService.create_token(args, %{"user_id" => current_user.id}) do
                {:ok, struct}
              else
                nil -> {:error, :not_found}
                failure -> failure
              end
            false -> {:error, %Ecto.Changeset{}}
          end
        false ->
          case CoreRepo.aggregate(querty, :count, :id) do
            0 ->
              with {:ok, card} <- StripePlatformCardService.create_token(args, %{"user_id" => current_user.id}),
                   user <- CoreRepo.get_by(User, id: current_user.id),
                   full_name <- Accounts.by_full_name(user.id),
                   {:ok, customer} <- StripePlatformCustomerService.create(%{email: user.email, name: full_name, phone: user.phone, source: card.token}, %{"user_id" => current_user.id})
              do
                {:ok, %StripeCardToken{}} = Payments.update_stripe_card_token(card, %{
                  id_from_customer: customer.id_from_stripe,
                  token: "xxxxxxxxx"
                })
              else
                nil -> {:error, :not_found}
                failure -> failure
              end
            n ->
              case n < 10 do
                true ->
                  with {:ok, created_token} <- StripePlatformCardService.create_token(args, %{"user_id" => current_user.id}),
                       id_from_customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}).id_from_stripe,
                       {:ok, created_card} <- StripePlatformCardService.create_card(%{customer: id_from_customer, source: created_token.token})
                  do
                    {:ok, %StripeCardToken{}} = Payments.update_stripe_card_token(created_token, %{
                      id_from_customer: created_card.customer,
                      token: "xxxxxxxxx"
                    })
                  else
                    nil -> {:error, :not_found}
                    failure -> failure
                  end
                false -> {:error, %Ecto.Changeset{}}
              end
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
            with customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}),
                 {:ok, struct} <- StripePlatformCardService.delete_card(id_from_stripe, %{customer: customer.id})
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
          {:error, "The StripeCarToken #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end
end
