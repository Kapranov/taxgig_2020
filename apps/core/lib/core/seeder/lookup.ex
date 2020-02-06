defmodule Core.Seeder.Lookup do
  @moduledoc """
  Seeds for `Core.Lookup` context.
  """

  alias Core.Lookup.UsZipcode
  alias Core.Repo

  @root_dir Path.expand("../../../priv/data/", __DIR__)
  @usa_zipcodes_part1 "#{@root_dir}/us_zip_part1.json"
  @usa_zipcodes_part2 "#{@root_dir}/us_zip_part2.json"
  @usa_zipcodes_part3 "#{@root_dir}/us_zip_part3.json"

  def reset_database! do
    Repo.delete_all(UsZipcode)
  end

  def seed! do
    seed_zipcode()
  end

  defp seed_zipcode do
    case Repo.aggregate(UsZipcode, :count, :id) > 0 do
      true -> nil
      false -> insert_zipcode()
    end
  end

  defp insert_zipcode do
    decoded_zipcode1 =
      @usa_zipcodes_part1
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end)

    decoded_zipcode2 =
      @usa_zipcodes_part2
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end)

    decoded_zipcode3 =
      @usa_zipcodes_part3
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end)

    Repo.insert_all(UsZipcode, decoded_zipcode1)
    Repo.insert_all(UsZipcode, decoded_zipcode2)
    Repo.insert_all(UsZipcode, decoded_zipcode3)
  end
end
