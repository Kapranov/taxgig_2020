defmodule ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Accounts.ProfileResolver
  alias ServerWeb.GraphQL.Resolvers.Accounts.UserResolver

  describe "#list" do
    it "returns accounts profile" do
      struct = insert(:profile)
      {:ok, data} = ProfileResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).address       == struct.address
      assert List.first(data).banner        == struct.banner
      assert List.first(data).description   == struct.description
      assert List.first(data).us_zipcode_id == struct.us_zipcode_id
      assert List.first(data).user_id       == struct.user_id
    end
  end

  describe "#show" do
    it "returns specific profile by user_id" do
      struct = insert(:profile)
      {:ok, found} = ProfileResolver.show(nil, %{id: struct.user_id}, nil)
      assert found.address       == struct.address
      assert found.banner        == struct.banner
      assert found.description   == struct.description
      assert found.us_zipcode_id == struct.us_zipcode_id
      assert found.user_id       == struct.user_id
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
      insert(:zipcode)

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
      assert created.address       == nil
      assert created.banner        == nil
      assert created.description   == nil
      assert created.us_zipcode_id == nil
      assert created.user_id       == user.id
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
