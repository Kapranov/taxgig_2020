defmodule Stripy.StripeService.StripePlatformAccountTokenService do
  @moduledoc """
  Used to perform actions on StripeAccountToken records, while propagating to
  and from associated Stripe.StripeAccountToken records
  """

  alias Stripy.{
    Payments,
    Payments.StripeAccountToken,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformAccountTokenAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.Token` record on Stripe API, as well as an associated local
  `StripeAccountToken` record

  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> account_attrs = %{
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
      iex> {:ok, created_token} = Stripe.Token.create(%{account: account_attrs})
      iex> {:ok, result} = StripePlatformAccountTokenAdapter.to_params(created_token, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeAccountToken.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(account_attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeAccountToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

      with {:ok, %Stripe.Token{} = account_token} = @api.Token.create(%{account: account_attrs}),
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
end
