defmodule ServerWeb.GraphQL.Integration.Products.BusinessEntityTypeIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessEntityTypes {
          id
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessEntityTypes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessEntityTypes"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["price"]                                 == nil
      assert List.first(data)["business_tax_returns"]["id"]            == struct.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["user"]["id"]    == user.id
      assert List.first(data)["business_tax_returns"]["user"]["email"] == user.email
      assert List.first(data)["business_tax_returns"]["user"]["role"]  == user.role

      {:ok, %{data: %{"allBusinessEntityTypes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["price"]                                 == nil
      assert first["business_tax_returns"]["id"]            == struct.business_tax_returns.id
      assert first["business_tax_returns"]["user"]["id"]    == user.id
      assert first["business_tax_returns"]["user"]["email"] == user.email
      assert first["business_tax_returns"]["user"]["role"]  == user.role
    end

    it "returns BusinessEntityType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      struct = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        allBusinessEntityTypes {
          id
          name
          price
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
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBusinessEntityTypes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBusinessEntityTypes"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["price"]                                 == struct.price
      assert List.first(data)["business_tax_returns"]["id"]            == struct.business_tax_returns.id
      assert List.first(data)["business_tax_returns"]["user"]["id"]    == user.id
      assert List.first(data)["business_tax_returns"]["user"]["email"] == user.email
      assert List.first(data)["business_tax_returns"]["user"]["role"]  == user.role

      {:ok, %{data: %{"allBusinessEntityTypes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["price"]                                 == struct.price
      assert first["business_tax_returns"]["id"]            == struct.business_tax_returns.id
      assert first["business_tax_returns"]["user"]["id"]    == user.id
      assert first["business_tax_returns"]["user"]["email"] == user.email
      assert first["business_tax_returns"]["user"]["role"]  == user.role
    end
  end

  describe "#show" do
    it "returns specific BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessEntityType(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"showBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessEntityType"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role
    end

    it "returns specific BusinessEntityType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      struct = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        showBusinessEntityType(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"showBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBusinessEntityType"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role
    end
  end

  describe "#find" do
    it "returns specific BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessEntityType(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"findBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessEntityType"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role
    end

    it "returns specific BusinessEntityType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      struct = insert(:pro_business_entity_type, %{business_tax_returns: business_tax_return})
      context = %{current_user: user}

      query = """
      {
        findBusinessEntityType(id: \"#{struct.id}\") {
          id
          name
          price
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

      {:ok, %{data: %{"findBusinessEntityType" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBusinessEntityType"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBusinessEntityType"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["business_tax_returns"]["id"]            == struct.business_tax_return_id
      assert found["business_tax_returns"]["user"]["id"]    == user.id
      assert found["business_tax_returns"]["user"]["email"] == user.email
      assert found["business_tax_returns"]["user"]["role"]  == user.role
    end
  end

  describe "#create" do
    it "created BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessEntityType(
          name: "C-Corp / Corporation",
          business_tax_returnId: \"#{business_tax_return.id}\"
        ) {
          id
          name
          price
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

      created = json_response(res, 200)["data"]["createBusinessEntityType"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["name"]                == "C-Corp / Corporation"
      assert created["price"]               == nil
    end

    it "created BusinessEntityType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})

      mutation = """
      {
        createBusinessEntityType(
          name: "C-Corp / Corporation",
          price: 22,
          business_tax_returnId: \"#{business_tax_return.id}\"
        ) {
          id
          name
          price
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

      created = json_response(res, 200)["data"]["createBusinessEntityType"]

      assert created["business_tax_returns"]["id"] == business_tax_return.id
      assert created["name"]                       == "C-Corp / Corporation"
      assert created["price"]                      == 22
    end
  end

  describe "#update" do
    it "updated specific BusinessEntityType by role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, %{user: user})
      struct = insert(:tp_business_entity_type, %{name: "C-Corp / Corporation", business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessEntityType(
          id: \"#{struct.id}\",
          businessEntityType: {
            name: "Sole proprietorship",
            business_tax_returnId: \"#{business_tax_return.id}\"
          }
        )
        {
          id
          name
          price
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

      updated = json_response(res, 200)["data"]["updateBusinessEntityType"]

      assert updated["business_tax_returns"]["id"] == struct.business_tax_return_id
      assert updated["id"]                         == struct.id
      assert updated["name"]                       == "Sole proprietorship"
      assert updated["price"]                      == nil
    end

    it "updated specific BusinessEntityType by role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, %{user: user})
      struct = insert(:pro_business_entity_type, %{name: "C-Corp / Corporation", business_tax_returns: business_tax_return})

      mutation = """
      {
        updateBusinessEntityType(
          id: \"#{struct.id}\",
          businessEntityType: {
            name: "Sole proprietorship",
            price: 33,
            business_tax_returnId: \"#{business_tax_return.id}\"
          }
        )
        {
          id
          name
          price
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

      updated = json_response(res, 200)["data"]["updateBusinessEntityType"]

      assert updated["business_tax_returns"]["id"] == struct.business_tax_return_id
      assert updated["id"]                         == struct.id
      assert updated["name"]                       == "Sole proprietorship"
      assert updated["price"]                      == 33
    end
  end

  describe "#delete" do
    it "delete specific BusinessEntityType" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      struct = insert(:business_entity_type, %{business_tax_returns: business_tax_return})

      mutation = """
      {
        deleteBusinessEntityType(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBusinessEntityType"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created BusinessEntityType" do
      user = insert(:user)
      business_tax_return = insert(:business_tax_return, %{user: user})
      %{id: id} = insert(:business_entity_type, %{business_tax_returns: business_tax_return})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:business_entity_types, source)
        |> Dataloader.load(:business_entity_types, Core.Services.BusinessEntityType, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :business_entity_types, Core.Services.BusinessEntityType, id)

      assert data.id == id
    end
  end

  @spec format_field(atom()) :: String.t()
  defp format_field(data), do: to_string(data)
end
