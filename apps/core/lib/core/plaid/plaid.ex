defmodule Core.Plaid do
  @moduledoc """
  The Plaid context.
  """

  use Core.Context

  alias Core.Plaid.PlaidAccount
  alias Core.Plaid.PlaidTransaction

  @doc """
  Returns the list of PlaidAccount.

  ## Examples

      iex> list_plaid_account()
      [%PlaidAccount{}, ...]
  """
  @spec list_plaid_account() :: [PlaidAccount.t()]
  def list_plaid_account do
    Repo.all(PlaidAccount)
    |> Repo.preload([:plaid_transactions])
  end

  @doc """
  Returns the list of PlaidTransaction.

  ## Examples

      iex> list_plaid_transaction()
      [%PlaidTransaction{}, ...]

  """
  @spec list_plaid_transaction() :: [PlaidTransaction.t()]
  def list_plaid_transaction, do: Repo.all(PlaidTransaction)

  @doc """
  Gets a single PlaidAccount.

  Raises `Ecto.NoResultsError` if the PlaidAccount does not exist.

  ## Examples

      iex> get_plaid_account!(123)
      %PlaidAccount{}

      iex> get_plaid_account!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_plaid_account!(String.t()) :: PlaidAccount.t() | error_tuple()
  def get_plaid_account!(id), do: Repo.get!(PlaidAccount, id)

  @doc """
  Gets a single PlaidTransaction.

  Raises `Ecto.NoResultsError` if the PlaidTransaction does not exist.

  ## Examples

      iex> get_plaid_transaction!(123)
      %PlaidTransaction{}

      iex> get_plaid_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plaid_transaction!(id), do: Repo.get!(PlaidTransaction, id)

  @doc """
  Creates a PlaidAccount.

  ## Examples

      iex> create_plaid_account(%{field: value})
      {:ok, %PlaidAccount{}}

      iex> create_plaid_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_plaid_account(%{atom => any}) :: result() | error_tuple()
  def create_plaid_account(attrs \\ %{}) do
    %PlaidAccount{}
    |> PlaidAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a PlaidTransaction.

  ## Examples

      iex> create_plaid_transaction(%{field: value})
      {:ok, %PlaidTransaction{}}

      iex> create_plaid_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_plaid_transaction(%{atom => any}) :: result() | error_tuple()
  def create_plaid_transaction(attrs \\ %{}) do
    %PlaidTransaction{}
    |> PlaidTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a PlaidAccount.

  ## Examples

      iex> update_plaid_account(struct, %{field: new_value})
      {:ok, %PlaidAccount{}}

      iex> update_plaid_account(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_plaid_account(PlaidAccount.t(), %{atom => any}) :: result() | error_tuple()
  def update_plaid_account(%PlaidAccount{} = struct, attrs) do
    struct
    |> PlaidAccount.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a PlaidTransaction.

  ## Examples

      iex> update_plaid_transaction(struct, %{field: new_value})
      {:ok, %PlaidTransaction{}}

      iex> update_plaid_transaction(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_plaid_transaction(PlaidTransaction.t(), %{atom => any}) :: result() | error_tuple()
  def update_plaid_transaction(%PlaidTransaction{} = struct, attrs) do
    struct
    |> PlaidTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PlaidAccount.

  ## Examples

      iex> delete_plaid_account(struct)
      {:ok, %PlaidAccount{}}

      iex> delete_plaid_account(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_plaid_account(PlaidAccount.t()) :: result()
  def delete_plaid_account(%PlaidAccount{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes a PlaidTransaction.

  ## Examples

      iex> delete_plaid_transaction(struct)
      {:ok, %PlaidTransaction{}}

      iex> delete_plaid_transaction(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_plaid_transaction(PlaidTransaction.t()) :: result()
  def delete_plaid_transaction(%PlaidTransaction{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking PlaidAccount Changes.

  ## Examples

      iex> change_plaid_account(struct)
      %Ecto.Changeset{source: %PlaidAccount{}}

  """
  @spec change_plaid_account(PlaidAccount.t()) :: Ecto.Changeset.t()
  def change_plaid_account(%PlaidAccount{} = struct) do
    PlaidAccount.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking PlaidTransaction Changes.

  ## Examples

      iex> change_plaid_transaction(struct)
      %Ecto.Changeset{source: %PlaidTransaction{}}

  """
  @spec change_plaid_transaction(PlaidTransaction.t()) :: Ecto.Changeset.t()
  def change_plaid_transaction(%PlaidTransaction{} = struct) do
    PlaidTransaction.changeset(struct, %{})
  end
end
