defmodule Core.Services.BookKeepingNumberEmployeeTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeepingNumberEmployee
  }

  describe "book_keeping_number_employee by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingNumberEmployee.changeset(%BookKeepingNumberEmployee{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingNumberEmployee{}
        |> BookKeepingNumberEmployee.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_number_employees/0 returns all book_keeping_number_employees" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_number_employee, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_number_employee()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_number_employee!/1 returns the book_keeping_number_employee with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_number_employee, book_keepings: book_keeping)
      data = Services.get_book_keeping_number_employee!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_number_employee/1 with valid data creates a book_keeping_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "21 - 50 employees",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_number_employee} = Services.create_book_keeping_number_employee(params)
      assert book_keeping_number_employee.name                         == :"21 - 50 employees"
      assert book_keeping_number_employee.price                        == nil
      assert book_keeping_number_employee.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_number_employee == 25
    end

    test "create_book_keeping_number_employee/1 with invalid attrs for creates a book_keeping_number_employee" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "some name",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_number_employee(params)
    end

    test "create_book_keeping_number_employee/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_number_employee(params)
    end

    test "update_book_keeping_number_employee/2 with valid data updates the book_keeping_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_number_employee, book_keepings: book_keeping)

      params = %{
        name: "101 - 500 employees",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingNumberEmployee{} = updated} =
        Services.update_book_keeping_number_employee(struct, params)

      assert updated.name                                              == :"101 - 500 employees"
      assert updated.price                                             == nil
      assert updated.book_keeping_id                                   == book_keeping.id
      assert match_value_relate.match_for_book_keeping_number_employee == 25
    end

    test "update_book_keeping_number_employee/2 with invalid data returns not error changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_number_employee, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping_number_employee!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_number_employee(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping_number_employee/1 deletes the book_keeping_number_employee" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_number_employee, book_keepings: book_keeping)
      assert {:ok, %BookKeepingNumberEmployee{}} = Services.delete_book_keeping_number_employee(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_number_employee!(struct.id) end
    end

    test "change_book_keeping_number_employee/1 returns a book_keeping_number_employee changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_number_employee, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_number_employee(struct)
    end
  end

  describe "book_keeping_number_employee by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = BookKeepingNumberEmployee.changeset(%BookKeepingNumberEmployee{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingNumberEmployee{}
        |> BookKeepingNumberEmployee.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_number_employees/0 returns all book_keeping_number_employees" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_number_employee, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_number_employee()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_number_employee!/1 returns the book_keeping_number_employee with given id" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_number_employee, book_keepings: book_keeping)
      data = Services.get_book_keeping_number_employee!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_number_employee/1 with valid data creates a book_keeping_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)

      params = %{
        name: "101 - 500 employees",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_number_employee} = Services.create_book_keeping_number_employee(params)
      assert book_keeping_number_employee.name                         == :"101 - 500 employees"
      assert book_keeping_number_employee.price                        == 22
      assert book_keeping_number_employee.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_number_employee == 25
    end

    test "create_book_keeping_number_employee/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_number_employee(params)
    end

    test "update_book_keeping_number_employee/2 with valid data updates the book_keeping_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_number_employee, book_keepings: book_keeping)

      params = %{
        name: "51 - 100 employees",
        price: 33,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingNumberEmployee{} = updated} =
        Services.update_book_keeping_number_employee(struct, params)

      assert updated.name                                              == :"51 - 100 employees"
      assert updated.price                                             == 33
      assert updated.book_keeping_id                                   == book_keeping.id
      assert match_value_relate.match_for_book_keeping_number_employee == 25
    end

    test "update_book_keeping_number_employee/2 with invalid data returns not error changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_number_employee, book_keepings: book_keeping)
      params = %{book_keeping_id: nil, name: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping_number_employee!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_number_employee(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping_number_employee/1 deletes the book_keeping_number_employee" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_number_employee, book_keepings: book_keeping)
      assert {:ok, %BookKeepingNumberEmployee{}} = Services.delete_book_keeping_number_employee(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_number_employee!(struct.id) end
    end

    test "change_book_keeping_number_employee/1 returns a book_keeping_number_employee changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_number_employee, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_number_employee(struct)
    end
  end
end
