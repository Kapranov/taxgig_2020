defmodule Core.Upload.Filter.Dedupe do
  @moduledoc """
  Names the file after its hash to avoid dedupes
  """

  @behaviour Core.Upload.Filter

  alias Core.Upload

  @spec filter(Upload.t()) :: {:ok, Upload.t()}
  def filter(%Upload{name: name, tempfile: tempfile} = upload) do
    extension =
      name
      |> String.split(".")
      |> List.last()

    shasum =
      :crypto.hash(:sha256, File.read!(tempfile))
      |> Base.encode16(case: :lower)

    filename = shasum <> "." <> extension
    {:ok, %Upload{upload | id: shasum, path: filename}}
  end

  @spec filter(any) :: :ok
  def filter(_), do: :ok
end
