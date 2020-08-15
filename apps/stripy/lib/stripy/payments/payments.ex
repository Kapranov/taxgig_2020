defmodule Stripy.Payments do
  @moduledoc """
  The Payments for context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeAccountToken,
    Payments.StripeBankAccountToken,
    Payments.StripeCardToken,
    Payments.StripeCustomer,
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
  def get_stripe_account!(id), do: Repo.get!(StripeAccount, id)

  @doc """
  Gets a single StripeAccount's User_id by their UserId.
  Raises `Ecto.NoResultsError` if the StripeAccount's UserId does not exist.

  ## Example

      iex> get_account_find_by_user_id('123')
      %StripeAccount{}

      iex> get_account_find_by_usr_id('not a name')
      ** (Ecto.NoResultsError)
  """
  def get_account_find_by_user_id(user_id) do
    account = from(p in StripeAccount, where: p.user_id == ^user_id)

    case user_id do
      nil -> nil
      _ -> Repo.all(account)
    end
  end

  @doc """
  Creates a StripeAccount.

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
  Deletes a StripeAccount.

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
  Gets a single StripeAccountToken's User_id by their UserId.
  Raises `Ecto.NoResultsError` if the StripeAccountToken's UserId does not exist.

  ## Example

      iex> get_account_token_find_by_user_id('123')
      %StripeAccountToken{}

      iex> get_account_token_find_by_usr_id('not a name')
      ** (Ecto.NoResultsError)
  """
  def get_account_token_find_by_user_id(user_id) do
    account_token = from(p in StripeAccountToken, where: p.user_id == ^user_id)

    case user_id do
      nil -> nil
      _ -> Repo.all(account_token)
    end
  end

  @doc """
  Creates a StripeAccountToken.

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
  Multi for Complex Database Transactions `StripeAccountToken`
  and then `StripeCustomer`.

  1. Try creating a `StripeAccountToken`
  2. If `StripeAccountToken` creation fails, return an error
  3. If `StripeAccountToken` creation succeeds, try creating `StripeCustomer`
  4. If `StripeCustomer` creation fails, delete the `StripeAccountToken` and return an error
  5. If `StripeCustomer` creation succeeds, return the while records
  """
  def create_multi_account_token(attrs) do
    {:ok, account_token} = Stripe.Token.create(%{
      :"account[individual][dob][day]" => attrs["dob_day"],
      :"account[individual][dob][month]" => attrs["dob_month"],
      :"account[individual][dob][year]" => attrs["dob_year"],
      :"account[individual][first_name]" => attrs["first_name"],
      :"account[individual][last_name]" => attrs["last_name"],
      :"account[individual][ssn_last_4]" => attrs["ssn_last_4"],
      :"account[tos_shown_and_accepted]" => attrs["tos_shown_and_accepted"],
      :"account[business_type]" => attrs["business_type"]
    })

    result = %{
      account_token: account_token.id,
      created: account_token.created,
      used: account_token.used,
      user_id: attrs["user_id"]
    }

    account_token_changeset =
      StripeAccountToken.changeset(%StripeAccountToken{}, result)

    Multi.new
    |> Multi.insert(:stripe_account_token, account_token_changeset)
    |> Repo.transaction()
  end

  @doc """
  Deletes a StripeAccountToken.

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
  Gets a single StripeBankAccountToken's User_id by their UserId.
  Raises `Ecto.NoResultsError` if the StripeBankAccountToken's UserId does not exist.

  ## Example

      iex> get_banks_find_by_user_id('123')
      %StripeBankAccountToken{}

      iex> get_banks_find_by_usr_id('not a name')
      ** (Ecto.NoResultsError)
  """
  def get_banks_find_by_user_id(user_id) do
    bank = from p in StripeBankAccountToken, where: p.user_id == ^user_id

    case user_id do
      nil -> nil
       _ -> Repo.all(bank)
    end
  end

  @doc """
  Creates a StripeBankAccountToken.

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
  Deletes a StripeBankAccountToken.

  ## Examples

      iex> delete_stripe_bank_account_token(stripe_bank_account_token)
      {:ok, %StripeBankAccountToken{}}

      iex> delete_stripe_bank_account_token(stripe_bank_account_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_bank_account_token(%StripeBankAccountToken{} = struct), do: Repo.delete(struct)

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
  Gets a single StripeCardToken's User_id by their UserId.
  Raises `Ecto.NoResultsError` if the StripeCardToken's UserId does not exist.

  ## Example

      iex> get_cards_find_by_user_id('123')
      %StripeCardToken{}

      iex> get_cards_find_by_user_id('not a name')
      ** (Ecto.NoResultsError)
  """
  def get_cards_find_by_user_id(user_id) do
    card = from p in StripeCardToken, where: p.user_id == ^user_id

    case user_id do
      nil -> nil
      _ -> Repo.all(card)
    end
  end

  @doc """
  Creates a StripeCardToken.

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
  Deletes a StripeCardToken.

  ## Examples

      iex> delete_stripe_card_token(stripe_card_token)
      {:ok, %StripeCardToken{}}

      iex> delete_stripe_card_token(stripe_card_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_card_token(%StripeCardToken{} = struct), do: Repo.delete(struct)

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
  Multi for Complex Database Transactions `StripeCardToken`
  and then `StripeCustomer`.

  1. Try creating a `StripeCardToken`
  2. If `StripeCardToken` creation fails, return an error
  3. If `StripeCardToken` creation succeeds, try creating `StripeCustomer`
  4. If `StripeCustomer` creation fails, delete the `StripeCardToken` and return an error
  5. If `StripeCustomer` creation succeeds, return the while records
  """
  def create_multi_card_token_customer(attrs) do
    card_token_changeset =
      StripeCardToken.changeset(%StripeCardToken{}, attrs)
    user_id = FlakeId.from_string(attrs["user_id"])
    [[email]] = Ecto.Adapters.SQL.query!(Repo, "SELECT email from users WHERE id = $1", [user_id]) |> Map.get(:rows)
    {:ok, customer} = Stripe.Customer.create(%{source: attrs["card_token"]})
    customer_attrs = %{stripe_customer_id: customer.id}

    Multi.new
    |> Multi.insert(:stripe_card_token, card_token_changeset)
    |> Multi.run(:stripe_customer, fn _, %{stripe_card_token: stripe_card_token} ->
      stripe_customer_changeset =
        %StripeCustomer{
          user_id: stripe_card_token.user_id,
          account_balance: customer.account_balance,
          created: customer.created,
          currency: customer.currency,
          delinquent: customer.delinquent,
          description: customer.description,
          email: email,
          livemode: customer.livemode
        }
        |> StripeCustomer.changeset(customer_attrs)

      Repo.insert(stripe_customer_changeset)
    end)
    |> Repo.transaction()
  end

  @doc """
  Multi for Complex Database Transactions `StripeBankAccountToken`
  and then `StripeCustomer`.
  """
  def create_multi_bank_account_token_customer(attrs) do
    bank_token_changeset =
      StripeBankAccountToken.changeset(%StripeBankAccountToken{}, attrs)
    user_id = FlakeId.from_string(attrs["user_id"])
    [[email]] = Ecto.Adapters.SQL.query!(Repo, "SELECT email from users WHERE id = $1", [user_id]) |> Map.get(:rows)
    {:ok, customer} = Stripe.Customer.create(%{source: attrs["bank_token"]})
    customer_attrs = %{stripe_customer_id: customer.id}

    Multi.new
    |> Multi.insert(:stripe_bank_account_token, bank_token_changeset)
    |> Multi.run(:stripe_customer, fn _, %{stripe_bank_account_token: stripe_bank_account_token} ->
      stripe_customer_changeset =
        %StripeCustomer{
          user_id: stripe_bank_account_token.user_id,
          account_balance: customer.account_balance,
          created: customer.created,
          currency: customer.currency,
          delinquent: customer.delinquent,
          description: customer.description,
          email: email,
          livemode: customer.livemode
        }
        |> StripeCustomer.changeset(customer_attrs)
      Repo.insert(stripe_customer_changeset)
    end)
    |> Repo.transaction()
  end

  @doc """
  A customer's bank account must first be verified before it can be charged.
  """
  def create_multi_verify_bank_account(attrs) do
    amounts1 = attrs["amounts1"]
    amounts2 = attrs["amounts2"]
    created = attrs["created"]
    bank_account_id = attrs["bank_account"]
    user_id = FlakeId.from_string(attrs["user_id"])
    [[email]] = Ecto.Adapters.SQL.query!(Repo, "SELECT email from users WHERE id = $1", [user_id]) |> Map.get(:rows)
    {:ok, customer} = Stripe.Customer.create(%{source: attrs["bank_token"]})
    customer_attrs = %{stripe_customer_id: customer.id}
    verify_data = %{
      :customer => customer.id,
      :"amounts[0]" => amounts1,
      :"amounts[1]" => amounts2
    }

    {:ok, verify} = Stripe.BankAccount.verify(bank_account_id, verify_data)

    updated_attrs = %{
      :account_holder_name => verify.account_holder_name,
      :account_holder_type => verify.account_holder_type,
      :bank_account => verify.id,
      :bank_name => verify.bank_name,
      :bank_token => attrs["bank_token"],
      :country => verify.country,
      :created => created,
      :currency => verify.currency,
      :fingerprint => verify.fingerprint,
      :last4 => verify.last4,
      :routing_number => verify.routing_number,
      :status => verify.status,
      :user_id => attrs["user_id"]
    }

    bank_token_changeset =
      StripeBankAccountToken.changeset(%StripeBankAccountToken{}, updated_attrs)

    Multi.new
    |> Multi.insert(:stripe_bank_account_token, bank_token_changeset)
    |> Multi.run(:stripe_customer, fn _, %{stripe_bank_account_token: stripe_bank_account_token} ->
      stripe_customer_changeset =
        %StripeCustomer{
          user_id: stripe_bank_account_token.user_id,
          account_balance: customer.account_balance,
          created: customer.created,
          currency: customer.currency,
          delinquent: customer.delinquent,
          description: customer.description,
          email: email,
          livemode: customer.livemode
        }
        |> StripeCustomer.changeset(customer_attrs)
      Repo.insert(stripe_customer_changeset)
    end)
    |> Repo.transaction()
  end

  @doc """
  A customer's bank account must first be verified before it can be charged.
  """
  def verify_bank_account(attrs) do
    verify_data = %{
      :customer => attrs["customer"],
      :"amounts[0]" => attrs["amounts1"],
      :"amounts[1]" => attrs["amounts2"]
    }

    {:ok, verify} = Stripe.BankAccount.verify(attrs["bank_account"], verify_data)

    updated_attrs = %{
      :user_id => attrs["user_id"],
      :status => verify.status
    }

    bank_token_changeset =
      StripeBankAccountToken.changeset(%StripeBankAccountToken{}, updated_attrs)

    Multi.new
    |> Multi.update(:stripe_bank_account_token, bank_token_changeset)
    |> Repo.transaction()
  end

  @doc """
  Deletes a StripeCustomer.

  ## Examples

      iex> delete_stripe_customer(stripe_customer)
      {:ok, %StripeCustomer{}}

      iex> delete_stripe_customer(stripe_customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stripe_customer(%StripeCustomer{} = struct), do: Repo.delete(struct)
end
