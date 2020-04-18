defmodule ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Accounts.{
    ProfileResolver,
    UserResolver
  }

  @trump_path Path.absname("../core/test/fixtures/trump.jpg")

  describe "#list" do
    it "returns accounts profile" do
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, profile} = ProfileResolver.list(nil, nil, context)
      data =
        profile
        |> Core.Repo.preload([:us_zipcode, user: [:languages]])
      assert length(data) == 1
      assert List.first(data).address           == struct.address
      assert List.first(data).banner            == struct.banner
      assert List.first(data).description       == struct.description
      assert List.first(data).logo.id           == struct.logo.id
      assert List.first(data).logo.content_type == struct.logo.content_type
      assert List.first(data).logo.name         == struct.logo.name
      assert List.first(data).logo.size         == struct.logo.size
      assert List.first(data).logo.url          == struct.logo.url
      assert List.first(data).logo.inserted_at  == struct.logo.inserted_at
      assert List.first(data).logo.updated_at   == struct.logo.updated_at
      assert List.first(data).us_zipcode_id     == struct.us_zipcode_id
      assert List.first(data).user_id           == struct.user_id
      assert List.first(data).user.id           == struct.user.id
      assert List.first(data).user.avatar       == struct.user.avatar
      assert List.first(data).user.active       == struct.user.active
      assert List.first(data).user.admin_role   == struct.user.admin_role
      assert List.first(data).user.avatar       == struct.user.avatar
      assert List.first(data).user.bio          == struct.user.bio
      assert List.first(data).user.birthday     == struct.user.birthday
      assert List.first(data).user.email        == struct.user.email
      assert List.first(data).user.first_name   == struct.user.first_name
      assert List.first(data).user.init_setup   == struct.user.init_setup
      assert List.first(data).user.last_name    == struct.user.last_name
      assert List.first(data).user.middle_name  == struct.user.middle_name
      assert List.first(data).user.phone        == struct.user.phone
      assert List.first(data).user.pro_role     == struct.user.pro_role
      assert List.first(data).user.provider     == struct.user.provider
      assert List.first(data).user.sex          == struct.user.sex
      assert List.first(data).user.ssn          == struct.user.ssn
      assert List.first(data).user.street       == struct.user.street
      assert List.first(data).user.zip          == struct.user.zip
      assert List.first(data).user.inserted_at  == struct.user.inserted_at
      assert List.first(data).user.updated_at   == struct.user.updated_at
      assert %Core.Lookup.UsZipcode{
        id: _,
        city: "AGUADA",
        state: "PR",
        zipcode: 602,
      } = List.first(data).us_zipcode
      [%Core.Localization.Language{
          id: _,
          abbr: "chi",
          name: "chinese",
          inserted_at: _,
          updated_at: _
        }
      ] = List.first(data).user.languages
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end
  end

  describe "#show" do
    it "returns specific profile by user_id" do
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, found} = ProfileResolver.show(nil, %{id: struct.user_id}, context)
      assert found.address           == struct.address
      assert found.banner            == struct.banner
      assert found.description       == struct.description
      assert found.logo.id           == struct.logo.id
      assert found.logo.content_type == struct.logo.content_type
      assert found.logo.name         == struct.logo.name
      assert found.logo.size         == struct.logo.size
      assert found.logo.url          == struct.logo.url
      assert found.logo.inserted_at  == struct.logo.inserted_at
      assert found.logo.updated_at   == struct.logo.updated_at
      assert found.us_zipcode_id     == struct.us_zipcode_id
      assert found.user_id           == struct.user_id
      assert found.user.id           == struct.user.id
      assert found.user.active       == struct.user.active
      assert found.user.admin_role   == struct.user.admin_role
      assert found.user.avatar       == struct.user.avatar
      assert found.user.bio          == struct.user.bio
      assert found.user.birthday     == struct.user.birthday
      assert found.user.email        == struct.user.email
      assert found.user.first_name   == struct.user.first_name
      assert found.user.init_setup   == struct.user.init_setup
      assert found.user.last_name    == struct.user.last_name
      assert found.user.middle_name  == struct.user.middle_name
      assert found.user.phone        == struct.user.phone
      assert found.user.pro_role     == struct.user.pro_role
      assert found.user.provider     == struct.user.provider
      assert found.user.sex          == struct.user.sex
      assert found.user.ssn          == struct.user.ssn
      assert found.user.street       == struct.user.street
      assert found.user.zip          == struct.user.zip
      assert found.user.inserted_at  == struct.user.inserted_at
      assert found.user.updated_at   == struct.user.updated_at
      assert %Core.Lookup.UsZipcode{
        id: _,
        city: "AGUADA",
        state: "PR",
        zipcode: 602,
      } = found.us_zipcode
      assert [
        %Core.Localization.Language{
          id: _,
          abbr: "chi",
          name: "chinese",
          inserted_at: _,
          updated_at: _
        }
      ] = found.user.languages
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end

    it "returns not found when profile does not exist" do
      id = FlakeId.get()
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = ProfileResolver.show(nil, %{id: id}, context)
      assert error == "permission denied"
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end

    it "returns error for missing params" do
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = ProfileResolver.show(nil, args, context)
      assert error == [
        [field: :id, message: "Can't be blank or Unauthenticated"]
      ]
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end
  end

  describe "#create" do
    it "creates profile via user" do
      insert(:language)

      args = %{
        active: false,
        admin_role: false,
        avatar: "some text",
        bio: "some text",
        birthday: Timex.today,
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
      }

      {:ok, user} = UserResolver.create(nil, args, nil)

      data = Core.Accounts.User.find_by(id: user.id)
      context = %{context: %{current_user: data}}

      {:ok, created} = ProfileResolver.show(nil, %{id: user.id}, context)
      assert created.address          == nil
      assert created.banner           == nil
      assert created.description      == nil
      assert created.logo             == nil
      assert created.us_zipcode_id    == nil
      assert created.us_zipcode       == nil
      assert created.user_id          == user.id
      assert created.user.id          == user.id
      assert created.user.active      == user.active
      assert created.user.admin_role  == user.admin_role
      assert created.user.avatar      == user.avatar
      assert created.user.bio         == user.bio
      assert created.user.birthday    == user.birthday
      assert created.user.email       == user.email
      assert created.user.first_name  == user.first_name
      assert created.user.init_setup  == user.init_setup
      assert created.user.last_name   == user.last_name
      assert created.user.middle_name == user.middle_name
      assert created.user.phone       == user.phone
      assert created.user.pro_role    == user.pro_role
      assert created.user.provider    == user.provider
      assert created.user.sex         == user.sex
      assert created.user.ssn         == user.ssn
      assert created.user.street      == user.street
      assert created.user.zip         == user.zip
      assert created.user.inserted_at == user.inserted_at
      assert created.user.updated_at  == user.updated_at
      assert [
        %Core.Localization.Language{
          id: _,
          abbr: "chi",
          name: "chinese",
          inserted_at: _,
          updated_at: _
        }
      ] = created.user.languages
    end
  end

  describe "#update" do
    it "update specific profile by user_id" do
      struct = insert(:profile)
      zipcode = insert(:zipcode)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      file = %Plug.Upload{
        content_type: "image/jpg",
        path: @trump_path,
        filename: "trump.jpg"
      }

      {:ok, data} = Core.Upload.store(file)

      args = %{
        id: struct.user_id,
        logo: %{
          name: file.filename,
          content_type: file.content_type,
          size: data.size,
          url: data.url
        },
        profile: %{
          address: "updated text",
          banner: "updated text",
          description: "updated text",
          us_zipcode_id: zipcode.id,
          user_id: struct.user_id
        }
      }

      {:ok, updated} = ProfileResolver.update(nil, args, context)
      assert updated.address           == "updated text"
      assert updated.banner            == "updated text"
      assert updated.logo.content_type == "image/jpg"
      assert updated.logo.name         == "Logo"
      assert updated.logo.size         == 5024
      assert updated.description   == "updated text"
      assert updated.us_zipcode_id == zipcode.id
      assert updated.user_id       == struct.user_id
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(data.url)
    end

    it "nothing change for missing params" do
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: struct.user_id, logo: %{}, profile: %{}}
      {:ok, updated} = ProfileResolver.update(nil, args, context)
      assert updated.address           == "some text"
      assert updated.banner            == "some text"
      assert updated.description       == "some text"
      assert updated.logo.id           == struct.logo.id
      assert updated.logo.content_type == "image/jpg"
      assert updated.logo.name         == "Logo"
      assert updated.logo.size         == 5024
      assert updated.logo.url          == struct.logo.url
      assert updated.logo.inserted_at  == struct.logo.inserted_at
      assert updated.logo.updated_at   == struct.logo.updated_at
      assert updated.us_zipcode_id     == struct.us_zipcode_id
      assert updated.user_id           == struct.user_id
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end

    it "returns error for missing params" do
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil, logo: nil, profile: nil}
      {:error, error} = ProfileResolver.update(nil, args, context)
      assert error == [
        [field: :user_id, message: "Can't be blank or Unauthenticated"]
      ]
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end
  end

  describe "#delete" do
    it "delete specific accounts subscriber by id" do
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, deleted} = ProfileResolver.delete(nil, %{id: struct.user_id}, context)
      assert deleted.id == struct.user_id
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end

    it "returns not found when profile does not exist" do
      id = FlakeId.get()
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = ProfileResolver.delete(nil, %{id: id}, context)
      assert error == "permission denied"
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end

    it "returns error for missing params" do
      struct = insert(:profile)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = ProfileResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank"]]
      assert {:ok, %{
          body: "",
          headers: [
            {"x-amz-request-id", _x_amz_request_id},
            {"Date", _time_remove_file},
            {"Strict-Transport-Security", "max-age=15552000; includeSubDomains; preload"}
          ],
          status_code: 204
        }
      } = Core.Upload.remove(struct.logo.url)
    end
  end
end
