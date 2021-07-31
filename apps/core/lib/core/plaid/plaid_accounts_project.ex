defmodule Core.Plaid.PlaidAccountsProject do
  @moduledoc """
  Schema for PlaidAccountsProjects.
  """

  use Core.Model

  @allowed_params ~w(
    plaid_account_id
    project_id
  )a

  @required_params ~w(
    plaid_account_id
    project_id
  )a

  schema "plaid_accounts_projects" do
    field :plaid_account_id, FlakeId.Ecto.CompatType, null: false
    field :project_id, FlakeId.Ecto.CompatType, null: false
  end

  @doc """
  Create changeset for Plaid's Account Projects.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
