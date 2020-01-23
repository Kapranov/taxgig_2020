defmodule ServerWeb.GraphQL.Resolvers.Landing.PressArticleResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Landing.PressArticleResolver

  describe "#list" do
    it "returns PressArticles" do
      struct = insert(:press_article)
      {:ok, data} = PressArticleResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id           == struct.id
      assert List.first(data).author       == struct.author
      assert List.first(data).preview_text == struct.preview_text
      assert List.first(data).title        == struct.title
      assert List.first(data).url          == struct.url
    end
  end

  describe "#show" do
    it "returns specific PressArticle by id" do
      struct = insert(:press_article)
      {:ok, found} = PressArticleResolver.show(nil, %{id: struct.id}, nil)
      assert found.id           == struct.id
      assert found.author       == struct.author
      assert found.preview_text == struct.preview_text
      assert found.title        == struct.title
      assert found.url          == struct.url
    end

    it "returns not found when PressArticle does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = PressArticleResolver.show(nil, %{id: id}, nil)
      assert error == "The Press Article #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:press_article)
      args = %{id: nil}
      {:error, error} = PressArticleResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates PressArticle" do
      args = %{
        author: "some text",
        preview_text: "some text",
        title: "some text",
        url: "some text"
      }
      {:ok, created} = PressArticleResolver.create(nil, args, nil)
      assert created.author       == "some text"
      assert created.preview_text == "some text"
      assert created.title        == "some text"
      assert created.url          == "some text"
    end

    it "returns error for missing params" do
      args = %{author: nil, preview_text: nil, title: nil, url: nil}
      {:error, error} = PressArticleResolver.create(nil, args, nil)
      assert error == [
        [field: :author, message: "Can't be blank"],
        [field: :preview_text, message: "Can't be blank"],
        [field: :title, message: "Can't be blank"],
        [field: :url, message: "Can't be blank"]
      ]
    end
  end

  describe "#update" do
    it "update specific PressArticle by id" do
      struct = insert(:press_article)
      params = %{
        author: "updated text",
        preview_text: "updated text",
        title: "updated text",
        url: "updated text"
      }
      args = %{id: struct.id, press_article: params}
      {:ok, updated} = PressArticleResolver.update(nil, args, nil)
      assert updated.id           == struct.id
      assert updated.author       == "updated text"
      assert updated.preview_text == "updated text"
      assert updated.title        == "updated text"
      assert updated.url          == "updated text"
    end

    it "nothing change for missing params" do
      struct = insert(:press_article)
      params = %{}
      args = %{id: struct.id, press_article: params}
      {:ok, updated} = PressArticleResolver.update(nil, args, nil)
      assert updated.id           == struct.id
      assert updated.author       == struct.author
      assert updated.preview_text == struct.preview_text
      assert updated.title        == struct.title
      assert updated.url          == struct.url
    end

    it "returns error for missing params" do
      insert(:press_article)
      params = %{author: nil, preview_text: nil, title: nil, url: nil}
      args = %{id: nil, press_article: params}
      {:error, error} = PressArticleResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific PressArticle by id" do
      struct = insert(:press_article)
      {:ok, deleted} = PressArticleResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when PressArticle does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = PressArticleResolver.delete(nil, %{id: id}, nil)
      assert error == "The Press Article #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:press_article)
      args = %{id: nil}
      {:error, error} = PressArticleResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
