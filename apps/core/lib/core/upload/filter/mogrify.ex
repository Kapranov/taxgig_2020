defmodule Core.Upload.Filter.Mogrify do
  @moduledoc """
  Handle mogrify transformations
  """

  @behaviour Core.Upload.Filter

  alias Core.Config

  @type conversion :: action :: String.t() | {action :: String.t(), opts :: String.t()}
  @type conversions :: conversion() | [conversion()]

  @spec filter(%Core.Upload{}) :: :ok
  def filter(%Core.Upload{tempfile: file, content_type: "image" <> _}) do
    filters = Config.get!([__MODULE__, :args])

    do_filter(file, filters)
    :ok
  end

  @spec filter(any) :: :ok
  def filter(_), do: :ok

  @spec do_filter(bitstring(), list()) :: bitstring()
  def do_filter(file, filters) do
    file
    |> Mogrify.open()
    |> mogrify_filter(filters)
    |> Mogrify.save(in_place: true)
  end

  @spec mogrify_filter(list(), nil) :: list()
  defp mogrify_filter(mogrify, nil), do: mogrify

  @spec mogrify_filter(list(), list()) :: list()
  defp mogrify_filter(mogrify, [filter | rest]) do
    mogrify
    |> mogrify_filter(filter)
    |> mogrify_filter(rest)
  end

  @spec mogrify_filter(list(), []) :: list()
  defp mogrify_filter(mogrify, []), do: mogrify

  @spec mogrify_filter(list(), tuple()) :: map()
  defp mogrify_filter(mogrify, {action, options}) do
    Mogrify.custom(mogrify, action, options)
  end

  @spec mogrify_filter(list(), binary()) :: map()
  defp mogrify_filter(mogrify, action) when is_binary(action) do
    Mogrify.custom(mogrify, action)
  end
end
