defmodule Core.Skills.WorkExperienceTest do
  use Core.DataCase

  alias Core.Skills

  describe "work experiences" do
    alias Core.Skills.WorkExperience

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
    end

    test "get_work_experience!/1 returns work_experience with given id" do
    end

    test "create_work_experience/1 with valid data creates work experience" do
    end

    test "create_work_experience/1 with invalid data returns error changeset" do
    end

    test "update_work_experience/2 with valid data updates work experience" do
    end

    test "update_work_experience/2 with invalid data returns error changeset" do
    end

    test "delete_work_experience/1 deletes work experience" do
    end

    test "change_work_experience/1 returns work experience changeset" do
    end
  end
end
