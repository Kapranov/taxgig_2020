defmodule Core.Landing.PressArticleTest do
  use Core.DataCase

  alias Core.Landing

  describe "press article" do
    alias Core.Landing.PressArticle

    @valid_attrs %{
      author: "some text",
      img_url: "some text",
      preview_text: "some text",
      title: "some text",
      url: "some text"
    }

    @update_attrs %{
      author: "updated text",
      img_url: "updated text",
      preview_text: "updated text",
      title: "updated text",
      url: "updated text"
    }

    @invalid_attrs %{
      author: nil,
      img_url: nil,
      preview_text: nil,
      title: nil,
      url: nil
    }

    test "list_press_article/0 returns all press articles" do
      struct = insert(:press_article)
      assert Landing.list_press_article() == [struct]
    end

    test "get_press_article!/1 returns the press article with given id" do
      struct = insert(:press_article)
      assert Landing.get_press_article!(struct.id) == struct
    end

    test "create_press_article/1 with valid data creates a press article" do
      assert {:ok, %PressArticle{} = struct} =
        Landing.create_press_article(@valid_attrs)
      assert struct.author       == "some text"
      assert struct.img_url      == "some text"
      assert struct.preview_text == "some text"
      assert struct.title        == "some text"
      assert struct.url          == "some text"
    end

    test "create_press_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
        Landing.create_press_article(@invalid_attrs)
    end

    test "update_press_article/2 with valid data updates the press article" do
      struct = insert(:press_article)
      assert {:ok, %PressArticle{} = struct} =
        Landing.update_press_article(struct, @update_attrs)
      assert struct.author       == "updated text"
      assert struct.img_url      == "updated text"
      assert struct.preview_text == "updated text"
      assert struct.title        == "updated text"
      assert struct.url          == "updated text"
    end

    test "update_press_article/2 with invalid data returns error changeset" do
      struct = insert(:press_article)
      assert {:error, %Ecto.Changeset{}} =
        Landing.update_press_article(struct, @invalid_attrs)
      assert struct == Landing.get_press_article!(struct.id)
    end

    test "delete_press_article/1 deletes the press article" do
      struct = insert(:press_article)
      assert {:ok, %PressArticle{}} = Landing.delete_press_article(struct)
      assert_raise Ecto.NoResultsError, fn -> Landing.get_press_article!(struct.id) end 
    end

    test "change_press_article/1 returns a press article changeset" do
      struct = insert(:press_article)
      assert %Ecto.Changeset{} = Landing.change_press_article(struct)
    end
  end
end
