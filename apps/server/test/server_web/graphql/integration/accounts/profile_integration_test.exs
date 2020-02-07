defmodule ServerWeb.GraphQL.Integration.Accounts.ProfileIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  describe "#list" do
    it "returns profiles" do
      struct = insert(:profile)

      context = %{}

      query = """
      {
        allProfiles{
          address
          banner
          description
          us_zipcode {id city state zipcode}
          user {
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
          inserted_at
          updated_at
        }
      }
      """
      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "allProfiles"))

      assert json_response(res, 200)["errors"] == nil

      data = json_response(res, 200)["data"]["allProfiles"]

      assert List.first(data)["address"]     == struct.address
      assert List.first(data)["banner"]      == struct.banner
      assert List.first(data)["description"] == struct.description
      assert List.first(data)["inserted_at"] == format_time(struct.inserted_at)
      assert List.first(data)["updated_at"]  == format_time(struct.updated_at)

      assert List.last(data)["address"]     == struct.address
      assert List.last(data)["banner"]      == struct.banner
      assert List.last(data)["description"] == struct.description
      assert List.last(data)["inserted_at"] == format_time(struct.inserted_at)
      assert List.last(data)["updated_at"]  == format_time(struct.updated_at)

      {:ok, %{data: %{"allProfiles" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["address"]     == struct.address
      assert first["banner"]      == struct.banner
      assert first["description"] == struct.description
      assert first["inserted_at"] == format_time(struct.inserted_at)
      assert first["updated_at"]  == format_time(struct.updated_at)

      assert first["user"]["id"]          == struct.user_id
      assert first["user"]["active"]      == struct.user.active
      assert first["user"]["admin_role"]  == struct.user.admin_role
      assert first["user"]["avatar"]      == struct.user.avatar
      assert first["user"]["bio"]         == struct.user.bio
      assert first["user"]["birthday"]    == to_string(struct.user.birthday)
      assert first["user"]["email"]       == struct.user.email
      assert first["user"]["first_name"]  == struct.user.first_name
      assert first["user"]["init_setup"]  == struct.user.init_setup
      assert first["user"]["last_name"]   == struct.user.last_name
      assert first["user"]["middle_name"] == struct.user.middle_name
      assert first["user"]["phone"]       == struct.user.phone
      assert first["user"]["pro_role"]    == struct.user.pro_role
      assert first["user"]["provider"]    == struct.user.provider
      assert first["user"]["sex"]         == struct.user.sex
      assert first["user"]["ssn"]         == struct.user.ssn
      assert first["user"]["street"]      == struct.user.street
      assert first["user"]["zip"]         == struct.user.zip

      assert first["us_zipcode"]["id"]      == struct.us_zipcode_id
      assert first["us_zipcode"]["city"]    == struct.us_zipcode.city
      assert first["us_zipcode"]["state"]   == struct.us_zipcode.state
      assert first["us_zipcode"]["zipcode"] == struct.us_zipcode.zipcode
    end
  end

  describe "#show" do
    it "returns specific profile by user_id" do
      struct = insert(:profile)

      context = %{}

      query = """
      {
        showProfile(id: \"#{struct.user_id}\") {
          address
          banner
          description
          us_zipcode {id city state zipcode}
          user {
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
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showProfile"))

      assert json_response(res, 200)["errors"] == nil

      found = json_response(res, 200)["data"]["showProfile"]

      assert found["address"]     == struct.address
      assert found["banner"]      == struct.banner
      assert found["description"] == struct.description
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)

      {:ok, %{data: %{"showProfile" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["address"]     == struct.address
      assert found["banner"]      == struct.banner
      assert found["description"] == struct.description
      assert found["inserted_at"] == format_time(struct.inserted_at)
      assert found["updated_at"]  == format_time(struct.updated_at)
    end

    it "returns not found when accounts subscriber does not exist" do
      user_id =  Ecto.UUID.generate()

      query = """
      {
        showProfile(id: \"#{user_id}\") {
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.query_skeleton(query, "showProfile"))

      assert hd(json_response(res, 200)["errors"])["message"] == "An User #{user_id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  describe "#update" do
    it "update specific profile by user_id" do
      struct = insert(:profile)
      zipcode = insert(:zipcode)

      mutation = """
      {
        updateProfile(
          id: \"#{struct.user_id}\",
          profile: {
            address: "updated text",
            banner: "updated text",
            description: "updated text",
            us_zipcodeId: \"#{zipcode.id}\",
            userId: \"#{struct.user_id}\"
          }
        ) {
          address
          banner
          description
          us_zipcode {id city state zipcode}
          user {
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
          inserted_at
          updated_at
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateProfile"]

      assert updated["address"]     == "updated text"
      assert updated["banner"]      == "updated text"
      assert updated["description"] == "updated text"
      assert updated["inserted_at"] == format_time(struct.inserted_at)
      assert updated["updated_at"]  == format_time(struct.updated_at)
    end

    it "nothing change for missing params" do
    end

    it "returns error for missing params" do
    end
  end

  describe "#delete" do
    it "delete specific profile by user_id" do
      struct = insert(:profile)

      mutation = """
      {
        deleteProfile(id: \"#{struct.user_id}\") {
          user {id}
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert json_response(res, 200)["errors"] == nil

      deleted = json_response(res, 200)["data"]["deleteProfile"]
      assert deleted["user"]["id"] == struct.user_id
    end

    it "returns not found when profile does not exist" do
      id = Ecto.UUID.generate()

      mutation = """
      {
        deleteProfile(id: \"#{id}\") {
          user {id}
        }
      }
      """

      res =
        build_conn()
        |> post("/graphiql", AbsintheHelpers.mutation_skeleton(mutation))

      assert hd(json_response(res, 200)["errors"])["message"] == "The Profile #{id} not found!"
    end

    it "returns error for missing params" do
    end
  end

  defp format_time(timestamp) do
    Timex.format!(Timex.to_datetime(timestamp, "Europe/Kiev"), "{ISO:Extended:Z}")
  end
end
