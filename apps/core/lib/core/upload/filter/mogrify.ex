defmodule Core.Upload.Filter.Mogrify do
  @moduledoc """
  Handle mogrify transformations
  """

  @behaviour Core.Upload.Filter

  alias Core.Config

  @type conversion :: action :: String.t() | {action :: String.t(), opts :: String.t()}
  @type conversions :: conversion() | [conversion()]

  def filter(%Core.Upload{tempfile: file, content_type: "image" <> _}) do
    filters = Config.get!([__MODULE__, :args])

    do_filter(file, filters)
    :ok
  end

  def filter(_), do: :ok

  def do_filter(file, filters) do
    file
    |> Mogrify.open()
    |> mogrify_filter(filters)
    |> Mogrify.save(in_place: true)
  end

  defp mogrify_filter(mogrify, nil), do: mogrify

  defp mogrify_filter(mogrify, [filter | rest]) do
    mogrify
    |> mogrify_filter(filter)
    |> mogrify_filter(rest)
  end

  defp mogrify_filter(mogrify, []), do: mogrify

  defp mogrify_filter(mogrify, {action, options}) do
    Mogrify.custom(mogrify, action, options)
  end

  defp mogrify_filter(mogrify, action) when is_binary(action) do
    Mogrify.custom(mogrify, action)
  end
end
