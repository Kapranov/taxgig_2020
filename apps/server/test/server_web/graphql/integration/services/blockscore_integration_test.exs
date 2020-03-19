defmodule ServerWeb.GraphQL.Integration.Services.BlockscoreIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  @opts [
    address_city: "Cupertino",
    address_country_code: "US",
    address_postal_code: "95014",
    address_street1: "1 Infinite Loop",
    address_street2: "Apt 6",
    address_subdivision: "CA",
    birth_day: 23,
    birth_month: 8,
    birth_year: 1993,
    document_type: "ssn",
    document_value: "0000",
    name_first: "John",
    name_last: "Doe",
    name_middle: "Pearce"
  ]

  describe "#get_status" do
    it "returns correct status - `AbsintheHelpers`" do
      query = """
      {
        getStatusBlockscore(
            address_city: \"#{Keyword.get(@opts, :address_city)}\",
            address_country_code: \"#{Keyword.get(@opts, :address_country_code)}\",
            address_postal_code: \"#{Keyword.get(@opts, :address_postal_code)}\",
            address_street1: \"#{Keyword.get(@opts, :address_street1)}\",
            address_street2: \"#{Keyword.get(@opts, :address_street2)}\",
            address_subdivision: \"#{Keyword.get(@opts, :address_subdivision)}\",
            birth_day: #{Keyword.get(@opts, :birth_day)},
            birth_month: #{Keyword.get(@opts, :birth_month)},
            birth_year: #{Keyword.get(@opts, :birth_year)},
            document_type: \"#{Keyword.get(@opts, :document_type)}\",
            document_value: \"#{Keyword.get(@opts, :document_value)}\",
            name_first: \"#{Keyword.get(@opts, :name_first)}\",
            name_last: \"#{Keyword.get(@opts, :name_last)}\",
            name_middle: \"#{Keyword.get(@opts, :name_middle)}\"
          ) {
            status
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getStatusBlockscore"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["getStatusBlockscore"]

      assert data["status"] == "valid"
    end

    it "returns correct status - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getStatusBlockscore(
            address_city: \"#{Keyword.get(@opts, :address_city)}\",
            address_country_code: \"#{Keyword.get(@opts, :address_country_code)}\",
            address_postal_code: \"#{Keyword.get(@opts, :address_postal_code)}\",
            address_street1: \"#{Keyword.get(@opts, :address_street1)}\",
            address_street2: \"#{Keyword.get(@opts, :address_street2)}\",
            address_subdivision: \"#{Keyword.get(@opts, :address_subdivision)}\",
            birth_day: #{Keyword.get(@opts, :birth_day)},
            birth_month: #{Keyword.get(@opts, :birth_month)},
            birth_year: #{Keyword.get(@opts, :birth_year)},
            document_type: \"#{Keyword.get(@opts, :document_type)}\",
            document_value: \"#{Keyword.get(@opts, :document_value)}\",
            name_first: \"#{Keyword.get(@opts, :name_first)}\",
            name_last: \"#{Keyword.get(@opts, :name_last)}\",
            name_middle: \"#{Keyword.get(@opts, :name_middle)}\"
          ) {
            status
        }
      }
      """

      {:ok, %{data: %{"getStatusBlockscore" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["status"] == "valid"
    end

    it "returns incorrect status - `AbsintheHelpers`" do
      query = """
      {
        getStatusBlockscore(
            address_city: \"#{Keyword.get(@opts, :address_city)}\",
            address_country_code: \"#{Keyword.get(@opts, :address_country_code)}\",
            address_postal_code: \"#{Keyword.get(@opts, :address_postal_code)}\",
            address_street1: \"#{Keyword.get(@opts, :address_street1)}\",
            address_street2: \"#{Keyword.get(@opts, :address_street2)}\",
            address_subdivision: \"#{Keyword.get(@opts, :address_subdivision)}\",
            birth_day: #{Keyword.get(@opts, :birth_day)},
            birth_month: #{Keyword.get(@opts, :birth_month)},
            birth_year: #{Keyword.get(@opts, :birth_year)},
            document_type: \"#{Keyword.get(@opts, :document_type)}\",
            document_value: \"1111\",
            name_first: \"#{Keyword.get(@opts, :name_first)}\",
            name_last: \"#{Keyword.get(@opts, :name_last)}\",
            name_middle: \"#{Keyword.get(@opts, :name_middle)}\"
          ) {
            status
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getStatusBlockscore"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["getStatusBlockscore"]

      assert data["status"] == "invalid"
    end

    it "returns incorrect status - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getStatusBlockscore(
            address_city: \"#{Keyword.get(@opts, :address_city)}\",
            address_country_code: \"#{Keyword.get(@opts, :address_country_code)}\",
            address_postal_code: \"#{Keyword.get(@opts, :address_postal_code)}\",
            address_street1: \"#{Keyword.get(@opts, :address_street1)}\",
            address_street2: \"#{Keyword.get(@opts, :address_street2)}\",
            address_subdivision: \"#{Keyword.get(@opts, :address_subdivision)}\",
            birth_day: #{Keyword.get(@opts, :birth_day)},
            birth_month: #{Keyword.get(@opts, :birth_month)},
            birth_year: #{Keyword.get(@opts, :birth_year)},
            document_type: \"#{Keyword.get(@opts, :document_type)}\",
            document_value: \"1111\",
            name_first: \"#{Keyword.get(@opts, :name_first)}\",
            name_last: \"#{Keyword.get(@opts, :name_last)}\",
            name_middle: \"#{Keyword.get(@opts, :name_middle)}\"
          ) {
            status
        }
      }
      """

      {:ok, %{data: %{"getStatusBlockscore" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["status"] == "invalid"
    end

    it "returns null status - `AbsintheHelpers`" do
      query = """
      {
        getStatusBlockscore(
            address_city: \"#{Keyword.get(@opts, :address_city)}\",
            address_country_code: \"#{Keyword.get(@opts, :address_country_code)}\",
            address_postal_code: \"#{Keyword.get(@opts, :address_postal_code)}\",
            address_street1: \"#{Keyword.get(@opts, :address_street1)}\",
            address_street2: \"#{Keyword.get(@opts, :address_street2)}\",
            address_subdivision: \"#{Keyword.get(@opts, :address_subdivision)}\",
            birth_day: #{Keyword.get(@opts, :birth_day)},
            birth_month: #{Keyword.get(@opts, :birth_month)},
            birth_year: #{Keyword.get(@opts, :birth_year)},
            document_type: \"XXXX\",
            document_value: \"0000\",
            name_first: \"#{Keyword.get(@opts, :name_first)}\",
            name_last: \"#{Keyword.get(@opts, :name_last)}\",
            name_middle: \"#{Keyword.get(@opts, :name_middle)}\"
          ) {
            status
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getStatusBlockscore"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["getStatusBlockscore"]

      assert data["status"] == nil
    end

    it "returns null status - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getStatusBlockscore(
            address_city: \"#{Keyword.get(@opts, :address_city)}\",
            address_country_code: \"#{Keyword.get(@opts, :address_country_code)}\",
            address_postal_code: \"#{Keyword.get(@opts, :address_postal_code)}\",
            address_street1: \"#{Keyword.get(@opts, :address_street1)}\",
            address_street2: \"#{Keyword.get(@opts, :address_street2)}\",
            address_subdivision: \"#{Keyword.get(@opts, :address_subdivision)}\",
            birth_day: #{Keyword.get(@opts, :birth_day)},
            birth_month: #{Keyword.get(@opts, :birth_month)},
            birth_year: #{Keyword.get(@opts, :birth_year)},
            document_type: \"XXXX\",
            document_value: \"0000\",
            name_first: \"#{Keyword.get(@opts, :name_first)}\",
            name_last: \"#{Keyword.get(@opts, :name_last)}\",
            name_middle: \"#{Keyword.get(@opts, :name_middle)}\"
          ) {
            status
        }
      }
      """

      {:ok, %{data: %{"getStatusBlockscore" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["status"] == nil
    end
  end
end
