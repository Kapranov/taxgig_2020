defmodule Core.Accounts.UserTest do
  use Core.DataCase

  alias Core.Accounts
  alias Core.Localization.Language

  describe "user" do
    alias Core.Accounts.User

    @valid_attrs %{
      active: false,
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
      phone: "555-555-5555",
      provider: "localhost",
      role: false,
      sex: "some text",
      ssn: 123456789,
      street: "some text",
      zip: 123456789
    }

    @update_attrs %{
      active: true,
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
      phone: "999-999-9999",
      provider: "google",
      role: true,
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

    test "list_user/0 returns all users" do
      langs = insert(:language)
      struct = insert(:user, languages: [langs])
      insert(:accounting_software, user: struct)
      insert(:education, user: struct)
      insert(:work_experience, user: struct)

      data =
        Accounts.list_user
        |> Repo.preload([
          :accounting_software,
          :languages,
          :work_experience,
          education: [:university]
        ])

      user =
        [%User{struct | password: nil, password_confirmation: nil, languages: [langs]}]
        |> Repo.preload([
          :accounting_software,
          :languages,
          :work_experience,
          education: [:university]
        ])

      assert data == user
    end

    test "get_user!/1 returns the user with given id" do
      struct = insert(:user)
      data =
        Accounts.get_user!(struct.id)
        |> Repo.preload([:languages])

      struct =
        %User{struct | password: nil, password_confirmation: nil}
        |> Repo.preload([:languages])

      assert data.id          == struct.id
      assert data.active      == struct.active
      assert data.avatar      == struct.avatar
      assert data.bio         == struct.bio
      assert data.birthday    == struct.birthday
      assert data.email       == struct.email
      assert data.first_name  == struct.first_name
      assert data.init_setup  == struct.init_setup
      assert data.languages   == struct.languages
      assert data.last_name   == struct.last_name
      assert data.middle_name == struct.middle_name
      assert data.inserted_at == struct.inserted_at
      assert data.phone       == struct.phone
      assert data.provider    == struct.provider
      assert data.role        == struct.role
      assert data.sex         == struct.sex
      assert data.ssn         == struct.ssn
      assert data.street      == struct.street
      assert data.updated_at  == struct.updated_at
      assert data.zip         == struct.zip
   end

    test "create_user/1 with valid data creates user" do
      lang_a = insert(:language)
      lang_b = insert(:language)
      params = Map.merge(@valid_attrs, %{
        languages: "#{lang_a.name}, #{lang_b.name}"})
      assert {:ok, %User{} = struct} = Accounts.create_user(params)
      [
        %Language{id: id1, abbr: abbr1, name: name1},
        %Language{id: id2, abbr: abbr2, name: name2}
      ] = struct.languages
      assert struct.active      == false
      assert struct.avatar      == "some text"
      assert struct.bio         == "some text"
      assert struct.birthday    == Timex.today
      assert struct.email       == "lugatex@yahoo.com"
      assert struct.first_name  == "some text"
      assert struct.init_setup  == false
      assert struct.last_name   == "some text"
      assert struct.middle_name == "some text"
      assert struct.phone       == "555-555-5555"
      assert struct.provider    == "localhost"
      assert struct.role        == false
      assert struct.sex         == "some text"
      assert struct.ssn         == 123456789
      assert struct.street      == "some text"
      assert struct.zip         == 123456789
      assert Argon2.verify_pass("qwerty", struct.password_hash)

      assert struct.languages |> Enum.count == 2

      assert lang_a.id   == id1
      assert lang_b.id   == id2
      assert lang_a.abbr == abbr1
      assert lang_b.abbr == abbr2
      assert lang_a.name == name1
      assert lang_b.name == name2
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      lang = insert(:language)
      struct = insert(:user)
      params = Map.merge(@update_attrs, %{
        languages: "#{lang.name}"
      })
      assert {:ok, %User{} = updated} = Accounts.update_user(struct, params)
      [
        %Language{id: id, abbr: abbr, name: name}
      ] = updated.languages
      assert updated.active      == true
      assert updated.avatar      == "updated text"
      assert updated.bio         == "updated text"
      assert updated.birthday    == Timex.today
      assert updated.email       == "kapranov.lugatex@gmail.com"
      assert updated.first_name  == "updated text"
      assert updated.init_setup  == true
      assert updated.last_name   == "updated text"
      assert updated.middle_name == "updated text"
      assert updated.phone       == "999-999-9999"
      assert updated.provider    == "google"
      assert updated.role        == true
      assert updated.sex         == "updated text"
      assert updated.ssn         == 987654321
      assert updated.street      == "updated text"
      assert updated.zip         == 987654321
      assert Argon2.verify_pass("qwertyyy", updated.password_hash)

      assert updated.languages |> Enum.count == 1

      assert lang.id   == id
      assert lang.abbr == abbr
      assert lang.name == name
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      insert(:accounting_software, user: user)
      insert(:education, user: user)
      insert(:work_experience, user: user)
      data =
        Accounts.get_user!(user.id)
        |> Repo.preload([
          :accounting_software,
          :languages,
          :work_experience,
          education: [:university]
        ])

      struct =
        %User{user | password: nil, password_confirmation: nil}
        |> Repo.preload([
          :accounting_software,
          :languages,
          :work_experience,
          education: [:university]
        ])

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(struct, @invalid_attrs)
      assert data == struct
    end

    test "delete_user/1 deletes the user" do
      struct = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(struct)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(struct.id) end
    end

    test "change_user/1 returns user changeset" do
      struct = insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(struct)
    end
  end
end
