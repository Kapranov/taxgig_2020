defmodule Stripy.StripeService.StripePlatformAccountTokenService do
  @moduledoc """
  Used to perform actions on StripeAccountToken records, while propagating to
  and from associated Stripe.StripeAccountToken records

  Stripe API reference: https://stripe.com/docs/api/tokens
  """

  alias Stripy.{
    Payments,
    Payments.StripeAccountToken,
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
    :email,
    :first_name,
    :id_number,
    :last_name,
    :maiden_name,
    :name,
    :phone,
    :tax_id,
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
        business_type: "individual",
        company: %{
          name: "Vlad Puryshev",
          tax_id: "000000000"
        },
        individual: %{
          email: "vk@taxgig.com",
          first_name: "Vlad",
          id_number: "000000000",
          last_name: "Puryshev",
          maiden_name: "Jr",
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
      iex> {:ok, account_token} = create(attrs, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeAccountToken.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | nil
  def create(attrs, user_attrs) do
    case Stripe.Token.create(%{account: attrs}) do
      {:ok, account_token} ->
        with {:ok, params} <- StripePlatformAccountTokenAdapter.to_params(account_token, user_attrs),
             {:ok, struct} <- Payments.create_stripe_account_token(params)
        do
          {:ok, struct}
        else
          failure -> failure
        end
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
          | nil
  def delete(id) do
    case Repo.get_by(StripeAccountToken, %{id_from_stripe: id}) do
      nil -> nil
      struct ->
        with {:ok, deleted} <- Payments.delete_stripe_account_token(struct) do
          {:ok, deleted}
        else
          failure -> failure
        end
    end
  end
end
