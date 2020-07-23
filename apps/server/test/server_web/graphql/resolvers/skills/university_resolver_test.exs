defmodule ServerWeb.GraphQL.Resolvers.Skills.UniversityResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Skills.UniversityResolver

  describe "#index" do
    it "returns University" do
      struct = insert(:university)
      {:ok, data} = UniversityResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id   == struct.id
      assert List.first(data).name == struct.name
    end
  end

  describe "#show" do
    it "returns specific University by id" do
      struct = insert(:university)
      {:ok, found} = UniversityResolver.show(nil, %{id: struct.id}, nil)

      assert found.id   == struct.id
      assert found.name == struct.name
    end

    it "returns error University does not exist" do
      id = FlakeId.get()
      insert(:university)
      {:error, error} = UniversityResolver.show(nil, %{id: id}, nil)
      assert error == "The University #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:university)
      args = %{id: nil}
      {:error, error} = UniversityResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates University" do
      args = %{name: "some text"}
      {:ok, created} = UniversityResolver.create(nil, args, nil)
      assert created.name == args.name
    end

    it "returns error for missing params" do
      args = %{name: nil}
      {:error, error} = UniversityResolver.create(nil, args, nil)
      assert error == [[field: :name, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific University by id" do
      struct = insert(:university)
      {:ok, deleted} = UniversityResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when University does not exist" do
      id = FlakeId.get()
      insert(:university)
      {:error, error} = UniversityResolver.delete(nil, %{id: id}, nil)
      assert error == "The University #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:university)
      args = %{id: nil}
      {:error, error} = UniversityResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
