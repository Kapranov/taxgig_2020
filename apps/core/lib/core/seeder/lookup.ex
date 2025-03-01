defmodule Core.Seeder.Lookup do
  @moduledoc """
  Seeds for `Core.Lookup` context.
  """

  alias Core.{
    Lookup.State,
    Lookup.UsZipcode,
    Repo
  }

  alias Ecto.Adapters.SQL

  @root_dir Path.expand("../../../priv/data/", __DIR__)
  @usa_states "#{@root_dir}/us_states.json"
  @usa_zipcodes_part1 "#{@root_dir}/us_zip_part1.json"
  @usa_zipcodes_part2 "#{@root_dir}/us_zip_part2.json"
  @usa_zipcodes_part3 "#{@root_dir}/us_zip_part3.json"

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE states CASCADE;")
    SQL.query!(Repo, "TRUNCATE us_zipcodes CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_states()
    seed_zipcode()
  end

  @spec seed_states() :: nil | Ecto.Schema.t()
  defp seed_states do
    case Repo.aggregate(State, :count, :id) > 0 do
      true -> nil
      false -> insert_states()
    end
  end

  @spec insert_states() :: {integer(), nil | [term()]}
  defp insert_states do
    states =
      @usa_states
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"abbr" => abbr, "name" => name} ->
         %{abbr: abbr, name: name}
      end)

    Repo.insert_all(State, states)
  end

  @spec seed_zipcode() :: nil | Ecto.Schema.t()
  defp seed_zipcode do
    case Repo.aggregate(UsZipcode, :count, :id) > 0 do
      true -> nil
      false -> insert_zipcode()
    end
  end

  @spec insert_zipcode() :: {integer(), nil | [term()]}
  defp insert_zipcode do
    decoded_zipcode1 =
      @usa_zipcodes_part1
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end) |> Enum.map(&Map.put(&1, :id, FlakeId.get()))

    decoded_zipcode2 =
      @usa_zipcodes_part2
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end) |> Enum.map(&Map.put(&1, :id, FlakeId.get()))

    decoded_zipcode3 =
      @usa_zipcodes_part3
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end) |> Enum.map(&Map.put(&1, :id, FlakeId.get()))

    Repo.insert_all(UsZipcode, decoded_zipcode1)
    Repo.insert_all(UsZipcode, decoded_zipcode2)
    Repo.insert_all(UsZipcode, decoded_zipcode3)
  end
end
