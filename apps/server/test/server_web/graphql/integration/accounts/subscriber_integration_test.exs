defmodule ServerWeb.GraphQL.Integration.Accounts.SubscriberIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns accounts subscriberi - `AbsintheHelpers`" do
      struct = insert(:subscriber)

      query = """
      {
        allSubscribers{
          id
          email
          pro_role
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allSubscribers"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allSubscribers"]

      assert List.first(data)["id"]          == struct.id
      assert List.first(data)["email"]       == struct.email
      assert List.first(data)["pro_role"]    == struct.pro_role

      assert List.last(data)["id"]          == struct.id
      assert List.last(data)["email"]       == struct.email
      assert List.last(data)["pro_role"]    == struct.pro_role
    end

    it "returns accounts subscriberi - `Absinthe.run`" do
      struct = insert(:subscriber)
      context = %{}

      query = """
      {
        allSubscribers{
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{data: %{"allSubscribers" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct.id
      assert first["email"]       == struct.email
      assert first["pro_role"]    == struct.pro_role
    end
  end

  describe "#show" do
    it "returns specific accounts subscriber by id - `AbsintheHelpers`" do
      struct = insert(:subscriber)

      query = """
      {
        showSubscriber(id: \"#{struct.id}\") {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSubscriber"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showSubscriber"]

      assert found["id"]          == struct.id
      assert found["email"]       == struct.email
      assert found["pro_role"]    == struct.pro_role
    end

    it "returns specific accounts subscriber by id - `Absinthe.run`" do
      struct = insert(:subscriber)
      context = %{}

      query = """
      {
        showSubscriber(id: \"#{struct.id}\") {
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{data: %{"showSubscriber" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["email"]       == struct.email
      assert found["pro_role"]    == struct.pro_role
    end

    it "returns not found when accounts subscriber does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()

      query = """
      {
        showSubscriber(id: \"#{id}\") {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSubscriber"))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Subscriber #{id} not found!"
    end

    it "returns not found when accounts subscriber does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      context = %{}

      query = """
      {
        showSubscriber(id: \"#{id}\") {
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{data: %{"showSubscriber" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      {
        showSubscriber(id: nil) {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showSubscriber"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#create" do
    it "creates accounts subscriber - `AbsintheHelpers`" do
      query = """
      mutation {
        createSubscriber(
          email: "lugatex@yahoo.com",
          pro_role: false
        ) {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createSubscriber"]

      assert created["email"]    == "lugatex@yahoo.com"
      assert created["pro_role"] == false
    end

    it "creates accounts subscriber - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createSubscriber(
          email: "lugatex@yahoo.com",
          pro_role: false
        ) {
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{data: %{"createSubscriber" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["email"]    == "lugatex@yahoo.com"
      assert created["pro_role"] == false
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createSubscriber(
          email: nil,
          pro_role: nil
        ) {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"email\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        createSubscriber(
          email: nil,
          pro_role: nil
        ) {
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"email\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update specific accounts subscriber by id - `AbsintheHelpers`" do
      struct = insert(:subscriber)

      query = """
      mutation {
        updateSubscriber(
          id: \"#{struct.id}\",
          subscriber: {
            email: "kapranov.lugatex@gmail.com",
            pro_role: true
          }
        ) {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSubscriber"]

      assert updated["id"]          == struct.id
      assert updated["email"]       == "kapranov.lugatex@gmail.com"
      assert updated["pro_role"]    == true
    end

    it "update specific accounts subscriber by id - `Absinthe.run`" do
      struct = insert(:subscriber)
      context = %{}

      query = """
      mutation {
        updateSubscriber(
          id: \"#{struct.id}\",
          subscriber: {
            email: "kapranov.lugatex@gmail.com",
            pro_role: true
          }
        ) {
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{data: %{"updateSubscriber" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct.id
      assert updated["email"]       == "kapranov.lugatex@gmail.com"
      assert updated["pro_role"]    == true
    end

    it "nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:subscriber)

      query = """
      mutation {
        updateSubscriber(
          id: \"#{struct.id}\",
          subscriber: {}
        ) {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateSubscriber"]

      assert updated["id"]          == struct.id
      assert updated["email"]       == struct.email
      assert updated["pro_role"]    == struct.pro_role
    end

    it "nothing change for missing params - `Absinthe.run`" do
      struct = insert(:subscriber)
      context = %{}

      query = """
      mutation {
        updateSubscriber(
          id: \"#{struct.id}\",
          subscriber: {}
        ) {
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{data: %{"updateSubscriber" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]          == struct.id
      assert updated["email"]       == struct.email
      assert updated["pro_role"]    == struct.pro_role
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        updateSubscriber(
          id: nil,
          subscriber: {
            email: "kapranov.lugatex@gmail.com",
            pro_role: true
          }
        ) {
          id
          email
          pro_role
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        updateSubscriber(
          id: nil,
          subscriber: {
            email: "kapranov.lugatex@gmail.com",
            pro_role: true
          }
        ) {
          id
          email
          pro_role
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#delete" do
    it "delete specific accounts subscriber by id - `AbsintheHelpers`" do
      struct = insert(:subscriber)

      query = """
      mutation {
        deleteSubscriber(email: \"#{struct.email}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteSubscriber"]
      assert deleted["id"] == struct.id
    end

    it "delete specific accounts subscriber by id - `Absinthe.run`" do
      struct = insert(:subscriber)
      context = %{}

      query = """
      mutation {
        deleteSubscriber(email: \"#{struct.email}\") {id}
      }
      """

      {:ok, %{data: %{"deleteSubscriber" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when accounts subscriber does not exist - ``AbsintheHelpers`" do
      email = "xxx"

      query = """
      mutation {
        deleteSubscriber(email: \"#{email}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Subscriber #{email} not found!"
    end

    it "returns not found when accounts subscriber does not exist - ``Absinthe.run`" do
      email = "xxx"
      context = %{}

      query = """
      mutation {
        deleteSubscriber(email: \"#{email}\") {id}
      }
      """

      {:ok, %{data: %{"deleteSubscriber" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        deleteSubscriber(email: nil) {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"email\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        deleteSubscriber(email: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"email\" has invalid value nil."
    end
  end
end
