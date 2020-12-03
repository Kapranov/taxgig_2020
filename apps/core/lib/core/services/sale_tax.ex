defmodule Core.Services.SaleTax do
  @moduledoc """
  Schema for SaleTax.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Repo,
    Services,
    Services.SaleTax,
    Services.SaleTaxFrequency,
    Services.SaleTaxIndustry
  }

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    deadline: DateTime.t(),
    financial_situation: String.t(),
    price_sale_tax_count: integer,
    project: Project.t(),
    sale_tax_count: integer,
    sale_tax_frequencies: [SaleTaxFrequency.t()],
    sale_tax_industries: [SaleTaxIndustry.t()],
    state: tuple,
    user_id: User.t()
  }

  @allowed_params ~w(
    deadline
    financial_situation
    price_sale_tax_count
    sale_tax_count
    state
    user_id
  )a

  @required_params ~w(
    user_id
  )a

  schema "sale_taxes" do
    field :deadline, :date
    field :financial_situation, :string
    field :price_sale_tax_count, :integer
    field :sale_tax_count, :integer
    field :state, {:array, :string}

    has_one :project, Project, on_delete: :delete_all

    has_many :sale_tax_frequencies, SaleTaxFrequency
    has_many :sale_tax_industries, SaleTaxIndustry

    belongs_to :user, User, foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for SaleTax.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_field_uniq(:state)
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user, name: :sale_taxes_user_id_index, message: "Only one an User")
  end

  @doc """
  List all and sorted.
  """
  @spec all :: list
  def all do
    Repo.all(from row in @name, order_by: [desc: row.id])
  end

  @doc """
  Share user's role.
  """
  @spec by_role(word) :: boolean | {:error, nonempty_list(message)}
  def by_role(id) when not is_nil(id) do
    struct =
      try do
        Services.get_sale_tax!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "UserId Not Found in SaleTax"]}
      %SaleTax{user_id: user_id} ->
        with %User{role: role} <- by_user(user_id), do: role
    end
  end

  @spec by_role(nil) :: {:error, nonempty_list(message)}
  def by_role(id) when is_nil(id) do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_role :: {:error, nonempty_list(message)}
  def by_role do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_user(word) :: Ecto.Schema.t() | nil
  defp by_user(user_id) do
    try do
      Repo.one(from c in User, where: c.id == ^user_id)
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec validate_field_uniq(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  defp validate_field_uniq(changeset, field) when is_atom(field) do
    update_change(changeset, field, fn
      nil -> nil
      data -> Enum.sort(data) |> Enum.uniq()
    end)
  end
end
