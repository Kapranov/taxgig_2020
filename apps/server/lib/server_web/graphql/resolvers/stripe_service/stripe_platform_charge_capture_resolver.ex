defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver do
  @moduledoc """
  The StripeChargeCapture GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User
  }

  alias Stripy.{
    Payments.StripeCharge,
    Repo,
    StripeService.StripePlatformChargeCaptureService
  }

  @type t :: StripeCharge.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec update(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- Repo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                {:ok, struct} <- StripePlatformChargeCaptureService.create(charge.id_from_stripe, %{amount: charge.amount})
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end
end
