defmodule Stripy.StripeTesting.Helpers do
  @moduledoc """
  Used to load JSON fitures which simulate Stripe API responses into
  stripity_stripe structs
  """

  @root_dir Path.expand("../../../lib/stripy/stripe_testing/", __DIR__)
  @fixture_path "#{@root_dir}/fixtures/"

  @doc """
  Load a stripe response fixture through stripy, into a struct
  """
  @spec load_fixture(String.t) :: struct
  def load_fixture(id) do
    id
    |> load_raw_fixture()
    |> Stripe.Converter.convert_result
  end

  @spec load_raw_fixture(String.t) :: map
  def load_raw_fixture(id) do
    id
    |> build_file_path
    |> File.read!
    |> Jason.decode!
  end

  @spec build_file_path(String.t) :: String.t
  defp build_file_path(id), do: id |> append_extension |> join_with_path

  @spec append_extension(String.t) :: String.t
  defp append_extension(id), do: id <> ".json"

  @spec join_with_path(String.t) :: String.t
  defp join_with_path(filename), do: @fixture_path <> filename
end
