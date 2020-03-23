defmodule Core.Upload.Filter do
  @moduledoc """
  Upload Filter behaviour

  This behaviour allows to run filtering actions just before a file is uploaded. This allows to:

  * morph in place the temporary file
  * change any field of a `Core.Upload` struct
  * cancel/stop the upload
  """

  require Logger

  @callback filter(Core.Upload.t()) :: :ok | {:ok, Core.Upload.t()} | {:error, any()}

  @spec filter([module()], Core.Upload.t()) :: {:ok, Core.Upload.t()} | {:error, any()}
  def filter([], upload) do
    {:ok, upload}
  end

  @spec filter(list(), Core.Upload.t()) :: {:ok, Core.Upload.t()} | {:error, any()}
  def filter([filter | rest], upload) do
    case filter.filter(upload) do
      :ok ->
        filter(rest, upload)
      {:ok, upload} ->
        filter(rest, upload)
      error ->
        Logger.error("#{__MODULE__}: Filter #{filter} failed: #{inspect(error)}")
        error
    end
  end
end
