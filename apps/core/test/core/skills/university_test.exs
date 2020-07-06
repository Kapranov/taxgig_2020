defmodule Core.Skills.UniversityTest do
  use Core.DataCase

  alias Core.Skills

  describe "university" do
    alias Core.Skills.University

    @valid_attrs %{name: "some text"}
    @update_attrs %{name: "updated text"}
    @invalid_attrs %{name: nil}

    test "list_university/0 returns all the universities" do
      struct = insert(:university)
      assert Skills.list_university() == [struct]
    end

    test "get_university!/1 returns the university with given id" do
      struct = insert(:university)
      assert Skills.get_university!(struct.id) == struct
    end

    test "create_university/1 with valid data creates the university" do
      assert {:ok, %University{} = struct} = Skills.create_university(@valid_attrs)
      assert struct.name == "some text"
    end

    test "create_university/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Skills.create_university(@invalid_attrs)
    end
  end
end
