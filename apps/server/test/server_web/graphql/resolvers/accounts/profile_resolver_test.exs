defmodule ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolver
  alias ServerWeb.GraphQL.Resolvers.Accounts.UserResolver

  describe "#list" do
    it "returns accounts profile" do
      struct = insert(:profile)
      {:ok, profile} = ProfileResolver.list(nil, nil, nil)
      data =
        profile
        |> Core.Repo.preload([:us_zipcode, user: [:languages]])
      assert length(data) == 1
      assert List.first(data).address          == struct.address
      assert List.first(data).banner           == struct.banner
      assert List.first(data).description      == struct.description
      assert List.first(data).us_zipcode_id    == struct.us_zipcode_id
      assert List.first(data).user_id          == struct.user_id
      assert List.first(data).user.id          == struct.user.id
      assert List.first(data).user.avatar      == struct.user.avatar
      assert List.first(data).user.active      == struct.user.active
      assert List.first(data).user.admin_role  == struct.user.admin_role
      assert List.first(data).user.avatar      == struct.user.avatar
      assert List.first(data).user.bio         == struct.user.bio
      assert List.first(data).user.birthday    == struct.user.birthday
      assert List.first(data).user.email       == struct.user.email
      assert List.first(data).user.first_name  == struct.user.first_name
      assert List.first(data).user.init_setup  == struct.user.init_setup
      assert List.first(data).user.last_name   == struct.user.last_name
      assert List.first(data).user.middle_name == struct.user.middle_name
      assert List.first(data).user.phone       == struct.user.phone
      assert List.first(data).user.pro_role    == struct.user.pro_role
      assert List.first(data).user.provider    == struct.user.provider
      assert List.first(data).user.sex         == struct.user.sex
      assert List.first(data).user.ssn         == struct.user.ssn
      assert List.first(data).user.street      == struct.user.street
      assert List.first(data).user.zip         == struct.user.zip
      assert List.first(data).user.inserted_at == struct.user.inserted_at
      assert List.first(data).user.updated_at  == struct.user.updated_at
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
    end
  end

  describe "#show" do
    it "returns specific profile by user_id" do
      struct = insert(:profile)
      {:ok, found} = ProfileResolver.show(nil, %{id: struct.user_id}, nil)
      assert found.address          == struct.address
      assert found.banner           == struct.banner
      assert found.description      == struct.description
      assert found.us_zipcode_id    == struct.us_zipcode_id
      assert found.user_id          == struct.user_id
      assert found.user.id          == struct.user.id
      assert found.user.active      == struct.user.active
      assert found.user.admin_role  == struct.user.admin_role
      assert found.user.avatar      == struct.user.avatar
      assert found.user.bio         == struct.user.bio
      assert found.user.birthday    == struct.user.birthday
      assert found.user.email       == struct.user.email
      assert found.user.first_name  == struct.user.first_name
      assert found.user.init_setup  == struct.user.init_setup
      assert found.user.last_name   == struct.user.last_name
      assert found.user.middle_name == struct.user.middle_name
      assert found.user.phone       == struct.user.phone
      assert found.user.pro_role    == struct.user.pro_role
      assert found.user.provider    == struct.user.provider
      assert found.user.sex         == struct.user.sex
      assert found.user.ssn         == struct.user.ssn
      assert found.user.street      == struct.user.street
      assert found.user.zip         == struct.user.zip
      assert found.user.inserted_at == struct.user.inserted_at
      assert found.user.updated_at  == struct.user.updated_at
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
    end

    it "returns not found when profile does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = ProfileResolver.show(nil, %{id: id}, nil)
      assert error == "An User #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:profile)
      args = %{id: nil}
      {:error, error} = ProfileResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
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

      {:ok, created} = ProfileResolver.show(nil, %{id: user.id}, nil)
      assert created.address          == nil
      assert created.banner           == nil
      assert created.description      == nil
      assert created.us_zipcode_id    == nil
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
      assert created.us_zipcode       == nil
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

      args = %{id: struct.user_id,
        profile: %{
          address: "updated text",
          banner: "updated text",
          description: "updated text",
          us_zipcode_id: zipcode.id,
          user_id: struct.user_id
        }
      }

      {:ok, updated} = ProfileResolver.update(nil, args, nil)
      assert updated.address       == "updated text"
      assert updated.banner        == "updated text"
      assert updated.description   == "updated text"
      assert updated.us_zipcode_id == zipcode.id
      assert updated.user_id       == struct.user_id
    end

    it "nothing change for missing params" do
      struct = insert(:profile)
      args = %{id: struct.user_id, profile: %{}}
      {:ok, updated} = ProfileResolver.update(nil, args, nil)
      assert updated.address       == "some text"
      assert updated.banner        == "some text"
      assert updated.description   == "some text"
      assert updated.us_zipcode_id == struct.us_zipcode_id
      assert updated.user_id       == struct.user_id
    end

    it "returns error for missing params" do
      insert(:profile)
      args = %{id: nil, profile: nil}
      {:error, error} = ProfileResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific accounts subscriber by id" do
      struct = insert(:profile)
      {:ok, deleted} = ProfileResolver.delete(nil, %{id: struct.user_id}, nil)
      assert deleted.id == struct.user_id
    end

    it "returns not found when profile does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = ProfileResolver.delete(nil, %{id: id}, nil)
      assert error == "The Profile #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:profile)
      args = %{id: nil}
      {:error, error} = ProfileResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
