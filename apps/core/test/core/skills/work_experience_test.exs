defmodule Core.Skills.WorkExperienceTest do
  use Core.DataCase

  alias Core.Skills

  describe "work experiences" do
    alias Core.Skills.WorkExperience

    @valid_attrs %{
      name: "some text",
      start_date: Date.utc_today
                  |> Date.add(-1),
      end_date: Date.utc_today
                |> Date.add(-3)
    }

    @update_attrs %{
      name: "updated text",
      start_date: Date.utc_today
                  |> Date.add(-2),
      end_date: Date.utc_today
                |> Date.add(-4)
    }

    @invalid_attrs %{
      name: nil,
      start_date: nil,
      end_date: nil
    }

    test "requires user_id via role's Pro" do
      changeset = WorkExperience.changeset(%WorkExperience{}, %{})
      refute changeset.valid?
      changeset
      |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, name: nil, start_date: nil, end_date: nil, user_id: nil}
      {result, changeset} =
        %WorkExperience{}
        |> WorkExperience.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset
      |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_work_experience/0 returns all WorkExperiences" do
      insert(:work_experience)
      data =
        Skills.list_work_experience()
        |> Repo.preload([:user])
        |> Enum.count
      assert data == 1
    end

    test "get_work_experience!/1 returns work_experience with given id" do
      struct = insert(:work_experience)
      data = Skills.get_work_experience!(struct.id)
      assert data.name       == struct.name
      assert data.start_date == struct.start_date
      assert data.end_date   == struct.end_date
      assert data.user_id    == struct.user_id
    end

    test "create_work_experience/1 with valid data creates work experience" do
      user = insert(:pro_user)
      params = Map.merge(@valid_attrs, %{user_id: user.id})
      assert {:ok, %WorkExperience{} = created} = Skills.create_work_experience(params)
      assert created.name       == "some text"
      assert created.start_date == Date.utc_today() |> Date.add(-1)
      assert created.end_date   == Date.utc_today() |> Date.add(-3)
      assert created.user_id    == user.id
    end

    test "create_work_experience/1 with invalid data returns error changeset" do
      user = insert(:tp_user)
      params = Map.merge(@invalid_attrs, %{user_id: user.id})
      assert {:error, %Ecto.Changeset{}} = Skills.create_work_experience(params)
    end

    test "update_work_experience/2 with valid data updates work experience" do
      struct = insert(:work_experience)
      assert {:ok, %WorkExperience{} = updated} = Skills.update_work_experience(struct, @update_attrs)
      assert updated.name       == "updated text"
      assert updated.start_date == Date.utc_today |> Date.add(-2)
      assert updated.end_date   == Date.utc_today |> Date.add(-4)
    end

    test "update_work_experience/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      struct = insert(:work_experience, user: user)
      assert {:error, %Ecto.Changeset{}} = Skills.update_work_experience(struct, @invalid_attrs)
      data = Skills.get_work_experience!(struct.id)
      assert data.name       == struct.name
      assert data.start_date == struct.start_date
      assert data.end_date   == struct.end_date
      assert data.user_id    == struct.user.id
    end

    test "delete_work_experience/1 deletes work experience" do
      struct = insert(:work_experience)
      assert {:ok, %WorkExperience{}} = Skills.delete_work_experience(struct)
      assert_raise Ecto.NoResultsError, fn -> Skills.get_work_experience!(struct.id) end
    end

    test "change_work_experience/1 returns work experience changeset" do
      struct = insert(:work_experience)
      assert %Ecto.Changeset{} = Skills.change_work_experience(struct)
    end
  end
end
