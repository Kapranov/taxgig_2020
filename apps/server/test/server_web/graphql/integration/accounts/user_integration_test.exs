defmodule ServerWeb.GraphQL.Integration.Accounts.UserIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns accounts an user" do
      struct = insert(:user)

      context = %{}

      query = """
      {
        allUsers{
          id
          active
          admin_role
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name inserted_at updated_at}
          last_name
          middle_name
          phone
          pro_role
          provider
          sex
          ssn
          street
          zip
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allUsers"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allUsers"]

      assert List.first(data)["id"]          == struct.id
      assert List.first(data)["active"]      == struct.active
      assert List.first(data)["admin_role"]  == struct.admin_role
      assert List.first(data)["avatar"]      == struct.avatar
      assert List.first(data)["bio"]         == struct.bio
      assert List.first(data)["birthday"]    == to_string(struct.birthday)
      assert List.first(data)["email"]       == struct.email
      assert List.first(data)["first_name"]  == struct.first_name
      assert List.first(data)["init_setup"]  == struct.init_setup
      assert List.first(data)["last_name"]   == struct.last_name
      assert List.first(data)["middle_name"] == struct.middle_name
      assert List.first(data)["phone"]       == struct.phone
      assert List.first(data)["pro_role"]    == struct.pro_role
      assert List.first(data)["provider"]    == struct.provider
      assert List.first(data)["sex"]         == struct.sex
      assert List.first(data)["ssn"]         == struct.ssn
      assert List.first(data)["street"]      == struct.street
      assert List.first(data)["zip"]         == struct.zip
      assert List.first(data)["inserted_at"] == format_time(struct.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct.updated_at)

      assert List.first(data)["languages"] |> length                       == 1
      assert List.first(data)["languages"] |> List.last |> Map.get("name") == "chinese"
      assert List.first(data)["languages"] |> List.last |> Map.get("abbr") == "chi"

      assert List.last(data)["id"]          == struct.id
      assert List.last(data)["active"]      == struct.active
      assert List.last(data)["admin_role"]  == struct.admin_role
      assert List.last(data)["avatar"]      == struct.avatar
      assert List.last(data)["bio"]         == struct.bio
      assert List.last(data)["birthday"]    == to_string(struct.birthday)
      assert List.last(data)["email"]       == struct.email
      assert List.last(data)["first_name"]  == struct.first_name
      assert List.last(data)["init_setup"]  == struct.init_setup
      assert List.last(data)["last_name"]   == struct.last_name
      assert List.last(data)["middle_name"] == struct.middle_name
      assert List.last(data)["phone"]       == struct.phone
      assert List.last(data)["pro_role"]    == struct.pro_role
      assert List.last(data)["provider"]    == struct.provider
      assert List.last(data)["sex"]         == struct.sex
      assert List.last(data)["ssn"]         == struct.ssn
      assert List.last(data)["street"]      == struct.street
      assert List.last(data)["zip"]         == struct.zip
      assert List.last(data)["inserted_at"] == format_time(struct.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct.updated_at)

      assert List.last(data)["languages"] |> length                       == 1
      assert List.last(data)["languages"] |> List.last |> Map.get("name") == "chinese"
      assert List.last(data)["languages"] |> List.last |> Map.get("abbr") == "chi"

      {:ok, %{data: %{"allUsers" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["id"]          == struct.id
      assert first["active"]      == struct.active
      assert first["admin_role"]  == struct.admin_role
      assert first["avatar"]      == struct.avatar
      assert first["bio"]         == struct.bio
      assert first["birthday"]    == to_string(struct.birthday)
      assert first["email"]       == struct.email
      assert first["first_name"]  == struct.first_name
      assert first["init_setup"]  == struct.init_setup
      assert first["last_name"]   == struct.last_name
      assert first["middle_name"] == struct.middle_name
      assert first["phone"]       == struct.phone
      assert first["pro_role"]    == struct.pro_role
      assert first["provider"]    == struct.provider
      assert first["sex"]         == struct.sex
      assert first["ssn"]         == struct.ssn
      assert first["street"]      == struct.street
      assert first["zip"]         == struct.zip
      assert first["inserted_at"] == format_time(struct.inserted_at)
      assert first["updated_at"]  == format_time(struct.updated_at)

      assert first["languages"] |> length                       == 1
      assert first["languages"] |> List.last |> Map.get("name") == "chinese"
      assert first["languages"] |> List.last |> Map.get("abbr") == "chi"
    end
  end

  describe "#show" do
    it "returns specific accounts an user by id" do
      struct = insert(:user)

      context = %{}

      query = """
      {
        showUser(id: \"#{struct.id}\") {
          id
          active
          admin_role
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name inserted_at updated_at}
          last_name
          middle_name
          phone
          pro_role
          provider
          sex
          ssn
          street
          zip
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUser"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showUser"]

      assert found["id"]          == struct.id
      assert found["active"]      == struct.active
      assert found["admin_role"]  == struct.admin_role
      assert found["avatar"]      == struct.avatar
      assert found["bio"]         == struct.bio
      assert found["birthday"]    == to_string(struct.birthday)
      assert found["email"]       == struct.email
      assert found["first_name"]  == struct.first_name
      assert found["init_setup"]  == struct.init_setup
      assert found["last_name"]   == struct.last_name
      assert found["middle_name"] == struct.middle_name
      assert found["phone"]       == struct.phone
      assert found["pro_role"]    == struct.pro_role
      assert found["provider"]    == struct.provider
      assert found["sex"]         == struct.sex
      assert found["ssn"]         == struct.ssn
      assert found["street"]      == struct.street
      assert found["zip"]         == struct.zip
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)

      assert found["languages"] |> length                       == 1
      assert found["languages"] |> List.last |> Map.get("name") == "chinese"
      assert found["languages"] |> List.last |> Map.get("abbr") == "chi"

      {:ok, %{data: %{"showUser" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["id"]          == struct.id
      assert found["active"]      == struct.active
      assert found["admin_role"]  == struct.admin_role
      assert found["avatar"]      == struct.avatar
      assert found["bio"]         == struct.bio
      assert found["birthday"]    == to_string(struct.birthday)
      assert found["email"]       == struct.email
      assert found["first_name"]  == struct.first_name
      assert found["init_setup"]  == struct.init_setup
      assert found["last_name"]   == struct.last_name
      assert found["middle_name"] == struct.middle_name
      assert found["phone"]       == struct.phone
      assert found["pro_role"]    == struct.pro_role
      assert found["provider"]    == struct.provider
      assert found["sex"]         == struct.sex
      assert found["ssn"]         == struct.ssn
      assert found["street"]      == struct.street
      assert found["zip"]         == struct.zip
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)

      assert found["languages"] |> length                       == 1
      assert found["languages"] |> List.last |> Map.get("name") == "chinese"
      assert found["languages"] |> List.last |> Map.get("abbr") == "chi"
    end

    it "returns not found when accounts an user does not exist" do
      id =  Ecto.UUID.generate()

      query = """
      {
        showUser(id: \"#{id}\") {
          id
          active
          admin_role
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name inserted_at updated_at}
          last_name
          middle_name
          phone
          pro_role
          provider
          sex
          ssn
          street
          zip
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showUser"))

      assert hd(json_response(res, 200)["errors"])["message"] == "An User #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  describe "#create" do
    it "creates accounts an user" do
      insert(:language)

      mutation = """
      {
        createUser(
          active: false,
          admin_role: false,
          avatar: "some text",
          bio: "some text",
          birthday: \"#{Timex.today}\",
          email: "lugatex@yahoo.com",
          first_name: "some text",
          init_setup: false,
          languages: "chinese",
          last_name: "some text",
          middle_name: "some text",
          password: "qwerty",
          password_confirmation: "qwerty",
          phone: "some text",
          pro_role: false,
          provider: "google",
          sex: "some text",
          ssn: 123456789,
          street: "some text",
          zip: 123456789
        ) {
          id
          active
          admin_role
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name inserted_at updated_at}
          last_name
          middle_name
          phone
          pro_role
          provider
          sex
          ssn
          street
          zip
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      created = json_response(res, 200)["data"]["createUser"]

      assert created["active"]      == false
      assert created["admin_role"]  == false
      assert created["avatar"]      == "some text"
      assert created["bio"]         == "some text"
      assert created["birthday"]    == to_string(Timex.today)
      assert created["email"]       == "lugatex@yahoo.com"
      assert created["first_name"]  == "some text"
      assert created["init_setup"]  == false
      assert created["last_name"]   == "some text"
      assert created["middle_name"] == "some text"
      assert created["phone"]       == "some text"
      assert created["pro_role"]    == false
      assert created["provider"]    == "google"
      assert created["sex"]         == "some text"
      assert created["ssn"]         == 123456789
      assert created["street"]      == "some text"
      assert created["zip"]         == 123456789

      assert created["languages"] |> length                       == 1
      assert created["languages"] |> List.last |> Map.get("name") == "chinese"
      assert created["languages"] |> List.last |> Map.get("abbr") == "chi"
    end

    it "returns error for missing params" do
    end
  end

  describe "#update" do
    it "update specific accounts an user by id" do
      struct = insert(:user)

      mutation = """
      {
        updateUser(
          id: \"#{struct.id}\",
          user: {
            active: true,
            admin_role: true,
            avatar: "updated text",
            bio: "updated text",
            birthday: \"#{Timex.today}\",
            email: "kapranov.lugatex@gmail.com",
            first_name: "updated text",
            init_setup: true,
            languages: "chinese",
            last_name: "updated text",
            middle_name: "updated text",
            password: "qwertyyy",
            password_confirmation: "qwertyyy",
            phone: "updated text",
            pro_role: true,
            provider: "facebook",
            sex: "updated text",
            ssn: 987654321,
            street: "updated text",
            zip: 987654321
          }
        ) {
          id
          active
          admin_role
          avatar
          bio
          birthday
          email
          first_name
          init_setup
          languages {id abbr name inserted_at updated_at}
          last_name
          middle_name
          phone
          pro_role
          provider
          sex
          ssn
          street
          zip
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateUser"]

      assert updated["id"]          == struct.id
      assert updated["active"]      == true
      assert updated["admin_role"]  == true
      assert updated["avatar"]      == "updated text"
      assert updated["bio"]         == "updated text"
      assert updated["birthday"]    == to_string(Timex.today)
      assert updated["email"]       == "kapranov.lugatex@gmail.com"
      assert updated["first_name"]  == "updated text"
      assert updated["init_setup"]  == true
      assert updated["last_name"]   == "updated text"
      assert updated["middle_name"] == "updated text"
      assert updated["phone"]       == "updated text"
      assert updated["pro_role"]    == true
      assert updated["provider"]    == "facebook"
      assert updated["sex"]         == "updated text"
      assert updated["ssn"]         == 987654321
      assert updated["street"]      == "updated text"
      assert updated["zip"]         == 987654321
      assert updated["inserted_at"] == format_time(struct.inserted_at)

      assert updated["languages"] |> length                       == 1
      assert updated["languages"] |> List.last |> Map.get("name") == "chinese"
      assert updated["languages"] |> List.last |> Map.get("abbr") == "chi"
    end

    it "nothing change for missing params" do
    end

    it "returns error for missing params" do
    end
  end

  describe "#delete" do
    it "delete specific accounts an user by id" do
      struct = insert(:user)

      mutation = """
      {
        deleteUser(id: \"#{struct.id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteUser"]
      assert deleted["id"] == struct.id
    end

    it "returns not found when accounts an user does not exist" do
      id = Ecto.UUID.generate()

      mutation = """
      {
        deleteUser(id: \"#{id}\") {id}
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert hd(json_response(res, 200)["errors"])["message"] == "An User #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  describe "#get_code" do
    it "return code by google" do
      context = %{}

      query = """
      {
        getCode(provider: "google") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] =~ "https://accounts.google.com/o/oauth2/v2/auth?"

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] =~ "https://accounts.google.com/o/oauth2/v2/auth?"
    end

    it "return code by linkedin" do
      context = %{}

      query = """
      {
        getCode(provider: "linkedin") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] =~ "https://www.linkedin.com/oauth/v2/authorization?"

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] =~ "https://www.linkedin.com/oauth/v2/authorization?"
    end

    it "return code by facebook" do
      context = %{}

      query = """
      {
        getCode(provider: "facebook") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] == "ok"

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == "ok"
    end

    it "return code by twitter" do
      context = %{}

      query = """
      {
        getCode(provider: "twitter") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] == "ok"

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == "ok"
    end

    it "return null by localhost" do
      context = %{}

      query = """
      {
        getCode(provider: "localhost") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] == nil

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == nil
    end

    it "return null when provider is nil" do
      context = %{}

      query = """
      {
        getCode(provider: \"\#{nil}") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] == nil

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == nil
    end

    it "return null when provider isn't exist" do
      context = %{}

      query = """
      {
        getCode(provider: "proba") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] == nil

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == nil
    end

    it "return null when string is blank" do
      context = %{}

      query = """
      {
        getCode(provider: "") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getCode"]

      assert found["code"] == nil

      {:ok, %{data: %{"getCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == nil
    end
  end

  describe "#get_token" do
    it "return token by google" do
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

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "google"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
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

    it "return token by linkedin" do
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

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getToken"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getToken"]

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return token by facebook" do
      context = %{}

      query = """
      {
        getToken(provider: "facebook") {
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return token by twitter" do
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null token by localhost" do
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider isn't exist" do
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider is empty string" do
      context = %{}

      query = """
      {
        getToken(provider: \"#{nil}\") {
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when code doesn't exist" do
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end
  end

  describe "#get_refresh_token_code" do
    it "return refresh code by google" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "google", token: "token1") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] =~ "https://accounts.google.com/o/oauth2/v2/auth?"

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] =~ "https://accounts.google.com/o/oauth2/v2/auth?"
    end

    it "return refresh code by linkedin" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "linkedin", token: "token1") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] =~ "https://www.linkedin.com/oauth/v2/accessToken"

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] =~ "https://www.linkedin.com/oauth/v2/accessToken"
    end

    it "return refresh code by linkedin when token is nil" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "linkedin", token: \"#{nil}\") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] =~ "https://www.linkedin.com/oauth/v2/accessToken"

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] =~ "https://www.linkedin.com/oauth/v2/accessToken&grant_type=refresh_token&refresh_token=&"
    end

    it "return refresh code by google when token is nil" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "google", token: \"#{nil}\") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] =~ "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&access_type=offline&"

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] =~ "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&access_type=offline&"
    end

    it "return refresh code by facebook" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "facebook", token: \"#{nil}\") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] == "ok"

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == "ok"
    end

    it "return refresh code by twitter" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "twitter", token: \"#{nil}\") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] == "ok"

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == "ok"
    end

    it "return null when provider is localhost" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "localhost", token: \"#{nil}\") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] == nil

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == nil
    end

    it "return error when provider is nil" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: \"#{nil}\", token: \"#{nil}\") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] == nil

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == nil
    end

    it "return error when provider doesn't exist" do
      context = %{}

      query = """
      {
        getRefreshTokenCode(provider: "xxx", token: \"#{nil}\") {
          code
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getRefreshTokenCode"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getRefreshTokenCode"]

      assert found["code"] == nil

      {:ok, %{data: %{"getRefreshTokenCode" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["code"] == nil
    end
  end

  describe "#get_refresh_token" do
    it "return refresh token by google" do
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

    it "return refresh token by linkedin" do
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
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "token1"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == "linkedin"
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return refresh token  by facebook" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: "facebook", token: "token1") {
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return refresh token  by twitter" do
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == "ok"
      assert found["error"]             == nil
      assert found["error_description"] == nil
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return null when provider isn't correct" do
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end

    it "return error when provider dosn't exist" do
      context = %{}

      query = """
      {
        getRefreshToken(provider: \"#{nil}\", token: "token1") {
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
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil

      {:ok, %{data: %{"getRefreshToken" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_token"]      == nil
      assert found["error"]             == "invalid provider"
      assert found["error_description"] == "invalid url by provider"
      assert found["expires_in"]        == nil
      assert found["id_token"]          == nil
      assert found["provider"]          == nil
      assert found["refresh_token"]     == nil
      assert found["scope"]             == nil
      assert found["token_type"]        == nil
    end
  end

  describe "#verify_token" do
    it "return checked out token by google" do
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
      assert found["provider"]          == "google"
      assert found["scope"]             == nil
      assert found["sub"]               == nil

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
      assert found["provider"]          == "google"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return null new token by google when isn't correct" do
      context = %{}

      query = """
      {
        getVerify(provider: "google", token: \"#{nil}\") {
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
      assert found["provider"]          == "google"
      assert found["scope"]             == nil
      assert found["sub"]               == nil

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
      assert found["provider"]          == "google"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error new token by google when doesn't exist" do
      context = %{}

      query = """
      {
        getVerify(provider: "xxx", token: \"#{nil}\") {
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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil

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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by linkedin" do
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

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == "Invalid access token"
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil

      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == "Invalid access token"
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error token by linkedin when token is nil" do
      context = %{}

      query = """
      {
        getVerify(provider: "linkedin", token: \"#{nil}\") {
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
      assert found["error"]             == "Invalid access token"
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil

      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == "Invalid access token"
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error token by linkedin when token doesn't exist" do
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

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "getVerify"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["getVerify"]

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == "Invalid access token"
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil

      {:ok, %{data: %{"getVerify" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["access_type"]       == nil
      assert found["aud"]               == nil
      assert found["azp"]               == nil
      assert found["email"]             == nil
      assert found["error"]             == "Invalid access token"
      assert found["error_description"] == nil
      assert found["exp"]               == nil
      assert found["expires_in"]        == nil
      assert found["provider"]          == "linkedin"
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by facebook" do
      context = %{}

      query = """
      {
        getVerify(provider: "facebook", token: "token1") {
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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil

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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return checked out token by twitter" do
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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil

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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end

    it "return error token by linkedin when provider doesn't correct" do
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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil

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
      assert found["provider"]          == nil
      assert found["scope"]             == nil
      assert found["sub"]               == nil
    end
  end

  describe "#signup" do
    it "create user used code by google and return access token" do
    end

    it "return error by google when code is nil" do
    end

    it "return error by google when code doesn't exist" do
    end

    it "create user used code by linkedin and return access token" do
    end

    it "return error by linkedin when code is nil" do
    end

    it "create user used code by facebook and return access token" do
    end

    it "create user used code by twitter and return access token" do
    end

    it "create user via localhost and return access token" do
    end

    it "return error via localhost when args nil" do
    end
  end

  describe "#signin" do
    it "signin via google and return access token" do
    end

    it "return error via google when code is nil" do
    end

    it "return error via google when code doesn't exist" do
    end

    it "signin via linkedin and return access token" do
    end

    it "return error via linkedin when code is nil" do
    end

    it "return error via linkedin when code doesn't exist" do
    end

    it "signin via facebook and return access token" do
    end

    it "signin via twitter and return access token" do
    end

    it "signin via localhost and return access token" do
    end

    it "return error via localhost when email is nil" do
    end

    it "return error via localhost when password is nil" do
    end

    it "return error when args is nil" do
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end

end
