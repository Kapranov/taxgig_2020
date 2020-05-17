defmodule ServerWeb.GraphQL.Integration.Lookup.UsZipcodeIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#show" do
    it "returns specific UsZipcode by id - `AbsintheHelpers`" do
      struct = insert(:zipcode)

      query = """
      {
        showZipcode(id: \"#{struct.id}\") {
          id
          city
          state
          zipcode
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showZipcode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showZipcode"]

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode
    end

    it "returns specific UsZipcode by id - `Absinthe.run`" do
      struct = insert(:zipcode)

      context = %{}

      query = """
      {
        showZipcode(id: \"#{struct.id}\") {
          id
          city
          state
          zipcode
        }
      }
      """

      {:ok, %{data: %{"showZipcode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode

    end

    it "returns not found when UsZipcode does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showZipcode(id: \"#{id}\") {
          id
          city
          state
          zipcode
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showZipcode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The UsZipcode #{id} not found!"
    end

    it "returns not found when UsZipcode does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        showZipcode(id: \"#{id}\") {
          id
          city
          state
          zipcode
        }
      }
      """

      {:ok, %{data: %{"showZipcode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"] == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showZipcode(id: nil) {
          id
          city
          state
          zipcode
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showZipcode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        showZipcode(id: nil) {
          id
          city
          state
          zipcode
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#search" do
    it "search specific UsZipcode by number - `AbsintheHelpers`" do
      struct = insert(:zipcode)
      number = 602

      query = """
      {
        searchZipcode(zipcode: #{number}) {
          id
          city
          state
          zipcode
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchZipcode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["searchZipcode"]

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode
    end

    it "search specific UsZipcode by number - `Absinthe.run`" do
      struct = insert(:zipcode)
      number = 602

      context = %{}

      query = """
      {
        searchZipcode(zipcode: #{number}) {
          id
          city
          state
          zipcode
        }
      }
      """

      {:ok, %{data: %{"searchZipcode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode
    end

    it "returns nil when UsZipcode does not exist - `AbsintheHelpers`" do
      number = 600

      query = """
      {
        searchZipcode(zipcode: #{number}) {
          id
          city
          state
          zipcode
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchZipcode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["searchZipcode"]

      assert found == nil
    end

    it "returns nil when UsZipcode does not exist - `Absinthe.run`" do
      number = 600

      context = %{}

      query = """
      {
        searchZipcode(zipcode: #{number}) {
          id
          city
          state
          zipcode
        }
      }
      """

      {:ok, %{data: %{"searchZipcode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        searchZipcode(zipcode: nil) {
          id
          city
          state
          zipcode
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchZipcode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"zipcode\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      {
        searchZipcode(zipcode: nil) {
          id
          city
          state
          zipcode
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"zipcode\" has invalid value nil."
    end
  end
end
