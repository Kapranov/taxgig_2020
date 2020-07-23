defmodule ServerWeb.GraphQL.Resolvers.Skills.AccountingSoftwareResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Skills.AccountingSoftwareResolver

  describe "#index" do
    it "returns AccountingSoftware" do
      struct = insert(:accounting_software)
      education = insert(:education, user: struct.user)
      work_experience = insert(:work_experience, user: struct.user)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, data} = AccountingSoftwareResolver.list(nil, nil, context)
      assert length(data) == 1
      assert List.first(data).id                == struct.id
      assert List.first(data).name              == struct.name

      assert List.first(data).user.id           == struct.user.id
      assert List.first(data).user.avatar       == struct.user.avatar
      assert List.first(data).user.active       == struct.user.active
      assert List.first(data).user.avatar       == struct.user.avatar
      assert List.first(data).user.bio          == struct.user.bio
      assert List.first(data).user.birthday     == struct.user.birthday
      assert List.first(data).user.email        == struct.user.email
      assert List.first(data).user.first_name   == struct.user.first_name
      assert List.first(data).user.init_setup   == struct.user.init_setup
      assert List.first(data).user.last_name    == struct.user.last_name
      assert List.first(data).user.middle_name  == struct.user.middle_name
      assert List.first(data).user.phone        == struct.user.phone
      assert List.first(data).user.provider     == struct.user.provider
      assert List.first(data).user.role         == struct.user.role
      assert List.first(data).user.sex          == struct.user.sex
      assert List.first(data).user.ssn          == struct.user.ssn
      assert List.first(data).user.street       == struct.user.street
      assert List.first(data).user.zip          == struct.user.zip

      assert List.first(data).user.education.course           == education.course
      assert List.first(data).user.education.graduation       == education.graduation
      assert List.first(data).user.education.id               == education.id
      assert List.first(data).user.education.university_id    == education.university_id
      assert List.first(data).user.education.university.name  == education.university.name
      assert List.first(data).user.education.user_id          == user.id

      assert List.first(data).user.languages                  == struct.user.languages

      assert List.first(data).user.work_experience.end_date   == work_experience.end_date
      assert List.first(data).user.work_experience.id         == work_experience.id
      assert List.first(data).user.work_experience.name       == work_experience.name
      assert List.first(data).user.work_experience.start_date == work_experience.start_date
      assert List.first(data).user.work_experience.user_id    == user.id
    end

    it "returns error unauthenticated" do
      insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.list(nil, nil, context)
      assert error == [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]
    end
  end

  describe "#show" do
    it "returns specific AccountingSoftware by id" do
      struct = insert(:accounting_software)
      education = insert(:education, user: struct.user)
      work_experience = insert(:work_experience, user: struct.user)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, found} = AccountingSoftwareResolver.show(nil, %{id: struct.id}, context)

      assert found.id                == struct.id
      assert found.name              == struct.name

      assert found.user.id           == struct.user.id
      assert found.user.avatar       == struct.user.avatar
      assert found.user.active       == struct.user.active
      assert found.user.avatar       == struct.user.avatar
      assert found.user.bio          == struct.user.bio
      assert found.user.birthday     == struct.user.birthday
      assert found.user.email        == struct.user.email
      assert found.user.first_name   == struct.user.first_name
      assert found.user.init_setup   == struct.user.init_setup
      assert found.user.last_name    == struct.user.last_name
      assert found.user.middle_name  == struct.user.middle_name
      assert found.user.phone        == struct.user.phone
      assert found.user.provider     == struct.user.provider
      assert found.user.role         == struct.user.role
      assert found.user.sex          == struct.user.sex
      assert found.user.ssn          == struct.user.ssn
      assert found.user.street       == struct.user.street
      assert found.user.zip          == struct.user.zip

      assert found.user.education.course           == education.course
      assert found.user.education.graduation       == education.graduation
      assert found.user.education.id               == education.id
      assert found.user.education.university_id    == education.university_id
      assert found.user.education.university.name  == education.university.name
      assert found.user.education.user_id          == user.id

      assert found.user.languages                  == struct.user.languages

      assert found.user.work_experience.end_date   == work_experience.end_date
      assert found.user.work_experience.id         == work_experience.id
      assert found.user.work_experience.name       == work_experience.name
      assert found.user.work_experience.start_date == work_experience.start_date
      assert found.user.work_experience.user_id    == user.id
    end

    it "returns error AccountingSoftware does not exist" do
      id = FlakeId.get()
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.show(nil, %{id: id}, context)
      assert error == "An AccountingSoftware #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = AccountingSoftwareResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.show(nil, %{id: struct.id}, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#create" do
    it "creates AccountingSoftware" do
      pro = insert(:pro_user)
      args = %{name: ["QuickBooks Desktop Premier"], user_id: pro.id}
      user = Core.Accounts.User.find_by(id: args.user_id)
      context = %{context: %{current_user: user}}
      {:ok, created} = AccountingSoftwareResolver.create(nil, args, context)
      assert created.name == [:"#{args.name}"]
    end

    it "returns error is not correct name" do
      pro = insert(:pro_user)
      args = %{name: ["some text"], user_id: pro.id}
      user = Core.Accounts.User.find_by(id: args.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.create(nil, args, context)
      assert error == [[field: :name, message: "Is invalid"]]
    end

    it "returns error for missing params by name" do
      pro = insert(:pro_user)
      args = %{name: nil, user_id: pro.id}
      user = Core.Accounts.User.find_by(id: args.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.create(nil, args, context)
      assert error == [[field: :name, message: "Can't be blank"]]
    end

    it "returns error for missing params by user_id" do
      pro = insert(:pro_user)
      args = %{name: ["QuickBooks Desktop Premier"], user_id: nil}
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end

    it "returns error for missing params" do
      pro = insert(:pro_user)
      args = %{name: nil, user_id: nil}
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end

    it "returns error unauthenticated" do
      pro = insert(:pro_user)
      args = %{name: ["QuickBooks Desktop Premier"], user_id: pro.id}
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end
  end

  describe "#update" do
    it "update specific AccountingSoftware by user_id" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      args = %{
        id: struct.id,
        accounting_software: %{
          name: ["Xero HQ"],
          user_id: struct.user_id
        }
      }

      {:ok, updated} = AccountingSoftwareResolver.update(nil, args, context)

      assert updated.id                == struct.id
      assert updated.name              == [:"Xero HQ"]
    end

    it "returns error AccountingSoftware does not exist" do
      id = FlakeId.get()
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      args = %{
        id: id,
        accounting_software: %{
          name: ["Xero HQ"],
          user_id: struct.user_id
        }
      }
      {:error, error} = AccountingSoftwareResolver.update(nil, args, context)
      assert error == "An AccountingSoftware #{id} not found!"
    end

    it "returns error is not correct name" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      args = %{
        id: struct.id,
        accounting_software: %{
          name: ["some text"],
          user_id: struct.user_id
        }
      }

      {:error, %Ecto.Changeset{}} = AccountingSoftwareResolver.update(nil, args, context)
    end

    it "nothing change for missing params" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil, accounting_software: nil}
      {:error, error} = AccountingSoftwareResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}

      args = %{
        id: struct.id,
        accounting_software: %{
          name: ["Xero HQ"],
          user_id: struct.user_id
        }
      }

      {:error, error} = AccountingSoftwareResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end
  end

  describe "#delete" do
    it "delete specific AccountingSoftware by id" do
      struct = insert(:accounting_software)
      insert(:education, user: struct.user)
      insert(:work_experience, user: struct.user)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, deleted} = AccountingSoftwareResolver.delete(nil, %{id: struct.id}, context)
      assert deleted.id == struct.id
    end

    it "returns not found when profile does not exist" do
      id = FlakeId.get()
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.delete(nil, %{id: id}, context)
      assert error == "An AccountingSoftware #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:accounting_software)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = AccountingSoftwareResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:accounting_software)
      args = %{id: struct.id}
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = AccountingSoftwareResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end
  end
end
