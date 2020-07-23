defmodule ServerWeb.GraphQL.Integration.Skills.WorkExperienceIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns work experiences - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        allWorkExperiences {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """
      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allWorkExperiences"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allWorkExperiences"]

      assert List.first(data)["id"]            == struct.id
      assert List.first(data)["name"]          == struct.name
      assert List.first(data)["start_date"]    == format_field(struct.start_date)
      assert List.first(data)["end_date"]      == format_field(struct.end_date)
      assert List.first(data)["user"]["id"]    == struct.user.id
      assert List.first(data)["user"]["email"] == struct.user.email
      assert List.first(data)["user"]["role"]  == struct.user.role

      assert List.last(data)["id"]            == struct.id
      assert List.last(data)["name"]          == struct.name
      assert List.last(data)["start_date"]    == format_field(struct.start_date)
      assert List.last(data)["end_date"]      == format_field(struct.end_date)
      assert List.last(data)["user"]["id"]    == struct.user.id
      assert List.last(data)["user"]["email"] == struct.user.email
      assert List.last(data)["user"]["role"]  == struct.user.role
    end

    it "returns work experience - `Absinthe.run`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        allWorkExperiences {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"allWorkExperiences" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]            == struct.id
      assert first["name"]          == struct.name
      assert first["start_date"]    == format_field(struct.start_date)
      assert first["end_date"]      == format_field(struct.end_date)
      assert first["user"]["id"]    == struct.user.id
      assert first["user"]["email"] == struct.user.email
      assert first["user"]["role"]  == struct.user.role
    end
  end

  describe "#show" do
    it "returns specific work experience by id - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showWorkExperience(id: \"#{struct.id}\") {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showWorkExperience"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showWorkExperience"]

      assert found["id"]            == struct.id
      assert found["name"]          == struct.name
      assert found["start_date"]    == format_field(struct.start_date)
      assert found["end_date"]      == format_field(struct.end_date)
      assert found["user"]["id"]    == struct.user.id
      assert found["user"]["email"] == struct.user.email
      assert found["user"]["role"]  == struct.user.role
    end

    it "returns specific work experience by id - `Absinthe.run`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showWorkExperience(id: \"#{struct.id}\") {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"showWorkExperience" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]            == struct.id
      assert found["name"]          == struct.name
      assert found["start_date"]    == format_field(struct.start_date)
      assert found["end_date"]      == format_field(struct.end_date)
      assert found["user"]["id"]    == struct.user.id
      assert found["user"]["email"] == struct.user.email
      assert found["user"]["role"]  == struct.user.role
    end

    it "returns not found when work experience does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showWorkExperience(id: \"#{id}\") {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showWorkExperience"))

      assert hd(json_response(res, 200)["errors"])["message"] == "A WorkExperience #{id} not found!"
    end

    it "returns not found when work experience does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showWorkExperience(id: \"#{id}\") {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"showWorkExperience" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showWorkExperience(id: nil) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showWorkExperience"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showWorkExperience(id: nil) {
          id
          name
          start_date
          end_date
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
    it "creates work experience - `AbsintheHelpers`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)

      query = """
      mutation {
        createWorkExperience(
          name: "some text",
          start_date: \"#{Date.utc_today()}\",
          end_date: \"#{Date.utc_today |> Date.add(+6)}\",
          userId: \"#{struct.id}\"
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createWorkExperience"]

      assert created["name"]           == "some text"
      assert created["start_date"]     == format_field(Date.utc_today())
      assert created["end_date"]       == format_field(Date.utc_today |> Date.add(+6))
      assert created["user"]["id"]     == struct.id
      assert created["user"]["email"]  == struct.email
      assert created["user"]["role"]   == struct.role
    end

    it "creates work experience - `Absinthe.run`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation {
        createWorkExperience(
          name: "some text",
          start_date: \"#{Date.utc_today()}\",
          end_date: \"#{Date.utc_today |> Date.add(+6)}\",
          userId: \"#{struct.id}\"
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"createWorkExperience" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["name"]           == "some text"
      assert created["start_date"]     == format_field(Date.utc_today())
      assert created["end_date"]       == format_field(Date.utc_today |> Date.add(+6))
      assert created["user"]["id"]     == struct.id
      assert created["user"]["email"]  == struct.email
      assert created["user"]["role"]   == struct.role
    end

    it "returns null for role tp - `AbsintheHelpers`" do
      struct = insert(:tp_user)
      user = Core.Accounts.User.find_by(id: struct.id)

      query = """
      mutation {
        createWorkExperience(
          name: "some text",
          start_date: \"#{Date.utc_today()}\",
          end_date: \"#{Date.utc_today |> Date.add(+6)}\",
          userId: \"#{struct.id}\"
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createWorkExperience"]

      assert created == nil
    end

    it "returns null for role tp - `Absinthe.run`" do
      struct = insert(:tp_user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation {
        createWorkExperience(
          name: "some text",
          start_date: \"#{Date.utc_today()}\",
          end_date: \"#{Date.utc_today |> Date.add(+6)}\",
          userId: \"#{struct.id}\"
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"createWorkExperience" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)

      query = """
      mutation {
        createWorkExperience(
          name: nil,
          start_date: nil,
          end_date: nil,
          userId: nil
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"name\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation {
        createWorkExperience(
          name: nil,
          start_date: nil,
          end_date: nil,
          userId: nil
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"name\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update work experience by id - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateWorkExperience(
          id: \"#{struct.id}\",
          work_experience: {
            name: "updated text",
            start_date: \"#{Date.utc_today |> Date.add(+3)}\",
            end_date: \"#{Date.utc_today |> Date.add(+6)}\",
            userId: \"#{user.id}\"
          }
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateWorkExperience"]

      assert updated["id"]            == struct.id
      assert updated["name"]          == "updated text"
      assert updated["start_date"]    == format_field(Date.utc_today |> Date.add(+3))
      assert updated["end_date"]      == format_field(Date.utc_today |> Date.add(+6))
      assert updated["user"]["id"]    == struct.user.id
      assert updated["user"]["email"] == struct.user.email
      assert updated["user"]["role"]  == struct.user.role
    end

    it "update specific work experience by id - `Absinthe.run`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateWorkExperience(
          id: \"#{struct.id}\",
          work_experience: {
            name: "updated text",
            start_date: \"#{Date.utc_today |> Date.add(+3)}\",
            end_date: \"#{Date.utc_today |> Date.add(+6)}\",
            userId: \"#{user.id}\"
          }
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"updateWorkExperience" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]            == struct.id
      assert updated["name"]          == "updated text"
      assert updated["start_date"]    == format_field(Date.utc_today |> Date.add(+3))
      assert updated["end_date"]      == format_field(Date.utc_today |> Date.add(+6))
      assert updated["user"]["id"]    == struct.user.id
      assert updated["user"]["email"] == struct.user.email
      assert updated["user"]["role"]  == struct.user.role
    end

    it "return error when title for missing params - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateWorkExperience(
          id: \"#{struct.id}\",
          work_experience: {}
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"work_experience\" has invalid value {}.\nIn field \"userId\": Expected type \"String!\", found null.\nIn field \"startDate\": Expected type \"Date!\", found null.\nIn field \"name\": Expected type \"String!\", found null.\nIn field \"endDate\": Expected type \"Date!\", found null."
    end

    it "return error when title for missing params - `Absinthe.run`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateWorkExperience(
          id: \"#{struct.id}\",
          work_experience: {}
        ) {
          id
          name
          start_date
          end_date
          user { id email role }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"work_experience\" has invalid value {}.\nIn field \"userId\": Expected type \"String!\", found null.\nIn field \"startDate\": Expected type \"Date!\", found null.\nIn field \"name\": Expected type \"String!\", found null.\nIn field \"endDate\": Expected type \"Date!\", found null."
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateWorkExperience(
          id: nil,
          work_experience: {
          name: nil,
          start_date: nil,
          end_date: nil,
          userId: nil
          }
        ) {
          id
          name
          start_date
          end_date
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
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateWorkExperience(
          id: nil,
          work_experience: {
          name: nil,
          start_date: nil,
          end_date: nil,
          userId: nil
          }
        ) {
          id
          name
          start_date
          end_date
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
    it "delete specific work experience by id - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteWorkExperience(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteWorkExperience"]
      assert deleted["id"] == struct.id
    end

    it "delete specific work experience by id - `Absinthe.run`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteWorkExperience(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteWorkExperience" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when work experience does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteWorkExperience(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "A WorkExperience #{id} not found!"
    end

    it "returns not found when work experience does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:WorkExperience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteWorkExperience(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteWorkExperience" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteWorkExperience(id: nil) {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteWorkExperience(id: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  @spec format_field(atom()) :: String.t()
  defp format_field(data), do: to_string(data)
end
