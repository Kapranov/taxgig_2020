defmodule Core.Uploaders.S3 do
  @moduledoc """
  Digital Ocean Spaces with Amazon AWS S3 uploader for files
  """

  @behaviour Core.Uploaders.Uploader

  require Logger

  alias Core.Config

  @name __MODULE__

  @spec get_file(String.t()) :: {:ok, {:url, String.t()}}
  def get_file(file) do
    config = Config.get([@name])
    bucket = Keyword.fetch!(config, :bucket)

    bucket_with_namespace =
      cond do
        truncated_namespace = Keyword.get(config, :truncated_namespace) ->
          truncated_namespace

        namespace = Keyword.get(config, :bucket_namespace) ->
          namespace <> ":" <> bucket

        true ->
          bucket
      end

    {:ok,
      {:url,
        Path.join([
          Keyword.fetch!(config, :public_endpoint),
          bucket_with_namespace,
          strict_encode(URI.decode(file))
        ])}}
  end

  @spec put_file(%Core.Upload{name: String.t(), content_type: String.t(), path: String.t(), tempfile: String.t()}) :: {:ok, {:file, String.t()}} | {:error, String.t()}
  def put_file(%Core.Upload{} = upload) do
    config = Config.get([@name])
    bucket = Keyword.get(config, :bucket)
    streaming = Keyword.get(config, :streaming_enabled)
    s3_name = strict_encode(upload.path)

    op =
      if streaming do
        upload.tempfile
        |> ExAws.S3.Upload.stream_file()
        |> ExAws.S3.upload(bucket, s3_name, [
          {:acl, :public_read},
          {:content_type, upload.content_type}
        ])
      else
        {:ok, file_data} = File.read(upload.tempfile)

        ExAws.S3.put_object(bucket, s3_name, file_data, [
          {:acl, :public_read},
          {:content_type, upload.content_type}
        ])
      end

    case ExAws.request(op) do
      {:ok, _} ->
        {:ok, {:file, s3_name}}

      error ->
        Logger.error("#{@name}: #{inspect(error)}")
        {:error, "S3 Upload failed"}
    end
  end

  @spec delete_file(String.t()) :: ExAws.Operation.S3.t() | {:error, String.t()}
  def delete_file(file) do
    bucket = Application.get_env(:ex_aws, :bucket)
    if strict_encode(URI.decode(file)) do
      list =
        ExAws.S3.list_objects(bucket)
        |> ExAws.stream!
        |> Enum.to_list

      data =
        Enum.find(list,
          fn obj -> obj.key == file
        end)

      if is_nil(data) do
        {:error, "S3 Upload failed"}
      else
        ExAws.S3.delete_object(bucket, file)
        |> ExAws.request()
      end
    end
  end

  @spec remove_file(String.t()) :: ExAws.Operation.S3.t()
  def remove_file(file) do
    if strict_encode(URI.decode(file)) do
      list = ExAws.S3.list_objects(System.get_env("AWS_S3_BUCKET_UPLOADS"), prefix: "uploads/users")
      |> ExAws.stream!
      |> Enum.to_list

      Enum.each list, fn obj ->
        [_, _, _, file_name] = String.split obj.key, "/"
        if file_name do
          ExAws.S3.delete_object(System.get_env("AWS_S3_BUCKET_UPLOADS"), obj.key)
          |> ExAws.request()
        end
      end
    end
  end

  @regex Regex.compile!("[^0-9a-zA-Z!.*/'()_-]")
  @spec strict_encode(String.t()) :: String.t()
  def strict_encode(name) do
    String.replace(name, @regex, "-")
  end
end
