defmodule Core.Accounts.ProfileTest do
  use Core.DataCase

  alias Core.Accounts
  alias Core.Lookup

  describe "profile" do
    alias Core.Accounts.Profile

    @valid_attrs %{
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

    @update_attrs %{
      address: "updated text",
      banner: "updated text",
      description: "updated text",
      logo: %{"image" => "updated text"}
    }

    @invalid_attrs %{user_id: nil}

    def fixture(attrs \\ %{}) do
      {:ok, struct} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      struct
    end

    test "list_profile/0 returns all profiles" do
      _user = fixture()
      struct = Accounts.list_profile()
      assert struct |> Enum.count == 1
    end

    test "get_profile!/1 returns the profile with given user_id" do
      user = fixture()
      struct = Accounts.get_profile!(user.id)
      assert struct.address     == nil
      assert struct.banner      == nil
      assert struct.description == nil
      assert struct.logo        == nil
    end

    test "create_profile/1 via multi created an user with only user_id" do
      user = fixture()
      struct = Accounts.get_profile!(user.id)

      assert struct.address       == nil
      assert struct.banner        == nil
      assert struct.description   == nil
      assert struct.logo          == nil
      assert struct.user_id       == user.id
      assert struct.us_zipcode_id == nil
    end

    test "update_profile/2 with valid data updates the profile" do
      user = fixture()
      struct = Accounts.get_profile!(user.id)
      zipcode_attrs = %{
        city: "some text",
        state: "some text",
        zipcode: 123456789
      }
      {:ok, zipcode} = Lookup.create_zipcode(zipcode_attrs)
      params =
        Map.merge(@update_attrs, %{
          user_id: user.id,
          us_zipcode_id: zipcode.id
        })

      assert {:ok, %Profile{} = updated} = Accounts.update_profile(struct, params)
      assert updated.address       == "updated text"
      assert updated.banner        == "updated text"
      assert updated.description   == "updated text"
      assert updated.logo          == %{"image" => "updated text"}
      assert updated.user_id       == user.id
      assert updated.us_zipcode_id == zipcode.id
    end

    test "update_profile/2 with invalid data returns error changeset" do
      user = fixture()
      struct = Accounts.get_profile!(user.id)
      assert {:error, %Ecto.Changeset{}} =
        Accounts.update_profile(struct, @invalid_attrs)
      assert struct == Accounts.get_profile!(struct.user_id)
    end

    test "delete_profile/1 deletes the profile" do
      user = fixture()
      struct = Accounts.get_profile!(user.id)
      assert {:ok, %Profile{}} = Accounts.delete_profile(struct)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_profile!(struct.user_id) end
    end

    test "change_profile/1 returns profile changeset" do
      user = fixture()
      struct = Accounts.get_profile!(user.id)
      assert %Ecto.Changeset{} = Accounts.change_profile(struct)
    end
  end
end
