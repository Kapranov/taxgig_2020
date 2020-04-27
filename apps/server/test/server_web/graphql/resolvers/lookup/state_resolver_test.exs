defmodule ServerWeb.GraphQL.Resolvers.Lookup.StateResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Lookup.StateResolver

  describe "#index" do
    it "returns States" do
      state = insert(:state)
      {:ok, data} = StateResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id   == state.id
      assert List.first(data).abbr == state.abbr
      assert List.first(data).name == state.name
      assert List.last(data).id    == state.id
      assert List.last(data).abbr  == state.abbr
      assert List.last(data).name  == state.name
    end
  end

  describe "#show" do
    it "returns specific State by id" do
      state = insert(:state)
      {:ok, found} = StateResolver.show(nil, %{id: state.id}, nil)
      assert found.id   == state.id
      assert found.abbr == state.abbr
      assert found.name == state.name
    end

    it "returns not found when State does not exist" do
      id = FlakeId.get()
      {:error, error} = StateResolver.show(nil, %{id: id}, nil)
      assert error == "The State #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:state)
      args = %{id: nil}
      {:error, error} = StateResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#find" do
    it "find specific State by id" do
      state = insert(:state)
      {:ok, found} = StateResolver.find(nil, %{id: state.id}, nil)
      assert found.id   == state.id
      assert found.abbr == state.abbr
      assert found.name == state.name
    end

    it "returns not found when the State does not exist" do
      id = FlakeId.get()
      {:error, error} = StateResolver.find(nil, %{id: id}, nil)
      assert error == "The State #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:state)
      args = %{id: nil}
      {:error, error} = StateResolver.find(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#search" do
    it "search specific State by keywords of abbr" do
      state = insert(:state, abbr: "TN")
      searching = "TN"
      {:ok, [searched]} = StateResolver.search_abbr(nil, %{search_term: searching}, nil)
      assert searched.id   == state.id
      assert searched.abbr == "TN"
      assert searched.name == state.name
    end

    it "search specific State by keyword of name" do
      state = insert(:state, name: "Tennessee")
      searching = "Tennessee"
      {:ok, [searched]} = StateResolver.search_name(nil, %{search_term: searching}, nil)
      assert searched.id   == state.id
      assert searched.abbr == state.abbr
      assert searched.name == "Tennessee"
    end
  end
end
