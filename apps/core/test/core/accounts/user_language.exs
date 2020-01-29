defmodule Core.Accounts.UserLanguageTest do
  use Core.DataCase

  alias Core.{
    Accounts,
    Localization
  }

  describe "user_language" do
    alias Core.{
      Accounts.User,
      Accounts.UserLanguage,
      Localization.Language
    }

    @invalid_attrs %{user_id: nil, language_id: nil}

    @user_attrs %{
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

    @language_attrs %{
      abbr: "chi",
      name: "chinese"
    }

    def fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@user_attrs)
        |> Accounts.create_user()

      {:ok, language} =
        attrs
        |> Enum.into(@language_attrs)
        |> Localization.create_language()

      attrs = %{user_id: user.id, language_id: language.id}

      {:ok, struct} =
        attrs
        |> Enum.into(attrs)
        |> Accounts.create_user_language()

      struct
    end

    test "list_user_language/0 returns all user_languages" do
      struct = fixture()
      assert Accounts.list_user_language() == [struct]
    end

    test "get_user_language!/1 returns the user_language with given id" do
      struct = fixture()
      assert Accounts.get_user_language!(struct.id) == struct
    end

    test "create_user_language/1 with valid data creates user_language" do
      assert {:ok, %User{} = user} = Accounts.create_user(@user_attrs)
      assert {:ok, %Language{} = language} =
        Localization.create_language(@language_attrs)

      attrs = %{user_id: user.id, language_id: language.id}

      assert {:ok, %UserLanguage{} = struct} = Accounts.create_user_language(attrs)
      assert struct.language_id == language.id
      assert struct.user_id     == user.id
    end

    test "create_user_language/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Accounts.create_user_language(@invalid_attrs)
    end

    test "update_user_language/2 with valid data updates the user_language" do
      struct = fixture()

      user_attrs = %{
        active: true,
        admin_role: true,
        avatar: "new text",
        bio: "new text",
        birthday: Timex.today,
        email: "kapranov.lugatex@gmail.com",
        first_name: "new text",
        init_setup: true,
        last_name: "new text",
        middle_name: "new text",
        password: "qwerty",
        password_confirmation: "qwerty",
        phone: "new text",
        pro_role: true,
        provider: "google",
        sex: "new text",
        ssn: 987654321,
        street: "new text",
        zip: 987654321
      }

      language_attrs = %{abbr: "fra", name: "french"}

      assert {:ok, %User{} = user} = Accounts.create_user(user_attrs)
      assert {:ok, %Language{} = language} =
        Localization.create_language(language_attrs)

      update_attrs = %{user_id: user.id, language_id: language.id}

      assert {:ok, %UserLanguage{} = struct} =
        Accounts.update_user_language(struct, update_attrs)
      assert struct.language_id == language.id
      assert struct.user_id     == user.id
    end

    test "update_user_language/2 with invalid data returns error changeset" do
      struct = fixture()
      assert {:error, %Ecto.Changeset{}} =
        Accounts.update_user_language(struct, @invalid_attrs)
      assert struct == Accounts.get_user_language!(struct.id)
    end

    test "delete_user_language/1 deletes the user_language" do
      struct = fixture()
      assert {:ok, %UserLanguage{}} = Accounts.delete_user_language(struct)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_language!(struct.id) end
    end

    test "change_user_language/1 returns user_language changeset" do
      struct = fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_language(struct)
    end
  end
end
