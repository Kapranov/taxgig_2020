defmodule Stripy.StripeService.StripePlatformBankAccountTokenService do
  @moduledoc """
  Used to perform actions on StripeBankAccountToken records, while propagating to
  and from associated StripeBankAccountToken records

  Stripe API reference: https://stripe.com/docs/api/tokens
  """

  alias Stripy.{
    Payments,
    Payments.StripeBankAccountToken,
    Queries,
    Repo,
    StripeService.Adapters.StripePlatformBankAccountTokenAdapter
  }

  @api Application.get_env(:stripy, :stripe)

  @doc """
  Creates a new `Stripe.Token` record on Stripe API, as well as an associated local
  `StripeBankAccountToken` record

  ## Example

      iex> user_id = FlakeId.get()
      iex> user_attrs = %{"user_id" => user_id}
      iex> attrs = %{
        bank_account: %{
          account_holder_name: "Jenny Rosen",
          account_holder_type: "individual",
          account_number: 000123456789,
          country: "US",
          currency: "usd",
          routing_number: 110000000
        }
      }
      iex> {:ok, bank_account_token} = Stripe.Token.create(attrs)
      iex> {:ok, result} = StripePlatformBankAccountTokenAdapter.to_params(bank_account_token, user_attrs)

  """
  @spec create(map, map) ::
          {:ok, StripeBankAccountToken.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, Stripe.Error.t()}
          | {:error, :platform_not_ready}
          | {:error, :not_found}
  def create(attrs, user_attrs) do
    querty =
      try do
        Queries.by_count(StripeBankAccountToken, :user_id, user_attrs["user_id"])
      rescue
        ArgumentError -> :error
      end

    with {:ok, %Stripe.Token{} = bank_account_token} = @api.Token.create(%{bank_account: attrs}),
         {:ok, params} <- StripePlatformBankAccountTokenAdapter.to_params(bank_account_token, user_attrs)
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

  @doc """
  only local
  """
  def delete do
  end
end
