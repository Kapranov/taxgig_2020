defmodule Core.Skills.Education do
  @moduledoc """
  Schema for Education.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Repo,
    Skills,
    Skills.Education,
    Skills.University
  }

  @type word() :: String.t()
  @type message() :: atom()

  @type t :: %__MODULE__{
    course: String.t(),
    graduation: String.t(),
    universities: University.t(),
    users: User.t()
  }

  @allowed_params ~w(
    course
    graduation
    university_id
    user_id
  )a

  @required_params ~w(
    course
    graduation
    university_id
    user_id
  )a

  schema "educations" do
    field :course, :string
    field :graduation, :date

    belongs_to :universities, University,
      foreign_key: :university_id, type: FlakeId.Ecto.CompatType, references: :id

    belongs_to :users, User,
      foreign_key: :user_id, type: FlakeId.Ecto.CompatType, references: :id

    timestamps()
  end

  @doc """
  Create changeset for Education.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:university_id, message: "Select an University")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:university_id, name: :universities_user_id_index)
  end

  @doc """
  List all and sorted.
  """
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
        Skills.get_education!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "UserId Not Found in Education"]}
      %Education{user_id: user_id} ->
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
  def by_user(user_id) do
    try do
      Repo.one(from c in User, where: c.id == ^user_id)
    rescue
      Ecto.Query.CastError -> nil
    end
  end
end
