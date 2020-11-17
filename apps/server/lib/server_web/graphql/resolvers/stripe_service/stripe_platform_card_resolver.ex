defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformCardResolver do
  @moduledoc """
  The StripeCardToken GraphQL resolvers.
  """

  alias Core.Accounts
  alias Stripy.{
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    Repo,
    StripeService.StripePlatformCardService
  }

  @type t :: StripeCardToken.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list() | error_tuple()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :user_id, message: "An User not found! or Unauthenticated"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with customer <- Repo.get_by(StripeCustomer, %{user_id: current_user.id}),
               {:ok, struct} <- StripePlatformCardService.list_card(%{customer: customer})
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:cvc]) || is_nil(args[:exp_month]) || is_nil(args[:exp_year]) || is_nil(args[:name]) || is_nil(args[:number]) do
      {:error, [[field: :stripe_card_token, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with {:ok, struct} <- StripePlatformCardService.create_token(args, %{"user_id" => current_user.id}) do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
      end
    end
  end

  @spec delete(any, %{id: bitstring, customer: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{id: id_from_stripe, customer: id_from_customer}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) do
          true ->
            with {:ok, struct} <- StripePlatformCardService.delete_card(id_from_stripe, %{customer: id_from_customer}) do
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
end
