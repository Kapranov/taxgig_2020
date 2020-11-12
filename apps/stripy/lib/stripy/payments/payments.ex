defmodule Stripy.Payments do
  @moduledoc """
  The Payments for context.
  """

  use Stripy.Context

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeAccountToken,
    Payments.StripeBankAccountToken,
    Payments.StripeCardToken,
    Payments.StripeCharge,
    Payments.StripeCustomer,
    Payments.StripeExternalAccountBank,
    Payments.StripeExternalAccountCard,
    Payments.StripeRefund,
    Payments.StripeTransfer,
    Payments.StripeTransferReversal,
    Repo
  }

  @doc """
  Gets a single StripeAccount.

  Raises `Ecto.NoResultsError` if the StripeAccount does not exist.

  ## Example

      iex> get_stripe_account!(123)
      %StripeAccount{}

      iex> get_stripe_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_account!(id), do: Repo.get(StripeAccount, id)

  @doc """
  Creates StripeAccount.

  ## Examples

      iex> create_stripe_account(%{field: value})
      {:ok, %StripeAccount{}}

      iex> create_stripe_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_stripe_account(attrs) do
    %StripeAccount{}
    |> StripeAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates StripeAccount

  ## Examples

      iex> update_stripe_account(struct, %{field: new_value})
      {:ok, %StripeAccount{}}

      iex> update_stripe_account(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec update_stripe_account(StripeAccount.t(), %{atom => any}) :: result() | error_tuple()
  def update_stripe_account(struct, attrs) do
    struct
    |> StripeAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes StripeAccount.

  ## Examples

      iex> delete_stripe_account(stripe_account)
      {:ok, %StripeAccount{}}

      iex> delete_stripe_account(stripe_account)
      {:error, %Ecto.Changeset{}}
  """
  def delete_stripe_account(%StripeAccount{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeAccountToken.

  Raises `Ecto.NoResultsError` if the StripeAccountToken does not exist.

  ## Examples

      iex> get_stripe_account_token!(123)
      %StripeAccountToken{}

      iex> get_stripe_account_token!(456)
      ** (Ecto.NoResultsError)
  """
  def get_stripe_account_token!(id), do: Repo.get!(StripeAccountToken, id)

  @doc """
  Creates StripeAccountToken.

  ## Examples

      iex> create_stripe_account_token(%{field: value})
      {:ok, %StripeAccountToken{}}

      iex> create_stripe_account_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_stripe_account_token(attrs) do
    %StripeAccountToken{}
    |> StripeAccountToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes StripeAccountToken.

  ## Examples

      iex> delete_stripe_account_token(stripe_account_token)
      {:ok, %StripeAccountToken{}}

      iex> delete_stripe_account_token(stripe_account_token)
      {:error, %Ecto.Changeset{}}
  """
  def delete_stripe_account_token(%StripeAccountToken{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeBankAccountToken.

  Raises `Ecto.NoResultsError` if the StripeBankAccountToken does not exist.

  ## Examples

      iex> get_stripe_bank_account_token!(123)
      %StripeBankAccountToken{}

      iex> get_stripe_bank_account_token!(456)
      ** (Ecto.NoResultsError)
  """
  def get_stripe_bank_account_token!(id), do: Repo.get!(StripeBankAccountToken, id)

  @doc """
  Creates StripeBankAccountToken.

  ## Examples

      iex> create_stripe_bank_account_token(%{field: value})
      {:ok, %StripeBankAccountToken{}}

      iex> create_stripe_bank_account_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_bank_account_token(attrs) do
    %StripeBankAccountToken{}
    |> StripeBankAccountToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes StripeBankAccountToken.

  ## Examples

      iex> delete_stripe_bank_account_token(stripe_bank_account_token)
      {:ok, %StripeBankAccountToken{}}

      iex> delete_stripe_bank_account_token(stripe_bank_account_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_bank_account_token(%StripeBankAccountToken{} = struct), do: Repo.delete(struct)

  @doc """
  Returns the list of the StripeCardToken.

  ## Examples

      iex> list_card_token()
      [%StripeCardToken{}, ...]
  """
  @spec list_card_token() :: [StripeCardToken.t()]
  def list_card_token, do: Repo.all(StripeCardToken)

  @doc """
  Gets a single StripeCardToken.

  Raises `Ecto.NoResultsError` if the StripeCardToken does not exist.

  ## Examples

      iex> get_stripe_card_token!(123)
      %StripeCardToken{}

      iex> get_stripe_card_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_card_token!(id), do: Repo.get!(StripeCardToken, id)

  @doc """
  Creates StripeCardToken.

  ## Examples

      iex> create_stripe_card_token(%{field: value})
      {:ok, %StripeCardToken{}}

      iex> create_stripe_card_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_card_token(attrs) do
    %StripeCardToken{}
    |> StripeCardToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates StripeCardToken

  ## Examples

      iex> update_stripe_card_token(struct, %{field: new_value})
      {:ok, %StripeCardToken{}}

      iex> update_stripe_card_token(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec update_stripe_card_token(StripeCardToken.t(), %{atom => any}) :: result() | error_tuple()
  def update_stripe_card_token(struct, attrs) do
    struct
    |> StripeCardToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes StripeCardToken.

  ## Examples

      iex> delete_stripe_card_token(stripe_card_token)
      {:ok, %StripeCardToken{}}

      iex> delete_stripe_card_token(stripe_card_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_card_token(%StripeCardToken{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeCharge.

  Raises `Ecto.NoResultsError` if the StripeCharge does not exist.

  ## Example

      iex> get_stripe_charge!(123)
      %StripeCharge{}

      iex> get_stripe_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_charge!(id), do: Repo.get!(StripeCharge, id)

  @doc """
  Creates StripeCharge.

  ## Examples

      iex> create_stripe_charge(%{field: value})
      {:ok, %StripeCharge{}}

      iex> create_stripe_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_charge(attrs) do
    %StripeCharge{}
    |> StripeCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates StripeCharge

  ## Examples

      iex> update_stripe_charge(struct, %{field: new_value})
      {:ok, %StripeCharge{}}

      iex> update_stripe_charge(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec update_stripe_charge(StripeCharge.t(), %{atom => any}) :: result() | error_tuple()
  def update_stripe_charge(struct, attrs) do
    struct
    |> StripeCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes StripeCharge.

  ## Examples

      iex> delete_stripe_charge(stripe_charge)
      {:ok, %StripeCharge{}}

      iex> delete_stripe_charge(stripe_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_charge(%StripeCharge{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeCustomer.

  Raises `Ecto.NoResultsError` if the StripeCustomer does not exist.

  ## Example

      iex> get_stripe_customer!(123)
      %StripeCustomer{}

      iex> get_stripe_customer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_customer!(id), do: Repo.get!(StripeCustomer, id)

  @doc """
  Creates StripeCustomer.

  ## Examples

      iex> create_stripe_customer(%{field: value})
      {:ok, %StripeCustomer{}}

      iex> create_stripe_customer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_customer(attrs) do
    %StripeCustomer{}
    |> StripeCustomer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates StripeCustomer

  ## Examples

      iex> update_stripe_customer(struct, %{field: new_value})
      {:ok, %StripeCustomer{}}

      iex> update_stripe_customer(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  @spec update_stripe_customer(StripeCustomer.t(), %{atom => any}) :: result() | error_tuple()
  def update_stripe_customer(struct, attrs) do
    struct
    |> StripeCustomer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes StripeCustomer.

  ## Examples

      iex> delete_stripe_customer(stripe_customer)
      {:ok, %StripeCustomer{}}

      iex> delete_stripe_customer(stripe_customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_customer(%StripeCustomer{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeExternalAccountBank.

  Raises `Ecto.NoResultsError` if the StripeExternalAccountBank does not exist.

  ## Example

      iex> get_stripe_external_account_bank!(123)
      %StripeExternalAccountBank{}

      iex> get_stripe_external_account_bank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_external_account_bank!(id), do: Repo.get(StripeExternalAccountBank, id)

  @doc """
  Creates StripeExternalAccountBank.

  ## Examples

      iex> create_stripe_external_account_bank(%{field: value})
      {:ok, %StripeExternalAccountBank{}}

      iex> create_stripe_external_account_bank(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_stripe_external_account_bank(attrs) do
    %StripeExternalAccountBank{}
    |> StripeExternalAccountBank.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes StripeExternalAccountBank.

  ## Examples

      iex> delete_stripe_external_account_bank(stripe_external_account_bank)
      {:ok, %StripeExternalAccountBank{}}

      iex> delete_stripe_external_account_bank(stripe_external_account_bank)
      {:error, %Ecto.Changeset{}}
  """
  def delete_stripe_external_account_bank(%StripeExternalAccountBank{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeExternalAccountCard.

  Raises `Ecto.NoResultsError` if the StripeExternalAccountCard does not exist.

  ## Example

      iex> get_stripe_external_account_card!(123)
      %StripeExternalAccountCard{}

      iex> get_stripe_external_account_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_external_account_card!(id), do: Repo.get(StripeExternalAccountCard, id)

  @doc """
  Creates StripeExternalAccountCard.

  ## Examples

      iex> create_stripe_external_account_card(%{field: value})
      {:ok, %StripeExternalAccountCard{}}

      iex> create_stripe_external_account_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_stripe_external_account_card(attrs) do
    %StripeExternalAccountCard{}
    |> StripeExternalAccountCard.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes StripeExternalAccountCard.

  ## Examples

      iex> delete_stripe_external_account_card(stripe_external_account_card)
      {:ok, %StripeExternalAccountCard{}}

      iex> delete_stripe_external_account_card(stripe_external_account_card)
      {:error, %Ecto.Changeset{}}
  """
  def delete_stripe_external_account_card(%StripeExternalAccountCard{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeRefund.

  Raises `Ecto.NoResultsError` if the StripeRefund does not exist.

  ## Example

      iex> get_stripe_refund!(123)
      %StripeRefund{}

      iex> get_stripe_refund!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_refund!(id), do: Repo.get!(StripeRefund, id)

  @doc """
  Creates StripeRefund.

  ## Examples

      iex> create_stripe_refund(%{field: value})
      {:ok, %StripeRefund{}}

      iex> create_stripe_refund(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_refund(attrs) do
    %StripeRefund{}
    |> StripeRefund.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes StripeRefund.

  ## Examples

      iex> delete_stripe_refund(stripe_refund)
      {:ok, %StripeRefund{}}

      iex> delete_stripe_refund(stripe_refund)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_refund(%StripeRefund{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeTransfer.

  Raises `Ecto.NoResultsError` if the StripeTransfer does not exist.

  ## Example

      iex> get_stripe_transfer!(123)
      %StripeTransfer{}

      iex> get_stripe_transfer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_transfer!(id), do: Repo.get!(StripeTransfer, id)

  @doc """
  Creates StripeTransfer.

  ## Examples

      iex> create_stripe_transfer(%{field: value})
      {:ok, %StripeTransfer{}}

      iex> create_stripe_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_transfer(attrs) do
    %StripeTransfer{}
    |> StripeTransfer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes StripeTransfer.

  ## Examples

      iex> delete_stripe_transfer(stripe_transfer)
      {:ok, %StripeTransfer{}}

      iex> delete_stripe_transfer(stripe_transfer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_transfer(%StripeTransfer{} = struct), do: Repo.delete(struct)

  @doc """
  Gets a single StripeTransferReversal.

  Raises `Ecto.NoResultsError` if the StripeTransferReversal does not exist.

  ## Example

      iex> get_stripe_transfer_reversal!(123)
      %StripeTransferReversal{}

      iex> get_stripe_transfer_reversal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stripe_transfer_reversal!(id), do: Repo.get!(StripeTransferReversal, id)

  @doc """
  Creates StripeTransferReversal.

  ## Examples

      iex> create_stripe_transfer_reversal(%{field: value})
      {:ok, %StripeTransferReversal{}}

      iex> create_stripe_transfer_reversal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stripe_transfer_reversal(attrs) do
    %StripeTransferReversal{}
    |> StripeTransferReversal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes StripeTransferReversal.

  ## Examples

      iex> delete_stripe_transfer_reversal(stripe_transfer_reversal)
      {:ok, %StripeTransferReversal{}}

      iex> delete_stripe_transfer_reversal(stripe_transfer_reversal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_transfer_reversal(%StripeTransferReversal{} = struct), do: Repo.delete(struct)

  @doc """
  Creates StripeCardToken and StripeCustomer.

  ## Examples

      iex> create_card_customer(%{field: value}, %{field: value})
      {:ok, %StripeCardToken}}

      iex> create_card_customer(%{field: bad_value}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card_customer(card_attrs, customer_attrs) do
    card_token_changeset =
      %StripeCardToken{}
      |> StripeCardToken.changeset(card_attrs)

    customer_changeset =
      %StripeCustomer{}
      |> StripeCustomer.changeset(customer_attrs)

    transaction =
      Multi.new
      |> Multi.insert(:stripe_card_tokens, card_token_changeset)
      |> Multi.insert(:stripe_customers, customer_changeset)
      |> Repo.transaction()

    case transaction do
      {:ok, %StripeCardToken{} = card} ->
        {:ok, card}
      {:ok, %StripeCustomer{}} ->
        {:ok, nil}
      {:error, error} ->
        {:error, error}
    end
  end
end
