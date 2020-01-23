defmodule ServerWeb.GraphQL.Resolvers.Landing.FaqResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Landing.FaqResolver

  describe "#list" do
    it "returns Faq" do
      struct = insert(:faq)
      {:ok, data} = FaqResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id              == struct.id
      assert List.first(data).content         == struct.content
      assert List.first(data).faq_category_id == struct.faq_category_id
      assert List.first(data).title           == struct.title
    end
  end

  describe "#show" do
    it "returns specific Faq by id" do
      struct = insert(:faq)
      {:ok, found} = FaqResolver.show(nil, %{id: struct.id}, nil)
      assert found.id              == struct.id
      assert found.content         == struct.content
      assert found.faq_category_id == struct.faq_category_id
      assert found.title           == struct.title
    end

    it "returns not found when Faq does not exist" do
      insert(:faq_category)
      id = Ecto.UUID.generate
      {:error, error} = FaqResolver.show(nil, %{id: id}, nil)
      assert error == "The Faq #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:faq)
      args = %{id: nil}
      {:error, error} = FaqResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates Faq" do
      %{id: id} = insert(:faq_category)
      args = %{content: "some text", title: "some text", faq_category_id: id}
      {:ok, created} = FaqResolver.create(nil, args, nil)
      assert created.content         == "some text"
      assert created.faq_category_id == id
      assert created.title           == "some text"
    end

    it "returns error for missing params" do
      args = %{content: nil, title: nil, faq_category_id: nil}
      {:error, error} = FaqResolver.create(nil, args, nil)
      assert error == [
        [field: :content, message: "Can't be blank"],
        [field: :faq_category_id, message: "Can't be blank"],
        [field: :title, message: "Can't be blank"]
      ]
    end
  end

  describe "#update" do
    it "update specific Faq by id" do
      %{id: new} = insert(:faq_category)
      struct = insert(:faq)
      params = %{content: "updated text", title: "updated text", faq_category_id: new}
      args = %{id: struct.id, faq: params}
      {:ok, updated} = FaqResolver.update(nil, args, nil)
      assert updated.id              == struct.id
      assert updated.content         == "updated text"
      assert updated.faq_category_id == new
      assert updated.title           == "updated text"
    end

    it "nothing change for missing params" do
      struct = insert(:faq)
      params = %{}
      args = %{id: struct.id, faq: params}
      {:ok, updated} = FaqResolver.update(nil, args, nil)
      assert updated.id              == struct.id
      assert updated.content         == struct.content
      assert updated.faq_category_id == struct.faq_category_id
      assert updated.title           == struct.title
    end

    it "returns error for missing params" do
      insert(:faq)
      params = %{content: nil, title: nil, faq_category_id: nil}
      args = %{id: nil, faq: params}
      {:error, error} = FaqResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific Faq by id" do
      struct = insert(:faq)
      {:ok, deleted} = FaqResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when Faq does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = FaqResolver.delete(nil, %{id: id}, nil)
      assert error == "The Faq #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:faq)
      args = %{id: nil}
      {:error, error} = FaqResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
