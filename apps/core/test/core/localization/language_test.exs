defmodule Core.Localization.LanguageTest do
  use Core.DataCase

  alias Core.Localization

  describe "language" do
    alias Core.Localization.Language

    @valid_attrs %{
      abbr: "some text",
      name: "some text",
    }

    @update_attrs %{
      abbr: "updated text",
      name: "updated text"
    }

    @invalid_attrs %{
      abbr: nil,
      name: nil
    }

    def fixture(attrs \\ %{}) do
      {:ok, struct} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Localization.create_language()

      struct
    end

    test "list_language/0 returns all languages" do
      struct = fixture()
      assert Localization.list_language() == [struct]
    end

    test "get_language!/1 returns the language with given id" do
      struct = fixture()
      assert Localization.get_language!(struct.id) == struct
    end

    test "create_language/1 with valid data creates language" do
      assert {:ok, %Language{} = struct} = Localization.create_language(@valid_attrs)
      assert struct.abbr == "some text"
      assert struct.name == "some text"
    end

    test "create_language/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Localization.create_language(@invalid_attrs)
    end

    test "update_language/2 with valid data updates the language" do
      struct = fixture()
      assert {:ok, %Language{} = struct} =
        Localization.update_language(struct, @update_attrs)
      assert struct.abbr == "updated text"
      assert struct.name == "updated text"
    end

    test "update_language/2 with invalid data returns error changeset" do
      struct = fixture()
      assert {:error, %Ecto.Changeset{}} =
        Localization.update_language(struct, @invalid_attrs)
      assert struct == Localization.get_language!(struct.id)
    end

    test "delete_language/1 deletes the language" do
      struct = fixture()
      assert {:ok, %Language{}} = Localization.delete_language(struct)
      assert_raise Ecto.NoResultsError, fn -> Localization.get_language!(struct.id) end
    end

    test "change_language/1 returns language changeset" do
      struct = fixture()
      assert %Ecto.Changeset{} = Localization.change_language(struct)
    end
  end
end
