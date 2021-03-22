defmodule Core.Skills do
  @moduledoc """
  The Skill context.
  """

  use Core.Context

  alias Core.{
    Skills.AccountingSoftware,
    Skills.Education,
    Skills.University,
    Skills.WorkExperience
  }

  @doc """
  Returns the list of AccountingSoftware.

  ## Examples

      iex> list_accounting_software()
      [%AccountingSoftware{}, ...]
  """
  @spec list_accounting_software() :: [AccountingSoftware.t()]
  def list_accounting_software do
    Repo.all(AccountingSoftware)
    |> Repo.preload([
      user: [
        :languages,
        :work_experiences,
        educations: [:universities]
      ]
    ])
  end

  @doc """
  Gets a single AccountingSoftware.

  Raises `Ecto.NoResultsError` if the AccountingSoftware does not exist.

  ## Examples

      iex> get_accounting_software!(123)
      %AccountingSoftware{}

      iex> get_accounting_software!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_accounting_software!(String.t()) :: AccountingSoftware.t() | error_tuple()
  def get_accounting_software!(id) do
    Repo.get!(AccountingSoftware, id)
    |> Repo.preload([
      user: [
        :languages,
        :work_experiences,
        educations: [:universities]
      ]
    ])
  end

  @doc """
  Creates AccountingSoftware.

  ## Examples

      iex> create_accounting_software(%{field: value})
      {:ok, %AccountingSoftware{}}

      iex> create_accounting_software(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_accounting_software(%{atom => any}) :: result() | error_tuple()
  def create_accounting_software(attrs \\ %{}) do
    case AccountingSoftware.by_user(attrs.user_id).role do
      false -> {:error, %Ecto.Changeset{}}
      true  ->
        %AccountingSoftware{}
        |> AccountingSoftware.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates AccountingSoftware.

  ## Examples

      iex> update_accounting_software(struct, %{field: new_value})
      {:ok, %AccountingSoftware{}}

      iex> update_accounting_software(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_accounting_software(AccountingSoftware.t(), %{atom => any}) :: result() | error_tuple()
  def update_accounting_software(struct, attrs) do
    case AccountingSoftware.by_user(struct.user_id).role do
      false -> {:error, %Ecto.Changeset{}}
      true  ->
        struct
        |> AccountingSoftware.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Deletes AccountingSoftware.

  ## Examples

      iex> delete_accounting_software(struct)
      {:ok, %AccountingSoftware{}}

      iex> delete_accounting_software(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_accounting_software(AccountingSoftware.t()) :: result()
  def delete_accounting_software(%AccountingSoftware{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking AccountingSoftware changes.

  ## Examples

      iex> change_accounting_software(struct)
      %Ecto.Changeset{source: %AccountingSoftware{}}

  """
  @spec change_accounting_software(AccountingSoftware.t()) :: Ecto.Changeset.t()
  def change_accounting_software(%AccountingSoftware{} = struct) do
    AccountingSoftware.changeset(struct, %{})
  end

  @doc """
  Returns the list of Education.

  ## Examples

      iex> list_education()
      [%Education{}, ...]
  """
  @spec list_education() :: [Education.t()]
  def list_education do
    Repo.all(Education)
    |> Repo.preload([
      :universities,
      users: [:languages]
    ])
  end

  @doc """
  Gets a single Education.

  Raises `Ecto.NoResultsError` if the Education does not exist.

  ## Examples

      iex> get_education!(123)
      %Education{}

      iex> get_education!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_education!(String.t()) :: Education.t() | error_tuple()
  def get_education!(id) do
    Repo.get!(Education, id)
    |> Repo.preload([
      :universities,
      users: [:languages]
    ])
  end

  @doc """
  Creates Education.

  ## Examples

      iex> create_education(%{field: value})
      {:ok, %Education{}}

      iex> create_education(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_education(%{atom => any}) :: result() | error_tuple()
  def create_education(attrs \\ %{}) do
    case Education.by_user(attrs.user_id).role do
      false -> {:error, %Ecto.Changeset{}}
      true ->
        %Education{}
        |> Education.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates Education.

  ## Examples

      iex> update_education(struct, %{field: new_value})
      {:ok, %Education{}}

      iex> update_education(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_education(Education.t(), %{atom => any}) :: result() | error_tuple()
  def update_education(struct, attrs) do
    case Education.by_user(struct.user_id).role do
      false -> {:error, %Ecto.Changeset{}}
      true ->
        struct
        |> Education.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Deletes Education.

  ## Examples

      iex> delete_education(struct)
      {:ok, %Education{}}

      iex> delete_education(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_education(Education.t()) :: result()
  def delete_education(%Education{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Education changes.

  ## Examples

      iex> change_education(struct)
      %Ecto.Changeset{source: %Education{}}

  """
  @spec change_education(Education.t()) :: Ecto.Changeset.t()
  def change_education(%Education{} = struct) do
    Education.changeset(struct, %{})
  end

  @doc """
  Returns the list of Universities.

  ## Examples

      iex> list_university()
      [%University{}, ...]
  """
  @spec list_university() :: [University.t()]
  def list_university, do: Repo.all(University)

  @doc """
  Gets a single University.

  Raises `Ecto.NoResultsError` if the University does not exist.

  ## Examples

      iex> get_university!(123)
      %University{}

      iex> get_university!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_university!(String.t()) :: University.t() | error_tuple()
  def get_university!(id), do: Repo.get!(University, id)

  @doc """
  Search record by University via `name`.

  ## Example

      iex> search_university("Abia")
      [%University{}]

      iex> search_university("Proba")
      []
  """
  @spec search_university(String.t()) :: [University.t()]
  def search_university(search_term) do
    Repo.all(
      from u in University,
      where: ilike(u.name, ^("%" <> search_term <> "%")),
      limit: 10
    )
  end

  @doc """
  Creates University.

  ## Examples

      iex> create_university(%{field: value})
      {:ok, %University{}}

      iex> create_university(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_university(%{atom => any}) :: result() | error_tuple()
  def create_university(attrs \\ %{}) do
    %University{}
    |> University.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of WorkExperiences.

  ## Examples

      iex> list_work_experience()
      [%WorkExperience{}, ...]
  """
  @spec list_work_experience() :: [WorkExperience.t()]
  def list_work_experience do
    Repo.all(WorkExperience)
    |> Repo.preload([
      users: [
        :accounting_software,
        :languages,
        educations: [:universities],
      ]
    ])
  end

  @doc """
  Gets a single WorkExperience.

  Raises `Ecto.NoResultsError` if the WorkExperience does not exist.

  ## Examples

      iex> get_work_experience!(123)
      %WorkExperience{}

      iex> get_work_experience!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_work_experience!(String.t()) :: WorkExperience.t() | error_tuple()
  def get_work_experience!(id) do
    Repo.get!(WorkExperience, id)
    |> Repo.preload([
      users: [
        :accounting_software,
        :languages,
        educations: [:universities],
      ]
    ])
  end

  @doc """
  Creates WorkExperience.

  ## Examples

      iex> create_work_experience(%{field: value})
      {:ok, %WorkExperience{}}

      iex> create_work_experience(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_work_experience(%{atom => any}) :: result() | error_tuple()
  def create_work_experience(attrs \\ %{}) do
    case WorkExperience.by_user(attrs.user_id).role do
      false -> {:error, %Ecto.Changeset{}}
      true ->
        %WorkExperience{}
        |> WorkExperience.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates WorkExperience.

  ## Examples

      iex> update_work_experience(struct, %{field: new_value})
      {:ok, %WorkExperience{}}

      iex> update_work_experience(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_work_experience(WorkExperience.t(), %{atom => any}) :: result() | error_tuple()
  def update_work_experience(struct, attrs) do
    case WorkExperience.by_user(struct.user_id).role do
      false -> {:error, %Ecto.Changeset{}}
      true ->
        struct
        |> WorkExperience.changeset(attrs)
        |> Repo.update()
    end
  end

  @doc """
  Deletes WorkExperience.

  ## Examples

      iex> delete_work_experience(struct)
      {:ok, %WorkExperience{}}

      iex> delete_work_experience(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_work_experience(WorkExperience.t()) :: result()
  def delete_work_experience(%WorkExperience{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking WorkExperience changes.

  ## Examples

      iex> change_work_experience(struct)
      %Ecto.Changeset{source: %WorkExperience{}}

  """
  @spec change_work_experience(WorkExperience.t()) :: Ecto.Changeset.t()
  def change_work_experience(%WorkExperience{} = struct) do
    WorkExperience.changeset(struct, %{})
  end
end
