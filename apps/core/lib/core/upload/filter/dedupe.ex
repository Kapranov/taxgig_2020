defmodule Core.Upload.Filter.Dedupe do
  @moduledoc """
  Names the file after its hash to avoid dedupes
  """

  @behaviour Core.Upload.Filter

  alias Core.Upload

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

  def filter(_), do: :ok
end
