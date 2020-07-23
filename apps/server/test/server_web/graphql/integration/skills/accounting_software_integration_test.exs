defmodule ServerWeb.GraphQL.Integration.Skills.AccountingSoftwareIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns accounting softwares - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        allAccountingSoftwares {
          id
          name
          user { id email role }
        }
      }
      """
      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allAccountingSoftwares"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allAccountingSoftwares"]

      assert List.first(data)["id"]                  == struct.id
      assert List.first(data)["name"] |> Enum.sort() == format_field(struct.name)
      assert List.first(data)["user"]["id"]          == struct.user.id
      assert List.first(data)["user"]["email"]       == struct.user.email
      assert List.first(data)["user"]["role"]        == struct.user.role

      assert List.last(data)["id"]                  == struct.id
      assert List.last(data)["name"] |> Enum.sort() == format_field(struct.name)
      assert List.last(data)["user"]["id"]          == struct.user.id
      assert List.last(data)["user"]["email"]       == struct.user.email
      assert List.last(data)["user"]["role"]        == struct.user.role
    end

    it "returns accounting softwares - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        allAccountingSoftwares {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"allAccountingSoftwares" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                  == struct.id
      assert first["name"] |> Enum.sort() == format_field(struct.name)
      assert first["user"]["id"]          == struct.user.id
      assert first["user"]["email"]       == struct.user.email
      assert first["user"]["role"]        == struct.user.role
    end
  end

  describe "#show" do
    it "returns specific accounting software by id - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showAccountingSoftware(id: \"#{struct.id}\") {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showAccountingSoftware"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showAccountingSoftware"]

      assert found["id"]                  == struct.id
      assert found["name"] |> Enum.sort() == format_field(struct.name)
      assert found["user"]["id"]          == struct.user.id
      assert found["user"]["email"]       == struct.user.email
      assert found["user"]["role"]        == struct.user.role
    end

    it "returns specific accounting software by id - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showAccountingSoftware(id: \"#{struct.id}\") {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"showAccountingSoftware" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                  == struct.id
      assert found["name"] |> Enum.sort() == format_field(struct.name)
      assert found["user"]["id"]          == struct.user.id
      assert found["user"]["email"]       == struct.user.email
      assert found["user"]["role"]        == struct.user.role
    end

    it "returns not found when accounting software does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showAccountingSoftware(id: \"#{id}\") {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showAccountingSoftware"))

      assert hd(json_response(res, 200)["errors"])["message"] == "An AccountingSoftware #{id} not found!"
    end

    it "returns not found when accounting software does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showAccountingSoftware(id: \"#{id}\") {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"showAccountingSoftware" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showAccountingSoftware(id: nil) {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showAccountingSoftware"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showAccountingSoftware(id: nil) {
          id
          name
          user { id email role }
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#create" do
    it "creates accounting software - `AbsintheHelpers`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)

      query = """
      mutation {
        createAccountingSoftware(
          name: ["QuickBooks Desktop Premier"],
          userId: \"#{struct.id}\"
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createAccountingSoftware"]

      assert created["name"] |> Enum.sort() == ["QuickBooks Desktop Premier"]
      assert created["user"]["id"]          == struct.id
      assert created["user"]["email"]       == struct.email
      assert created["user"]["role"]        == struct.role
    end

    it "creates accounting software - `Absinthe.run`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation {
        createAccountingSoftware(
          name: ["QuickBooks Desktop Premier"],
          userId: \"#{struct.id}\"
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"createAccountingSoftware" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["name"] |> Enum.sort() == ["QuickBooks Desktop Premier"]
      assert created["user"]["id"]          == struct.id
      assert created["user"]["email"]       == struct.email
      assert created["user"]["role"]        == struct.role
    end

    it "returns null for role tp - `AbsintheHelpers`" do
      struct = insert(:tp_user)
      user = Core.Accounts.User.find_by(id: struct.id)

      query = """
      mutation {
        createAccountingSoftware(
          name: ["QuickBooks Desktop Premier"],
          userId: \"#{struct.id}\"
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createAccountingSoftware"]

      assert created == nil
    end

    it "returns null for role tp - `Absinthe.run`" do
      struct = insert(:tp_user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation {
        createAccountingSoftware(
          name: ["QuickBooks Desktop Premier"],
          userId: \"#{struct.id}\"
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"createAccountingSoftware" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)

      query = """
      mutation {
        createAccountingSoftware(
          name: [],
          userId: nil
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"userId\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation {
        createAccountingSoftware(
          name: [],
          userId: nil
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"userId\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update specific accounting software by id - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateAccountingSoftware(
          id: \"#{struct.id}\",
          accounting_software: {
            name: ["Xero HQ"],
            userId: \"#{user.id}\"
          }
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateAccountingSoftware"]

      assert updated["id"]            == struct.id
      assert updated["name"]          == ["Xero HQ"]
      assert updated["user"]["id"]    == struct.user.id
      assert updated["user"]["email"] == struct.user.email
      assert updated["user"]["role"]  == struct.user.role
    end

    it "update specific accounting software by id - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateAccountingSoftware(
          id: \"#{struct.id}\",
          accounting_software: {
            name: ["Xero HQ"],
            userId: \"#{user.id}\"
          }
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"updateAccountingSoftware" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]            == struct.id
      assert updated["name"]          == ["Xero HQ"]
      assert updated["user"]["id"]    == struct.user.id
      assert updated["user"]["email"] == struct.user.email
      assert updated["user"]["role"]  == struct.user.role
    end

    it "return error when accounting_software for missing params - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateAccountingSoftware(
          id: \"#{struct.id}\",
          accounting_software: {}
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "permission denied"
    end

    it "return error when accounting_software for missing params - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateAccountingSoftware(
          id: \"#{struct.id}\",
          accounting_software: {}
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "permission denied"
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateAccountingSoftware(
          id: nil,
          accounting_software: {
            name: [],
            userId: nil
          }
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateAccountingSoftware(
          id: nil,
          accounting_software: {
            name: [],
            userId: nil
          }
        ) {
          id
          name
          user { id email role }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#delete" do
    it "delete specific accounting software by id - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteAccountingSoftware(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteAccountingSoftware"]
      assert deleted["id"] == struct.id
    end

    it "delete specific accounting software by id - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteAccountingSoftware(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteAccountingSoftware" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when accounting software does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteAccountingSoftware(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "An AccountingSoftware #{id} not found!"
    end

    it "returns not found when accounting software does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteAccountingSoftware(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteAccountingSoftware" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteAccountingSoftware(id: nil) {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteAccountingSoftware(id: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  @spec format_field([atom()]) :: [String.t()]
  defp format_field(data) do
    Enum.reduce(data, [], fn(x, acc) ->
      [to_string(x) | acc]
    end) |> Enum.sort()
  end
end
