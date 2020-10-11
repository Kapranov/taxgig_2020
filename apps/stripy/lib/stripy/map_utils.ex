defmodule Stripy.MapUtils do
  @moduledoc """
  MapUtils is transfer map by StripeServices
  """

  @spec rename(map, atom, atom) :: map
  def rename(map, old_key, new_key) do
    map
    |> Map.put(new_key, map |> Map.get(old_key))
    |> Map.delete(old_key)
  end

  @spec nested_merge(map, atom) :: map
  def nested_merge(map, nested) do
    n1 =
      map
      |> Map.from_struct
      |> Map.delete(nested)

    n2 =
      map
      |> Map.get(nested)
      |> case do
        %_{} = struct ->
          Map.from_struct(struct)

        map -> map
      end

    Map.merge(n1, n2)
  end

  @spec keys_to_string(map) :: map
  def keys_to_string(map), do: stringify_keys(map)

  @spec keys_to_atom(map) :: map
  def keys_to_atom(map), do: atomize_keys(map)

  @spec stringify_keys(%DateTime{}) :: %DateTime{}
  defp stringify_keys(%DateTime{} = val), do: val

  @spec stringify_keys(map) :: map
  defp stringify_keys(map = %{}) do
    map
    |> Enum.map(fn {k, v} -> {stringify_key(k), stringify_keys(v)} end)
    |> Enum.into(%{})
  end

  @spec stringify_keys(list) :: list
  defp stringify_keys([head | rest]), do: [stringify_keys(head) | stringify_keys(rest)]

  @spec stringify_keys(any) :: any
  defp stringify_keys(val), do: val

  @spec stringify_key(atom) :: String.t()
  defp stringify_key(k) when is_atom(k), do: Atom.to_string(k)

  @spec stringify_key(any) :: any
  defp stringify_key(k), do: k

  @spec atomize_keys(map) :: map
  defp atomize_keys(map), do: map |> Enum.map(&atomize_key/1) |> Enum.into(%{})

  @spec atomize_key({String.t(), atom}) :: {atom, atom}
  defp atomize_key({k, v}) when is_binary(k), do: {k |> String.to_existing_atom, v}

  @spec atomize_key(any) :: any
  defp atomize_key(any), do: any
end
