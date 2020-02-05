defmodule ServerWeb.GraphQL.Integration.Services.PtinIntegrationTest do
  use ServerWeb.ConnCase

#  alias Server.AbsintheHelpers
#  alias ServerWeb.GraphQL.Schema

  describe "#create" do
    it "creates ptin" do
#      _mutation = """
#      {
#        createPtin(
#          expired: "Updated August 30, 2019",
#          url: "https://www.irs.gov/pub/irs-utl/foia_utah_extract.zip"
#        ) {
#          path
#        }
#      }
#      """
    end

    it "returns error for missing params" do
    end
  end

  describe "#search" do
    it "search profession by specific ptin" do
#      struct = insert(:ptin)
#
#      context = %{}
#
#      query = """
#      {
#        searchProfession(
#            bus_addr_zip: "84116",
#            bus_st_code: "UT",
#            first_name: "Jason",
#            last_name: "Broschinsky"
#          ) {
#          profession
#        }
#      }
#      """
#
#      res =
#        build_conn()
#        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchProfession"))
#
#      assert json_response(res, 200)["errors"] == nil
#
#      found = json_response(res, 200)["data"]["searchProfession"]
#
#      assert found["profession"] == struct.profession
#
#      {:ok, %{data: %{"searchProfession" => found}}} =
#        Absinthe.run(query, Schema, context: context)
#
#      assert found["profession"] == struct.profession
    end

    it "search profession by specific ptini when nil" do
#      struct = insert(:ptin)
#
#      context = %{}
#
#      query = """
#      {
#        searchProfession(
#            bus_addr_zip: "xxx",
#            bus_st_code: "xxx",
#            first_name: "xxx",
#            last_name: "xxx"
#          ) {
#          profession
#        }
#      }
#      """
#
#      res =
#        build_conn()
#        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "searchProfession"))
#
#      assert json_response(res, 200)["errors"] == nil
#
#      found = json_response(res, 200)["data"]["searchProfession"]
#
#      refute found["profession"] == struct.profession
#      assert found["profession"] == nil
#
#      {:ok, %{data: %{"searchProfession" => found}}} =
#        Absinthe.run(query, Schema, context: context)
#
#      refute found["profession"] == struct.profession
#      assert found["profession"] == nil
    end
  end

  describe "#delete" do
    it "delete all the ptins" do
#      insert(:ptin)
#
#      mutation = """
#      {
#        deletePtin{ptin}
#      }
#      """
#
#      res =
#        build_conn()
#        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))
#
#      assert json_response(res, 200)["errors"] == nil
#
#      deleted = json_response(res, 200)["data"]["deletePtin"]
#
#      assert deleted["ptin"] == "it has been deleted 1 records"
    end

    it "returns not found when the ptins does not exist" do
#      mutation = """
#      {
#        deletePtin{ptin}
#      }
#      """
#
#      res =
#        build_conn()
#        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))
#
#      assert json_response(res, 200)["errors"] == nil
#
#      deleted = json_response(res, 200)["data"]["deletePtin"]
#
#      assert deleted["ptin"] == "none records"
    end
  end

  describe "#delete_directory" do
    it "delete directory by timestamp" do
    end

    it "return nil delete directory by timestamp" do
#      time = Timex.today |> to_string
#      mutation = """
#      {
#        deleteDir(date: \"#{time}\"){path}
#      }
#      """
#
#      res =
#        build_conn()
#        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))
#
#      assert json_response(res, 200)["errors"] == nil
#
#      deleted = json_response(res, 200)["data"]["deleteDir"]
#
#      assert deleted["path"] == nil
    end
  end
end
