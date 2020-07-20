defmodule ServerWeb.GraphQL.Integration.Products.BusinessForeignOwnershipCountIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessForeignOwnershipCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessForeignOwnershipCounts {
          id
          name
          business_tax_returns {
            id
            accounting_software
            capital_asset_sale
            church_hospital
            deadline
            dispose_asset
            dispose_property
            educational_facility
            financial_situation
            foreign_account_interest
            foreign_account_value_more
            foreign_entity_interest
            foreign_partner_count
            foreign_shareholder
            foreign_value
            fundraising_over
            has_contribution
            has_loan
            income_over_thousand
            invest_research
            k1_count
            lobbying
            make_distribution
            none_expat
            operate_facility
            property_sale
            public_charity
            rental_property_count
            reported_grant
            restricted_donation
            state
            tax_exemption
            tax_year
            total_asset_less
            total_asset_over
            businessEntityTypes { id name }
            businessForeignAccountCounts { id name }
            businessForeignOwnershipCounts { id name }
            businessLlcTypes { id name }
            businessIndustries { id name }
            businessNumberEmployees { id name }
            businessTotalRevenues { id name }
            businessTransactionCounts { id name }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessForeignOwnershipCounts"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessForeignOwnershipCounts"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["business_tax_returns"]["id"]            == struct.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["user"]["id"]    == user.id
      assert List.first(data)["business_tax_returns"]["user"]["email"] == user.email
      assert List.first(data)["business_tax_returns"]["user"]["role"]  == user.role

      {:ok, %{data: %{"allBusinessForeignOwnershipCounts" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["business_tax_returns"]["id"]            == struct.business_tax_returns.id
      assert first["business_tax_returns"]["user"]["id"]    == user.id
      assert first["business_tax_returns"]["user"]["email"] == user.email
      assert first["business_tax_returns"]["user"]["role"]  == user.role
    end
  end

  describe "#show" do
    it "returns specific BusinessForeignOwnershipCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessForeignOwnershipCount(id: \"#{struct.id}\") {
          id
          name
          business_tax_returns {
            id
            accounting_software
            capital_asset_sale
            church_hospital
            deadline
            dispose_asset
            dispose_property
            educational_facility
            financial_situation
            foreign_account_interest
            foreign_account_value_more
            foreign_entity_interest
            foreign_partner_count
            foreign_shareholder
            foreign_value
            fundraising_over
            has_contribution
            has_loan
            income_over_thousand
            invest_research
            k1_count
            lobbying
            make_distribution
            none_expat
            operate_facility
            property_sale
            public_charity
            rental_property_count
            reported_grant
            restricted_donation
            state
            tax_exemption
            tax_year
            total_asset_less
            total_asset_over
            businessEntityTypes { id name }
            businessForeignAccountCounts { id name }
            businessForeignOwnershipCounts { id name }
            businessLlcTypes { id name }
            businessIndustries { id name }
            businessNumberEmployees { id name }
            businessTotalRevenues { id name }
            businessTransactionCounts { id name }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showBusinessForeignOwnershipCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessForeignOwnershipCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessForeignOwnershipCount"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role
    end
  end

  describe "#find" do
    it "returns specific BusinessForeignOwnershipCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_foreign_ownership_count, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessForeignOwnershipCount(id: \"#{struct.id}\") {
          id
          name
          business_tax_returns {
            id
            accounting_software
            capital_asset_sale
            church_hospital
            deadline
            dispose_asset
            dispose_property
            educational_facility
            financial_situation
            foreign_account_interest
            foreign_account_value_more
            foreign_entity_interest
            foreign_partner_count
            foreign_shareholder
            foreign_value
            fundraising_over
            has_contribution
            has_loan
            income_over_thousand
            invest_research
            k1_count
            lobbying
            make_distribution
            none_expat
            operate_facility
            property_sale
            public_charity
            rental_property_count
            reported_grant
            restricted_donation
            state
            tax_exemption
            tax_year
            total_asset_less
            total_asset_over
            businessEntityTypes { id name }
            businessForeignAccountCounts { id name }
            businessForeignOwnershipCounts { id name }
            businessLlcTypes { id name }
            businessIndustries { id name }
            businessNumberEmployees { id name }
            businessTotalRevenues { id name }
            businessTransactionCounts { id name }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findBusinessForeignOwnershipCount" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessForeignOwnershipCount"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessForeignOwnershipCount"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role
    end
  end

  describe "#create" do
    it "created BusinessForeignOwnershipCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessForeignOwnershipCount(
          name: "1",
          business_tax_returnId: \"#{business_tax_return.id}\"
        ) {
          id
          name
          business_tax_returns {
            id
            accounting_software
            capital_asset_sale
            church_hospital
            deadline
            dispose_asset
            dispose_property
            educational_facility
            financial_situation
            foreign_account_interest
            foreign_account_value_more
            foreign_entity_interest
            foreign_partner_count
            foreign_shareholder
            foreign_value
            fundraising_over
            has_contribution
            has_loan
            income_over_thousand
            invest_research
            k1_count
            lobbying
            make_distribution
            none_expat
            operate_facility
            property_sale
            public_charity
            rental_property_count
            reported_grant
            restricted_donation
            state
            tax_exemption
            tax_year
            total_asset_less
            total_asset_over
            businessEntityTypes { id name }
            businessForeignAccountCounts { id name }
            businessForeignOwnershipCounts { id name }
            businessLlcTypes { id name }
            businessIndustries { id name }
            businessNumberEmployees { id name }
            businessTotalRevenues { id name }
            businessTransactionCounts { id name }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBusinessForeignOwnershipCount"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["name"]                == "1"
    end

    it "created BusinessForeignOwnershipCount by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessForeignOwnershipCount(
          name: "1",
          business_tax_returnId: \"#{business_tax_return.id}\"
        ) {
          id
          name
          business_tax_returns {
            id
            none_expat
            price_state
            price_tax_year
            businessEntityTypes { id name price }
            businessNumberEmployees { id name price }
            businessTotalRevenues { id name price }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBusinessForeignOwnershipCount"]

      assert created == nil
    end
  end

  describe "#update" do
    it "updated specific BusinessForeignOwnershipCount by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_foreign_ownership_count, %{name: "1", business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessForeignOwnershipCount(
          id: \"#{struct.id}\",
          businessForeignOwnershipCount: {
            name: "5+",
            business_tax_returnId: \"#{business_tax_return.id}\"
          }
        )
        {
          id
          name
          business_tax_returns {
            id
            accounting_software
            capital_asset_sale
            church_hospital
            deadline
            dispose_asset
            dispose_property
            educational_facility
            financial_situation
            foreign_account_interest
            foreign_account_value_more
            foreign_entity_interest
            foreign_partner_count
            foreign_shareholder
            foreign_value
            fundraising_over
            has_contribution
            has_loan
            income_over_thousand
            invest_research
            k1_count
            lobbying
            make_distribution
            none_expat
            operate_facility
            property_sale
            public_charity
            rental_property_count
            reported_grant
            restricted_donation
            state
            tax_exemption
            tax_year
            total_asset_less
            total_asset_over
            businessEntityTypes { id name }
            businessForeignAccountCounts { id name }
            businessForeignOwnershipCounts { id name }
            businessLlcTypes { id name }
            businessIndustries { id name }
            businessNumberEmployees { id name }
            businessTotalRevenues { id name }
            businessTransactionCounts { id name }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBusinessForeignOwnershipCount"]

      assert updated["business_tax_returns"]["id"] == struct.business_tax_return_id
      assert updated["id"]                         == struct.id
      assert updated["name"]                       == "5+"
    end
  end

  describe "#delete" do
    it "delete specific BusinessForeignOwnershipCount" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      struct = insert(:business_foreign_ownership_count, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessForeignOwnershipCount(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessForeignOwnershipCount"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created BusinessForeignOwnershipCount" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      %{id: id} = insert(:business_foreign_ownership_count, %{business_tax_returns: business_tax_return})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_foreign_ownership_counts, source)
        |> Dataloader.load(:business_foreign_ownership_counts, Core.Services.BusinessForeignOwnershipCount, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_foreign_ownership_counts, Core.Services.BusinessForeignOwnershipCount, id)

      assert data.id == id
    end
  end

  @spec format_field(atom()) :: String.t()
  defp format_field(data), do: to_string(data)
end
