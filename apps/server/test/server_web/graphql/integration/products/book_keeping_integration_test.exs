defmodule ServerWeb.GraphQL.Integration.Products.BookKeepingIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#index" do
    it "returns BookKeeping by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allBookKeepings {
          id
          account_count
          balance_sheet
          deadline
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepings"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepings"]

      assert List.first(data)["id"]                  == struct.id
      assert List.first(data)["account_count"]       == struct.account_count
      assert List.first(data)["balance_sheet"]       == struct.balance_sheet
      assert List.first(data)["deadline"]            == format_deadline(struct.deadline)
      assert List.first(data)["financial_situation"] == struct.financial_situation
      assert List.first(data)["inventory"]           == struct.inventory
      assert List.first(data)["inventory_count"]     == struct.inventory_count
      assert List.first(data)["payroll"]             == struct.payroll
      assert List.first(data)["tax_return_current"]  == struct.tax_return_current
      assert List.first(data)["tax_year"]            == struct.tax_year
      assert List.first(data)["user"]["id"]          == user.id
      assert List.first(data)["user"]["email"]       == user.email
      assert List.first(data)["user"]["role"]        == user.role

      {:ok, %{data: %{"allBookKeepings" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                  == struct.id
      assert first["account_count"]       == struct.account_count
      assert first["balance_sheet"]       == struct.balance_sheet
      assert first["deadline"]            == format_deadline(struct.deadline)
      assert first["financial_situation"] == struct.financial_situation
      assert first["inventory"]           == struct.inventory
      assert first["inventory_count"]     == struct.inventory_count
      assert first["payroll"]             == struct.payroll
      assert first["tax_return_current"]  == struct.tax_return_current
      assert first["tax_year"]            == struct.tax_year
      assert first["user"]["id"]          == user.id
      assert first["user"]["email"]       == user.email
      assert first["user"]["role"]        == user.role
    end

    it "returns BookKeeping by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})
      context = %{current_user: user}

      query = """
      {
        allBookKeepings {
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allBookKeepings"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allBookKeepings"]

      assert List.first(data)["id"]            == struct.id
      assert List.first(data)["payroll"]       == struct.payroll
      assert List.first(data)["price_payroll"] == struct.price_payroll
      assert List.first(data)["user"]["id"]    == user.id
      assert List.first(data)["user"]["email"] == user.email
      assert List.first(data)["user"]["role"]  == user.role

      {:ok, %{data: %{"allBookKeepings" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]            == struct.id
      assert first["payroll"]       == struct.payroll
      assert first["price_payroll"] == struct.price_payroll
      assert first["user"]["id"]    == user.id
      assert first["user"]["email"] == user.email
      assert first["user"]["role"]  == user.role
    end
  end

  describe "#show" do
    it "returns specific BookKeeping by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showBookKeeping(id: \"#{struct.id}\") {
          id
          account_count
          balance_sheet
          deadline
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
      """

      {:ok, %{data: %{"showBookKeeping" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                  == struct.id
      assert found["account_count"]       == struct.account_count
      assert found["balance_sheet"]       == struct.balance_sheet
      assert found["deadline"]            == format_deadline(struct.deadline)
      assert found["financial_situation"] == struct.financial_situation
      assert found["inventory"]           == struct.inventory
      assert found["inventory_count"]     == struct.inventory_count
      assert found["payroll"]             == struct.payroll
      assert found["tax_return_current"]  == struct.tax_return_current
      assert found["tax_year"]            == struct.tax_year
      assert found["user"]["id"]          == user.id
      assert found["user"]["email"]       == user.email
      assert found["user"]["role"]        == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeeping"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeeping"]

      assert found["id"]                  == struct.id
      assert found["account_count"]       == struct.account_count
      assert found["balance_sheet"]       == struct.balance_sheet
      assert found["deadline"]            == format_deadline(struct.deadline)
      assert found["financial_situation"] == struct.financial_situation
      assert found["inventory"]           == struct.inventory
      assert found["inventory_count"]     == struct.inventory_count
      assert found["payroll"]             == struct.payroll
      assert found["tax_return_current"]  == struct.tax_return_current
      assert found["tax_year"]            == struct.tax_year
      assert found["user"]["id"]          == user.id
      assert found["user"]["email"]       == user.email
      assert found["user"]["role"]        == user.role
    end

    it "returns specific BookKeeping by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})
      context = %{current_user: user}

      query = """
      {
        showBookKeeping(id: \"#{struct.id}\") {
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
      """

      {:ok, %{data: %{"showBookKeeping" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]            == struct.id
      assert found["payroll"]       == struct.payroll
      assert found["price_payroll"] == struct.price_payroll
      assert found["user"]["id"]    == user.id
      assert found["user"]["email"] == user.email
      assert found["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showBookKeeping"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showBookKeeping"]

      assert found["id"]            == struct.id
      assert found["payroll"]       == struct.payroll
      assert found["price_payroll"] == struct.price_payroll
      assert found["user"]["id"]    == user.id
      assert found["user"]["email"] == user.email
      assert found["user"]["role"]  == user.role
    end
  end

  describe "#find" do
    it "returns specific BookKeeping by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findBookKeeping(id: \"#{struct.id}\") {
          id
          account_count
          balance_sheet
          deadline
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
      """

      {:ok, %{data: %{"findBookKeeping" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                  == struct.id
      assert found["account_count"]       == struct.account_count
      assert found["balance_sheet"]       == struct.balance_sheet
      assert found["deadline"]            == format_deadline(struct.deadline)
      assert found["financial_situation"] == struct.financial_situation
      assert found["inventory"]           == struct.inventory
      assert found["inventory_count"]     == struct.inventory_count
      assert found["payroll"]             == struct.payroll
      assert found["tax_return_current"]  == struct.tax_return_current
      assert found["tax_year"]            == struct.tax_year
      assert found["user"]["id"]          == user.id
      assert found["user"]["email"]       == user.email
      assert found["user"]["role"]        == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeeping"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeeping"]

      assert found["id"]                  == struct.id
      assert found["account_count"]       == struct.account_count
      assert found["balance_sheet"]       == struct.balance_sheet
      assert found["deadline"]            == format_deadline(struct.deadline)
      assert found["financial_situation"] == struct.financial_situation
      assert found["inventory"]           == struct.inventory
      assert found["inventory_count"]     == struct.inventory_count
      assert found["payroll"]             == struct.payroll
      assert found["tax_return_current"]  == struct.tax_return_current
      assert found["tax_year"]            == struct.tax_year
      assert found["user"]["id"]          == user.id
      assert found["user"]["email"]       == user.email
      assert found["user"]["role"]        == user.role
    end

    it "returns specific BookKeeping by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})
      context = %{current_user: user}

      query = """
      {
        findBookKeeping(id: \"#{struct.id}\") {
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
      """

      {:ok, %{data: %{"findBookKeeping" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]            == struct.id
      assert found["payroll"]       == struct.payroll
      assert found["price_payroll"] == struct.price_payroll
      assert found["user"]["id"]    == user.id
      assert found["user"]["email"] == user.email
      assert found["user"]["role"]  == user.role

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "findBookKeeping"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["findBookKeeping"]

      assert found["id"]            == struct.id
      assert found["payroll"]       == struct.payroll
      assert found["price_payroll"] == struct.price_payroll
      assert found["user"]["id"]    == user.id
      assert found["user"]["email"] == user.email
      assert found["user"]["role"]  == user.role
    end
  end

  describe "#create" do
    it "created BookKeeping by role's Tp" do
      user = insert(:tp_user)

      mutation = """
      {
        createBookKeeping(
          account_count: 22,
          balance_sheet: true,
          deadline: \"#{Date.utc_today()}\",
          financial_situation: "some text",
          inventory: true,
          inventory_count: 22,
          payroll: true,
          tax_return_current: true,
          tax_year: ["2019", "2020"],
          userId: \"#{user.id}\"
        ) {
          id
          account_count
          balance_sheet
          deadline
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBookKeeping"]

      assert created["account_count"]       == 22
      assert created["balance_sheet"]       == true
      assert created["deadline"]            == format_deadline(Date.utc_today())
      assert created["financial_situation"] == "some text"
      assert created["inventory"]           == true
      assert created["inventory_count"]     == 22
      assert created["payroll"]             == true
      assert created["tax_return_current"]  == true
      assert created["tax_year"]            == ["2019", "2020"]
      assert created["user"]["id"]          == user.id
      assert created["user"]["email"]       == user.email
      assert created["user"]["role"]        == user. role
    end

    it "created BookKeeping by role's Pro" do
      user = insert(:pro_user)

      mutation = """
      {
        createBookKeeping(
          payroll: true,
          price_payroll: 22,
          userId: \"#{user.id}\"
        ) {
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createBookKeeping"]

      assert created["payroll"]       == true
      assert created["price_payroll"] == 22
      assert created["user"]["id"]    == user.id
      assert created["user"]["email"] == user.email
      assert created["user"]["role"]  == user. role
    end
  end

  describe "#update" do
    it "updated specific BookKeeping by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})

      mutation = """
      {
        updateBookKeeping(
          id: \"#{struct.id}\",
          book_keeping: {
            account_count: 33,
            balance_sheet: false,
            deadline: \"#{Date.utc_today |> Date.add(-3)}\",
            financial_situation: "updated text",
            inventory: false,
            inventory_count: 33,
            payroll: false,
            tax_return_current: false,
            tax_year: ["2015"],
            userId: \"#{user.id}\"
          }
        )
        {
          id
          account_count
          balance_sheet
          deadline
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBookKeeping"]

      assert updated["id"]                  == struct.id
      assert updated["account_count"]       == 33
      assert updated["balance_sheet"]       == false
      assert updated["deadline"]            == format_deadline(Date.utc_today |> Date.add(-3))
      assert updated["financial_situation"] == "updated text"
      assert updated["inventory"]           == false
      assert updated["inventory_count"]     == 33
      assert updated["payroll"]             == false
      assert updated["tax_return_current"]  == false
      assert updated["tax_year"]            == ["2015"]
      assert updated["user"]["id"]          == user.id
      assert updated["user"]["email"]       == user.email
      assert updated["user"]["role"]        == user. role
    end

    it "updated specific BookKeeping by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})

      mutation = """
      {
        updateBookKeeping(
          id: \"#{struct.id}\",
          book_keeping: {
            payroll: false,
            price_payroll: 33,
            userId: \"#{user.id}\"
          }
        )
        {
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
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateBookKeeping"]

      assert updated["id"]            == struct.id
      assert updated["payroll"]       == false
      assert updated["price_payroll"] == 33
      assert updated["user"]["id"]    == user.id
      assert updated["user"]["email"] == user.email
      assert updated["user"]["role"]  == user. role
    end
  end

  describe "#delete" do
    it "delete specific BookKeeping" do
      user = insert(:user)
      struct = insert(:book_keeping, %{user: user})

      mutation = """
      {
        deleteBookKeeping(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteBookKeeping"]
      assert deleted["id"] == struct.id
    end
  end

  describe "#dataloads" do
    it "created BookKeeping" do
      user = insert(:user)
      %{id: id} = insert(:book_keeping, %{user: user})

      source = Dataloader.Ecto.new(Core.Repo)

      loader =
        Dataloader.new
        |> Dataloader.add_source(:book_keepings, source)
        |> Dataloader.load(:book_keepings, Core.Services.BookKeeping, id)
        |> Dataloader.run

      data = Dataloader.get(loader, :book_keepings, Core.Services.BookKeeping, id)

      assert data.id == id
    end
  end

  @spec format_deadline(Date.t()) :: String.t()
  defp format_deadline(data), do: to_string(data)
end
