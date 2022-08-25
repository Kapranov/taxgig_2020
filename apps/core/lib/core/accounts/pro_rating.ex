defmodule Core.Accounts.ProRating do
  @moduledoc """
  Schema for ProRating.
  """

  use Core.Model

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Repo
  }

  @type t :: %__MODULE__{
    average_communication: integer,
    average_professionalism: integer,
    average_rating: integer,
    average_work_quality: integer,
    projects: [Project.t()],
    user_id: User.t()
  }

  @allowed_params ~w(
    average_communication
    average_professionalism
    average_rating
    average_work_quality
    user_id
  )a

  @required_params ~w(
    average_communication
    average_professionalism
    average_rating
    average_work_quality
    user_id
  )a

  schema "pro_ratings" do
    field :average_communication, :decimal
    field :average_professionalism, :decimal
    field :average_rating, :decimal
    field :average_work_quality, :decimal

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    many_to_many :projects, Project, join_through: "pro_ratings_projects", on_replace: :delete

    timestamps()
  end

  @doc """
  Create changeset for ProRating.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> changeset_preload(:projects)
    |> put_assoc_nochange(:projects, parse_id(attrs))
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:user_id, name: :pro_ratings_user_id_index)
  end

  @spec changeset_preload(map, Keyword.t()) :: Ecto.Changeset.t()
  defp changeset_preload(ch, field),
    do: update_in(ch.data, &Repo.preload(&1, field))

  @spec put_assoc_nochange(map, Keyword.t(), map) :: Ecto.Changeset.t()
  defp put_assoc_nochange(ch, field, new_change) do
    case get_change(ch, field) do
      nil -> put_assoc(ch, field, new_change)
      _ -> ch
    end
  end

  @spec parse_id(%{atom => any}) :: map()
  defp parse_id(params) do
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
