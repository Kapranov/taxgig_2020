defmodule Core.Accounts.UserTest do
  use Core.DataCase

  alias Core.Accounts

  describe "user" do
    alias Core.Accounts.User

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
      active: true,
      admin_role: true,
      avatar: "updated text",
      bio: "updated text",
      birthday: Timex.today,
      email: "kapranov.lugatex@gmail.com",
      first_name: "updated text",
      init_setup: true,
      last_name: "updated text",
      middle_name: "updated text",
      password: "qwertyyy",
      password_confirmation: "qwertyyy",
      phone: "updated text",
      pro_role: true,
      provider: "google",
      sex: "updated text",
      ssn: 987654321,
      street: "updated text",
      zip: 987654321
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
      assert struct.active      == false
      assert struct.admin_role  == false
      assert struct.avatar      == "some text"
      assert struct.bio         == "some text"
      assert struct.birthday    == Timex.today
      assert struct.email       == "lugatex@yahoo.com"
      assert struct.first_name  == "some text"
      assert struct.init_setup  == false
      assert struct.last_name   == "some text"
      assert struct.middle_name == "some text"
      assert struct.phone       == "some text"
      assert struct.pro_role    == false
      assert struct.provider    == "localhost"
      assert struct.sex         == "some text"
      assert struct.ssn         == 123456789
      assert struct.street      == "some text"
      assert struct.zip         == 123456789
      assert Argon2.verify_pass("qwerty", struct.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      struct = fixture()
      assert {:ok, %User{} = updated} = Accounts.update_user(struct, @update_attrs)
      assert updated.active      == true
      assert updated.admin_role  == true
      assert updated.avatar      == "updated text"
      assert updated.bio         == "updated text"
      assert updated.birthday    == Timex.today
      assert updated.email       == "kapranov.lugatex@gmail.com"
      assert updated.first_name  == "updated text"
      assert updated.init_setup  == true
      assert updated.last_name   == "updated text"
      assert updated.middle_name == "updated text"
      assert updated.phone       == "updated text"
      assert updated.pro_role    == true
      assert updated.provider    == "google"
      assert updated.sex         == "updated text"
      assert updated.ssn         == 987654321
      assert updated.street      == "updated text"
      assert updated.zip         == 987654321
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
