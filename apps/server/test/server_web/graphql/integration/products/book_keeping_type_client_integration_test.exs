defmodule ServerWeb.GraphQL.Integration.Products.BookKeepingTypeClientIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BookKeepingTypeClient by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_type_client, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingTypeClients {
          id
          name
          price
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingTypeClients"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingTypeClients"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["price"]                                 == nil
      assert List.first(data)["book_keepings"]["id"]                   == struct.book_keepings.id
      assert List.first(data)["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert List.first(data)["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert List.first(data)["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert List.first(data)["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert List.first(data)["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert List.first(data)["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert List.first(data)["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert List.first(data)["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert List.first(data)["book_keepings"]["user"]["id"]           == user.id
      assert List.first(data)["book_keepings"]["user"]["email"]        == user.email
      assert List.first(data)["book_keepings"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allBookKeepingTypeClients" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["price"]                                 == nil
      assert first["book_keepings"]["id"]                   == struct.book_keepings.id
      assert first["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert first["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert first["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert first["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert first["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert first["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert first["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert first["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert first["book_keepings"]["user"]["id"]           == user.id
      assert first["book_keepings"]["user"]["email"]        == user.email
      assert first["book_keepings"]["user"]["role"]         == user.role
    end

    it "returns BookKeepingTypeClient by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_type_client, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        allBookKeepingTypeClients {
          id
          name
          price
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepingTypeClients"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepingTypeClients"]

      assert List.first(data)["id"]                                    == struct.id
      assert List.first(data)["name"]                                  == format_field(struct.name)
      assert List.first(data)["price"]                                 == struct.price
      assert List.first(data)["book_keepings"]["id"]                   == struct.book_keepings.id
      assert List.first(data)["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert List.first(data)["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert List.first(data)["book_keepings"]["user"]["id"]           == user.id
      assert List.first(data)["book_keepings"]["user"]["email"]        == user.email
      assert List.first(data)["book_keepings"]["user"]["role"]         == user.role

      {:ok, %{data: %{"allBookKeepingTypeClients" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                                    == struct.id
      assert first["name"]                                  == format_field(struct.name)
      assert first["price"]                                 == struct.price
      assert first["book_keepings"]["id"]                   == struct.book_keepings.id
      assert first["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert first["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert first["book_keepings"]["user"]["id"]           == user.id
      assert first["book_keepings"]["user"]["email"]        == user.email
      assert first["book_keepings"]["user"]["role"]         == user.role
    end
  end

  describe "#show" do
    it "returns specific BookKeepingTypeClient by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_type_client, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingTypeClient(id: \"#{struct.id}\") {
          id
          name
          price
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showBookKeepingTypeClient" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingTypeClient"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingTypeClient"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end

    it "returns specific BookKeepingTypeClient by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_type_client, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        showBookKeepingTypeClient(id: \"#{struct.id}\") {
          id
          name
          price
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"showBookKeepingTypeClient" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeepingTypeClient"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeepingTypeClient"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end
  end

  describe "#find" do
    it "find specific BookKeepingTypeClient by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_type_client, %{book_keepings: book_keeping})
      context = %{current_user: user}


      query = """
      {
        findBookKeepingTypeClient(id: \"#{struct.id}\") {
          id
          name
          price
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findBookKeepingTypeClient" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeepingTypeClient"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeepingTypeClient"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == nil
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["account_count"]        == struct.book_keepings.account_count
      assert found["book_keepings"]["balance_sheet"]        == struct.book_keepings.balance_sheet
      assert found["book_keepings"]["financial_situation"]  == struct.book_keepings.financial_situation
      assert found["book_keepings"]["inventory"]            == struct.book_keepings.inventory
      assert found["book_keepings"]["inventory_count"]      == struct.book_keepings.inventory_count
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["tax_return_current"]   == struct.book_keepings.tax_return_current
      assert found["book_keepings"]["tax_year"]             == struct.book_keepings.tax_year
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end

    it "find specific BookKeepingTypeClient by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_type_client, %{book_keepings: book_keeping})
      context = %{current_user: user}

      query = """
      {
        findBookKeepingTypeClient(id: \"#{struct.id}\") {
          id
          name
          price
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
            user { id email role}
          }
        }
      }
      """

      {:ok, %{data: %{"findBookKeepingTypeClient" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeepingTypeClient"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeepingTypeClient"]

      assert found["id"]                                    == struct.id
      assert found["name"]                                  == format_field(struct.name)
      assert found["price"]                                 == struct.price
      assert found["book_keepings"]["id"]                   == struct.book_keepings.id
      assert found["book_keepings"]["payroll"]              == struct.book_keepings.payroll
      assert found["book_keepings"]["price_payroll"]        == struct.book_keepings.price_payroll
      assert found["book_keepings"]["user"]["id"]           == user.id
      assert found["book_keepings"]["user"]["email"]        == user.email
      assert found["book_keepings"]["user"]["role"]         == user.role
    end
  end

  describe "#create" do
    it "created BookKeepingTypeClient by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})

      mutation = """
      {
        createBookKeepingTypeClient(
          name: "C-Corp / Corporation",
          book_keepingId: \"#{book_keeping.id}\"
        ) {
          id
          name
          price
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      created = json_response(res, 200)["data"]["createBookKeepingTypeClient"]

      assert created["book_keepings"]["id"] == book_keeping.id
      assert created["name"]                == "C-Corp / Corporation"
      assert created["price"]               == nil
    end

    it "created BookKeepingTypeClient by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})

      mutation = """
      {
        createBookKeepingTypeClient(
          name: "C-Corp / Corporation",
          price: 22,
          book_keepingId: \"#{book_keeping.id}\"
        ) {
          id
          name
          price
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      created = json_response(res, 200)["data"]["createBookKeepingTypeClient"]

      assert created["book_keepings"]["id"] == book_keeping.id
      assert created["name"]                == "C-Corp / Corporation"
      assert created["price"]               == 22
    end
  end

  describe "#update" do
    it "updated specific BookKeepingTypeClient by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_type_client, %{name: "C-Corp / Corporation", book_keepings: book_keeping})

      mutation = """
      {
        updateBookKeepingTypeClient(
          id: \"#{struct.id}\",
          book_keeping_type_client: {
            name: "S-Corp",
            book_keepingId: \"#{book_keeping.id}\"
          }
        )
        {
          id
          name
          price
          book_keepings {
            id
            account_count
            balance_sheet
            financial_situation
            inventory
            inventory_count
            payroll
            tax_return_current
            tax_year
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      updated = json_response(res, 200)["data"]["updateBookKeepingTypeClient"]

      assert updated["book_keepings"]["id"]          == struct.book_keeping_id
      assert updated["id"]                           == struct.id
      assert updated["name"]                         == "S-Corp"
      assert updated["price"]                        == nil
    end

    it "updated specific BookKeepingTypeClient by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_type_client, %{name: "C-Corp / Corporation", book_keepings: book_keeping})

      mutation = """
      {
        updateBookKeepingTypeClient(
          id: \"#{struct.id}\",
          book_keeping_type_client: {
            name: "S-Corp",
            price: 33,
            book_keepingId: \"#{book_keeping.id}\"
          }
        )
        {
          id
          name
          price
          book_keepings {
            id
            payroll
            price_payroll
            book_keeping_additional_needs { id }
            book_keeping_annual_revenues { id }
            book_keeping_classify_inventories { id }
            book_keeping_industries { id }
            book_keeping_number_employees { id }
            book_keeping_transaction_volumes { id }
            book_keeping_type_clients { id }
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

      updated = json_response(res, 200)["data"]["updateBookKeepingTypeClient"]

      assert updated["book_keepings"]["id"]          == struct.book_keeping_id
      assert updated["id"]                           == struct.id
      assert updated["name"]                         == "S-Corp"
      assert updated["price"]                        == 33
    end
  end

  describe "#delete" do
    it "delete specific BookKeepingTypeClient" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      struct = insert(:book_keeping_type_client, %{book_keepings: book_keeping})

      mutation = """
      {
        deleteBookKeepingTypeClient(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBookKeepingTypeClient"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created BookKeepingTypeClient" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      %{id: id} = insert(:book_keeping_type_client, %{book_keepings: book_keeping})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:book_keeping_type_clients, source)
        |> Dataloader.load(:book_keeping_type_clients, Core.Services.BookKeepingTypeClient, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :book_keeping_type_clients, Core.Services.BookKeepingTypeClient, id)

      assert data.id == id
    end
  end

  @spec format_field(atom()) :: String.t()
  defp format_field(data), do: to_string(data)
end
