defmodule ServerWeb.GraphQL.Integration.Accounts.ProfileIntegrationTest do
  use ServerWeb.ConnCase

  alias Server.AbsintheHelpers
  alias ServerWeb.GraphQL.Schema

  @bernie_path Path.absname("../core/test/fixtures/bernie.jpg")

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
          logo {id content_type name size url inserted_at updated_at}
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

      assert List.first(data)["address"]                         == struct.address
      assert List.first(data)["banner"]                          == struct.banner
      assert List.first(data)["description"]                     == struct.description
      assert List.first(data)["logo"]["id"]                      == struct.logo.id
      assert List.first(data)["logo"]["content_type"]            == struct.logo.content_type
      assert List.first(data)["logo"]["name"]                    == struct.logo.name
      assert List.first(data)["logo"]["size"]                    == struct.logo.size
      assert List.first(data)["logo"]["url"]                     == struct.logo.url
      assert List.first(data)["logo"]["inserted_at"]             == format_time(struct.logo.inserted_at)
      assert List.first(data)["logo"]["updated_at"]              == format_time(struct.logo.updated_at)
      assert List.first(data)["inserted_at"]                     == format_time(struct.inserted_at)
      assert List.first(data)["updated_at"]                      == format_time(struct.updated_at)
      assert List.first(data)["us_zipcode"]["city"]              == struct.us_zipcode.city
      assert List.first(data)["us_zipcode"]["state"]             == struct.us_zipcode.state
      assert List.first(data)["us_zipcode"]["zipcode"]           == struct.us_zipcode.zipcode
      assert List.first(data)["user"]["id"]                      == struct.user.id
      assert List.first(data)["user"]["active"]                  == struct.user.active
      assert List.first(data)["user"]["admin_role"]              == struct.user.admin_role
      assert List.first(data)["user"]["avatar"]                  == struct.user.avatar
      assert List.first(data)["user"]["bio"]                     == struct.user.bio
      assert List.first(data)["user"]["birthday"]                == to_string(struct.user.birthday)
      assert List.first(data)["user"]["email"]                   == struct.user.email
      assert List.first(data)["user"]["first_name"]              == struct.user.first_name
      assert List.first(data)["user"]["init_setup"]              == struct.user.init_setup
      assert List.first(data)["user"]["last_name"]               == struct.user.last_name
      assert List.first(data)["user"]["middle_name"]             == struct.user.middle_name
      assert List.first(data)["user"]["phone"]                   == struct.user.phone
      assert List.first(data)["user"]["pro_role"]                == struct.user.pro_role
      assert List.first(data)["user"]["provider"]                == struct.user.provider
      assert List.first(data)["user"]["sex"]                     == struct.user.sex
      assert List.first(data)["user"]["ssn"]                     == struct.user.ssn
      assert List.first(data)["user"]["street"]                  == struct.user.street
      assert List.first(data)["user"]["zip"]                     == struct.user.zip
      assert List.first(data)["user"]["inserted_at"]             == format_time(struct.user.inserted_at)
      assert List.first(data)["user"]["updated_at"]              == format_time(struct.user.updated_at)
      assert List.first(data)["user"]["languages"][:id]          == nil
      assert List.first(data)["user"]["languages"][:abbr]        == nil
      assert List.first(data)["user"]["languages"][:name]        == nil
      assert List.first(data)["user"]["languages"][:inserted_at] == nil
      assert List.first(data)["user"]["languages"][:updated_at]  == nil

      assert List.last(data)["address"]                         == struct.address
      assert List.last(data)["banner"]                          == struct.banner
      assert List.last(data)["description"]                     == struct.description
      assert List.last(data)["logo"]["id"]                      == struct.logo.id
      assert List.last(data)["logo"]["content_type"]            == struct.logo.content_type
      assert List.last(data)["logo"]["name"]                    == struct.logo.name
      assert List.last(data)["logo"]["size"]                    == struct.logo.size
      assert List.last(data)["logo"]["url"]                     == struct.logo.url
      assert List.last(data)["logo"]["inserted_at"]             == format_time(struct.logo.inserted_at)
      assert List.last(data)["logo"]["updated_at"]              == format_time(struct.logo.updated_at)
      assert List.last(data)["inserted_at"]                     == format_time(struct.inserted_at)
      assert List.last(data)["updated_at"]                      == format_time(struct.updated_at)
      assert List.last(data)["us_zipcode"]["city"]              == struct.us_zipcode.city
      assert List.last(data)["us_zipcode"]["state"]             == struct.us_zipcode.state
      assert List.last(data)["us_zipcode"]["zipcode"]           == struct.us_zipcode.zipcode
      assert List.last(data)["user"]["id"]                      == struct.user.id
      assert List.last(data)["user"]["active"]                  == struct.user.active
      assert List.last(data)["user"]["admin_role"]              == struct.user.admin_role
      assert List.last(data)["user"]["avatar"]                  == struct.user.avatar
      assert List.last(data)["user"]["bio"]                     == struct.user.bio
      assert List.last(data)["user"]["birthday"]                == to_string(struct.user.birthday)
      assert List.last(data)["user"]["email"]                   == struct.user.email
      assert List.last(data)["user"]["first_name"]              == struct.user.first_name
      assert List.last(data)["user"]["init_setup"]              == struct.user.init_setup
      assert List.last(data)["user"]["last_name"]               == struct.user.last_name
      assert List.last(data)["user"]["middle_name"]             == struct.user.middle_name
      assert List.last(data)["user"]["phone"]                   == struct.user.phone
      assert List.last(data)["user"]["pro_role"]                == struct.user.pro_role
      assert List.last(data)["user"]["provider"]                == struct.user.provider
      assert List.last(data)["user"]["sex"]                     == struct.user.sex
      assert List.last(data)["user"]["ssn"]                     == struct.user.ssn
      assert List.last(data)["user"]["street"]                  == struct.user.street
      assert List.last(data)["user"]["zip"]                     == struct.user.zip
      assert List.last(data)["user"]["inserted_at"]             == format_time(struct.user.inserted_at)
      assert List.last(data)["user"]["updated_at"]              == format_time(struct.user.updated_at)
      assert List.last(data)["user"]["languages"][:id]          == nil
      assert List.last(data)["user"]["languages"][:abbr]        == nil
      assert List.last(data)["user"]["languages"][:name]        == nil
      assert List.last(data)["user"]["languages"][:inserted_at] == nil
      assert List.last(data)["user"]["languages"][:updated_at]  == nil

      {:ok, %{data: %{"allProfiles" => data}}} =
        Absinthe.run(query, Schema, context: context)

      first = hd(data)

      assert first["address"]                         == struct.address
      assert first["banner"]                          == struct.banner
      assert first["description"]                     == struct.description
      assert first["logo"]["id"]                      == struct.logo.id
      assert first["logo"]["content_type"]            == struct.logo.content_type
      assert first["logo"]["name"]                    == struct.logo.name
      assert first["logo"]["size"]                    == struct.logo.size
      assert first["logo"]["url"]                     == struct.logo.url
      assert first["logo"]["inserted_at"]             == format_time(struct.logo.inserted_at)
      assert first["logo"]["updated_at"]              == format_time(struct.logo.updated_at)
      assert first["inserted_at"]                     == format_time(struct.inserted_at)
      assert first["updated_at"]                      == format_time(struct.updated_at)
      assert first["us_zipcode"]["id"]                == struct.us_zipcode_id
      assert first["us_zipcode"]["city"]              == struct.us_zipcode.city
      assert first["us_zipcode"]["state"]             == struct.us_zipcode.state
      assert first["us_zipcode"]["zipcode"]           == struct.us_zipcode.zipcode
      assert first["user"]["id"]                      == struct.user_id
      assert first["user"]["active"]                  == struct.user.active
      assert first["user"]["admin_role"]              == struct.user.admin_role
      assert first["user"]["avatar"]                  == struct.user.avatar
      assert first["user"]["bio"]                     == struct.user.bio
      assert first["user"]["birthday"]                == to_string(struct.user.birthday)
      assert first["user"]["email"]                   == struct.user.email
      assert first["user"]["first_name"]              == struct.user.first_name
      assert first["user"]["init_setup"]              == struct.user.init_setup
      assert first["user"]["last_name"]               == struct.user.last_name
      assert first["user"]["middle_name"]             == struct.user.middle_name
      assert first["user"]["phone"]                   == struct.user.phone
      assert first["user"]["pro_role"]                == struct.user.pro_role
      assert first["user"]["provider"]                == struct.user.provider
      assert first["user"]["sex"]                     == struct.user.sex
      assert first["user"]["ssn"]                     == struct.user.ssn
      assert first["user"]["street"]                  == struct.user.street
      assert first["user"]["zip"]                     == struct.user.zip
      assert first["user"]["languages"][:id]          == nil
      assert first["user"]["languages"][:abbr]        == nil
      assert first["user"]["languages"][:name]        == nil
      assert first["user"]["languages"][:inserted_at] == nil
      assert first["user"]["languages"][:updated_at]  == nil
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
          logo {id content_type name size url inserted_at updated_at}
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

      assert found["address"]                         == struct.address
      assert found["banner"]                          == struct.banner
      assert found["description"]                     == struct.description
      assert found["logo"]["id"]                      == struct.logo.id
      assert found["logo"]["content_type"]            == struct.logo.content_type
      assert found["logo"]["name"]                    == struct.logo.name
      assert found["logo"]["size"]                    == struct.logo.size
      assert found["logo"]["url"]                     == struct.logo.url
      assert found["logo"]["inserted_at"]             == format_time(struct.logo.inserted_at)
      assert found["logo"]["updated_at"]              == format_time(struct.logo.updated_at)
      assert found["inserted_at"]                     == format_time(struct.inserted_at)
      assert found["updated_at"]                      == format_time(struct.updated_at)
      assert found["us_zipcode"]["id"]                == struct.us_zipcode_id
      assert found["us_zipcode"]["city"]              == struct.us_zipcode.city
      assert found["us_zipcode"]["state"]             == struct.us_zipcode.state
      assert found["us_zipcode"]["zipcode"]           == struct.us_zipcode.zipcode
      assert found["user"]["id"]                      == struct.user_id
      assert found["user"]["active"]                  == struct.user.active
      assert found["user"]["admin_role"]              == struct.user.admin_role
      assert found["user"]["avatar"]                  == struct.user.avatar
      assert found["user"]["bio"]                     == struct.user.bio
      assert found["user"]["birthday"]                == to_string(struct.user.birthday)
      assert found["user"]["email"]                   == struct.user.email
      assert found["user"]["first_name"]              == struct.user.first_name
      assert found["user"]["init_setup"]              == struct.user.init_setup
      assert found["user"]["last_name"]               == struct.user.last_name
      assert found["user"]["middle_name"]             == struct.user.middle_name
      assert found["user"]["phone"]                   == struct.user.phone
      assert found["user"]["pro_role"]                == struct.user.pro_role
      assert found["user"]["provider"]                == struct.user.provider
      assert found["user"]["sex"]                     == struct.user.sex
      assert found["user"]["ssn"]                     == struct.user.ssn
      assert found["user"]["street"]                  == struct.user.street
      assert found["user"]["zip"]                     == struct.user.zip
      assert found["user"]["languages"][:id]          == nil
      assert found["user"]["languages"][:abbr]        == nil
      assert found["user"]["languages"][:name]        == nil
      assert found["user"]["languages"][:inserted_at] == nil
      assert found["user"]["languages"][:updated_at]  == nil

      {:ok, %{data: %{"showProfile" => found}}} =
        Absinthe.run(query, Schema, context: context)

      assert found["address"]                         == struct.address
      assert found["banner"]                          == struct.banner
      assert found["description"]                     == struct.description
      assert found["logo"]["id"]                      == struct.logo.id
      assert found["logo"]["content_type"]            == struct.logo.content_type
      assert found["logo"]["name"]                    == struct.logo.name
      assert found["logo"]["size"]                    == struct.logo.size
      assert found["logo"]["url"]                     == struct.logo.url
      assert found["logo"]["inserted_at"]             == format_time(struct.logo.inserted_at)
      assert found["logo"]["updated_at"]              == format_time(struct.logo.updated_at)
      assert found["inserted_at"]                     == format_time(struct.inserted_at)
      assert found["updated_at"]                      == format_time(struct.updated_at)
      assert found["user"]["languages"][:id]          == nil
      assert found["user"]["languages"][:abbr]        == nil
      assert found["user"]["languages"][:name]        == nil
      assert found["user"]["languages"][:inserted_at] == nil
      assert found["user"]["languages"][:updated_at]  == nil
      assert found["user"]["id"]                      == struct.user_id
      assert found["user"]["active"]                  == struct.user.active
      assert found["user"]["admin_role"]              == struct.user.admin_role
      assert found["user"]["avatar"]                  == struct.user.avatar
      assert found["user"]["bio"]                     == struct.user.bio
      assert found["user"]["birthday"]                == to_string(struct.user.birthday)
      assert found["user"]["email"]                   == struct.user.email
      assert found["user"]["first_name"]              == struct.user.first_name
      assert found["user"]["init_setup"]              == struct.user.init_setup
      assert found["user"]["last_name"]               == struct.user.last_name
      assert found["user"]["middle_name"]             == struct.user.middle_name
      assert found["user"]["phone"]                   == struct.user.phone
      assert found["user"]["pro_role"]                == struct.user.pro_role
      assert found["user"]["provider"]                == struct.user.provider
      assert found["user"]["sex"]                     == struct.user.sex
      assert found["user"]["ssn"]                     == struct.user.ssn
      assert found["user"]["street"]                  == struct.user.street
      assert found["user"]["zip"]                     == struct.user.zip
      assert found["us_zipcode"]["id"]                == struct.us_zipcode_id
      assert found["us_zipcode"]["city"]              == struct.us_zipcode.city
      assert found["us_zipcode"]["state"]             == struct.us_zipcode.state
      assert found["us_zipcode"]["zipcode"]           == struct.us_zipcode.zipcode
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
      logo = %{name: "Time for #NeverBernie", alt: "I woke up this morning wondering whether it’s time to unfurl the #NeverBernie banner.", file: "bernie.jpg"}

      mutation = """
      {
        updateProfile(
          id: \"#{struct.user_id}\",
          logo: {
            picture: {
              alt: \"#{logo.alt}\",
              file: \"#{logo.file}\",
              name: \"#{logo.name}\"
            }
          },
          profile: {
            address: "updated text",
            banner: "updated text",
            description: "updated text",
            us_zipcodeId: \"#{zipcode.id}\",
            userId: \"#{struct.user_id}\"
          },
        ) {
          address
          banner
          description
          logo {id content_type name size url inserted_at updated_at}
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

      map = %{
        "query" => "mutation #{mutation}",
        logo.file => %Plug.Upload{
          filename: logo.file,
          path: @bernie_path
        }
      }

      res =
        build_conn()
        |> put_req_header("content-type", "multipart/form-data")
        |> post("/graphiql", map)

      assert json_response(res, 200)["errors"] == nil

      updated = json_response(res, 200)["data"]["updateProfile"]

      assert updated["address"]                         == "updated text"
      assert updated["banner"]                          == "updated text"
      assert updated["description"]                     == "updated text"
      assert updated["logo"]["id"]
      assert updated["logo"]["content_type"]            == "image/jpg"
      assert updated["logo"]["name"]                    == "Logo"
      assert updated["logo"]["size"]                    == 5024
      assert updated["logo"]["url"]                     =~ ServerWeb.Endpoint.url() <> "/media/"
      assert updated["logo"]["inserted_at"]
      assert updated["logo"]["updated_at"]
      assert updated["inserted_at"]                     == format_time(struct.inserted_at)
      assert updated["updated_at"]                      == format_time(struct.updated_at)
      assert updated["user"]["languages"][:id]          == nil
      assert updated["user"]["languages"][:abbr]        == nil
      assert updated["user"]["languages"][:name]        == nil
      assert updated["user"]["languages"][:inserted_at] == nil
      assert updated["user"]["languages"][:updated_at]  == nil
      assert updated["user"]["id"]                      == struct.user_id
      assert updated["user"]["active"]                  == struct.user.active
      assert updated["user"]["admin_role"]              == struct.user.admin_role
      assert updated["user"]["avatar"]                  == struct.user.avatar
      assert updated["user"]["bio"]                     == struct.user.bio
      assert updated["user"]["birthday"]                == to_string(struct.user.birthday)
      assert updated["user"]["email"]                   == struct.user.email
      assert updated["user"]["first_name"]              == struct.user.first_name
      assert updated["user"]["init_setup"]              == struct.user.init_setup
      assert updated["user"]["last_name"]               == struct.user.last_name
      assert updated["user"]["middle_name"]             == struct.user.middle_name
      assert updated["user"]["phone"]                   == struct.user.phone
      assert updated["user"]["pro_role"]                == struct.user.pro_role
      assert updated["user"]["provider"]                == struct.user.provider
      assert updated["user"]["sex"]                     == struct.user.sex
      assert updated["user"]["ssn"]                     == struct.user.ssn
      assert updated["user"]["street"]                  == struct.user.street
      assert updated["user"]["zip"]                     == struct.user.zip
      assert updated["us_zipcode"]["id"]                == zipcode.id
      assert updated["us_zipcode"]["city"]              == struct.us_zipcode.city
      assert updated["us_zipcode"]["state"]             == struct.us_zipcode.state
      assert updated["us_zipcode"]["zipcode"]           == struct.us_zipcode.zipcode
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
