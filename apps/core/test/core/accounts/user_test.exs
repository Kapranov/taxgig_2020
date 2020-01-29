defmodule Core.Accounts.UserTest do
  use Core.DataCase

  alias Core.Accounts

  describe "user" do
    alias Core.Accounts.User

    @valid_attrs %{
      email: "lugatex@yahoo.com",
      password: "qwerty",
      password_confirmation: "qwerty",
      provider: "localhost"
    }

    @update_attrs %{
      email: "kapranov.lugatex@gmail.com",
      password: "qwertyyy",
      password_confirmation: "qwertyyy",
      provider: "google"
    }

    @invalid_attrs %{
      email: nil,
      password: nil,
      password_confirmation: nil
    }

    def fixture(attrs \\ %{}) do
      {:ok, struct} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      struct
    end

    test "list_user/0 returns all users" do
      struct = fixture()
      assert Accounts.list_user() == [%User{struct | password: nil, password_confirmation: nil}]
    end

    test "get_user!/1 returns the user with given id" do
      struct = fixture()
      assert Accounts.get_user!(struct.id) == %User{struct | password: nil, password_confirmation: nil}
    end

    test "create_user/1 with valid data creates user" do
      assert {:ok, %User{} = struct} = Accounts.create_user(@valid_attrs)
      assert struct.active      == nil
      assert struct.admin_role  == nil
      assert struct.avatar      == nil
      assert struct.bio         == nil
      assert struct.birthday    == nil
      assert struct.email       == "lugatex@yahoo.com"
      assert struct.first_name  == nil
      assert struct.init_setup  == nil
      assert struct.last_name   == nil
      assert struct.middle_name == nil
      assert struct.phone       == nil
      assert struct.pro_role    == nil
      assert struct.provider    == "localhost"
      assert struct.sex         == nil
      assert struct.ssn         == nil
      assert struct.street      == nil
      assert struct.zip         == nil
      assert Argon2.verify_pass("qwerty", struct.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      struct = fixture()
      assert {:ok, %User{} = updated} = Accounts.update_user(struct, @update_attrs)
      assert updated.active      == nil
      assert updated.admin_role  == nil
      assert updated.avatar      == nil
      assert updated.bio         == nil
      assert updated.birthday    == nil
      assert updated.email       == "kapranov.lugatex@gmail.com"
      assert updated.first_name  == nil
      assert updated.init_setup  == nil
      assert updated.last_name   == nil
      assert updated.middle_name == nil
      assert updated.phone       == nil
      assert updated.pro_role    == nil
      assert updated.provider    == "google"
      assert updated.sex         == nil
      assert updated.ssn         == nil
      assert updated.street      == nil
      assert updated.zip         == nil
      assert Argon2.verify_pass("qwertyyy", updated.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      struct = fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(struct, @invalid_attrs)
      assert %User{struct | password: nil, password_confirmation: nil} == Accounts.get_user!(struct.id)
      assert Argon2.verify_pass("qwerty", struct.password_hash)
    end

    test "delete_user/1 deletes the user" do
      struct = fixture()
      assert {:ok, %User{}} = Accounts.delete_user(struct)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(struct.id) end
    end

    test "change_user/1 returns user changeset" do
      struct = fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(struct)
    end
  end
end
