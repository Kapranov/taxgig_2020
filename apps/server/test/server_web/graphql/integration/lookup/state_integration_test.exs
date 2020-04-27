defmodule ServerWeb.GraphQL.Integration.Lookup.StateIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns the States" do
      state1 = insert(:state)
      state2 = insert(:state)

      context = %{}

      query = """
      {
        allStates {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"allStates" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)
      assert first["id"]   == state1.id
      assert first["abbr"] == state1.abbr
      assert first["name"] == state1.name

      [second] = tl(data)
      assert second["id"]   == state2.id
      assert second["abbr"] == state2.abbr
      assert second["name"] == state2.name

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allStates"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allStates"]

      assert List.first(data)["id"]   == to_string(state1.id)
      assert List.first(data)["abbr"] == to_string(state1.abbr)
      assert List.first(data)["name"] == to_string(state1.name)

      assert List.last(data)["id"]    == to_string(state2.id)
      assert List.last(data)["abbr"]  == to_string(state2.abbr)
      assert List.last(data)["name"]  == to_string(state2.name)
    end
  end

  describe "#show" do
    it "returns specific the State" do
      state = insert(:state)

      context = %{}

      query = """
      {
        showState(id: \"#{state.id}\") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"showState" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]    == state.id
      assert found["abbr"]  == state.abbr
      assert found["name"]  == state.name

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showState"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showState"]
      assert found["id"]   == to_string(state.id)
      assert found["abbr"] == to_string(state.abbr)
      assert found["name"] == to_string(state.name)
    end
  end

  describe "#find" do
    it "find specific the State" do
      state = insert(:state)

      context = %{}

      query = """
      {
        findState(id: \"#{state.id}\") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"findState" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]    == state.id
      assert found["abbr"]  == state.abbr
      assert found["name"]  == state.name

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findState"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findState"]
      assert found["id"]   == to_string(state.id)
      assert found["abbr"] == to_string(state.abbr)
      assert found["name"] == to_string(state.name)
    end
  end

  describe "#search" do
    it "search specific abbr the State" do
      insert(:state)
      state = insert(:state, abbr: "TX")
      insert(:state, abbr: "CA")

      context = %{}

      query = """
      {
        searchStateAbbr(searchTerm: "TX") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"searchStateAbbr" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]    == state.id
      assert found["abbr"]  == "TX"
      assert found["name"]  == state.name

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchStateAbbr"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["searchStateAbbr"]
      assert length(found)              == 1
      assert List.first(found)["id"]    == to_string(state.id)
      assert List.first(found)["abbr"]  == "TX"
      assert List.first(found)["name"]  == to_string(state.name)
    end

    it "search specific name the State" do
      insert(:state)
      state = insert(:state, name: "Colorado")
      insert(:state, name: "Columbia")

      context = %{}

      query = """
      {
        searchStateName(searchTerm: "Colorado") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"searchStateName" => [found]}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]    == state.id
      assert found["abbr"]  == state.abbr
      assert found["name"]  == "Colorado"

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchStateName"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["searchStateName"]

      assert length(found)              == 1
      assert List.first(found)["id"]    == to_string(state.id)
      assert List.first(found)["abbr"]  == to_string(state.abbr)
      assert List.first(found)["name"]  == "Colorado"
    end

    it "returns empty none matching Abbr" do
      insert(:state)

      context = %{}

      query = """
      {
        searchStateAbbr(searchTerm: "CA") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"searchStateAbbr" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == []

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchStateAbbr"))

      found = json_response(res, 200)["data"]["searchStateAbbr"]
      assert length(found) == 0
      assert found         == []
    end

    it "returns empty none matching Name" do
      insert(:state)

      context = %{}

      query = """
      {
        searchStateName(searchTerm: "Colorado") {
          id
          abbr
          name
        }
      }
      """

      {:ok, %{data: %{"searchStateName" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == []

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchStateName"))

      found = json_response(res, 200)["data"]["searchStateName"]
      assert length(found) == 0
      assert found         == []
    end
  end
end
