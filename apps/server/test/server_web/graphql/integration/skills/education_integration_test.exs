defmodule ServerWeb.GraphQL.Integration.Skills.EducationIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns educations - `AbsintheHelpers`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        allEducations {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """
      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allEducations"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allEducations"]

      assert List.first(data)["id"]                 == struct.id
      assert List.first(data)["course"]             == struct.course
      assert List.first(data)["graduation"]         == format_field(struct.graduation)
      assert List.first(data)["university"]["id"]   == struct.university.id
      assert List.first(data)["university"]["name"] == struct.university.name
      assert List.first(data)["user"]["id"]         == struct.user.id
      assert List.first(data)["user"]["email"]      == struct.user.email
      assert List.first(data)["user"]["role"]       == struct.user.role

      assert List.last(data)["id"]                 == struct.id
      assert List.last(data)["course"]             == struct.course
      assert List.last(data)["graduation"]         == format_field(struct.graduation)
      assert List.last(data)["university"]["id"]   == struct.university.id
      assert List.last(data)["university"]["name"] == struct.university.name
      assert List.last(data)["user"]["id"]         == struct.user.id
      assert List.last(data)["user"]["email"]      == struct.user.email
      assert List.last(data)["user"]["role"]       == struct.user.role
    end

    it "returns educations - `Absinthe.run`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        allEducations {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"allEducations" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                 == struct.id
      assert first["course"]             == struct.course
      assert first["graduation"]         == format_field(struct.graduation)
      assert first["university"]["id"]   == struct.university.id
      assert first["university"]["name"] == struct.university.name
      assert first["user"]["id"]         == struct.user.id
      assert first["user"]["email"]      == struct.user.email
      assert first["user"]["role"]       == struct.user.role
    end
  end

  describe "#show" do
    it "returns specific education by id - `AbsintheHelpers`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showEducation(id: \"#{struct.id}\") {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showEducation"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showEducation"]

      assert found["id"]                 == struct.id
      assert found["course"]             == struct.course
      assert found["graduation"]         == format_field(struct.graduation)
      assert found["university"]["id"]   == struct.university.id
      assert found["university"]["name"] == struct.university.name
      assert found["user"]["id"]         == struct.user.id
      assert found["user"]["email"]      == struct.user.email
      assert found["user"]["role"]       == struct.user.role
    end

    it "returns specific education by id - `Absinthe.run`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showEducation(id: \"#{struct.id}\") {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"showEducation" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                 == struct.id
      assert found["course"]             == struct.course
      assert found["graduation"]         == format_field(struct.graduation)
      assert found["university"]["id"]   == struct.university.id
      assert found["university"]["name"] == struct.university.name
      assert found["user"]["id"]         == struct.user.id
      assert found["user"]["email"]      == struct.user.email
      assert found["user"]["role"]       == struct.user.role
    end

    it "returns not found when education does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showEducation(id: \"#{id}\") {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showEducation"))

      assert hd(json_response(res, 200)["errors"])["message"] == "An Education #{id} not found!"
    end

    it "returns not found when education does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showEducation(id: \"#{id}\") {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"showEducation" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      {
        showEducation(id: nil) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showEducation"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      {
        showEducation(id: nil) {
          id
          course
          graduation
          university { id name }
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
    it "creates education - `AbsintheHelpers`" do
      pro = insert(:pro_user)
      university = insert(:university)
      user = Core.Accounts.User.find_by(id: pro.id)

      query = """
      mutation {
        createEducation(
          course: "some text",
          graduation: \"#{Date.utc_today()}\",
          universityId: \"#{university.id}\",
          userId: \"#{pro.id}\"
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createEducation"]

      assert created["course"]             == "some text"
      assert created["graduation"]         == format_field(Date.utc_today())
      assert created["university"]["id"]   == university.id
      assert created["university"]["name"] == university.name
      assert created["user"]["id"]         == pro.id
      assert created["user"]["email"]      == pro.email
      assert created["user"]["role"]       == pro.role
    end

    it "creates education - `Absinthe.run`" do
      pro = insert(:pro_user)
      university = insert(:university)
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{current_user: user}

      query = """
      mutation {
        createEducation(
          course: "some text",
          graduation: \"#{Date.utc_today()}\",
          universityId: \"#{university.id}\",
          userId: \"#{pro.id}\"
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"createEducation" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["course"]             == "some text"
      assert created["graduation"]         == format_field(Date.utc_today())
      assert created["university"]["id"]   == university.id
      assert created["university"]["name"] == university.name
      assert created["user"]["id"]         == pro.id
      assert created["user"]["email"]      == pro.email
      assert created["user"]["role"]       == pro.role
    end

    it "returns null for role tp - `AbsintheHelpers`" do
      university = insert(:university)
      pro = insert(:tp_user)
      user = Core.Accounts.User.find_by(id: pro.id)

      query = """
      mutation {
        createEducation(
          course: "some text",
          graduation: \"#{Date.utc_today()}\",
          universityId: \"#{university.id}\",
          userId: \"#{pro.id}\"
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createEducation"]

      assert created == nil
    end

    it "returns null for role tp - `Absinthe.run`" do
      university = insert(:university)
      pro = insert(:tp_user)
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{current_user: user}

      query = """
      mutation {
        createEducation(
          course: "some text",
          graduation: \"#{Date.utc_today()}\",
          universityId: \"#{university.id}\",
          userId: \"#{pro.id}\"
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"createEducation" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)

      query = """
      mutation {
        createEducation(
          course: nil,
          graduation: nil,
          universityId: nil,
          userId: nil
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"course\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:pro_user)
      user = Core.Accounts.User.find_by(id: struct.id)
      context = %{current_user: user}

      query = """
      mutation {
        createEducation(
          course: nil,
          graduation: nil,
          universityId: nil,
          userId: nil
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"course\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update specific education by id - `AbsintheHelpers`" do
      university = insert(:university)
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateEducation(
          id: \"#{struct.id}\",
          education: {
            course: "updated text",
            graduation: \"#{Date.utc_today |> Date.add(+3)}\",
            universityId: \"#{university.id}\",
            userId: \"#{user.id}\"
          }
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateEducation"]

      assert updated["id"]                 == struct.id
      assert updated["course"]             == "updated text"
      assert updated["graduation"]         == format_field(Date.utc_today |> Date.add(+3))
      assert updated["university"]["id"]   == university.id
      assert updated["university"]["name"] == university.name
      assert updated["user"]["id"]         == struct.user.id
      assert updated["user"]["email"]      == struct.user.email
      assert updated["user"]["role"]       == struct.user.role
    end

    it "update specific education by id - `Absinthe.run`" do
      university = insert(:university)
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateEducation(
          id: \"#{struct.id}\",
          education: {
            course: "updated text",
            graduation: \"#{Date.utc_today |> Date.add(+3)}\",
            universityId: \"#{university.id}\",
            userId: \"#{user.id}\"
          }
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{data: %{"updateEducation" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]                 == struct.id
      assert updated["course"]             == "updated text"
      assert updated["graduation"]         == format_field(Date.utc_today |> Date.add(+3))
      assert updated["university"]["id"]   == university.id
      assert updated["university"]["name"] == university.name
      assert updated["user"]["id"]         == struct.user.id
      assert updated["user"]["email"]      == struct.user.email
      assert updated["user"]["role"]       == struct.user.role
    end

    it "return error when title for missing params - `AbsintheHelpers`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateEducation(
          id: \"#{struct.id}\",
          education: {}
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"education\" has invalid value {}.\nIn field \"userId\": Expected type \"String!\", found null.\nIn field \"universityId\": Expected type \"String!\", found null.\nIn field \"graduation\": Expected type \"Date!\", found null.\nIn field \"course\": Expected type \"String!\", found null."
    end

    it "return error when title for missing params - `Absinthe.run`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateEducation(
          id: \"#{struct.id}\",
          education: {}
        ) {
          id
          course
          graduation
          university { id name }
          user { id email role }
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"education\" has invalid value {}.\nIn field \"userId\": Expected type \"String!\", found null.\nIn field \"universityId\": Expected type \"String!\", found null.\nIn field \"graduation\": Expected type \"Date!\", found null.\nIn field \"course\": Expected type \"String!\", found null."
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        updateEducation(
          id: nil,
          education: {
            course: nil,
            graduation: nil,
            universityId: nil,
            userId: nil
          }
        ) {
          id
          course
          graduation
          university { id name }
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
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        updateEducation(
          id: nil,
          education: {
            course: nil,
            graduation: nil,
            universityId: nil,
            userId: nil
          }
        ) {
          id
          course
          graduation
          university { id name }
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
    it "delete specific education by id - `AbsintheHelpers`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteEducation(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteEducation"]
      assert deleted["id"] == struct.id
    end

    it "delete specific education by id - `Absinthe.run`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteEducation(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteEducation" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when education does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteEducation(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "An Education #{id} not found!"
    end

    it "returns not found when education does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteEducation(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteEducation" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)

      query = """
      mutation {
        deleteEducation(id: nil) {id}
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{current_user: user}

      query = """
      mutation {
        deleteEducation(id: nil) {id}
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
