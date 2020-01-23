defmodule Core.Landing.FaqTest do
  use Core.DataCase

  alias Core.Landing

  describe "faq" do
    alias Core.Landing.Faq

    @valid_attrs %{
      content: "some text",
      title: "some text"
    }

    @update_attrs %{
      content: "updated text",
      title: "updated text"
    }

    @invalid_attrs %{
      content: nil,
      title: nil
    }

    def fixture(attrs \\ %{}) do
      valid_attrs = %{title: "some text"}

      {:ok, faq_category} =
        attrs
        |> Enum.into(valid_attrs)
        |> Landing.create_faq_category()

      params = Map.merge(@valid_attrs, %{faq_category_id: faq_category.id})

      {:ok, struct} =
        attrs
        |> Enum.into(params)
        |> Landing.create_faq()

      struct
    end

    test "list_faq/0 returns all faq" do
      struct = fixture()
      assert Landing.list_faq() == [struct]
    end

    test "get_faq!/1 returns the faq with given id" do
      struct = fixture()
      assert Landing.get_faq!(struct.id) == struct
    end

    test "create_faq/1 with valid data creates a faq" do
      {:ok, faq_category} =
        Landing.create_faq_category(%{title: "some text"})

      params = Map.merge(@valid_attrs, %{faq_category_id: faq_category.id})

      assert {:ok, %Faq{} = struct} = Landing.create_faq(params)
      assert struct.content         == "some text"
      assert struct.title           == "some text"
      assert struct.faq_category_id == faq_category.id
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Landing.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      {:ok, %{id: faq_category}} =
        Landing.create_faq_category(%{title: "new text"})

      params = Map.merge(@update_attrs, %{faq_category_id: faq_category})

      struct = fixture()
      assert {:ok, %Faq{} = struct} = Landing.update_faq(struct, params)
      assert struct.content         == "updated text"
      assert struct.title           == "updated text"
      assert struct.faq_category_id == faq_category
    end

    test "update_faq/2 with invalid data returns error changeset" do
      struct = fixture()
      assert {:error, %Ecto.Changeset{}} =
        Landing.update_faq(struct, @invalid_attrs)
      assert struct == Landing.get_faq!(struct.id)
    end

    test "delete_faq/1 deletes the faq" do
      struct = fixture()
      assert {:ok, %Faq{}} = Landing.delete_faq(struct)
      assert_raise Ecto.NoResultsError, fn -> Landing.get_faq!(struct.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      struct = fixture()
      assert %Ecto.Changeset{} = Landing.change_faq(struct)
    end
  end
end
