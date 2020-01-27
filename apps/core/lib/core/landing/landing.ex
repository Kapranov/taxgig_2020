defmodule Core.Landing do
  @moduledoc """
  The Landing context.
  """

  use Core.Context

  alias Core.{
    Landing,
    Landing.Faq,
    Landing.FaqCategory,
    Landing.PressArticle,
    Landing.Vacancy
  }

  @doc """
  Returns the list of Faq.

  ## Examples

      iex> list_faq()
      [%Faq{}, ...]
  """
  @spec list_faq() :: list
  def list_faq, do: Repo.all(Faq)

  @doc """
  Returns the list of Faq Category.

  ## Examples

      iex> list_faq_category()
      [%FaqCategory{}, ...]

  """
  @spec list_faq_category() :: list
  def list_faq_category do
    Repo.all(from(
      faq_category in FaqCategory,
      left_join: faq in subquery(from c in Faq),
      on: faq.faq_category_id == faq_category.id,
      select_merge: %{:faqs_count => count(field(faq, :id))},
      group_by: [faq.faq_category_id, faq_category.id]
    ))
  end

  @spec list_count_faq_category() :: list
  def list_count_faq_category do
    FaqCategory
    |> join(:inner, [u], f in Faq, on: u.id == f.faq_category_id)
    |> group_by([u], u.title)
    |> group_by([u], u.id)
    |> select_merge([f], %{faqs_count: count(f.id)})
    |> Repo.all
  end

  @doc """
  Returns the list of Press Article.

  ## Examples

      iex> list_press_article()
      [%PressArticle{}, ...]

  """
  @spec list_press_article() :: list
  def list_press_article, do: Repo.all(PressArticle)

  @doc """
  Returns the list of Vacancy.

  ## Examples

      iex> list_vacancy()
      [%Vacancy{}, ...]

  """
  @spec list_vacancy() :: list
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
  @spec get_faq!(String.t) :: map | error_tuple
  def get_faq!(id), do: Repo.get!(Faq, id)

  @doc """
  Gets a single Faq Category.

  Raises `Ecto.NoResultsError` if the FaqCategory does not exist.

  ## Examples

      iex> get_faq_category!(123)
      %FaqCategory{}

      iex> get_faq_category!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_faq_category!(String.t) :: map | error_tuple
  def get_faq_category!(id) do
    data = Repo.get!(FaqCategory, id)

    case Landing.create_count(Map.get(data, :title)) do
      nil -> data
      changeset -> changeset
    end
  end

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
  @spec get_vacancy!(String.t) :: map | error_tuple
  def get_vacancy!(id), do: Repo.get!(Vacancy, id)

  @doc """
  Search by title for Faq

  ## Examples

      iex> search_title("123")
      [%Faq{}, ...]

      iex> search_title(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec search_title(String.t) :: list | error_tuple
  def search_title(word) do
    if is_nil(word) do
      {:error, %Ecto.Changeset{}}
    else
      Repo.all(
        from u in Faq,
        where: ilike(u.title, ^("%" <> word <> "%")),
        limit: 25
      )
    end
  end

  @doc """
  Count by title for FaqCategory by Faq

  ## Examples

      iex> count_title("123")
      0

      iex> count_title(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec count_title(String.t) :: integer | error_tuple
  def count_title(word) do
    if is_nil(word) do
      {:error, %Ecto.Changeset{}}
    else
      title =
        Repo.aggregate(
          from(
            c in FaqCategory,
            join: cu in Faq,
            where: c.title ==^word and cu.faq_category_id == c.id
          ), :count, :id
        )
      case title do
        nil ->
          0
        _ ->
          title
      end
    end
  end

  @doc """
  Count faq_category_id by FaqCategory.

  ## Examples

      iex> count("123")
      0

      iex> count(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec count(String.t) :: integer | error_tuple
  def count(id) do
    if is_nil(id) do
      {:error, %Ecto.Changeset{}}
    else
      case id do
        "" ->
          {:error, %Ecto.Changeset{}}
        _ ->
          query =
            from p in Faq,
            where: p.faq_category_id == ^id

          id_count =
            Repo.aggregate(query, :count, :faq_category_id)

          id_count
      end
    end
  end

  @doc """
  Find FaqCategoryId all records by Faq.

  ## Examples

      iex> find_by_faq_category_id("123")
      [%Faq{}, ...]

      iex> find_by_faq_category_id(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec find_by_faq_category_id(String.t) :: list | error_tuple
  def find_by_faq_category_id(id) do
    if is_nil(id) do
      {:error, %Ecto.Changeset{}}
    else
      case id do
        "" ->
          {:error, %Ecto.Changeset{}}
        _ ->
          query =
            from p in Faq,
            where: p.faq_category_id == ^id

          Repo.all(query)
      end
    end
  end

  @doc """
  Create new struct with count by title for FaqCategory by Faq.

  ## Examples

      iex> create_count("123")
      [%FaqCategory{}, ...]

      iex> create_count(456)
      {:error, %Ecto.Changeset{}}

  """
  @spec create_count(String.t) :: map | nil
  def create_count(word) do
    if is_nil(word) do
      {:error, %Ecto.Changeset{}}
    else
      Repo.one(from(
        c in FaqCategory,
        join: cu in Faq,
        where: c.title ==^word and cu.faq_category_id == c.id,
        select_merge: %{:faqs_count => count(field(cu, :id))},
        group_by: [cu.faq_category_id, c.id]
      ))
    end
  end

  @doc """
  Creates a Faq.

  ## Examples

      iex> create_faq(%{field: value})
      {:ok, %Faq{}}

      iex> create_faq(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
   @spec create_faq(map) :: result | error_tuple
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
  @spec create_faq_category(map) :: result | error_tuple
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
  @spec create_press_article(map) :: result | error_tuple
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
  @spec create_vacancy(map) :: result | error_tuple
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
  @spec update_faq(map, map) :: result | error_tuple
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
  @spec update_faq_category(map, map) :: result | error_tuple
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
  @spec update_press_article(map, map) :: result | error_tuple
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
  @spec update_vacancy(map, map) :: result | error_tuple
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
  @spec delete_faq(map) :: result
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
  @spec delete_faq_category(map) :: result | error_tuple
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
  @spec delete_press_article(map) :: result | error_tuple
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
  @spec delete_vacancy(map) :: result | error_tuple
  def delete_vacancy(%Vacancy{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Faq Changes.

  ## Examples

      iex> change_faq(struct)
      %Ecto.Changeset{source: %Faq{}}

  """
  @spec change_faq(map) :: result
  def change_faq(%Faq{} = struct) do
    Faq.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Faq Category changes.

  ## Examples

      iex> change_faq_category(struct)
      %Ecto.Changeset{source: %FaqCategory{}}

  """
  @spec change_faq_category(map) :: result
  def change_faq_category(%FaqCategory{} = struct) do
    FaqCategory.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Press Article changes.

  ## Examples

      iex> change_press_article(struct)
      %Ecto.Changeset{source: %PressArticle{}}

  """
  @spec change_press_article(map) :: result
  def change_press_article(%PressArticle{} = struct) do
    PressArticle.changeset(struct, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking Vacancy changes.

  ## Examples

      iex> change_vacancy(struct)
      %Ecto.Changeset{source: %Vacancy{}}

  """
  @spec change_vacancy(map) :: result
  def change_vacancy(%Vacancy{} = struct) do
    Vacancy.changeset(struct, %{})
  end
end
