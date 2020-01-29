defmodule ServerWeb.GraphQL.Resolvers.Accounts.UserResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Accounts.UserResolver

  describe "#list" do
    it "returns accounts an user" do
      struct = insert(:user)
      {:ok, data} = UserResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id          == struct.id
      assert List.first(data).active      == struct.active
      assert List.first(data).admin_role  == struct.admin_role
      assert List.first(data).avatar      == struct.avatar
      assert List.first(data).bio         == struct.bio
      assert List.first(data).birthday    == struct.birthday
      assert List.first(data).email       == struct.email
      assert List.first(data).first_name  == struct.first_name
      assert List.first(data).init_setup  == struct.init_setup
      assert List.first(data).last_name   == struct.last_name
      assert List.first(data).middle_name == struct.middle_name
      assert List.first(data).phone       == struct.phone
      assert List.first(data).pro_role    == struct.pro_role
      assert List.first(data).provider    == struct.provider
      assert List.first(data).sex         == struct.sex
      assert List.first(data).ssn         == struct.ssn
      assert List.first(data).street      == struct.street
      assert List.first(data).zip         == struct.zip
    end
  end

  describe "#show" do
    it "returns specific accounts an user by id" do
      struct = insert(:user)
      {:ok, found} = UserResolver.show(nil, %{id: struct.id}, nil)
      assert found.id          == struct.id
      assert found.active      == struct.active
      assert found.admin_role  == struct.admin_role
      assert found.avatar      == struct.avatar
      assert found.bio         == struct.bio
      assert found.birthday    == struct.birthday
      assert found.email       == struct.email
      assert found.first_name  == struct.first_name
      assert found.init_setup  == struct.init_setup
      assert found.last_name   == struct.last_name
      assert found.middle_name == struct.middle_name
      assert found.phone       == struct.phone
      assert found.pro_role    == struct.pro_role
      assert found.provider    == struct.provider
      assert found.sex         == struct.sex
      assert found.ssn         == struct.ssn
      assert found.street      == struct.street
      assert found.zip         == struct.zip
    end

    it "returns not found when accounts an user does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = UserResolver.show(nil, %{id: id}, nil)
      assert error == "An User #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:user)
      args = %{id: nil, email: nil, password: nil, password_confirmation: nil}
      {:error, error} = UserResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates accounts an user" do
      args = %{
        active: false,
        admin_role: false,
        avatar: "some text",
        bio: "some text",
        birthday: Timex.today,
        email: "lugatex@yahoo.com",
        first_name: "some text",
        init_setup: false,
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
      {:ok, created} = UserResolver.create(nil, args, nil)
      assert created.active      == false
      assert created.admin_role  == false
      assert created.avatar      == "some text"
      assert created.bio         == "some text"
      assert created.birthday    == Timex.today
      assert created.email       == "lugatex@yahoo.com"
      assert created.first_name  == "some text"
      assert created.init_setup  == false
      assert created.last_name   == "some text"
      assert created.middle_name == "some text"
      assert created.phone       == "some text"
      assert created.pro_role    == false
      assert created.provider    == "google"
      assert created.sex         == "some text"
      assert created.ssn         == 123456789
      assert created.street      == "some text"
      assert created.zip         == 123456789
    end

    it "returns error for missing params" do
      args = %{email: nil, password: nil, password_confirmation: nil}
      {:error, error} = UserResolver.create(nil, args, nil)
      assert error == [
        [field: :email, message: "Can't be blank"],
        [field: :password, message: "Can't be blank"],
        [field: :password_confirmation, message: "Can't be blank"]
      ]
    end
  end

  describe "#update" do
    it "update specific accounts an user by id" do
      struct = insert(:user)
      params = %{
        active: true,
        admin_role: true,
        avatar: "updated text",
        bio: "updated text",
        birthday: Timex.today,
        email: "kapranov.lugatex@gmail.com",
        first_name: "updated text",
        init_setup: true,
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
      args = %{id: struct.id, user: params}
      {:ok, updated} = UserResolver.update(nil, args, nil)
      assert updated.id          == struct.id
      assert updated.active      == true
      assert updated.admin_role  == true
      assert updated.avatar      == "updated text"
      assert updated.bio         == "updated text"
      assert updated.birthday    == Timex.today
      assert updated.email       == "kapranov.lugatex@gmail.com"
      assert updated.first_name  == "updated text"
      assert updated.init_setup  == true
      assert updated.last_name   == "updated text"
      assert updated.middle_name == "updated text"
      assert updated.phone       == "updated text"
      assert updated.pro_role    == true
      assert updated.provider    == "facebook"
      assert updated.sex         == "updated text"
      assert updated.ssn         == 987654321
      assert updated.street      == "updated text"
      assert updated.zip         == 987654321
    end

    it "return error when some params for missing params" do
      struct = insert(:user)
      params = %{}
      args = %{id: struct.id, user: params}
      {:error, %Ecto.Changeset{errors: error}} = UserResolver.update(nil, args, nil)
      assert error == [
        {:password, {"can't be blank", [validation: :required]}},
        {:password_confirmation, {"can't be blank", [validation: :required]}}
      ]
    end

    it "returns error for missing params" do
      insert(:user)
      params = %{email: nil, password: nil, password_confirmation: nil}
      args = %{id: nil, user: params}
      {:error, error} = UserResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific accounts an user by id" do
      struct = insert(:user)
      {:ok, deleted} = UserResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when accounts an user does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = UserResolver.delete(nil, %{id: id}, nil)
      assert error == "An User #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:user)
      args = %{id: nil}
      {:error, error} = UserResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
