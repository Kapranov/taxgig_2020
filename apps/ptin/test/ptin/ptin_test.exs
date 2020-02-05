defmodule PtinTest do
  use Ptin.DataCase

  alias Ptin.{
    Services,
    Services.Expire,
    Services.Ptin
  }

  describe "expires all actions" do
    @valid_attrs %{expired: "some text", url: "some text"}
    @invalid_attrs %{expired: nil, url: nil}

    def expire_fixture(attrs \\ %{}) do
      {:ok, struct} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Services.create_expire()

      struct
    end

    test "list_expires/0 returns all expired" do
      expired = expire_fixture()
      assert Services.list_expire == [expired]
    end

    test "create_expire/1 with valid data creates an expire" do
      assert {:ok, %Expire{} = expire} = Services.create_expire(@valid_attrs)
      assert expire.expired == "some text"
      assert expire.url     == "some text"
    end

    test "create_expire/1 only one record into Repo" do
      assert {:ok, %Expire{} = created1} = Services.create_expire(@valid_attrs)
      assert created1.expired == "some text"
      assert created1.url     == "some text"

      new_attrs = %{expired: "new text", url: "new text"}
      assert {:ok, %Expire{} = created2} = Services.create_expire(new_attrs)
      assert created2.expired == "new text"
      assert created2.url     == "new text"

      assert Services.list_expire |> Enum.count == 1
    end

    test "create_multi_expire/1 with ecto.multi data" do
      assert {:ok, %{delete_all: {0, nil}, expires: created}} =
        Services.create_multi_expire(@valid_attrs)
      assert created.expired == "some text"
      assert created.url     == "some text"
      assert Services.list_expire |> Enum.count == 1
    end

    test "create_expire/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Services.create_expire(@invalid_attrs)
    end

    test "change_expire/1 returns a ptin changeset" do
      expired = expire_fixture()
      assert %Ecto.Changeset{} = Services.change_expire(expired)
    end
  end

  describe "ptins all actions" do
    @valid_attrs %{
      bus_addr_zip: "84116",
      bus_st_code: "UT",
      first_name: "Jason",
      last_name: "Broschinsky",
      profession: "CPA,EA"
    }

    @invalid_attrs %{
      bus_addr_zip: nil,
      bus_st_code:  nil,
      first_name:   nil,
      last_name:    nil,
      profession:   nil
    }

    def ptin_fixture(attrs \\ %{}) do
      {:ok, struct} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Services.create_ptin()

      struct
    end

    test "create_ptin/1 with valid data creates an ptin" do
      assert {:ok, %Ptin{} = created} = Services.create_ptin(@valid_attrs)
      assert created.bus_addr_zip == "84116"
      assert created.bus_st_code  == "UT"
      assert created.first_name   == "Jason"
      assert created.last_name    == "Broschinsky"
      assert created.profession   == "CPA,EA"
    end

    test "create_multi_ptin/1 with valid data creates an ptin" do
      assert {:ok, %{ptins: created}} = Services.create_multi_ptin(@valid_attrs)
      assert created.bus_addr_zip == "84116"
      assert created.bus_st_code  == "UT"
      assert created.first_name   == "Jason"
      assert created.last_name    == "Broschinsky"
      assert created.profession   == "CPA,EA"
    end

    test "create_ptin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Services.create_ptin(@invalid_attrs)
    end

    test "create_multi_ptin/1 with invalid data returns error changeset" do
      assert {:error, error} = Services.create_multi_ptin(@invalid_attrs)
      assert error == [
        [field: :bus_addr_zip, message: "Can't be blank"],
        [field: :bus_st_code, message: "Can't be blank"],
        [field: :first_name, message: "Can't be blank"],
        [field: :last_name, message: "Can't be blank"]
      ]
    end

    test "search_profession/1 with valid data specific" do
      ptin = ptin_fixture()
      assert found = Services.search_profession(@valid_attrs)
      assert found == ptin.profession
      assert found == "CPA,EA"
    end

    test "delete_ptin/1 deletes the ptin" do
      ptin = ptin_fixture()
      assert {:ok, %Ptin{}} = Services.delete_ptin(ptin)
    end

    test "change_ptin/1 returns a ptin changeset" do
      ptin = ptin_fixture()
      assert %Ecto.Changeset{} = Services.change_ptin(ptin)
    end
  end

  describe "ptins.download all actions" do
    test "create/1" do
    end

    test "get/1" do
    end

    test "get!/1" do
    end

    test "get_csv/1" do
    end

    test "insert/2" do
    end

    test "insert!/2" do
    end

    test "remove_repo/1" do
    end

    test "remove_file/2" do
    end
  end
end
