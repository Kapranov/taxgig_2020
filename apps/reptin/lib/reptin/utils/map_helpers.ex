defmodule Reptin.Client.Utils.MapHelpers do
  @moduledoc """
  Functions to transform maps
  """

   @doc """
   Convert map string camelCase keys to underscore_keys
   Walk the list and atomize the keys of of any map members
   """
   def underscore_keys(nil), do: nil

   def underscore_keys(map = %{}) do
     map
     |> Enum.map(fn {k, v} -> {Macro.underscore(k), underscore_keys(v)} end)
     |> Enum.map(fn {k, v} -> {String.replace(k, "-", "_"), v} end)
     |> Enum.into(%{})
   end

   def underscore_keys([head | rest]) do
     [underscore_keys(head) | underscore_keys(rest)]
   end

   def underscore_keys(not_a_map) do
     not_a_map
   end

   @doc """
   Convert map string keys to :atom keys
   Structs don't do enumerable and anyway the keys are already atoms
   Walk the list and atomize the keys of of any map members
   """
   def atomize_keys(nil), do: nil

   def atomize_keys(struct = %{__struct__: _}) do
     struct
   end

   def atomize_keys(map = %{}) do
     map
     |> Enum.map(fn {k, v} -> {String.to_atom(k), atomize_keys(v)} end)
     |> Enum.into(%{})
   end

   def atomize_keys([head | rest]) do
     [atomize_keys(head) | atomize_keys(rest)]
   end

   def atomize_keys(not_a_map) do
     not_a_map
   end

   @doc """
   Convert map atom keys to strings
   Walk the list and stringify the keys of any map members
   """
   def stringify_keys(nil), do: nil

   def stringify_keys(map = %{}) do
     map
     |> Enum.map(fn {k, v} -> {Atom.to_string(k), stringify_keys(v)} end)
     |> Enum.into(%{})
   end

   def stringify_keys([head | rest]) do
     [stringify_keys(head) | stringify_keys(rest)]
   end

   def stringify_keys(not_a_map) do
     not_a_map
   end

   @doc """
   Deep merge two maps
   Key exists in both maps, and both values are maps as well.
   These can be merged recursively.
   Key exists in both maps, but at least one of the values is
   npt a map. We fall back to standard merge behavior, preferring
   the value on the right.
   """
   def deep_merge(left, right) do
     Map.merge(left, right, &deep_resolve/3)
   end

   defp deep_resolve(_key, left = %{}, right = %{}) do
     deep_merge(left, right)
   end

   defp deep_resolve(_key, _left, right) do
     right
   end
end
