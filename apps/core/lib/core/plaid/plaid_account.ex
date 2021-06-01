defmodule Core.Plaid.PlaidAccount do
  @moduledoc """
  Schema for PlaidAccount.
  """

  use Core.Model

  alias Core.{
    Contracts.Project,
    Plaid.PlaidTransaction,
    Repo
  }

  @type t :: %__MODULE__{
    from_plaid_account_mask: String.t(),
    from_plaid_account_name: String.t(),
    from_plaid_account_official_name: String.t(),
    from_plaid_account_subtype: String.t(),
    from_plaid_account_type: String.t(),
    from_plaid_balance_currency: String.t(),
    from_plaid_balance_current: integer,
    from_plaid_total_transaction: integer,
    id_from_plaid_account: String.t(),
    plaid_transactions: [PlaidTransaction.t()],
    projects: [Project.t()]
  }

  @allowed_params ~w(
    from_plaid_account_mask
    from_plaid_account_name
    from_plaid_account_official_name
    from_plaid_account_subtype
    from_plaid_account_type
    from_plaid_balance_currency
    from_plaid_balance_current
    from_plaid_total_transaction
    id_from_plaid_account
  )a

  @required_params ~w(
    from_plaid_account_name
    from_plaid_account_type
    from_plaid_balance_current
    from_plaid_total_transaction
    id_from_plaid_account
  )a

  schema "plaid_accounts" do
    field :from_plaid_account_mask, :string, null: true
    field :from_plaid_account_name, :string, null: false
    field :from_plaid_account_official_name, :string, null: true
    field :from_plaid_account_subtype, :string, null: true
    field :from_plaid_account_type, :string, null: false
    field :from_plaid_balance_currency, :string, null: true
    field :from_plaid_balance_current, :decimal, default: 0.0, null: false
    field :from_plaid_total_transaction, :integer, default: 0, null: false
    field :id_from_plaid_account, :string, null: false

    has_many :plaid_transactions, PlaidTransaction, on_delete: :delete_all

    many_to_many :projects, Project, join_through: "plaid_accounts_projects", on_replace: :delete

    timestamps(type: :utc_datetime_usec)
  end

  @doc """
  Create changeset for Plaid's Account.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> changeset_preload(:projects)
    |> put_assoc_nochange(:projects, parse_project(attrs))
    |> unique_constraint(:id_from_plaid_account, name: :plaid_accounts_id_from_plaid_account_index, message: "Only one a PlaidAccountId by Plaid")
  end

  @spec put_assoc_nochange(map, Keyword.t(), map) :: Ecto.Changeset.t()
  defp put_assoc_nochange(ch, field, new_change) do
    case get_change(ch, field) do
      nil -> put_assoc(ch, field, new_change)
      _ -> ch
    end
  end

  @spec changeset_preload(map, Keyword.t()) :: Ecto.Changeset.t()
  defp changeset_preload(ch, field),
    do: update_in(ch.data, &Repo.preload(&1, field))

  @spec parse_project(%{atom => any}) :: map()
  defp parse_project(params)  do
    (params[:projects] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_project/1)
  end

  @spec get_or_insert_project(String.t()) :: map()
  defp get_or_insert_project(id) do
    Repo.get_by(Project, id: id) || maybe_insert_project(id)
  end

  @spec maybe_insert_project(String.t()) :: map()
  defp maybe_insert_project(id) do
    %Project{}
    |> Ecto.Changeset.change(id: id)
    |> Ecto.Changeset.unique_constraint(:id)
    |> Repo.insert!(on_conflict: [set: [id: id]], conflict_target: :id)
    |> case do
      {:ok, project} -> project
      {:error, _} -> Repo.get_by!(Project, id: id)
    end
  end
end
