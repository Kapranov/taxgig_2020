defmodule Core.Skills.EducationTest do
  use Core.DataCase

  alias Core.Skills

  describe "educations" do
    alias Core.Skills.Education

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
    end

    test "get_education!/1 returns the education with given id" do
    end

    test "create_education/1 with valid data creates the education" do
    end

    test "create_education/1 with invalid data returns error changeset" do
    end

    test "update_education/2 with valid data updates the education" do
    end

    test "update_education/2 with invalid data returns error changeset" do
    end

    test "delete_education/1 deletes the education" do
    end

    test "change_education/1 returns the education changeset" do
    end
  end
end
