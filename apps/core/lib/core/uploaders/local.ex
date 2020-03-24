defmodule Core.Uploaders.Local do
  @moduledoc """
  Local uploader for files
  """

  @behaviour Core.Uploaders.Uploader
  @type posix :: :file.posix()

  alias Core.Config

  @spec get_file(any()) :: {:ok, {:static_dir, String.t()}}
  def get_file(_) do
    {:ok, {:static_dir, upload_path()}}
  end


  @spec put_file(map()) :: :ok | {:error, posix()}
  def put_file(upload) do
    {path, file} = local_path(upload.path)
    result_file = Path.join(path, file)

    unless File.exists?(result_file) do
      File.cp!(upload.tempfile, result_file)
    end

    :ok
  end

  @spec remove_file(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def remove_file(path) do
    with {path, file} <- local_path(path),
         full_path <- Path.join(path, file),
         true <- File.exists?(full_path),
         :ok <- File.rm(full_path),
         :ok <- remove_folder(path) do
      {:ok, path}
    else
      false -> {:error, "File #{path} doesn't exist"}
    end
  end

  @spec remove_folder(String.t) :: :ok | {:error, atom()} | {:error, String.t()}
  defp remove_folder(path) do
    with {:subfolder, true} <- {:subfolder, path != upload_path()},
         {:empty_folder, {:ok, [] = _files}} <- {:empty_folder, File.ls(path)} do
      File.rmdir(path)
    else
      {:subfolder, _} -> :ok
      {:empty_folder, _} -> {:error, "Error: Folder is not empty"}
    end
  end

  @spec local_path(String.t) :: {String.t(), binary()}
  defp local_path(path) do
    case Enum.reverse(String.split(path, "/", trim: true)) do
      [file] ->
        {upload_path(), file}
      [file | folders] ->
        path = Path.join([upload_path()] ++ Enum.reverse(folders))
        File.mkdir_p!(path)
        {path, file}
    end
  end

  @spec upload_path() :: String.t()
  def upload_path do
    Config.get!([__MODULE__, :uploads])
  end
end
