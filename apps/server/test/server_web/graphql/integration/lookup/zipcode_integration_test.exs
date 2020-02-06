defmodule ServerWeb.GraphQL.Integration.Lookup.ZipcodeIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#show" do
    it "returns specific UsZipcode by id" do
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

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showZipcode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showZipcode"]

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode

      {:ok, %{data: %{"showZipcode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode

    end

    it "returns not found when UsZipcode does not exist" do
      id =  Ecto.UUID.generate()

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

    it "returns error for missing params" do
    end
  end

  describe "#search" do
    it "search specific UsZipcode by number" do
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

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchZipcode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["searchZipcode"]

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode

      {:ok, %{data: %{"searchZipcode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]      == struct.id
      assert found["city"]    == struct.city
      assert found["state"]   == struct.state
      assert found["zipcode"] == struct.zipcode

    end

    it "returns nil when UsZipcode does not exist" do
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

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchZipcode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["searchZipcode"]

      assert found == nil

      {:ok, %{data: %{"searchZipcode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params" do
    end
  end
end
