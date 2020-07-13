defmodule Core.Skills.EducationTest do
  use Core.DataCase

  alias Core.Skills

  describe "educations" do
    alias Core.Skills.Education

    @valid_attrs %{
      course: "some text",
      graduation: Date.utc_today()
    }

    @update_attrs %{
      course: "updated text",
      graduation: Date.utc_today
                  |> Date.add(-3)
    }

    @invalid_attrs %{
      course: nil,
      graduation: nil
    }

    test "requires user_id via role's Pro" do
      changeset = Education.changeset(%Education{}, %{})
      refute changeset.valid?
      changeset
      |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, course: nil, graduation: nil, university_id: nil, user_id: nil}
      {result, changeset} =
        %Education{}
        |> Education.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset
      |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_education/0 returns all Educations" do
      insert(:education)
      data =
        Skills.list_education()
        |> Repo.preload([:user])
        |> Enum.count
      assert data == 1
    end

    test "get_education!/1 returns the education with given id" do
      struct = insert(:education)
      data = Skills.get_education!(struct.id)
      assert data.course        == struct.course
      assert data.graduation    == struct.graduation
      assert data.university_id == struct.university_id
      assert data.user_id       == struct.user_id
    end

    test "create_education/1 with valid data creates the education" do
      user = insert(:pro_user)
      university = insert(:university)
      params = Map.merge(@valid_attrs, %{user_id: user.id, university_id: university.id})
      assert {:ok, %Education{} = created} = Skills.create_education(params)
      assert created.course        == "some text"
      assert created.graduation    == Date.utc_today()
      assert created.university_id == university.id
      assert created.user_id       == user.id
    end

    test "create_education/1 with invalid data returns error changeset" do
      user = insert(:tp_user)
      params = Map.merge(@invalid_attrs, %{user_id: user.id, university_id: nil})
      assert {:error, %Ecto.Changeset{}} = Skills.create_education(params)
    end

    test "update_education/2 with valid data updates the education" do
      struct = insert(:education)
      assert {:ok, %Education{} = updated} = Skills.update_education(struct, @update_attrs)
      assert updated.course     == "updated text"
      assert updated.graduation == Date.utc_today |> Date.add(-3)
    end

    test "update_education/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      university = insert(:university)
      struct = insert(:education, user: user, university: university)
      assert {:error, %Ecto.Changeset{}} = Skills.update_education(struct, @invalid_attrs)
      data = Skills.get_education!(struct.id)
      assert data.course        == struct.course
      assert data.graduation    == struct.graduation
      assert data.university_id == struct.university.id
      assert data.user_id       == struct.user.id
    end

    test "delete_education/1 deletes the education" do
      struct = insert(:education)
      assert {:ok, %Education{}} = Skills.delete_education(struct)
      assert_raise Ecto.NoResultsError, fn -> Skills.get_education!(struct.id) end
    end

    test "change_education/1 returns the education changeset" do
      struct = insert(:education)
      assert %Ecto.Changeset{} = Skills.change_education(struct)
    end
  end
end
