defmodule ServerWeb.GraphQL.Resolvers.Skills.WorkExperienceResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Skills.WorkExperienceResolver

  describe "#index" do
    it "returns WorkExperience" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, data} = WorkExperienceResolver.list(nil, nil, context)
      assert length(data) == 1
      assert List.first(data).id                == struct.id
      assert List.first(data).name              == struct.name
      assert List.first(data).start_date        == struct.start_date
      assert List.first(data).end_date          == struct.end_date
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
      assert List.first(data).user.languages    == struct.user.languages
    end

    it "returns error unauthenticated" do
      insert(:work_experience)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.list(nil, nil, context)
      assert error == [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]
    end
  end

  describe "#show" do
    it "returns specific WorkExperience by id" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, found} = WorkExperienceResolver.show(nil, %{id: struct.id}, context)

      assert found.id                == struct.id
      assert found.name              == struct.name
      assert found.start_date        == struct.start_date
      assert found.end_date          == struct.end_date
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
      assert found.user.languages    == struct.user.languages
    end

    it "returns error WorkExperience does not exist" do
      id = FlakeId.get()
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.show(nil, %{id: id}, context)
      assert error == "A WorkExperience #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = WorkExperienceResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.show(nil, %{id: struct.id}, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#create" do
    it "creates WorkExperience for role Pro" do
      pro = insert(:pro_user)
      args = %{name: "some text", start_date: Date.utc_today(), end_date: Date.utc_today(), user_id: pro.id}
      user = Core.Accounts.User.find_by(id: args.user_id)
      context = %{context: %{current_user: user}}
      {:ok, created} = WorkExperienceResolver.create(nil, args, context)
      assert created.name       == args.name
      assert created.start_date == args.start_date
      assert created.end_date   == args.end_date
      assert created.user_id    == args.user_id
    end

    it "creates WorkExperience for role Tp" do
      tp = insert(:tp_user)
      args = %{name: "some text", start_date: Date.utc_today(), end_date: Date.utc_today(), user_id: tp.id}
      user = Core.Accounts.User.find_by(id: args.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.create(nil, args, context)
      assert error == []
    end

    it "returns error for missing params by user_id" do
      pro = insert(:pro_user)
      args = %{name: "some text", start_date: Date.utc_today(), end_date: Date.utc_today(), user_id: nil}
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end

    it "returns error for missing params" do
      pro = insert(:pro_user)
      args = %{name: nil, start_date: nil, end_date: nil, user_id: nil}
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end

    it "returns error unauthenticated" do
      pro = insert(:pro_user)
      args = %{name: "some text", start_date: Date.utc_today(), end_date: Date.utc_today(), user_id: pro.id}
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end
  end

  describe "#update" do
    it "update specific WorkExperience by user_id" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      args = %{
        id: struct.id,
        work_experience: %{
          name: "updated text",
          start_date: Date.utc_today |> Date.add(-3),
          end_date: Date.utc_today |> Date.add(-6),
          user_id: struct.user_id
        }
      }

      {:ok, updated} = WorkExperienceResolver.update(nil, args, context)

      assert updated.id          == struct.id
      assert updated.name        == "updated text"
      assert updated.start_date  == Date.utc_today |> Date.add(-3)
      assert updated.end_date    == Date.utc_today |> Date.add(-6)
      assert updated.user_id     == user.id
    end

    it "returns error WorkExperience does not exist" do
      id = FlakeId.get()
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      args = %{
        id: id,
        work_experience: %{
          name: "updated text",
          start_date: Date.utc_today |> Date.add(-3),
          end_date: Date.utc_today |> Date.add(-6),
          user_id: struct.user_id
        }
      }

      {:error, error} = WorkExperienceResolver.update(nil, args, context)
      assert error == "A WorkExperience #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil, work_experience: nil}
      {:error, error} = WorkExperienceResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}

      args = %{
        id: struct.id,
        work_experience: %{
          name: "updated text",
          start_date: Date.utc_today |> Date.add(-3),
          end_date: Date.utc_today |> Date.add(-6),
          user_id: struct.user_id
        }
      }

      {:error, error} = WorkExperienceResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end
  end

  describe "#delete" do
    it "delete specific WorkExperience by id" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, deleted} = WorkExperienceResolver.delete(nil, %{id: struct.id}, context)
      assert deleted.id == struct.id
    end

    it "returns not found when WorkExperience does not exist" do
      id = FlakeId.get()
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.delete(nil, %{id: id}, context)
      assert error == "A WorkExperience #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:work_experience)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = WorkExperienceResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:work_experience)
      args = %{id: struct.id}
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = WorkExperienceResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end
  end
end
