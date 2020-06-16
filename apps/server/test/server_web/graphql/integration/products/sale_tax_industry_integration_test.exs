defmodule ServerWeb.GraphQL.Integration.Products.SaleTaxIndustryIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      sale_tax_industry = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxIndustries {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxIndustries"]

      assert List.first(data)["id"]                        == sale_tax_industry.id
      assert List.first(data)["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert List.first(data)["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert List.first(data)["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert List.first(data)["inserted_at"]               == formatting_time(sale_tax_industry.inserted_at)
      assert List.first(data)["name"]                      == sale_tax_industry.name
      assert List.first(data)["updated_at"]                == formatting_time(sale_tax_industry.updated_at)

      {:ok, %{data: %{"allSaleTaxIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                       == sale_tax_industry.id
      assert first["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert first["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert first["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert first["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert first["name"]                     == sale_tax_industry.name
      assert first["updated_at"]               == formatting_time(sale_tax_industry.updated_at)
    end

    it "returns BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      sale_tax_industry = insert(:pro_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxIndustries {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxIndustries"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxIndustries"]

      assert List.first(data)["id"]                       == sale_tax_industry.id
      assert List.first(data)["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert List.first(data)["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert List.first(data)["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert List.first(data)["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert List.first(data)["name"]                     == sale_tax_industry.name
      assert List.first(data)["updated_at"]               == formatting_time(sale_tax_industry.updated_at)

      {:ok, %{data: %{"allSaleTaxIndustries" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                       == sale_tax_industry.id
      assert first["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert first["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert first["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert first["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert first["name"]                     == sale_tax_industry.name
      assert first["updated_at"]               == formatting_time(sale_tax_industry.updated_at)
    end
  end

  describe "#show" do
    it "returns specific SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      sale_tax_industry = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        showSaleTaxIndustry(id: \"#{sale_tax_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTaxIndustry"]

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)
    end

    it "returns specific SaleTaxIndustry by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      sale_tax_industry = insert(:pro_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        showSaleTaxIndustry(id: \"#{sale_tax_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"showSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTaxIndustry"]

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      sale_tax_industry = insert(:tp_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        findSaleTaxIndustry(id: \"#{sale_tax_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTaxIndustry"]

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)
    end

    it "find specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      sale_tax_industry = insert(:pro_sale_tax_industry, %{sale_taxes: sale_tax})
      context = %{current_user: user}

      query = """
      {
        findSaleTaxIndustry(id: \"#{sale_tax_industry.id}\") {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      {:ok, %{data: %{"findSaleTaxIndustry" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTaxIndustry"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTaxIndustry"]

      assert found["id"]                       == sale_tax_industry.id
      assert found["sale_taxes"]["id"]          == sale_tax_industry.sale_taxes.id
      assert found["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert found["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert found["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert found["name"]                     == sale_tax_industry.name
      assert found["updated_at"]               == formatting_time(sale_tax_industry.updated_at)
    end
  end

  describe "#create" do
    it "created SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})

      mutation = """
      {
        createSaleTaxIndustry(
          name: ["some name"],
          sale_taxId: \"#{sale_tax.id}\"
        ) {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createSaleTaxIndustry"]

      assert created["sale_taxes"]["id"] == sale_tax.id
      assert created["inserted_at"]     == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]            == ["some name"]
      assert created["updated_at"]      == formatting_time(DateTime.truncate(Timex.now(), :second))
    end

    it "created SaleTaxIndustry by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})

      mutation = """
      {
        createSaleTaxIndustry(
          name: ["some name"],
          sale_taxId: \"#{sale_tax.id}\"
        ) {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createSaleTaxIndustry"]

      assert created["sale_taxes"]["id"] == sale_tax.id
      assert created["inserted_at"]     == formatting_time(DateTime.truncate(Timex.now(), :second))
      assert created["name"]            == ["some name"]
      assert created["updated_at"]      == formatting_time(DateTime.truncate(Timex.now(), :second))
    end
  end

  describe "#update" do
    it "updated specific SaleTaxIndustry by role's Tp" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, %{user: user})
      sale_tax_industry = insert(:sale_tax_industry, %{sale_taxes: sale_tax})

      mutation = """
      {
        updateSaleTaxIndustry(
          id: \"#{sale_tax_industry.id}\",
          sale_tax_industry: {
            name: ["updated some name"],
            sale_taxId: \"#{sale_tax.id}\"
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSaleTaxIndustry"]

      assert updated["id"]                                  == sale_tax_industry.id
      assert updated["sale_taxes"]["id"]          == sale_tax.id
      assert updated["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert updated["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert updated["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert updated["name"]                     == ["updated some name"]
    end

    it "updated specific BusinessTaxReturn by role's Pro" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, %{user: user})
      sale_tax_industry = insert(:sale_tax_industry, %{sale_taxes: sale_tax})

      mutation = """
      {
        updateSaleTaxIndustry(
          id: \"#{sale_tax_industry.id}\",
          sale_tax_industry: {
            sale_taxId: \"#{sale_tax.id}\"
            name: ["updated some name"],
          }
        )
        {
          id
          inserted_at
          name
          updated_at
          sale_taxes {
            id
            inserted_at
            updated_at
            user { id }
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSaleTaxIndustry"]

      assert updated["id"]                       == sale_tax_industry.id
      assert updated["sale_taxes"]["id"]          == sale_tax.id
      assert updated["sale_taxes"]["inserted_at"] == formatting_time(sale_tax_industry.sale_taxes.inserted_at)
      assert updated["sale_taxes"]["updated_at"]  == formatting_time(sale_tax_industry.sale_taxes.updated_at)
      assert updated["inserted_at"]              == formatting_time(sale_tax_industry.inserted_at)
      assert updated["name"]                     == ["updated some name"]
      assert updated["updated_at"]               == formatting_time(sale_tax_industry.updated_at)
    end
  end

  describe "#delete" do
    it "delete specific SaleTaxIndustry" do
      user = insert(:user)
      sale_tax = insert(:sale_tax, %{user: user})
      sale_tax_industry = insert(:sale_tax_industry, %{sale_taxes: sale_tax})

      mutation = """
      {
        deleteSaleTaxIndustry(id: \"#{sale_tax_industry.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteSaleTaxIndustry"]
      assert deleted["id"] == sale_tax_industry.id
    end
  end

  describe "#dataloads" do
    it "created SaleTaxIndustry by role's Tp" do
       user = insert(:tp_user)
       %{id: sale_tax_id} = insert(:tp_sale_tax, user: user)

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:sale_tax_industries, source)
        |> Dataloader.load(:sale_tax_industries, Core.Services.SaleTax, sale_tax_id)
        |> Dataloader.run

      data = Dataloader.get(loader, :sale_tax_industries, Core.Services.SaleTax, sale_tax_id)

      assert data.id == sale_tax_id
    end
  end

  defp formatting_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end
