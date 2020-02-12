defmodule Core.Landing.FaqCategoryTest do
  use Core.DataCase

  alias Core.Landing

  describe "faq_category" do
    alias Core.Landing.FaqCategory

    @valid_attrs %{title: "some text"}
    @update_attrs %{title: "updated text"}
    @invalid_attrs %{title: nil}

    test "list_faq_category/0 returns all faq categories and faqs join" do
      struct = insert(:faq_category)
      assert Landing.list_faq_category() == [struct]
    end

    test "get_faq_category!/1 returns the faq category with given id" do
      struct = insert(:faq_category)
      assert Landing.get_faq_category!(struct.id) == struct
    end

    test "create_faq_category/1 with valid data creates a faq category" do
      assert {:ok, %FaqCategory{} = struct} =
        Landing.create_faq_category(@valid_attrs)
      assert struct.title == "some text"
    end

    test "create_faq_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Landing.create_faq_category(@invalid_attrs)
    end

    test "update_faq_category/2 with valid data updates the faq category" do
      struct = insert(:faq_category)
      assert {:ok, %FaqCategory{} = struct} =
        Landing.update_faq_category(struct, @update_attrs)
      assert struct.title == "updated text"
    end

    test "update_faq_category/2 with invalid data returns error changeset" do
      struct = insert(:faq_category)
      assert {:error, %Ecto.Changeset{}} = Landing.update_faq_category(struct, @invalid_attrs)
      assert struct == Landing.get_faq_category!(struct.id)
    end

    test "delete_faq_category/1 deletes the faq category" do
      struct = insert(:faq_category)
      assert {:ok, %FaqCategory{}} = Landing.delete_faq_category(struct)
      assert_raise Ecto.NoResultsError, fn -> Landing.get_faq_category!(struct.id) end
    end

    test "change_faq_category/1 returns a faq category changeset" do
      struct = insert(:faq_category)
      assert %Ecto.Changeset{} = Landing.change_faq_category(struct)
    end
  end
end
