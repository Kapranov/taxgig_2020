defmodule ServerWeb.GraphQL.Resolvers.Landing.FaqCategoryResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Landing.FaqCategoryResolver

  describe "#list" do
    it "returns FaqCategories" do
      struct = insert(:faq_category)
      {:ok, data} = FaqCategoryResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id    == struct.id
      assert List.first(data).title == struct.title
    end
  end

  describe "#findFaqCategory" do
    it "found Faq with specific FaqCategory by id" do
      struct_a = insert(:faq_category)
      struct_b = insert(:faq, faq_categories: struct_a)
      {:ok, [found]} = FaqCategoryResolver.find_faq_category(nil, %{id: struct_a.id}, nil)
      assert found.id              == struct_b.id
      assert found.content         == struct_b.content
      assert found.title           == struct_b.title
      assert found.faq_category_id == struct_a.id
    end

    it "returns not found Faq with specific FaqCategory by id" do
      id = FlakeId.get()
      {:ok, found} = FaqCategoryResolver.find_faq_category(nil, %{id: id}, nil)
      assert found == []
    end

    it "returns error when nil FaqCategory by id" do
      id = nil
      {:ok, found} = FaqCategoryResolver.find_faq_category(nil, %{id: id}, nil)
      assert found == {:error, %Ecto.Changeset{}}
    end
  end

  describe "#show" do
    it "returns specific FaqCategory by id" do
      struct = insert(:faq_category)
      {:ok, found} = FaqCategoryResolver.show(nil, %{id: struct.id}, nil)
      assert found.id    == struct.id
      assert found.title == struct.title
    end

    it "returns not found when FaqCategory does not exist" do
      id = FlakeId.get()
      {:error, error} = FaqCategoryResolver.show(nil, %{id: id}, nil)
      assert error == "The Faq Category #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:faq_category)
      args = %{id: nil}
      {:error, error} = FaqCategoryResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates FaqCategory" do
      args = %{title: "some text"}
      {:ok, created} = FaqCategoryResolver.create(nil, args, nil)
      assert created.title == "some text"
    end

    it "returns error for missing params" do
      args = %{title: nil}
      {:error, error} = FaqCategoryResolver.create(nil, args, nil)
      assert error == [[field: :title, message: "Can't be blank"]]
    end
  end

  describe "#update" do
    it "update specific FaqCategory by id" do
      struct = insert(:faq_category)
      params = %{title: "updated text"}
      args = %{id: struct.id, faq_category: params}
      {:ok, updated} = FaqCategoryResolver.update(nil, args, nil)
      assert updated.id    == struct.id
      assert updated.title == "updated text"
    end

    it "nothing change for missing params" do
      struct = insert(:faq_category)
      params = %{}
      args = %{id: struct.id, faq_category: params}
      {:ok, updated} = FaqCategoryResolver.update(nil, args, nil)
      assert updated.id    == struct.id
      assert updated.title == struct.title
    end

    it "returns error for missing params" do
      insert(:faq_category)
      params = %{title: nil}
      args = %{id: nil, faq_category: params}
      {:error, error} = FaqCategoryResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific FaqCategory by id" do
      struct = insert(:faq_category)
      {:ok, deleted} = FaqCategoryResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when FaqCategory does not exist" do
      id = FlakeId.get()
      {:error, error} = FaqCategoryResolver.delete(nil, %{id: id}, nil)
      assert error == "The Faq Category #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:faq_category)
      args = %{id: nil}
      {:error, error} = FaqCategoryResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
