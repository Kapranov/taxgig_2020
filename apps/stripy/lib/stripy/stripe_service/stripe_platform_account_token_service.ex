defmodule Stripy.StripeService.StripePlatformAccountTokenService do
  @moduledoc """
  Used to perform actions on StripeAccountToken records, while propagating to
  and from associated Stripe.StripeAccountToken records

  Stripe API reference: https://stripe.com/docs/api/tokens
  """

  alias Stripy.{
    Payments,
    Payments.StripeAccountToken,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformAccountTokenAdapter
  }

  @doc """
  Creates a new `Stripe.Token` record on Stripe API, as well as an associated local
  `StripeAccountToken` record

  Creates a single-use token that wraps a user’s legal entity information.
  Use this when creating or updating a Connect account.

  StripeAccountToken:
  fronend - [
    :business_type,
    :first_name,
    :last_name,
    :maiden_name,
    :email,
    :phone,
    address: %{
      :city,
      :country,
      :line1,
      :postal_code,
      :state
    },
    dob: %{
      :day,
      :month,
      :year
    },
    :ssn_last_4,
    :tos_shown_and_accepted
  ]
  backend - []

  StripeAccount:
  fronend - []
  backend - []

  1. If create a new `StripeAccountToken` and `StripeAccount` this performs only
     one records and for role's pro.
  2. if has one record return error
  3. If `StripeAccountToken` creation fails, don't create `StripeAccount` and return an error
  4. If `StripeAccountToken` creation succeeds return created `StripeAccountToken`

  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{
        account: %{
          business_type: "individual",
          individual: %{
            first_name: "Vlad",
            last_name: "Puryshev",
            maiden_name: "Jr",
            email: "vk@taxgig.com",
            phone: "999-999-9999",
            address: %{
              city: "New York",
              country: "us",
              line1: "95 Wall St",
              postal_code: 10005,
              state: "NY"
            },
            dob: %{
              day: 15,
              month: 7,
              year: 1989
            },
            ssn_last_4: "0000"
          },
          tos_shown_and_accepted: true
        }
      }
      iex> {:ok, account_token} = create(attrs, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeAccountToken.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeAccountToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Token{} = account_token} = Stripe.Token.create(%{account: attrs}),
         {:ok, params} <- StripePlatformAccountTokenAdapter.to_params(account_token, user_attrs)
    do
      case Repo.aggregate(querty, :count, :id) < 10 do
        false -> {:error, %Ecto.Changeset{}}
        true ->
          case Payments.create_stripe_account_token(params) do
            {:error, error} -> {:error, error}
            {:ok, data} -> {:ok, data}
          end
      end

    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end

  @doc """
  Delete StripeAccountToken

  ## Example

      iex> id = "ct_1HmiqgLhtqtNnMebvcO8EfQh"
      iex> {:ok, deleted} = delete(id)

  """
  @spec delete(String.t) ::
          {:ok, StripeAccountToken.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def delete(id) do
    with struct <- Repo.get_by(StripeAccountToken, %{id_from_stripe: id}),
         {:ok, deleted} <- Payments.delete_stripe_account_token(struct)
    do
      {:ok, deleted}
    else
      nil -> {:error, :not_found}
      failure -> failure
    end
  end
end
