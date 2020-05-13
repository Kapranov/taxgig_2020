defmodule Core.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi

  alias Core.{
    Media.File,
    Media.Picture,
    Upload,
    Repo
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
      {:ok, picture}
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

  @spec picture_by_url_query(String.t()) :: Ecto.Query.t()
  defp picture_by_url_query(url) do
    from(
      p in Picture,
      where: fragment("? @> ?", p.file, ~s|{"url": "#{url}"}|)
    )
  end
end
