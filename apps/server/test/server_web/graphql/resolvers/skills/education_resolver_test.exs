defmodule ServerWeb.GraphQL.Resolvers.Skills.EducationResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Skills.EducationResolver

  describe "#index" do
    it "returns Education" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, data} = EducationResolver.list(nil, nil, context)
      assert length(data) == 1
      assert List.first(data).id                == struct.id
      assert List.first(data).course            == struct.course
      assert List.first(data).graduation        == struct.graduation

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

      assert List.first(data).university.id     == struct.university.id
      assert List.first(data).university.name   == struct.university.name
    end

    it "returns error unauthenticated" do
      insert(:education)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.list(nil, nil, context)
      assert error == [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]
    end
  end

  describe "#show" do
    it "returns specific Education by id" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, found} = EducationResolver.show(nil, %{id: struct.id}, context)

      assert found.id                == struct.id
      assert found.course            == struct.course
      assert found.graduation        == struct.graduation

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

      assert found.university.id     == struct.university.id
      assert found.university.name   == struct.university.name
    end

    it "returns error Education does not exist" do
      id = FlakeId.get()
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.show(nil, %{id: id}, context)
      assert error == "An Education #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = EducationResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.show(nil, %{id: struct.id}, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#create" do
    it "creates Education" do
      pro = insert(:pro_user)
      university = insert(:university)
      args = %{course: "some text", graduation: Date.utc_today(), university_id: university.id, user_id: pro.id}
      user = Core.Accounts.User.find_by(id: args.user_id)
      context = %{context: %{current_user: user}}
      {:ok, created} = EducationResolver.create(nil, args, context)
      assert created.course        == args.course
      assert created.graduation    == args.graduation
      assert created.university_id == args.university_id
      assert created.user_id       == args.user_id
    end

    it "returns error for missing params by user_id" do
      pro = insert(:pro_user)
      university = insert(:university)
      args = %{course: "some text", graduation: Date.utc_today(), university_id: university.id, user_id: nil}
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end

    it "returns error for missing params by university_id" do
      pro = insert(:pro_user)
      args = %{course: "some text", graduation: Date.utc_today(), university_id: nil, user_id: pro.id}
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.create(nil, args, context)
      assert error == [[field: :university_id, message: "Can't be blank"]]
    end

    it "returns error for missing params" do
      pro = insert(:pro_user)
      args = %{course: nil, graduation: nil, university_id: nil, user_id: nil}
      user = Core.Accounts.User.find_by(id: pro.id)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end

    it "returns error unauthenticated" do
      pro = insert(:pro_user)
      university = insert(:university)
      args = %{course: "some text", graduation: Date.utc_today(), university_id: university.id, user_id: pro.id}
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.create(nil, args, context)
      assert error == [[field: :user_id, message: "Can't be blank or Permission denied for current_user to perform action Create"]]
    end
  end

  describe "#update" do
    it "update specific Education by user_id" do
      struct = insert(:education)
      university = insert(:university)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      args = %{
        id: struct.id,
        education: %{
          course: "updated text",
          graduation: Date.utc_today |> Date.add(-3),
          university_id: university.id,
          user_id: struct.user_id
        }
      }

      {:ok, updated} = EducationResolver.update(nil, args, context)

      assert updated.id            == struct.id
      assert updated.course        == "updated text"
      assert updated.graduation    == Date.utc_today |> Date.add(-3)
      assert updated.user_id       == user.id
      assert updated.university_id == university.id
    end

    it "returns error Education does not exist" do
      id = FlakeId.get()
      struct = insert(:education)
      university = insert(:university)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}

      args = %{
        id: id,
        education: %{
          course: "updated text",
          graduation: Date.utc_today |> Date.add(-3),
          university_id: university.id,
          user_id: struct.user_id
        }
      }

      {:error, error} = EducationResolver.update(nil, args, context)
      assert error == "An Education #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil, education: nil}
      {:error, error} = EducationResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:education)
      university = insert(:university)
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}

      args = %{
        id: struct.id,
        education: %{
          course: "updated text",
          graduation: Date.utc_today |> Date.add(-3),
          university_id: university.id,
          user_id: struct.user_id
        }
      }

      {:error, error} = EducationResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end
  end

  describe "#delete" do
    it "delete specific Education by id" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:ok, deleted} = EducationResolver.delete(nil, %{id: struct.id}, context)
      assert deleted.id == struct.id
    end

    it "returns not found when profile does not exist" do
      id = FlakeId.get()
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.delete(nil, %{id: id}, context)
      assert error == "An Education #{id} not found!"
    end

    it "returns error for missing params" do
      struct = insert(:education)
      user = Core.Accounts.User.find_by(id: struct.user_id)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = EducationResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end

    it "returns error unauthenticated" do
      struct = insert(:education)
      args = %{id: struct.id}
      user = Core.Accounts.User.find_by(id: FlakeId.get)
      context = %{context: %{current_user: user}}
      {:error, error} = EducationResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Unauthenticated"]]
    end
  end
end
