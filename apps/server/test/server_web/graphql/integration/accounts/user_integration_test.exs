defmodule ServerWeb.GraphQL.Integration.Accounts.UserIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns accounts an user - `AbsintheHelpers`" do
      struct = insert(:user)

      query = """
      {
        allUsers{
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allUsers"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allUsers"]

      assert List.first(data)["id"]                 == struct.id
      assert List.first(data)["active"]             == struct.active
      assert List.first(data)["avatar"]             == struct.avatar
      assert List.first(data)["bio"]                == struct.bio
      assert List.first(data)["birthday"]           == "#{struct.birthday}"
      assert List.first(data)["email"]              == struct.email
      assert List.first(data)["first_name"]         == struct.first_name
      assert List.first(data)["init_setup"]         == struct.init_setup
      assert List.first(data)["last_name"]          == struct.last_name
      assert List.first(data)["middle_name"]        == struct.middle_name
      assert List.first(data)["phone"]              == struct.phone
      assert List.first(data)["provider"]           == struct.provider
      assert List.first(data)["role"]               == struct.role
      assert List.first(data)["sex"]                == struct.sex
      assert List.first(data)["ssn"]                == struct.ssn
      assert List.first(data)["street"]             == struct.street
      assert List.first(data)["zip"]                == struct.zip
      assert List.last(data)["languages"] |> length == 1

      assert List.last(data)["id"]                  == struct.id
      assert List.last(data)["active"]              == struct.active
      assert List.last(data)["avatar"]              == struct.avatar
      assert List.last(data)["bio"]                 == struct.bio
      assert List.last(data)["birthday"]            == "#{struct.birthday}"
      assert List.last(data)["email"]               == struct.email
      assert List.last(data)["first_name"]          == struct.first_name
      assert List.last(data)["init_setup"]          == struct.init_setup
      assert List.last(data)["last_name"]           == struct.last_name
      assert List.last(data)["middle_name"]         == struct.middle_name
      assert List.last(data)["phone"]               == struct.phone
      assert List.last(data)["provider"]            == struct.provider
      assert List.last(data)["role"]                == struct.role
      assert List.last(data)["sex"]                 == struct.sex
      assert List.last(data)["ssn"]                 == struct.ssn
      assert List.last(data)["street"]              == struct.street
      assert List.last(data)["zip"]                 == struct.zip
      assert List.last(data)["languages"] |> length == 1
    end

    it "returns accounts an user - `Absinthe.run`" do
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      {
        allUsers{
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{data: %{"allUsers" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]                  == struct.id
      assert first["active"]              == struct.active
      assert first["avatar"]              == struct.avatar
      assert first["bio"]                 == struct.bio
      assert first["birthday"]            == to_string(struct.birthday)
      assert first["email"]               == struct.email
      assert first["first_name"]          == struct.first_name
      assert first["init_setup"]          == struct.init_setup
      assert first["last_name"]           == struct.last_name
      assert first["middle_name"]         == struct.middle_name
      assert first["phone"]               == struct.phone
      assert first["provider"]            == struct.provider
      assert first["role"]                == struct.role
      assert first["sex"]                 == struct.sex
      assert first["ssn"]                 == struct.ssn
      assert first["street"]              == struct.street
      assert first["zip"]                 == struct.zip
      assert first["languages"] |> length == 1
    end
  end

  describe "#show" do
    it "returns specific accounts an user by id - `AbsintheHelpers`" do
      struct = insert(:user)

      query = """
      {
        showUser(id: \"#{struct.id}\") {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUser"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showUser"]

      assert found["id"]                  == struct.id
      assert found["active"]              == struct.active
      assert found["avatar"]              == struct.avatar
      assert found["bio"]                 == struct.bio
      assert found["birthday"]            == "#{struct.birthday}"
      assert found["email"]               == struct.email
      assert found["first_name"]          == struct.first_name
      assert found["init_setup"]          == struct.init_setup
      assert found["last_name"]           == struct.last_name
      assert found["middle_name"]         == struct.middle_name
      assert found["phone"]               == struct.phone
      assert found["provider"]            == struct.provider
      assert found["role"]                == struct.role
      assert found["sex"]                 == struct.sex
      assert found["ssn"]                 == struct.ssn
      assert found["street"]              == struct.street
      assert found["zip"]                 == struct.zip
      assert found["languages"] |> length == 1
    end

    it "returns specific accounts an user by id - `Absinthe.run`" do
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      {
        showUser(id: \"#{struct.id}\") {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{data: %{"showUser" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]                  == struct.id
      assert found["active"]              == struct.active
      assert found["avatar"]              == struct.avatar
      assert found["bio"]                 == struct.bio
      assert found["birthday"]            == "#{struct.birthday}"
      assert found["email"]               == struct.email
      assert found["first_name"]          == struct.first_name
      assert found["init_setup"]          == struct.init_setup
      assert found["last_name"]           == struct.last_name
      assert found["middle_name"]         == struct.middle_name
      assert found["phone"]               == struct.phone
      assert found["provider"]            == struct.provider
      assert found["role"]                == struct.role
      assert found["sex"]                 == struct.sex
      assert found["ssn"]                 == struct.ssn
      assert found["street"]              == struct.street
      assert found["zip"]                 == struct.zip
      assert found["languages"] |> length == 1
    end

    it "returns not found when accounts an user does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:user)

      query = """
      {
        showUser(id: \"#{id}\") {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUser"))

      assert hd(json_response(res, 200)["errors"])["message"] == "permission denied"
    end

    it "returns not found when accounts an user does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      {
        showUser(id: \"#{id}\") {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{data: %{"showUser" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:user)

      query = """
      {
        showUser(id: nil) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUser"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      {
        showUser(id: nil) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#create" do
    it "creates accounts an user - `AbsintheHelpers`" do
      lang = insert(:language)

      query = """
      mutation {
        createUser(
          active: false,
          avatar: "some text",
          bio: "some text",
          birthday: \"#{Timex.today}\",
          email: "lugatex@yahoo.com",
          first_name: "some text",
          init_setup: false,
          languages: \"#{lang.name}\",
          last_name: "some text",
          middle_name: "some text",
          password: "qwerty",
          password_confirmation: "qwerty",
          phone: "555-555-5555",
          provider: "google",
          role: false,
          sex: "some text",
          ssn: 123456789,
          street: "some text",
          zip: 123456789
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createUser"]

      assert created["active"]              == false
      assert created["avatar"]              == "some text"
      assert created["bio"]                 == "some text"
      assert created["birthday"]            == "#{Timex.today}"
      assert created["email"]               == "lugatex@yahoo.com"
      assert created["first_name"]          == "some text"
      assert created["init_setup"]          == false
      assert created["last_name"]           == "some text"
      assert created["middle_name"]         == "some text"
      assert created["phone"]               == "555-555-5555"
      assert created["provider"]            == "google"
      assert created["role"]                == false
      assert created["sex"]                 == "some text"
      assert created["ssn"]                 == 123456789
      assert created["street"]              == "some text"
      assert created["zip"]                 == 123456789
      assert created["languages"] |> length == 1
    end

    it "creates accounts an user - `Absinthe.run`" do
      lang = insert(:language)
      context = %{}

      query = """
      mutation{
        createUser(
          active: false,
          avatar: "some text",
          bio: "some text",
          birthday: \"#{Timex.today}\",
          email: "lugatex@yahoo.com",
          first_name: "some text",
          init_setup: false,
          languages: \"#{lang.name}\",
          last_name: "some text",
          middle_name: "some text",
          password: "qwerty",
          password_confirmation: "qwerty",
          phone: "555-555-5555",
          provider: "google",
          role: false,
          sex: "some text",
          ssn: 123456789,
          street: "some text",
          zip: 123456789
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{data: %{"createUser" => created}}} = Absinthe.run(query, Schema, context: context)

      assert created["active"]              == false
      assert created["avatar"]              == "some text"
      assert created["bio"]                 == "some text"
      assert created["birthday"]            == "#{Timex.today}"
      assert created["email"]               == "lugatex@yahoo.com"
      assert created["first_name"]          == "some text"
      assert created["init_setup"]          == false
      assert created["last_name"]           == "some text"
      assert created["middle_name"]         == "some text"
      assert created["phone"]               == "555-555-5555"
      assert created["provider"]            == "google"
      assert created["role"]                == false
      assert created["sex"]                 == "some text"
      assert created["ssn"]                 == 123456789
      assert created["street"]              == "some text"
      assert created["zip"]                 == 123456789
      assert created["languages"] |> length == 1
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      query = """
      mutation {
        createUser(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: nil
        ) {
          email
          provider
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
      mutation{
        createUser(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: nil
        ) {
          email
          provider
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"email\" has invalid value nil."
    end
  end

  describe "#update" do
    it "update specific accounts an user by id - `AbsintheHelpers`" do
      lang = insert(:language)
      struct = insert(:user)

      query = """
      mutation {
        updateUser(
          id: \"#{struct.id}\",
          user: {
            active: true,
            avatar: "updated text",
            bio: "updated text",
            birthday: \"#{Timex.today}\",
            email: "kapranov.lugatex@gmail.com",
            first_name: "updated text",
            init_setup: true,
            languages: \"#{lang.name}\",
            last_name: "updated text",
            middle_name: "updated text",
            password: "qwertyyy",
            password_confirmation: "qwertyyy",
            phone: "999-999-9999",
            provider: "facebook",
            role: true,
            sex: "updated text",
            ssn: 987654321,
            street: "updated text",
            zip: 987654321
          }
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateUser"]

      assert updated["id"]                  == struct.id
      assert updated["active"]              == true
      assert updated["avatar"]              == "updated text"
      assert updated["bio"]                 == "updated text"
      assert updated["birthday"]            == "#{Timex.today}"
      assert updated["email"]               == "kapranov.lugatex@gmail.com"
      assert updated["first_name"]          == "updated text"
      assert updated["init_setup"]          == true
      assert updated["last_name"]           == "updated text"
      assert updated["middle_name"]         == "updated text"
      assert updated["phone"]               == "999-999-9999"
      assert updated["provider"]            == "facebook"
      assert updated["role"]                == true
      assert updated["sex"]                 == "updated text"
      assert updated["ssn"]                 == 987654321
      assert updated["street"]              == "updated text"
      assert updated["zip"]                 == 987654321
      assert updated["languages"] |> length == 1
    end

    it "update specific accounts an user by id - `Absinthe.run`" do
      lang = insert(:language)
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      mutation{
        updateUser(
          id: \"#{struct.id}\",
          user: {
            active: true,
            avatar: "updated text",
            bio: "updated text",
            birthday: \"#{Timex.today}\",
            email: "kapranov.lugatex@gmail.com",
            first_name: "updated text",
            init_setup: true,
            languages: \"#{lang.name}\",
            last_name: "updated text",
            middle_name: "updated text",
            password: "qwertyyy",
            password_confirmation: "qwertyyy",
            phone: "999-999-9999",
            provider: "facebook",
            role: true,
            sex: "updated text",
            ssn: 987654321,
            street: "updated text",
            zip: 987654321
          }
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{data: %{"updateUser" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated["id"]                  == struct.id
      assert updated["active"]              == true
      assert updated["avatar"]              == "updated text"
      assert updated["bio"]                 == "updated text"
      assert updated["birthday"]            == to_string(Timex.today)
      assert updated["email"]               == "kapranov.lugatex@gmail.com"
      assert updated["first_name"]          == "updated text"
      assert updated["init_setup"]          == true
      assert updated["last_name"]           == "updated text"
      assert updated["middle_name"]         == "updated text"
      assert updated["phone"]               == "999-999-9999"
      assert updated["provider"]            == "facebook"
      assert updated["role"]                == true
      assert updated["sex"]                 == "updated text"
      assert updated["ssn"]                 == 987654321
      assert updated["street"]              == "updated text"
      assert updated["zip"]                 == 987654321
      assert updated["languages"] |> length == 1
    end

    it "nothing change for missing params - `AbsintheHelpers`" do
      struct = insert(:user)

      query = """
      mutation {
        updateUser(
          id: \"#{struct.id}\",
          user: {}
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Can't be blank"
    end

    it "nothing change for missing params - `Absinthe.run`" do
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      mutation {
        updateUser(
          id: \"#{struct.id}\",
          user: {}
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{data: %{"updateUser" => updated}}} =
        Absinthe.run(query, Schema, context: context)

      assert updated == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:user)

      query = """
      mutation {
        updateUser(
          id: nil,
          user: {}
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      mutation {
        updateUser(
          id: nil,
          user: {}
        ) {
          id
          active
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name}
          last_name
          middle_name
          phone
          provider
          role
          sex
          ssn
          street
          zip
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#delete" do
    it "delete specific accounts an user by id - `AbsintheHelpers`" do
      struct = insert(:user)

      query = """
      mutation {
        deleteUser(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteUser"]
      assert deleted["id"] == struct.id
    end

    it "delete specific accounts an user by id - `Absinthe.run`" do
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      mutation {
        deleteUser(id: \"#{struct.id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteUser" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted["id"] == struct.id
    end

    it "returns not found when accounts an user does not exist - `AbsintheHelpers`" do
      id = FlakeId.get()
      struct = insert(:user)

      query = """
      mutation {
        deleteUser(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "permission denied"
    end

    it "returns not found when accounts an user does not exist - `Absinthe.run`" do
      id = FlakeId.get()
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      mutation {
        deleteUser(id: \"#{id}\") {id}
      }
      """

      {:ok, %{data: %{"deleteUser" => deleted}}} =
        Absinthe.run(query, Schema, context: context)

      assert deleted == nil
    end

    it "returns error for missing params - `AbsintheHelpers`" do
      struct = insert(:user)

      query = """
      mutation {
        deleteUser(id: nil) {id}
      }
      """

      res =
        build_conn()
        |> auth_conn(struct)
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"id\" has invalid value nil."
    end

    it "returns error for missing params - `Absinthe.run`" do
      struct = insert(:user)
      context = %{current_user: struct}

      query = """
      mutation {
        deleteUser(id: nil) {id}
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"id\" has invalid value nil."
    end
  end

  describe "#get_code" do
    it "return code by google - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: "google") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     =~ "https://accounts.google.com/o/oauth2/v2/auth?"
      assert found["provider"] == "google"
    end

    it "return code by google - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: "google") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     =~ "https://accounts.google.com/o/oauth2/v2/auth?"
      assert found["provider"] == "google"
    end

    it "return code by linkedin - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: "linkedin") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     =~ "https://www.linkedin.com/oauth/v2/authorization?"
      assert found["provider"] == "linkedin"
    end

    it "return code by linkedin - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: "linkedin") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     =~ "https://www.linkedin.com/oauth/v2/authorization?"
      assert found["provider"] == "linkedin"
    end

    it "return code by facebook - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: "facebook") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     =~ "https://www.facebook.com/v6.0/dialog/oauth?"
      assert found["provider"] == "facebook"
    end

    it "return code by facebook - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: "facebook") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] =~ "https://www.facebook.com/v6.0/dialog/oauth?"
    end

    it "return code by twitter - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: "twitter") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     == "ok"
      assert found["provider"] == "twitter"
    end

    it "return code by twitter - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: "twitter") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     == "ok"
      assert found["provider"] == "twitter"
    end

    it "return null by localhost - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: "localhost") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     == nil
      assert found["provider"] == "localhost"
    end

    it "return null by localhost - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: "localhost") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     == nil
      assert found["provider"] == "localhost"
    end

    it "return null when provider is nil - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: nil) {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"provider\" has invalid value nil."

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     == nil
      assert found["provider"] == nil
    end

    it "return null when provider is nil - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: nil) {
          code
          provider
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"provider\" has invalid value nil."
    end

    it "return null when provider isn't exist - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: "xxx") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     == nil
      assert found["provider"] == "xxx"
    end

    it "return null when provider isn't exist - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: "xxx") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     == nil
      assert found["provider"] == "xxx"
    end

    it "return null when string is blank - `AbsintheHelpers`" do
      query = """
      {
        getCode(provider: "") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"]     == nil
      assert found["provider"] == ""
    end

    it "return null when string is blank - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getCode(provider: "") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     == nil
      assert found["provider"] == ""
    end
  end

  describe "#get_token" do
    it "return token by google - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: "google", code: "ok_code") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "3570"
      assert found["id_token"]          == "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3ZDU1ZmY0ZTEwOTkxZDZiMGVmZDM5MmI5MWEzM2U1NGMwZTIxOGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyMDA5MzI5NjI2MjE1NzU4MTgiLCJlbWFpbCI6ImthcHJhbm92Lmx1Z2F0ZXhAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJYY3p0RVZCTTI1VUFFRkZyYWpyR3lBIiwibmFtZSI6IkthcHJhbm92IE9sZWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2ctbEl3VEZYVnFUZXFBUWEzbGJVV01HSXAwS3RzQkZFeHV4WTdlPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkthcHJhbm92IiwiZmFtaWx5X25hbWUiOiJPbGVnIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE1ODMwODIzMDMsImV4cCI6MTU4MzA4NTkwM30.jb20PuqB2-ZqMCALYi9t2iKxiCgaYxh5ccjSzmLoS_GkxpegtVu0GnGocbHifieJCrU4K-XpjWkFtSaL9mOmVVWQXnUtXuZKIoPDQFRsD3WMlmCmXAw-fLf_cMGZqf2FbEu1uSvIWrgRIXhnZHfaGXJDp3_kWPyU-5bBNrzdSTmMmnVf2kr5b-lMHueNikTHRk2ovFn6HV_NZX318LV8Yf5EU68j-tWIEIL3IrloFTN0c7zvqIT77S2oY473fNUmRQQJ-ch9myyHMpOExm85t1duYWp8oDVScM9d3P09s_qIDAtxQAUldYjc6eszAVdfd5jPafH-5VEDq_CcYr7peA"
      assert found["provider"]          == "google"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == "openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"
      assert found["token_type"]        == "Bearer"
    end

    it "return token by google - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: "google", code: "ok_code") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "3570"
      assert found["id_token"]          == "eyJhbGciOiJSUzI1NiIsImtpZCI6IjE3ZDU1ZmY0ZTEwOTkxZDZiMGVmZDM5MmI5MWEzM2U1NGMwZTIxOGIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2NzAxMTY3MDA4MDMtYjc2bmh1Y2Z2dGJjaTFjOWN1cmE2OXY1NnZmaml0YWQuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgyMDA5MzI5NjI2MjE1NzU4MTgiLCJlbWFpbCI6ImthcHJhbm92Lmx1Z2F0ZXhAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJYY3p0RVZCTTI1VUFFRkZyYWpyR3lBIiwibmFtZSI6IkthcHJhbm92IE9sZWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EtL0FPaDE0R2ctbEl3VEZYVnFUZXFBUWEzbGJVV01HSXAwS3RzQkZFeHV4WTdlPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkthcHJhbm92IiwiZmFtaWx5X25hbWUiOiJPbGVnIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE1ODMwODIzMDMsImV4cCI6MTU4MzA4NTkwM30.jb20PuqB2-ZqMCALYi9t2iKxiCgaYxh5ccjSzmLoS_GkxpegtVu0GnGocbHifieJCrU4K-XpjWkFtSaL9mOmVVWQXnUtXuZKIoPDQFRsD3WMlmCmXAw-fLf_cMGZqf2FbEu1uSvIWrgRIXhnZHfaGXJDp3_kWPyU-5bBNrzdSTmMmnVf2kr5b-lMHueNikTHRk2ovFn6HV_NZX318LV8Yf5EU68j-tWIEIL3IrloFTN0c7zvqIT77S2oY473fNUmRQQJ-ch9myyHMpOExm85t1duYWp8oDVScM9d3P09s_qIDAtxQAUldYjc6eszAVdfd5jPafH-5VEDq_CcYr7peA"
      assert found["provider"]          == "google"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == "openid https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile"
      assert found["token_type"]        == "Bearer"
    end

    it "return token by linkedin - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: "linkedin", code: "ok_code") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "5183999"
      assert found["id_token"]          == nil
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return token by linkedin - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: "linkedin", code: "ok_code") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """
      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "5183999"
      assert found["id_token"]          == nil
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return token by facebook - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: "facebook", code: "ok_code") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      =~ "EAAJ3B40DJTcBAP83UjtPGyvS7e9GdVUFSxvZB0VZCdcPUqnOq"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "5156727"
      assert found["id_token"]          == nil
      assert found["provider"]          == "facebook"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return token by facebook - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: "facebook", code: "ok_code") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      =~ "EAAJ3B40DJTcBAP83UjtPGyvS7e9GdVUFSxvZB0VZCdcPUqnOq"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "5156727"
      assert found["id_token"]          == nil
      assert found["provider"]          == "facebook"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return token by twitter - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: "twitter") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "twitter"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return token by twitter - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: "twitter") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "twitter"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null token by localhost - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: "localhost") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "localhost"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null token by localhost - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: "localhost") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "localhost"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider isn't exist - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: "xxx") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "xxx"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider isn't exist - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: "xxx") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "xxx"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider is empty string - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: nil) {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"provider\" has invalid value nil."

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == nil
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider is empty string - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: nil) {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"provider\" has invalid value nil."
    end

    it "return null when code doesn't exist - `AbsintheHelpers`" do
      query = """
      {
        getToken(provider: "google") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "google"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when code doesn't exist - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getToken(provider: "google") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "google"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end
  end

  describe "#get_refresh_token_code" do
    it "return refresh code by google - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "google", token: "token1") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"]     =~ "https://accounts.google.com/o/oauth2/v2/auth?"
      assert found["provider"] == "google"
    end

    it "return refresh code by google - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "google", token: "token1") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     =~ "https://accounts.google.com/o/oauth2/v2/auth?"
      assert found["provider"] == "google"
    end

    it "return refresh code by linkedin - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "linkedin", token: "token1") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"]     =~ "https://www.linkedin.com/oauth/v2/accessToken"
      assert found["provider"] == "linkedin"
    end

    it "return refresh code by linkedin - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "linkedin", token: "token1") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]   =~ "https://www.linkedin.com/oauth/v2/accessToken"
      assert found["provider"] == "linkedin"
    end

    it "return refresh code by linkedin when token is nil - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "linkedin", token: nil) {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"token\" has invalid value nil."
    end

    it "return refresh code by linkedin when token is nil - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "linkedin", token: nil) {
          code
          provider
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"token\" has invalid value nil."
    end

    it "return refresh code by google when token is nil - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "google", token: nil) {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"token\" has invalid value nil."
    end

    it "return refresh code by google when token is nil - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "google", token: nil) {
          code
          provider
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"token\" has invalid value nil."
    end

    it "return refresh code by facebook - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "facebook", token: "ok_token") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"]     =~ "AQCkGgxi5MAsrEpRjruN"
      assert found["provider"] == "facebook"
    end

    it "return refresh code by facebook - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "facebook", token: "ok_token") {

          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     =~ "AQCkGgxi5MAsrEpRjruN"
      assert found["provider"] == "facebook"
    end

    it "return refresh code by twitter - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "twitter", token: \"#{nil}\") {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"]     == "ok"
      assert found["provider"] == "twitter"
    end

    it "return refresh code by twitter - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "twitter", token: \"#{nil}\") {
          code
          provider
        }
      }
      """

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"]     == "ok"
      assert found["provider"] == "twitter"
    end

    it "return null when provider is localhost - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "localhost", token: nil) {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"token\" has invalid value nil."
    end

    it "return null when provider is localhost - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "localhost", token: nil) {
          code
          provider
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"token\" has invalid value nil."
    end

    it "return error when provider is nil - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: nil, token: nil) {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"provider\" has invalid value nil."
    end

    it "return error when provider is nil - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: nil, token: nil) {
          code
          provider
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"provider\" has invalid value nil."
    end

    it "return error when provider doesn't exist - `AbsintheHelpers`" do
      query = """
      {
        getRefreshTokenCode(provider: "xxx", token: nil) {
          code
          provider
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"token\" has invalid value nil."
    end

    it "return error when provider doesn't exist - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "xxx", token: nil) {
          code
          provider
        }
      }
      """
      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"token\" has invalid value nil."
    end
  end

  describe "#get_refresh_token" do
    it "return refresh token by google - `AbsintheHelpers`" do
      query = """
      {
        getRefreshToken(provider: "google", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshToken"]

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "google"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return refresh token by google - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: "google", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "google"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return refresh token by linkedin - `AbsintheHelpers`" do
      query = """
      {
        getRefreshToken(provider: "linkedin", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshToken"]

      assert found["access_token"]      == nil
      assert found["error"]             == "access_denied"
      assert found["error_description"] == "Refresh token not allowed"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return refresh token by linkedin - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: "linkedin", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "access_denied"
      assert found["error_description"] == "Refresh token not allowed"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return refresh token  by facebook - `AbsintheHelpers`" do
      query = """
      {
        getRefreshToken(provider: "facebook", token: "ok_token") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshToken"]

      assert found["access_token"]      =~ "EAAJ3B40DJTcBAP83UjtPGyvS7"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "5156727"
      assert found["id_token"]          == nil
      assert found["provider"]          == "facebook"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == "bearer"
    end

    it "return refresh token  by facebook - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: "facebook", token: "ok_token") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      =~ "EAAJ3B40DJTcBAP83UjtPGyvS7"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == "5156727"
      assert found["id_token"]          == nil
      assert found["provider"]          == "facebook"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == "bearer"
    end

    it "return refresh token  by twitter - `AbsintheHelpers`" do
      query = """
      {
        getRefreshToken(provider: "twitter", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshToken"]

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "twitter"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return refresh token  by twitter - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: "twitter", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "twitter"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider isn't correct - `AbsintheHelpers`" do
      query = """
      {
        getRefreshToken(provider: "xxx", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshToken"]

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "xxx"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider isn't correct - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: "xxx", token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """
      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "xxx"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return error when provider dosn't exist - `AbsintheHelpers`" do
      query = """
      {
        getRefreshToken(provider: nil, token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshToken"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"provider\" has invalid value nil."
    end

    it "return error when provider dosn't exist - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: nil, token: "token1") {
          access_token
          error
          error_description
          expires_in
          id_token
          provider
          refresh_token
          scope
          token_type
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"provider\" has invalid value nil."
    end
  end

  describe "#verify_token" do
    it "return checked out token by google - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "google", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == "online"
      assert found["aud"]               == "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com"
      assert found["azp"]               == "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com"
      assert found["email"]             == nil
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == "1583085800"
      assert found["expires_in"]        == "3320"
      assert found["provider"]          == "google"
      assert found["scope"]             == "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid"
      assert found["sub"]               == "108200932962621575818"
    end

    it "return checked out token by google - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "google", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == "online"
      assert found["aud"]               == "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com"
      assert found["azp"]               == "670116700803-b76nhucfvtbci1c9cura69v56vfjitad.apps.googleusercontent.com"
      assert found["email"]             == nil
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == "1583085800"
      assert found["expires_in"]        == "3320"
      assert found["provider"]          == "google"
      assert found["scope"]             == "https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid"
      assert found["sub"]               == "108200932962621575818"
    end

    it "return null new token by google when isn't correct - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "google", token: nil) {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"token\" has invalid value nil."
    end

    it "return error new token by google when doesn't exist - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "xxx", token: nil) {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"token\" has invalid value nil."
    end

    it "return error new token by google when doesn't exist - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "xxx", token: nil) {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"token\" has invalid value nil."
    end

    it "return checked out token by linkedin - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "linkedin", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == "lugatex@yahoo.com"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by linkedin - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "linkedin", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == "lugatex@yahoo.com"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error token by linkedin when token is nil - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "linkedin", token: nil) {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"token\" has invalid value nil."
    end

    it "return error token by linkedin when token is nil - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "linkedin", token: nil) {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"token\" has invalid value nil."
    end

    it "return error token by linkedin when token doesn't exist - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "linkedin", token: "xxx") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == "lugatex@yahoo.com"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error token by linkedin when token doesn't exist - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "linkedin", token: "xxx") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == "lugatex@yahoo.com"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by facebook - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "facebook", token: "ok_token") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == "5156727"
      assert found["provider"]          == "facebook"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by facebook - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "facebook", token: "ok_token") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """


      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == "5156727"
      assert found["provider"]          == "facebook"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by twitter - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "twitter", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "twitter"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by twitter - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "twitter", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """
      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "twitter"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error token by linkedin when provider doesn't correct - `AbsintheHelpers`" do
      query = """
      {
        getVerify(provider: "xxx", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "xxx"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error token by linkedin when provider doesn't correct - `Absinthe.run`" do
      context = %{}

      query = """
      {
        getVerify(provider: "xxx", token: "token1") {
          access_type
          aud
          azp
          email
          error
          error_description
          exp
          expires_in
          provider
          scope
          sub
        }
      }
      """


      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "xxx"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end
  end

  describe "#signup" do
    it "create user used code by google and return access token - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          code: "ok_code",
          provider: "google"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signUp"]

      assert created["access_token"]      =~ "SFMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "google"
    end

    it "create user used code by google and return access token - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          code: "ok_code",
          provider: "google"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signUp" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "FMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "google"
    end

    it "create user used code by linkedin and return access token - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          code: "ok_code",
          provider: "linkedin"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signUp"]

      assert created["access_token"]      =~ "SFMyNTY."
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "linkedin"
    end

    it "create user used code by linkedin and return access token - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          code: "ok_code",
          provider: "linkedin"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signUp" => created}}} = Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "FMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "linkedin"
    end

    it "return error by linkedin when code is fault - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          code: "wrong_code",
          provider: "linkedin"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signUp"]

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid_request"
      assert created["error_description"] == "Unable to retrieve access token: authorization code not found"
      assert created["provider"]          == "linkedin"
    end

    it "return error by linkedin when code is fault - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          code: "wrong_code",
          provider: "linkedin"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signUp" => created}}} = Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid_request"
      assert created["error_description"] == "Unable to retrieve access token: authorization code not found"
      assert created["provider"]          == "linkedin"
    end

    it "create user used code by facebook and return access token - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          code: "ok_code",
          provider: "facebook"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signUp"]

      assert created["access_token"]      =~ "SFMyNTY.g2gDbQAAABI5eF"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "facebook"
    end

    it "create user used code by facebook and return access token - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          code: "ok_code",
          provider: "facebook"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signUp" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "SFMyNTY.g2gDbQAAABI5eF"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "facebook"
    end

    it "return error by facebook when code is fault - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          code: "wrong_code",
          provider: "facebook"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signUp"]

      assert created["access_token"]      == nil
      assert created["error"]             == "OAuthException, 100"
      assert created["error_description"] == "Invalid verification code format."
      assert created["provider"]          == "facebook"
    end

    it "return error by facebook when code is fault - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          code: "wrong_code",
          provider: "facebook"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signUp" => created}}} = Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      == nil
      assert created["error"]             == "OAuthException, 100"
      assert created["error_description"] == "Invalid verification code format."
      assert created["provider"]          == "facebook"
    end

    it "create user used code by twitter and return access token - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          email: "oleg@yahoo.com",
          provider: "twitter"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signUp"]

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid provider"
      assert created["error_description"] == "invalid url by provider"
      assert created["provider"]          == "twitter"
    end

    it "create user used code by twitter and return access token - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          email: "oleg@yahoo.com",
          provider: "twitter"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signUp" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid provider"
      assert created["error_description"] == "invalid url by provider"
      assert created["provider"]          == "twitter"
    end

    it "create user via localhost and return access token - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          provider: "localhost"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signUp"]

      assert created["access_token"]      =~ "FMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "localhost"
    end

    it "create user via localhost and return access token - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          provider: "localhost"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signUp" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "FMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "localhost"
    end

    it "return error via localhost when provider is nil - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          provider: nil
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"provider\" has invalid value nil."
    end

    it "return error via localhost when provider is nil - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          provider: nil
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"provider\" has invalid value nil."
    end

    it "return errors via localhost when args nil - `AbsintheHelpers`" do
      query = """
      mutation {
        signUp(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: "localhost"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(query))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"email\" has invalid value nil."
    end

    it "return errors via localhost when args nil - `Absinthe.run`" do
      context = %{}

      query = """
      mutation {
        signUp(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: "localhost"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"email\" has invalid value nil."
    end
  end

  describe "#signin" do
    it "signin via google and return access token - `AbsintheHelpers`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "google")

      query = """
      {
        signIn(
          code: "ok_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      =~ "SFMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "google"
    end

    it "signin via google and return access token - `Absinthe.run`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "google")

      context = %{}

      query = """
      {
        signIn(
          code: "ok_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "SFMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "google"
    end

    it "return error via google when code doesn't exist - `AbsintheHelpers`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "google")

      query = """
      {
        signIn(
          code: "wrong_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid grant"
      assert created["error_description"] == "Bad Request"
      assert created["provider"]          == "google"
    end

    it "return error via google when code doesn't exist - `Absinthe.run`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "google")
      context = %{}

      query = """
      {
        signIn(
          code: "wrong_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid grant"
      assert created["error_description"] == "Bad Request"
      assert created["provider"]          == "google"
    end

    it "return error via google when code is nil - `AbsintheHelpers`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "google")

      query = """
      {
        signIn(
          code: nil,
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"code\" has invalid value nil."
    end

    it "signin via linkedin and return access token - `AbsintheHelpers`" do
      struct = insert(:user, email: "lugatex@yahoo.com", provider: "linkedin")

      query = """
      {
        signIn(
          code: "ok_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      =~ "SFMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "linkedin"
    end

    it "signin via linkedin and return access token - `Absinthe.run`" do
      struct = insert(:user, email: "lugatex@yahoo.com", provider: "linkedin")
      context = %{}

      query = """
      {
        signIn(
          code: "ok_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "SFMyNTY.g"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "linkedin"
    end

    it "return error via linkedin when code doesn't exist - `AbsintheHelpers`" do
      struct = insert(:user, email: "lugatex@yahoo.com", provider: "linkedin")

      query = """
      {
        signIn(
          code: "wrong_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid_request"
      assert created["error_description"] == "Unable to retrieve access token: authorization code not found"
      assert created["provider"]          == "linkedin"
    end

    it "return error via linkedin when code doesn't exist - `Absinthe.run`" do
      struct = insert(:user, email: "lugatex@yahoo.com", provider: "linkedin")
      context = %{}

      query = """
      {
        signIn(
          code: "wrong_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid_request"
      assert created["error_description"] == "Unable to retrieve access token: authorization code not found"
      assert created["provider"]          == "linkedin"
    end

    it "return error via linkedin when code is nil - `AbsintheHelpers`" do
      struct = insert(:user, email: "lugatex@yahoo.com", provider: "linkedin")

      query = """
      {
        signIn(
          code: nil,
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"code\" has invalid value nil."
    end

    it "signin via facebook and return access token - `AbsintheHelpers`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "facebook")

      query = """
      {
        signIn(
          code: "ok_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      =~ "SFMyNTY.g2gDbQAAABI5eF"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "facebook"
    end

    it "signin via facebook and return access token - `Argument.run`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "facebook")
      context = %{current_user: struct}

      query = """
      {
        signIn(
          code: "ok_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "SFMyNTY.g2gDbQAAABI5eF"
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "facebook"
    end

    it "return error via facebook when code doesn't exist - `AbsintheHelpers`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "facebook")

      query = """
      {
        signIn(
          code: "wrong_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      == nil
      assert created["error"]             == "OAuthException, 100"
      assert created["error_description"] == "Invalid verification code format."
      assert created["provider"]          == "facebook"
    end

    it "return error via facebook when code doesn't exist - `Absinthe.run`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "facebook")
      context = %{current_user: struct}

      query = """
      {
        signIn(
          code: "wrong_code",
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      == nil
      assert created["error"]             == "OAuthException, 100"
      assert created["error_description"] == "Invalid verification code format."
      assert created["provider"]          == "facebook"
    end

    it "return error via facebook when code is nil - `AbsintheHelpers`" do
      struct = insert(:user, email: "kapranov.lugatex@gmail.com", provider: "facebook")

      query = """
      {
        signIn(
          code: nil,
          email: \"#{struct.email}\",
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"code\" has invalid value nil."
    end

    it "signin via twitter and return access token - `AbsintheHelpers`" do
      struct = insert(:user, provider: "twitter")

      query = """
      {
        signIn(
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid provider"
      assert created["error_description"] == "invalid url by provider"
      assert created["provider"]          == "twitter"
    end

    it "signin via twitter and return access token - `Absinthe.run`" do
      struct = insert(:user, provider: "twitter")
      context = %{}

      query = """
      {
        signIn(
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      == nil
      assert created["error"]             == "invalid provider"
      assert created["error_description"] == "invalid url by provider"
      assert created["provider"]          == "twitter"
    end

    it "signin via localhost and return access token - `AbsintheHelpers`" do
      struct =
        insert(:user,
          provider: "localhost",
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          password_hash: "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s"
        )
      Argon2.verify_pass(struct.password, "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s")
      args = %{provider: "localhost", email: struct.email, password: "qwerty"}

      query = """
      {
        signIn(
          email: \"#{args.email}\",
          password: \"#{args.password}\",
          password_confirmation: \"#{args.password}\",
          provider: \"#{args.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      created = json_response(res, 200)["data"]["signIn"]

      assert created["access_token"]      =~ "SFMyNTY."
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "localhost"
    end

    it "signin via localhost and return access token - `Absinthe.run`" do
      struct =
        insert(:user,
          provider: "localhost",
          email: "oleg@yahoo.com",
          password: "qwerty",
          password_confirmation: "qwerty",
          password_hash: "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s"
        )
      Argon2.verify_pass(struct.password, "$argon2id$v=19$m=131072,t=8,p=4$UXqzl/WwvwNsP/f95t2Tew$FGIeOOerDnGEVa8R79xxmCXHJ1nkSnSm/am58ng0A8s")
      args = %{provider: "localhost", email: struct.email, password: "qwerty"}

      context = %{}

      query = """
      {
        signIn(
          email: \"#{args.email}\",
          password: \"#{args.password}\",
          password_confirmation: \"#{args.password}\",
          provider: \"#{args.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{data: %{"signIn" => created}}} =
        Absinthe.run(query, Schema, context: context)

      assert created["access_token"]      =~ "SFMyNTY."
      assert created["error"]             == nil
      assert created["error_description"] == nil
      assert created["provider"]          == "localhost"
    end

    it "return error via localhost when email is nil - `AbsintheHelpers`" do
      struct = insert(:user, provider: "localhost")

      query = """
      {
        signIn(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"email\" has invalid value nil."
    end

    it "return error via localhost when email is nil - `Absinthe.run`" do
      struct = insert(:user, provider: "localhost")
      context = %{}

      query = """
      {
        signIn(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"email\" has invalid value nil."
    end

    it "return error via localhost when password is nil - `AbsintheHelpers`" do
      struct = insert(:user, provider: "localhost")

      query = """
      {
        signIn(
          email: \"#{struct.email}\",
          password: nil,
          password_confirmation: nil,
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"password\" has invalid value nil."
    end

    it "return error via localhost when password is nil - `Absinthe.run`" do
      struct = insert(:user, provider: "localhost")

      context = %{}

      query = """
      {
        signIn(
          email: \"#{struct.email}\",
          password: nil,
          password_confirmation: nil,
          provider: \"#{struct.provider}\"
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"password\" has invalid value nil."
    end

    it "return error when args is nil - `AbsintheHelpers`" do
      query = """
      {
        signIn(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: nil
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "signIn"))

      assert hd(json_response(res, 200)["errors"])["message"] == "Argument \"email\" has invalid value nil."
    end

    it "return error when args is nil - `Absinthe.run`" do
      context = %{}

      query = """
      {
        signIn(
          email: nil,
          password: nil,
          password_confirmation: nil,
          provider: nil
        ) {
          access_token
          provider
          error
          error_description
        }
      }
      """

      {:ok, %{errors: error}} =
        Absinthe.run(query, Schema, context: context)

      assert hd(error).message == "Argument \"email\" has invalid value nil."
    end
  end
end
