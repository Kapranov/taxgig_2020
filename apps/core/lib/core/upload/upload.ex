defmodule Core.Upload do
  @moduledoc """
  Manage user uploads

  Options:
  * `:type`: presets for activity type (defaults to Document) and size limits from app configuration
  * `:description`: upload alternative text
  * `:base_url`: override base url
  * `:uploader`: override uploader
  * `:filters`: override filters
  * `:size_limit`: override size limit
  * `:activity_type`: override activity type

  The `%Core.Upload{}` struct: all documented fields are meant to be overwritten in filters:

  * `:id` - the upload id.
  * `:name` - the upload file name.
  * `:path` - the upload path: set at first to `id/name` but can be changed. Keep in mind that the path
    is once created permanent and changing it (especially in uploaders) is probably a bad idea!
  * `:tempfile` - path to the temporary file. Prefer in-place changes on the file rather than changing the
    path as the temporary file is also tracked by `Plug.Upload{}` and automatically deleted once the request is over.

  Related behaviors:

  * `Core.Uploaders.Uploader`
  * `Core.Upload.Filter`
  """

  alias Ecto.UUID
  alias Core.{
    Config,
    Upload,
    Uploaders
  }

  alias Core.MIME, as: CoreMIME

  require Logger

  @name __MODULE__
  @host "nyc3.digitaloceanspaces.com"
  @url "https://" <> @host

  @type source ::
          Plug.Upload.t()
          | (data_uri_string :: String.t())
          | {:from_local, name :: String.t(), id :: String.t(), path :: String.t()}

  @type option ::
          {:type, :avatar | :banner | :background}
          | {:description, String.t()}
          | {:activity_type, String.t()}
          | {:size_limit, nil | non_neg_integer()}
          | {:uploader, module()}
          | {:filters, [module()]}

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          tempfile: String.t(),
          content_type: String.t(),
          path: String.t(),
          size: integer()
        }

  defstruct [:id, :name, :tempfile, :content_type, :path, :size]

  @spec store(source(), [option()]) :: {:ok, map()} | {:error, any()}
  def store(upload, opts \\ []) do
   opts = get_opts(opts)

   with {:ok, upload} <- prepare_upload(upload, opts),
        upload = %__MODULE__{upload | path: upload.path || "#{upload.id}/#{upload.name}"},
        {:ok, upload} <- Upload.Filter.filter(opts.filters, upload),
        {:ok, url_spec} <- Uploaders.Uploader.put_file(opts.uploader, upload) do
     {:ok,
       %{
         name: Map.get(opts, :description) || upload.name,
         url: url_from_spec(upload, opts.base_url, url_spec),
         content_type: upload.content_type,
         size: upload.size
       }
     }
   else
     {:error, error} ->
       Logger.info("#{@name} store (using #{inspect(opts.uploader)}) failed: #{inspect(error)}")
       {:error, :enoent}
     false ->
       Logger.info("#{@name} store (using #{inspect(opts.uploader)}) failed: file format not supported")
       {:error, :enoent}
   end
  end

  @spec remove(String.t(), list()) :: String.t() | {:error, String.t()}
  def remove(url, opts \\ []) do
    with opts <- get_opts(opts), %URI{path: "/taxgig/" <> path, host: host} <- URI.parse(url), {:same_host, true} <- {:same_host, host == @host} do
      Uploaders.Uploader.remove_file(opts.uploader, path)
    else
      %URI{} = _uri ->
        {:error, "URL doesn't match pattern"}
      {:same_host, _} ->
        Logger.error("Media can't be deleted because its URL doesn't match current host")
    end
  end

  @spec char_unescaped?(char()) :: boolean()
  def char_unescaped?(char) do
    URI.char_unreserved?(char) or char == ?/
  end

  @spec get_opts(keyword(t)) ::
    %{description: String.t(),
      filters: [struct()] | [],
      base_url: String.t(),
      formats: [String.t()] | [],
      uploader: struct(),
      activity_type: String.t(),
      size_limit: integer()
    }
  def get_opts(opts) do
    media_1 = Config.get!([:instance, :formats])
    media_2 = Config.get!([:instance, :formats]) |> List.delete(".pdf")
    media_3 = Config.get!([:instance, :formats]) |> List.delete(".pdf") |> List.delete(".gif")
    media_4 = Config.get!([:instance, :formats]) |> List.delete(".pdf") |> List.delete(".gif") |> List.delete(".jpg") |> List.delete(".jpeg")
    media_5 = Config.get!([:instance, :formats]) |> List.delete(".jpg") |> List.delete(".jpeg") |> List.delete(".gif") |> List.delete(".png")

    {size_limit, activity_type, description, filter, formats} =
      case Keyword.get(opts, :type) do
        :avatar ->
          {Config.get!([:instance, :avatar_upload_limit]), "Image", "Uploaded Image", Config.get([@name, :filters]), media_2}
        :banner ->
          {Config.get!([:instance, :banner_upload_limit]), "Image", "Uploaded Image", Config.get([@name, :filters]), media_3}
        :logo ->
          {Config.get!([:instance, :logo_upload_limit]), "Image", "Uploaded Image", Config.get([@name, :filters]), media_4}
        :pdf ->
          {Config.get!([:instance, :pdf_upload_limit]), "Document", "Uploaded Document", [], media_5}
        _ ->
          {Config.get!([:instance, :upload_limit]), "Media", "Uploaded all Media", Config.get([@name, :filters]), media_1}
      end

    %{
      activity_type: Keyword.get(opts, :activity_type, activity_type),
      formats: Keyword.get(opts, :formats, formats),
      base_url: Keyword.get(opts, :base_url, Config.get([@name, :base_url], @url)),
      description: Keyword.get(opts, :description, description),
      filters: Keyword.get(opts, :filters, filter),
      size_limit: Keyword.get(opts, :size_limit, size_limit),
      uploader: Keyword.get(opts, :uploader, Config.get([@name, :uploader]))
    }
  end

  @spec prepare_upload(Plug.Upload.t(), map()) ::
    {:ok, %__MODULE__{id: String.t(),
        name: String.t(),
        tempfile: String.t(),
        content_type: String.t(),
        size: integer()}} |
    {:error, atom()}
  def prepare_upload(%Plug.Upload{} = file, opts) do
    id = UUID.generate()
    with {:ok, size} <- check_file_size(file.path, opts.size_limit),
         true <- opts.formats |> Enum.member?(Path.extname(file.filename)),
         {:ok, content_type, name} <- CoreMIME.file_mime_type(file.path, file.filename)
    do
      {:ok,
        %@name{
          content_type: content_type,
          id: id,
          name: name,
          path: "#{id}/#{name}",
          size: size,
          tempfile: file.path
        }}
    end
  end

  @spec prepare_upload(%{img: bitstring()}, map()) ::
    {:ok, %__MODULE__{id: String.t(),
        name: String.t(),
        tempfile: String.t(),
        content_type: String.t(),
        size: integer()}} |
    {:error, atom()}
  def prepare_upload(%{img: "data:image/" <> image_data}, opts) do
    case Regex.named_captures(~r/(?<filetype>jpeg|jpg|png|gif|heic|heif);base64,(?<data>.*)/, image_data) do
      nil -> false
      parsed ->
        id = UUID.generate()
        data = Base.decode64!(parsed["data"], ignore: :whitespace)
        hash = Base.encode16(:crypto.hash(:sha256, data), lower: true)
        content_type = "image/" <> parsed["filetype"]
        with :ok <- check_binary_size(data, opts.size_limit),
             tmp_path <- tempfile_for_image(data),
             {:ok, size} <- check_file_size(tmp_path, opts.size_limit),
             [ext | _] <- MIME.extensions(content_type)
        do
          {:ok,
            %@name{
              content_type: content_type,
              id: id,
              name: hash <> "." <> ext,
              path: "#{id}/#{hash <> "." <> ext}",
              size: size,
              tempfile: tmp_path
            }}
        end
    end
  end

  @spec check_binary_size(bitstring(), integer()) :: tuple()
  defp check_binary_size(binary, size_limit) when is_integer(size_limit) and size_limit > 0 and byte_size(binary) >= size_limit do
    {:error, :file_too_large}
  end

  @spec check_binary_size(any(), any()) :: atom()
  defp check_binary_size(_, _), do: :ok

  @spec check_file_size(String.t(), integer()) :: {:ok, integer()} | {:error, atom()} | atom()
  defp check_file_size(path, size_limit) when is_integer(size_limit) and size_limit > 0 do
    with {:ok, %{size: size}} <- File.stat(path), true <- size <= size_limit do
      {:ok, size}
    else
      false -> {:error, :file_too_large}
      error -> error
    end
  end

  @spec check_file_size(any(), any()) :: atom()
  defp check_file_size(_, _), do: :ok

  @spec tempfile_for_image(bitstring()) :: String.t()
  defp tempfile_for_image(data) do
    {:ok, tmp_path} = Plug.Upload.random_file("profile_pics")
    {:ok, tmp_file} = File.open(tmp_path, [:write, :raw, :binary])
    :ok = IO.binwrite(tmp_file, data)
    :ok = File.close(tmp_file)
    tmp_path
  end

  @spec url_from_spec(%__MODULE__{name: String.t()}, String.t(), {:file, String.t}) :: String.t
  defp url_from_spec(%__MODULE__{name: name}, base_url, {:file, path}) do
    path =
      URI.encode(path, &char_unescaped?/1) <>
        if Config.get([@name, :link_name], false) do
          "?name=#{URI.encode(name, &char_unescaped?/1)}"
        else
           ""
        end

    [base_url, "taxgig", path] |> Path.join()
  end

  @spec url_from_spec(any(), any(), {:url, String.t()}) :: String.t()
  defp url_from_spec(_upload, _base_url, {:url, url}), do: url
end
