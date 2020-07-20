defmodule ServerWeb.GraphQL.Integration.Products.SaleTaxIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns SaleTax by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxes {
          id
          deadline
          financial_situation
          sale_tax_count
          state
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxes"]

      assert List.first(data)["id"]                   == struct.id
      assert List.first(data)["deadline"]             == format_deadline(struct.deadline)
      assert List.first(data)["financial_situation"]  == struct.financial_situation
      assert List.first(data)["sale_tax_count"]       == struct.sale_tax_count
      assert List.first(data)["state"]                == struct.state
      assert List.first(data)["user"]["id"]           == user.id
      assert List.first(data)["user"]["email"]        == user.email
      assert List.first(data)["user"]["role"]         == user.role

      {:ok, %{data: %{"allSaleTaxes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                   == struct.id
      assert first["deadline"]             == format_deadline(struct.deadline)
      assert first["financial_situation"]  == struct.financial_situation
      assert first["sale_tax_count"]       == struct.sale_tax_count
      assert first["state"]                == struct.state
      assert first["user"]["id"]           == user.id
      assert first["user"]["email"]        == user.email
      assert first["user"]["role"]         == user.role
    end

    it "returns SaleTaxFrequency by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allSaleTaxes {
          id
          price_sale_tax_count
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSaleTaxes"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSaleTaxes"]

      assert List.first(data)["id"]                   == struct.id
      assert List.first(data)["price_sale_tax_count"] == struct.price_sale_tax_count
      assert List.first(data)["user"]["id"]           == user.id
      assert List.first(data)["user"]["email"]        == user.email
      assert List.first(data)["user"]["role"]         == user.role

      {:ok, %{data: %{"allSaleTaxes" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                   == struct.id
      assert first["price_sale_tax_count"] == struct.price_sale_tax_count
      assert first["user"]["id"]           == user.id
      assert first["user"]["email"]        == user.email
      assert first["user"]["role"]         == user.role
    end
  end

  describe "#show" do
    it "returns specific SaleTax by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showSaleTax(id: \"#{struct.id}\") {
          id
          deadline
          financial_situation
          sale_tax_count
          state
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"showSaleTax" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                   == struct.id
      assert found["deadline"]             == format_deadline(struct.deadline)
      assert found["financial_situation"]  == struct.financial_situation
      assert found["sale_tax_count"]       == struct.sale_tax_count
      assert found["state"]                == struct.state
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTax"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTax"]

      assert found["id"]                   == struct.id
      assert found["deadline"]             == format_deadline(struct.deadline)
      assert found["financial_situation"]  == struct.financial_situation
      assert found["sale_tax_count"]       == struct.sale_tax_count
      assert found["state"]                == struct.state
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role
    end

    it "returns specific SaleTax by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showSaleTax(id: \"#{struct.id}\") {
          id
          price_sale_tax_count
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"showSaleTax" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                   == struct.id
      assert found["price_sale_tax_count"] == struct.price_sale_tax_count
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSaleTax"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSaleTax"]

      assert found["id"]                   == struct.id
      assert found["price_sale_tax_count"] == struct.price_sale_tax_count
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role
    end
  end

  describe "#find" do
    it "returns specific SaleTax by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findSaleTax(id: \"#{struct.id}\") {
          id
          deadline
          financial_situation
          sale_tax_count
          state
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"findSaleTax" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                   == struct.id
      assert found["deadline"]             == format_deadline(struct.deadline)
      assert found["financial_situation"]  == struct.financial_situation
      assert found["sale_tax_count"]       == struct.sale_tax_count
      assert found["state"]                == struct.state
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTax"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTax"]

      assert found["id"]                   == struct.id
      assert found["deadline"]             == format_deadline(struct.deadline)
      assert found["financial_situation"]  == struct.financial_situation
      assert found["sale_tax_count"]       == struct.sale_tax_count
      assert found["state"]                == struct.state
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role
    end

    it "returns specific SaleTax by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findSaleTax(id: \"#{struct.id}\") {
          id
          price_sale_tax_count
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      {:ok, %{data: %{"findSaleTax" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                   == struct.id
      assert found["price_sale_tax_count"] == struct.price_sale_tax_count
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findSaleTax"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findSaleTax"]

      assert found["id"]                   == struct.id
      assert found["price_sale_tax_count"] == struct.price_sale_tax_count
      assert found["user"]["id"]           == user.id
      assert found["user"]["email"]        == user.email
      assert found["user"]["role"]         == user.role
    end
  end

  describe "#create" do
    it "created SaleTax by role's Tp" do
      user = insert(:tp_user)

      mutation = """
      {
        createSaleTax(
          deadline: \"#{Date.utc_today()}\",
          financial_situation: "some text",
          sale_tax_count: 22,
          state: ["Alabama", "Florida"],
          userId: \"#{user.id}\"
        ) {
          id
          deadline
          financial_situation
          sale_tax_count
          state
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createSaleTax"]

      assert created["deadline"]            == format_deadline(Date.utc_today())
      assert created["financial_situation"] == "some text"
      assert created["sale_tax_count"]      == 22
      assert created["state"]               == ["Alabama", "Florida"]
      assert created["user"]["id"]          == user.id
      assert created["user"]["email"]       == user.email
      assert created["user"]["role"]        == user. role
    end

    it "created SaleTaxFrequency by role's Pro" do
      user = insert(:pro_user)

      mutation = """
      {
        createSaleTax(
          price_sale_tax_count: 22,
          userId: \"#{user.id}\"
        ) {
          id
          price_sale_tax_count
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createSaleTax"]

      assert created["price_sale_tax_count"] == 22
      assert created["user"]["id"]           == user.id
      assert created["user"]["email"]        == user.email
      assert created["user"]["role"]         == user. role
    end
  end

  describe "#update" do
    it "updated specific SaleTax by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, %{user: user})

      mutation = """
      {
        updateSaleTax(
          id: \"#{struct.id}\",
          sale_tax: {
            deadline: \"#{Date.utc_today |> Date.add(-3)}\",
            financial_situation: "updated text",
            sale_tax_count: 33,
            state: ["Ohio", "Federated States Of Micronesia", "Arizona"],
            userId: \"#{user.id}\"
          }
        )
        {
          id
          deadline
          financial_situation
          sale_tax_count
          state
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSaleTax"]

      assert updated["id"]                  == struct.id
      assert updated["deadline"]            == format_deadline(Date.utc_today |> Date.add(-3))
      assert updated["financial_situation"] == "updated text"
      assert updated["sale_tax_count"]      == 33
      assert updated["state"]               == ["Ohio", "Federated States Of Micronesia", "Arizona"]
      assert updated["user"]["id"]          == user.id
      assert updated["user"]["email"]       == user.email
      assert updated["user"]["role"]        == user. role
    end

    it "updated specific SaleTax by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, %{user: user})

      mutation = """
      {
        updateSaleTax(
          id: \"#{struct.id}\",
          sale_tax: {
            price_sale_tax_count: 33,
            userId: \"#{user.id}\"
          }
        )
        {
          id
          price_sale_tax_count
          sale_tax_frequencies { id }
          sale_tax_industries { id }
          user { id email role}
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSaleTax"]

      assert updated["id"]                   == struct.id
      assert updated["price_sale_tax_count"] == 33
      assert updated["user"]["id"]           == user.id
      assert updated["user"]["email"]        == user.email
      assert updated["user"]["role"]         == user. role
    end
  end

  describe "#delete" do
    it "delete specific SaleTax" do
      user = insert(:user)
      struct = insert(:sale_tax, %{user: user})

      mutation = """
      {
        deleteSaleTax(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteSaleTax"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created SaleTax" do
      user = insert(:user)
      %{id: id} = insert(:sale_tax, %{user: user})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:sale_taxes, source)
        |> Dataloader.load(:sale_taxes, Core.Services.SaleTax, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :sale_taxes, Core.Services.SaleTax, id)

      assert data.id == id
    end
  end

  @spec format_deadline(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end
