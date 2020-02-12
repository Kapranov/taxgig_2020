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
      faq_category_id: nil,
      title: nil
    }

    test "list_faq/0 returns all faq" do
      struct = insert(:faq)
      data =
        Landing.list_faq()
        |> Repo.preload([:faq_categories])
      assert data == [struct]
    end

    test "get_faq!/1 returns the faq with given id" do
      struct = insert(:faq)
      data =
        Landing.get_faq!(struct.id)
        |> Repo.preload([:faq_categories])
      assert data == struct
    end

    test "search_title/1 1 returns the faqs with given title" do
      struct = insert(:faq)
      word = struct.title
      data =
        Landing.search_title(word)
        |> Repo.preload([:faq_categories])
      assert data == [struct]
    end

    test "create_faq/1 with valid data creates a faq" do
      struct = insert(:faq_category)
      params = Map.merge(@valid_attrs, %{faq_category_id: struct.id})

      assert {:ok, %Faq{} = created} = Landing.create_faq(params)
      assert created.content         == "some text"
      assert created.title           == "some text"
      assert created.faq_category_id == struct.id
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Landing.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq)

      params = Map.merge(@update_attrs, %{faq_category_id: struct_a.id})

      assert {:ok, %Faq{} = updated} = Landing.update_faq(struct_b, params)
      assert updated.content         == "updated text"
      assert updated.title           == "updated text"
      assert updated.faq_category_id == struct_a.id
    end

    test "update_faq/2 with invalid data returns error changeset" do
      struct = insert(:faq)
      data =
        Landing.get_faq!(struct.id)
        |> Repo.preload([:faq_categories])
      assert {:error, %Ecto.Changeset{}} = Landing.update_faq(struct, @invalid_attrs)
      assert data == struct
    end

    test "delete_faq/1 deletes the faq" do
      struct = insert(:faq)
      assert {:ok, %Faq{}} = Landing.delete_faq(struct)
      assert_raise Ecto.NoResultsError, fn -> Landing.get_faq!(struct.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      struct = insert(:faq)
      assert %Ecto.Changeset{} = Landing.change_faq(struct)
    end
  end
end
