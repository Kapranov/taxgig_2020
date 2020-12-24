defmodule Core.Media do
  @moduledoc """
  The Media context.
  """

  use Core.Context

  import Ecto.Query, warn: false

  alias Ecto.Multi

  alias Core.{
    Media.File,
    Media.Picture,
    Media.ProDoc,
    Media.TpDoc,
    Repo,
    Upload
  }

  @bucket Application.get_env(:core, Core.Uploaders.S3)[:bucket]

  @doc """
  Gets a single picture.
  """
  @spec get_picture(String.t()) :: Picture.t() | nil
  def get_picture(id) do
    Repo.get(Picture, id)
    |> Repo.preload([:profile])
  end

  @doc """
  Gets a single picture.
  Raises `Ecto.NoResultsError` if the picture does not exist.
  """
  @spec get_picture!(String.t()) :: Picture.t()
  def get_picture!(profile_id), do: Repo.get_by(Picture, %{profile_id: profile_id})

  @doc """
  Get a picture by its URL.
  """
  @spec get_picture_by_url(String.t()) :: Picture.t() | nil
  def get_picture_by_url(url) do
    url
    |> picture_by_url_query()
    |> Repo.one()
  end

  @doc """
  Creates a picture.
  """
  @spec create_picture(%{atom => any}) :: {:ok, Picture.t()} | {:error, Ecto.Changeset.t()}
  def create_picture(attrs \\ %{}) do
    %Picture{}
    |> Picture.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a picture.
  """
  @spec update_picture(Picture.t(), %{atom => any}) :: {:ok, Picture.t()} | {:error, Ecto.Changeset.t()}
  def update_picture(%Picture{} = picture, attrs) do
    picture_changeset =
      picture
      |> Picture.changeset(attrs)

    if picture.file.url == attrs.file.url do
      transaction =
        Multi.new()
        |> Multi.update(:update, picture_changeset)
        |> Repo.transaction()

      case transaction do
        {:ok, %{update: %Picture{} = picture}} ->
          {:ok, picture}
        {:error, error} ->
          {:error, error}
        {:error, :update, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    else
      transaction =
        Multi.new()
        |> Multi.update(:update, picture_changeset)
        |> Multi.run(:picture, fn _, _ ->
          Upload.remove(picture.file.url)
        end)
        |> Repo.transaction()

      case transaction do
        {:ok, %{picture: _header, update: %Picture{} = picture}} ->
          {:ok, picture}
        {:error, error} ->
          {:error, error}
        {:error, :picture, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    end
  end

  @doc """
  Deletes a picture.
  """
  @spec delete_picture(Picture.t()) :: {:ok, Picture.t()} | {:error, Ecto.Changeset.t()}
  def delete_picture(%Picture{} = picture) do
      [_, _, _, _, file_name] = String.split(picture.file.url, "/")
      status_code =
        try do
          ExAws.S3.get_object(@bucket, file_name)
          |> ExAws.request!
          |> get_in([:status_code])
        rescue
          ExAws.Error ->
            :error
        end

      case status_code do
        :error ->
          transaction =
            Multi.new()
            |> Multi.delete(:picture, picture)
            |> Repo.transaction()
          case transaction do
            {:ok, %{picture: %Picture{} = picture}} ->
              {:ok, picture}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
        200 ->
          transaction =
            Multi.new()
            |> Multi.delete(:picture, picture)
            |> Multi.run(:remove, fn _repo, %{picture: %Picture{file: %File{url: url}}} ->
              Upload.remove(url)
            end)
            |> Repo.transaction()

          case transaction do
            {:ok, %{picture: %Picture{} = picture}} ->
              {:ok, picture}
            {:error, :remove, error, _} ->
              {:error, error}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
      end
  end

  @doc """
  Returns the list of ProDoc.

  ## Examples

      iex> list_pro_doc()
      [%ProDoc{}, ...]
  """
  @spec list_pro_doc() :: [ProDoc.t()]
  def list_pro_doc, do: Repo.all(ProDoc)

  @doc """
  Gets a single pro document.
  """
  @spec get_pro_doc(String.t()) :: ProDoc.t() | nil
  def get_pro_doc(id) do
    Repo.get(ProDoc, id)
    |> Repo.preload([:project])
  end

  @doc """
  Gets a single pro document.
  Raises `Ecto.NoResultsError` if the pro document does not exist.
  """
  @spec get_pro_doc!(String.t()) :: ProDoc.t()
  def get_pro_doc!(project_id), do: Repo.get_by(ProDoc, %{project_id: project_id})

  @doc """
  Get a pro document by its URL.
  """
  @spec get_pro_doc_by_url(String.t()) :: ProDoc.t() | nil
  def get_pro_doc_by_url(url) do
    url
    |> pro_doc_by_url_query()
    |> Repo.one()
  end

  @doc """
  Creates a pro document.
  """
  @spec create_pro_doc(%{atom => any}) :: {:ok, ProDoc.t()} | {:error, Ecto.Changeset.t()}
  def create_pro_doc(attrs \\ %{}) do
    %ProDoc{}
    |> ProDoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pro document.
  """
  @spec update_pro_doc(ProDoc.t(), %{atom => any}) :: {:ok, ProDoc.t()} | {:error, Ecto.Changeset.t()}
  def update_pro_doc(%ProDoc{} = pro_doc, attrs) do
    pro_doc_changeset =
      pro_doc
      |> ProDoc.changeset(attrs)

    if pro_doc.file.url == attrs.file.url do
      transaction =
        Multi.new()
        |> Multi.update(:update, pro_doc_changeset)
        |> Repo.transaction()

      case transaction do
        {:ok, %{update: %ProDoc{} = pro_doc}} ->
          {:ok, pro_doc}
        {:error, error} ->
          {:error, error}
        {:error, :update, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    else
      transaction =
        Multi.new()
        |> Multi.update(:update, pro_doc_changeset)
        |> Multi.run(:pro_doc, fn _, _ ->
          Upload.remove(pro_doc.file.url)
        end)
        |> Repo.transaction()

      case transaction do
        {:ok, %{pro_doc: _header, update: %ProDoc{} = pro_doc}} ->
          {:ok, pro_doc}
        {:error, error} ->
          {:error, error}
        {:error, :document, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    end
  end

  @doc """
  Deletes a pro document.
  """
  @spec delete_pro_doc(ProDoc.t()) :: {:ok, ProDoc.t()} | {:error, Ecto.Changeset.t()}
  def delete_pro_doc(%ProDoc{} = pro_doc) do
      [_, _, _, _, file_name] = String.split(pro_doc.file.url, "/")
      status_code =
        try do
          ExAws.S3.get_object(@bucket, file_name)
          |> ExAws.request!
          |> get_in([:status_code])
        rescue
          ExAws.Error ->
            :error
        end

      case status_code do
        :error ->
          transaction =
            Multi.new()
            |> Multi.delete(:pro_doc, pro_doc)
            |> Repo.transaction()
          case transaction do
            {:ok, %{pro_doc: %ProDoc{} = pro_doc}} ->
              {:ok, pro_doc}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
        200 ->
          transaction =
            Multi.new()
            |> Multi.delete(:pro_doc, pro_doc)
            |> Multi.run(:remove, fn _repo, %{pro_doc: %ProDoc{file: %File{url: url}}} ->
              Upload.remove(url)
            end)
            |> Repo.transaction()

          case transaction do
            {:ok, %{pro_doc: %ProDoc{} = pro_doc}} ->
              {:ok, pro_doc}
            {:error, :remove, error, _} ->
              {:error, error}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
      end
  end

  @doc """
  Returns the list of TpDoc.

  ## Examples

      iex> list_tp_doc()
      [%TpDoc{}, ...]
  """
  @spec list_tp_doc() :: [TpDoc.t()]
  def list_tp_doc, do: Repo.all(TpDoc)

  @doc """
  Gets a single tp document.
  """
  @spec get_tp_doc(String.t()) :: TpDoc.t() | nil
  def get_tp_doc(id) do
    Repo.get(TpDoc, id)
    |> Repo.preload([:projects])
  end

  @doc """
  Gets a single tp document.
  Raises `Ecto.NoResultsError` if the tp document does not exist.
  """
  @spec get_tp_doc!(String.t()) :: TpDoc.t()
  def get_tp_doc!(project_id), do: Repo.get_by(TpDoc, %{project_id: project_id})

  @doc """
  Get a tp document by its URL.
  """
  @spec get_tp_doc_by_url(String.t()) :: TpDoc.t() | nil
  def get_tp_doc_by_url(url) do
    url
    |> tp_doc_by_url_query()
    |> Repo.one()
  end

  @doc """
  Creates a tp document.
  """
  @spec create_tp_doc(%{atom => any}) :: {:ok, TpDoc.t()} | {:error, Ecto.Changeset.t()}
  def create_tp_doc(attrs \\ %{}) do
    %TpDoc{}
    |> TpDoc.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tp document.
  """
  @spec update_tp_doc(TpDoc.t(), %{atom => any}) :: {:ok, TpDoc.t()} | {:error, Ecto.Changeset.t()}
  def update_tp_doc(%TpDoc{} = tp_doc, attrs) do
    tp_doc_changeset =
      tp_doc
      |> TpDoc.changeset(attrs)

    if Map.has_key?(attrs, :file) do
      if tp_doc.file.url == attrs.file.url do
        transaction =
          Multi.new()
          |> Multi.update(:update, tp_doc_changeset)
          |> Repo.transaction()

        case transaction do
          {:ok, %{update: %TpDoc{} = tp_doc}} ->
            {:ok, tp_doc}
          {:error, error} ->
            {:error, error}
          {:error, :update, error, _} ->
            {:error, error}
          {:error, _model, changeset, _completed} ->
            {:error, changeset}
        end
      else
        transaction =
          Multi.new()
          |> Multi.update(:update, tp_doc_changeset)
          |> Multi.run(:tp_doc, fn _, _ ->
            Upload.remove(tp_doc.file.url)
          end)
          |> Repo.transaction()

        case transaction do
          {:ok, %{tp_doc: _header, update: %TpDoc{} = tp_doc}} ->
            {:ok, tp_doc}
          {:error, error} ->
            {:error, error}
          {:error, :document, error, _} ->
            {:error, error}
          {:error, _model, changeset, _completed} ->
            {:error, changeset}
        end
      end
    else
      transaction =
        Multi.new()
        |> Multi.update(:update, tp_doc_changeset)
        |> Repo.transaction()

      case transaction do
        {:ok, %{update: %TpDoc{} = tp_doc}} ->
          {:ok, tp_doc}
        {:error, error} ->
          {:error, error}
        {:error, :update, error, _} ->
          {:error, error}
        {:error, _model, changeset, _completed} ->
          {:error, changeset}
      end
    end
  end

  @doc """
  Deletes a tp document.
  """
  @spec delete_tp_doc(TpDoc.t()) :: {:ok, TpDoc.t()} | {:error, Ecto.Changeset.t()}
  def delete_tp_doc(%TpDoc{} = tp_doc) do
      [_, _, _, _, file_name] = String.split(tp_doc.file.url, "/")
      status_code =
        try do
          ExAws.S3.get_object(@bucket, file_name)
          |> ExAws.request!
          |> get_in([:status_code])
        rescue
          ExAws.Error ->
            :error
        end

      case status_code do
        :error ->
          transaction =
            Multi.new()
            |> Multi.delete(:tp_doc, tp_doc)
            |> Repo.transaction()
          case transaction do
            {:ok, %{tp_doc: %TpDoc{} = tp_doc}} ->
              {:ok, tp_doc}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
        200 ->
          transaction =
            Multi.new()
            |> Multi.delete(:tp_doc, tp_doc)
            |> Multi.run(:remove, fn _repo, %{tp_doc: %TpDoc{file: %File{url: url}}} ->
              Upload.remove(url)
            end)
            |> Repo.transaction()

          case transaction do
            {:ok, %{tp_doc: %TpDoc{} = tp_doc}} ->
              {:ok, tp_doc}
            {:error, :remove, error, _} ->
              {:error, error}
            {:error, _model, changeset, _completed} ->
              {:error, changeset}
          end
      end
  end

  @spec picture_by_url_query(String.t()) :: Ecto.Query.t()
  defp picture_by_url_query(url) do
    from(
      p in Picture,
      where: fragment("? @> ?", p.file, ~s|{"url": "#{url}"}|)
    )
  end

  @spec pro_doc_by_url_query(String.t()) :: Ecto.Query.t()
  defp pro_doc_by_url_query(url) do
    from(
      p in ProDoc,
      where: fragment("? @> ?", p.file, ~s|{"url": "#{url}"}|)
    )
  end

  @spec tp_doc_by_url_query(String.t()) :: Ecto.Query.t()
  defp tp_doc_by_url_query(url) do
    from(
      p in TpDoc,
      where: fragment("? @> ?", p.file, ~s|{"url": "#{url}"}|)
    )
  end
end
