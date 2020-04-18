defmodule ServerWeb.GraphQL.Resolvers.Localization.LanguageResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Localization.LanguageResolver

  describe "#list" do
    it "returns Languages" do
      struct = insert(:language)
      {:ok, data} = LanguageResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id   == struct.id
      assert List.first(data).abbr == struct.abbr
      assert List.first(data).name == struct.name
    end
  end

  describe "#show" do
    it "returns specific Language by id" do
      struct = insert(:language)
      {:ok, found} = LanguageResolver.show(nil, %{id: struct.id}, nil)
      assert found.id   == struct.id
      assert found.abbr == struct.abbr
      assert found.name == struct.name
    end

    it "returns not found when Language does not exist" do
      id = FlakeId.get()
      {:error, error} = LanguageResolver.show(nil, %{id: id}, nil)
      assert error == "The Language #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:language)
      args = %{id: nil}
      {:error, error} = LanguageResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates Language" do
      args = %{
        abbr: "some text",
        name: "some text"
      }
      {:ok, created} = LanguageResolver.create(nil, args, nil)
      assert created.abbr == "some text"
      assert created.name == "some text"
    end

    it "returns error for missing params" do
      args = %{abbr: nil, name: nil}
      {:error, error} = LanguageResolver.create(nil, args, nil)
      assert error == [
        [field: :abbr, message: "Can't be blank"],
        [field: :name, message: "Can't be blank"]
      ]
    end
  end

  describe "#update" do
    it "update specific Language by id" do
      struct = insert(:language)
      params = %{
        abbr: "updated text",
        name: "updated text"
      }
      args = %{id: struct.id, language: params}
      {:ok, updated} = LanguageResolver.update(nil, args, nil)
      assert updated.id   == struct.id
      assert updated.abbr == "updated text"
      assert updated.name == "updated text"
    end

    it "nothing change for missing params" do
      struct = insert(:language)
      params = %{}
      args = %{id: struct.id, language: params}
      {:ok, updated} = LanguageResolver.update(nil, args, nil)
      assert updated.id   == struct.id
      assert updated.abbr == struct.abbr
      assert updated.name == struct.name
    end

    it "returns error for missing params" do
      insert(:language)
      params = %{abbr: nil, name: nil}
      args = %{id: nil, language: params}
      {:error, error} = LanguageResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific Language by id" do
      struct = insert(:language)
      {:ok, deleted} = LanguageResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when Language does not exist" do
      id = FlakeId.get()
      {:error, error} = LanguageResolver.delete(nil, %{id: id}, nil)
      assert error == "The Language #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:language)
      args = %{id: nil}
      {:error, error} = LanguageResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
