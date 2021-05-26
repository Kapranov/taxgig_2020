defmodule Plaid.Utils do
  @moduledoc """
  Utility functions.
  """

  @type response :: %{required(String.t()) => any}
  @type endpoint :: atom

  @doc """
  Handles Plaid response and maps to the correct data structure.
  """
  def handle_resp({:ok, %HTTPoison.Response{status_code: code} = resp}, endpoint) when code in 200..201 do
    {:ok, map_response(resp.body, endpoint)}
  end

  def handle_resp({:ok, %HTTPoison.Response{} = resp}, _endpoint) do
    {:error, transform(resp.body, %{as: %Plaid.Error{}})}
  end

  def handle_resp({:error, %HTTPoison.Error{} = error}, _endpoint) do
    {:error, error}
  end

  @doc """
  Maps an endpoint's response to the corresponding internal data structure.
  """
  def map_response(response, :link) do
    # transform(response, %{as: %Plaid.Link{}})
    Jason.decode!(response)
  end

  def transform(value, options) when is_map(value) or is_list(value) do
    case Map.get(options, :as) do
      nil -> value
      as -> transform(value, Map.get(options, :keys), as, options)
    end
  end

  def transform(value, _options) do
    value
  end

  defp transform(nil, _keys, _as, _options), do: nil

  defp transform(value, keys, %{__struct__: _} = as, options) do
    transform_struct(value, keys, as, options)
  end

  defp transform(value, keys, as, options) when is_map(as) do
    transform_map(value, keys, as, options)
  end

  defp transform(value, keys, [as], options) do
    for v <- value, do: transform(v, keys, as, options)
  end

  defp transform(value, _keys, _as, _options) do
    value
  end

  defp transform_map(value, keys, as, options) do
    Enum.reduce(as, value, fn {key, as}, acc ->
      case Map.get(acc, key) do
        value when is_map(value) or is_list(value) ->
          Map.put(acc, key, transform(value, keys, as, options))
        _ ->
          acc
      end
    end)
  end

  defp transform_struct(value, keys, as, options) when keys in [:atoms, :atoms!] do
    as
    |> Map.from_struct()
    |> Map.merge(value)
    |> do_transform_struct(keys, as, options)
  end

  defp transform_struct(value, keys, as, options) do
    as
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn {key, default}, acc ->
      Map.put(acc, key, Map.get(value, Atom.to_string(key), default))
    end)
    |> do_transform_struct(keys, as, options)
  end

  defp do_transform_struct(value, keys, as, options) do
    default = struct(as.__struct__)

    as
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn {key, as}, acc ->
      new_value =
        case Map.fetch(value, key) do
          {:ok, ^as} when is_map(as) or is_list(as) ->
            Map.get(default, key)
          {:ok, value} when is_map(value) or is_list(value) ->
            transform(value, keys, as, options)
          {:ok, value} ->
            value
          :error ->
            Map.get(default, key)
        end

      Map.put(acc, key, new_value)
    end)
    |> Map.put(:__struct__, as.__struct__)
    |> decode()
  end

  def decode(iodata) do
    {:ok, Jason.decode!(iodata)}
  rescue
    exception in [ParseError, DecodeError] ->
      {:error, exception}
  end
end
