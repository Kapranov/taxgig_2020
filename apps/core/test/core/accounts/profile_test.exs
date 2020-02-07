defmodule Core.Accounts.ProfileTest do
  use Core.DataCase

  alias Core.Accounts
  alias Core.Lookup

  describe "profile" do
    alias Core.Accounts.Profile
    alias Core.Accounts.User
    alias Core.Lookup.UsZipcode

    @valid_attrs %{
      address: "some text",
      banner: "some text",
      description: "some text",
      logo: %{"image" => "some text"}
    }

    @update_attrs %{
      address: "updated text",
      banner: "updated text",
      description: "updated text",
      logo: %{"image" => "updated text"}
    }

    @invalid_attrs %{
      user_id: nil
    }

    def fixture(attrs \\ %{}) do
      user_attrs = %{
        active: false,
        admin_role: false,
        avatar: "some text",
        bio: "some text",
        birthday: Timex.today,
        email: "lugatex@yahoo.com",
        first_name: "some text",
        init_setup: false,
        last_name: "some text",
        middle_name: "some text",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "some text",
        pro_role: false,
        provider: "localhost",
        sex: "some text",
        ssn: 123456789,
        street: "some text",
        zip: 123456789
      }

      zipcode_attrs = %{
        city: "some text",
        state: "some text",
        zipcode: 123456789
      }

      {:ok, user} =
        %{}
        |> Enum.into(user_attrs)
        |> Accounts.create_user()

      {:ok, zipcode} =
        %{}
        |> Enum.into(zipcode_attrs)
        |> Lookup.create_zipcode()

      params =
        Map.merge(@valid_attrs, %{
          user_id: user.id,
          us_zipcode_id: zipcode.id
        })

      {:ok, struct} =
        attrs
        |> Enum.into(params)
        |> Accounts.create_profile()

      struct
    end

    test "list_profile/0 returns all profiles" do
      fixture()
      struct = Accounts.list_profile()
      assert struct |> Enum.count == 1
    end

    test "get_profile!/1 returns the profile with given user_id" do
      struct = fixture()
      struct = Accounts.get_profile!(struct.user_id)
      assert struct.address     == "some text"
      assert struct.banner      == "some text"
      assert struct.description == "some text"
      assert struct.logo        == %{"image" => "some text"}
    end

    test "create_profile/1 with valid data creates profile" do
      user_attrs = %{
        active: false,
        admin_role: false,
        avatar: "some text",
        bio: "some text",
        birthday: Timex.today,
        email: "lugatex@yahoo.com",
        first_name: "some text",
        init_setup: false,
        last_name: "some text",
        middle_name: "some text",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "some text",
        pro_role: false,
        provider: "localhost",
        sex: "some text",
        ssn: 123456789,
        street: "some text",
        zip: 123456789
      }

      zipcode_attrs = %{
        city: "some text",
        state: "some text",
        zipcode: 123456789
      }

      assert {:ok, %User{} = user} = Accounts.create_user(user_attrs)
      assert {:ok, %UsZipcode{} = zipcode} = Lookup.create_zipcode(zipcode_attrs)

      params =
        Map.merge(@valid_attrs, %{
          user_id: user.id,
          us_zipcode_id: zipcode.id
        })

      assert {:ok, %Profile{} = struct} = Accounts.create_profile(params)
      assert struct.address       == "some text"
      assert struct.banner        == "some text"
      assert struct.description   == "some text"
      assert struct.logo          == %{"image" => "some text"}
      assert struct.user_id       == user.id
      assert struct.us_zipcode_id == zipcode.id
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Accounts.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      struct = fixture()
      struct = Accounts.get_profile!(struct.user_id)
      assert {:ok, %Profile{} = struct} = Accounts.update_profile(struct, @update_attrs)
      assert struct.address     == "updated text"
      assert struct.banner      == "updated text"
      assert struct.description == "updated text"
      assert struct.logo        == %{"image" => "updated text"}
    end

    test "update_profile/2 with invalid data returns error changeset" do
      struct = fixture()
      struct = Accounts.get_profile!(struct.user_id)
      assert {:error, %Ecto.Changeset{}} =
        Accounts.update_profile(struct, @invalid_attrs)
      assert struct == Accounts.get_profile!(struct.id)
    end

    test "delete_profile/1 deletes the profile" do
      struct = fixture()
      struct = Accounts.get_profile!(struct.user_id)
      assert {:ok, %Profile{}} = Accounts.delete_profile(struct)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(struct.id) end
    end

    test "change_profile/1 returns profile changeset" do
      struct = fixture()
      struct = Accounts.get_profile!(struct.user_id)
      assert %Ecto.Changeset{} = Accounts.change_profile(struct)
    end
  end
end
