defmodule Core.Services.BusinessNumberEmployeeTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessNumberEmployee
  }

  describe "business_number_employees by role's Tp" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessNumberEmployee.changeset(%BusinessNumberEmployee{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessNumberEmployee{}
        |> BusinessNumberEmployee.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_number_employees/0 returns all business_number_employees" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      [data] = Services.list_business_number_employee()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_number_employee!/1 returns the business_number_employee with given id" do
      struct = insert(:tp_business_number_employee)
      data = Services.get_business_number_employee!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_number_employee/1 with valid data creates a business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "1 employee",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessNumberEmployee{} = business_number_employee} =
        Services.create_business_number_employee(params)
      assert %Ecto.Association.NotLoaded{} = business_number_employee.business_tax_returns

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert loaded.name                                                     == :"1 employee"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_number_employee.inserted_at
      assert loaded.updated_at                                               == business_number_employee.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "create_business_number_employee/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_number_employee(params)
    end

    test "update_business_number_employee/2 with valid data updates the business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)

      params = %{name: "51 - 100 employees", business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessNumberEmployee{} = updated} =
        Services.update_business_number_employee(struct, params)

      assert updated.name                                                     == :"51 - 100 employees"
      assert updated.price                                                    == nil
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "update_business_number_employee/2 with invalid data returns error changeset" do
      struct = insert(:tp_business_number_employee)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_number_employee!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_number_employee(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_number_employee/1 deletes the business_number_employee" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessNumberEmployee{}} =
        Services.delete_business_number_employee(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_number_employee!(struct.id)
      end
    end

    test "change_business_number_employee/1 returns a business_number_employee.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_number_employee(struct)
    end
  end

  describe "business_number_employees by role's Pro" do
    test "requires name and business_tax_return_id via role's Pro" do
      changeset = BusinessNumberEmployee.changeset(%BusinessNumberEmployee{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessNumberEmployee{}
        |> BusinessNumberEmployee.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_number_employees/0 returns all business_number_employees" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      [data] = Services.list_business_number_employee()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_number_employee!/1 returns the business_number_employee with given id" do
      struct = insert(:pro_business_number_employee)
      data = Services.get_business_number_employee!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_number_employee/1 with valid data creates a business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "1 employee",
        price: 22,
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessNumberEmployee{} = business_number_employee} =
        Services.create_business_number_employee(params)
      assert %Ecto.Association.NotLoaded{} = business_number_employee.business_tax_returns

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert loaded.name                                                     == :"1 employee"
      assert loaded.price                                                    == 22
      assert loaded.inserted_at                                              == business_number_employee.inserted_at
      assert loaded.updated_at                                               == business_number_employee.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "create_business_number_employee/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_number_employee(params)
    end

    test "update_business_number_employee/2 with valid data updates the business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)

      params = %{name: "51 - 100 employees", price: 33, business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessNumberEmployee{} = updated} =
        Services.update_business_number_employee(struct, params)

      assert updated.name                                                     == :"51 - 100 employees"
      assert updated.price                                                    == 33
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "update_business_number_employee/2 with invalid data returns error changeset" do
      struct = insert(:pro_business_number_employee)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_number_employee!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_number_employee(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_number_employee/1 deletes the business_number_employee" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessNumberEmployee{}} =
        Services.delete_business_number_employee(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_number_employee!(struct.id)
      end
    end

    test "change_business_number_employee/1 returns a business_number_employee.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_number_employee(struct)
    end
  end
end
