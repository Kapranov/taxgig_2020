defmodule Core.Landing do
  @moduledoc """
  The Landing context.
  """

  import Ecto.Query, warn: false

  alias Core.Landing.{
    Faq,
    FaqCategory,
    PressArticle,
    Vacancy
  }

  alias Core.Repo

  @doc """
  Returns the list of Faq.

  ## Examples

      iex> list_faq()
      [%Faq{}, ...]
  """
  def list_faq, do: Repo.all(Faq)

  @doc """
  Returns the list of Faq Category.

  ## Examples

      iex> list_faq_category()
      [%FaqCategory{}, ...]

  """
  def list_faq_category, do: Repo.all(FaqCategory)

  @doc """
  Returns the list of Press Article.

  ## Examples

      iex> list_press_article()
      [%PressArticle{}, ...]

  """
  def list_press_article, do: Repo.all(PressArticle)

  @doc """
  Returns the list of Vacancy.

  ## Examples

      iex> list_vacancy()
      [%Vacancy{}, ...]

  """
  def list_vacancy, do: Repo.all(Vacancy)

  @doc """
  Gets a single Faq.

  Raises `Ecto.NoResultsError` if the Faq does not exist.

  ## Examples

      iex> get_faq!(123)
      %Faq{}

      iex> get_faq!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq!(id), do: Repo.get!(Faq, id)

  @doc """
  Search by title for Faq
  """
  @spec search_title(String.t) :: list
  def search_title(word) do
    Repo.all(
      from u in Faq,
      where: ilike(u.title, ^("%" <> word <> "%")),
      limit: 25
    )
  end

  @doc """
  Gets a single Faq Category.

  Raises `Ecto.NoResultsError` if the FaqCategory does not exist.

  ## Examples

      iex> get_faq_category!(123)
      %FaqCategory{}

      iex> get_faq_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq_category!(id), do: Repo.get!(FaqCategory, id)

  @doc """
  Gets a single Press Article.

  Raises `Ecto.NoResultsError` if the PressArticle does not exist.

  ## Examples

      iex> get_press_article!(123)
      %PressArticle{}

      iex> get_press_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_press_article!(id), do: Repo.get!(PressArticle, id)

  @doc """
  Gets a single Vacancy.

  Raises `Ecto.NoResultsError` if the Vacancy does not exist.

  ## Examples

      iex> get_vacancy!(123)
      %Vacancy{}

      iex> get_vacancy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vacancy!(id), do: Repo.get!(Vacancy, id)

  @doc """
  Creates a Faq.

  ## Examples

      iex> create_faq(%{field: value})
      {:ok, %Faq{}}

      iex> create_faq(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_faq(attrs \\ %{}) do
    %Faq{}
    |> Faq.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a Faq Category.

  ## Examples

      iex> create_faq_category(%{field: value})
      {:ok, %FaqCategory{}}

      iex> create_faq_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_faq_category(attrs \\ %{}) do
    %FaqCategory{}
    |> FaqCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a PressArticle.

  ## Examples

      iex> create_press_article(%{field: value})
      {:ok, %PressArticle{}}

      iex> create_press_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_press_article(attrs \\ %{}) do
    %PressArticle{}
    |> PressArticle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a Vacancy.

  ## Examples

      iex> create_vacancy(%{field: value})
      {:ok, %Vacancy{}}

      iex> create_vacancy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vacancy(attrs \\ %{}) do
    %Vacancy{}
    |> Vacancy.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a Faq.

  ## Examples

      iex> update_faq(struct, %{field: new_value})
      {:ok, %Faq{}}

      iex> update_faq(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_faq(%Faq{} = struct, attrs) do
    struct
    |> Faq.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a Faq Category.

  ## Examples

      iex> update_faq_category(struct, %{field: new_value})
      {:ok, %FaqCategory{}}

      iex> update_faq_category(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_faq_category(%FaqCategory{} = struct, attrs) do
    struct
    |> FaqCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a Press Article.

  ## Examples

      iex> update_press_article(struct, %{field: new_value})
      {:ok, %PressArticle{}}

      iex> update_press_article(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_press_article(%PressArticle{} = struct, attrs) do
    struct
    |> PressArticle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a Vacancy.

  ## Examples

      iex> update_vacancy(struct, %{field: new_value})
      {:ok, %Vacancy{}}

      iex> update_vacancy(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vacancy(%Vacancy{} = struct, attrs) do
    struct
    |> Vacancy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Faq.

  ## Examples

      iex> delete_faq(struct)
      {:ok, %Faq{}}

      iex> delete_faq(struct)
      {:error, %Ecto.Changeset{}}

  """
  def delete_faq(%Faq{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes a Faq Category.

  ## Examples

      iex> delete_faq_category(struct)
      {:ok, %FaqCategory{}}

      iex> delete_faq_category(struct)
      {:error, %Ecto.Changeset{}}

  """
  def delete_faq_category(%FaqCategory{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes a Press Article.

  ## Examples

      iex> delete_press_article(struct)
      {:ok, %PressArticle{}}

      iex> delete_press_article(struct)
      {:error, %Ecto.Changeset{}}

  """
  def delete_press_article(%PressArticle{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Deletes a Vacancy.

  ## Examples

      iex> delete_vacancy(struct)
      {:ok, %Vacancy{}}

      iex> delete_vacancy(struct)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vacancy(%Vacancy{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Faq Changes.

  ## Examples

      iex> change_faq(struct)
      %Ecto.Changeset{source: %Faq{}}

  """
  def change_faq(%Faq{} = struct) do
    Faq.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Faq Category changes.

  ## Examples

      iex> change_faq_category(struct)
      %Ecto.Changeset{source: %FaqCategory{}}

  """
  def change_faq_category(%FaqCategory{} = struct) do
    FaqCategory.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Press Article changes.

  ## Examples

      iex> change_press_article(struct)
      %Ecto.Changeset{source: %PressArticle{}}

  """
  def change_press_article(%PressArticle{} = struct) do
    PressArticle.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Vacancy changes.

  ## Examples

      iex> change_vacancy(struct)
      %Ecto.Changeset{source: %Vacancy{}}

  """
  def change_vacancy(%Vacancy{} = struct) do
    Vacancy.changeset(struct, %{})
  end
end
