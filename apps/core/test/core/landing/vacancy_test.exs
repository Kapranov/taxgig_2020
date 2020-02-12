defmodule Core.Landing.VacancyTest do
  use Core.DataCase

  alias Core.Landing

  describe "vacancy" do
    alias Core.Landing.Vacancy

    @valid_attrs %{
      content: "some text",
      department: "some text",
      title: "some text",
    }

    @update_attrs %{
      content: "updated text",
      department: "updated text",
      title: "updated text"
    }

    @invalid_attrs %{
      content: nil,
      department: nil,
      title: nil
    }

    test "list_vacancy/0 returns all vacancies" do
      struct = insert(:vacancy)
      assert Landing.list_vacancy() == [struct]
    end

    test "get_vacancy!/1 returns the vacancy with given id" do
      struct = insert(:vacancy)
      assert Landing.get_vacancy!(struct.id) == struct
    end

    test "create_vacancy/1 with valid data creates a vacancy" do
      assert {:ok, %Vacancy{} = struct} = Landing.create_vacancy(@valid_attrs)
      assert struct.content    == "some text"
      assert struct.department == "some text"
      assert struct.title      == "some text"
    end

    test "create_vacancy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Landing.create_vacancy(@invalid_attrs)
    end

    test "update_vacancy/2 with valid data updates the vacancy" do
      struct = insert(:vacancy)
      assert {:ok, %Vacancy{} = struct} =
        Landing.update_vacancy(struct, @update_attrs)
      assert struct.content    == "updated text"
      assert struct.department == "updated text"
      assert struct.title      == "updated text"
    end

    test "update_vacancy/2 with invalid data returns error changeset" do
      struct = insert(:vacancy)
      assert {:error, %Ecto.Changeset{}} =
        Landing.update_vacancy(struct, @invalid_attrs)
      assert struct == Landing.get_vacancy!(struct.id)
    end

    test "delete_vacancy/1 deletes the vacancy" do
      struct = insert(:vacancy)
      assert {:ok, %Vacancy{}} = Landing.delete_vacancy(struct)
      assert_raise Ecto.NoResultsError, fn -> Landing.get_vacancy!(struct.id) end
    end

    test "change_vacancy/1 returns a vacancy changeset" do
      struct = insert(:vacancy)
      assert %Ecto.Changeset{} = Landing.change_vacancy(struct)
    end
  end
end
