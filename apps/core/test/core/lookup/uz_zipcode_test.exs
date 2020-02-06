defmodule Core.Lookup.UsZipcodeTest do
  use Core.DataCase

  alias Core.Lookup

  describe "zipcode" do
    alias Core.Lookup.UsZipcode

    @valid_attrs %{
      city: "some text",
      state: "some text",
      zipcode: 123456789
    }

    @update_attrs %{
      city: "updated text",
      state: "updated text",
      zipcode: 987654321
    }

    @invalid_attrs %{
      city: nil,
      state: nil,
      zipcode: nil
    }

    def fixture(attrs \\ %{}) do
      {:ok, struct} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lookup.create_zipcode()

      struct
    end

    test "list_zipcode/0 returns all UsZipcodes" do
      struct = fixture()
      assert Lookup.list_zipcode() == [struct]
    end

    test "get_zipcode!/1 returns the UsZipcode with given id" do
      struct = fixture()
      assert Lookup.get_zipcode!(struct.id) == struct
    end

    test "search_zipcode!/1 returns the UsZipcode with given zipcode" do
      struct = fixture()
      number = 123456789
      assert Lookup.search_zipcode(number) == struct
    end

    test "create_zipcode/1 with valid data creates UsZipcode" do
      assert {:ok, %UsZipcode{} = struct} = Lookup.create_zipcode(@valid_attrs)
      assert struct.city    == "some text"
      assert struct.state   == "some text"
      assert struct.zipcode == 123456789
    end

    test "create_zipcode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Lookup.create_zipcode(@invalid_attrs)
    end

    test "update_zipcode/2 with valid data updates the UsZipcode" do
      struct = fixture()
      assert {:ok, %UsZipcode{} = struct} =
        Lookup.update_zipcode(struct, @update_attrs)
      assert struct.city    == "updated text"
      assert struct.state   == "updated text"
      assert struct.zipcode == 987654321
    end

    test "update_zipcode/2 with invalid data returns error changeset" do
      struct = fixture()
      assert {:error, %Ecto.Changeset{}} =
        Lookup.update_zipcode(struct, @invalid_attrs)
      assert struct == Lookup.get_zipcode!(struct.id)
    end

    test "delete_zipcode/1 deletes the UsZipcode" do
      struct = fixture()
      assert {:ok, %UsZipcode{}} = Lookup.delete_zipcode(struct)
      assert_raise Ecto.NoResultsError, fn -> Lookup.get_zipcode!(struct.id) end
    end

    test "change_zipcode/1 returns UsZipcode changeset" do
      struct = fixture()
      assert %Ecto.Changeset{} = Lookup.change_zipcode(struct)
    end
  end
end
