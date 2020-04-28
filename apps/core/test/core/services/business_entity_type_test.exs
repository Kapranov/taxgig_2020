defmodule Core.Services.BusinessEntityTypeTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessEntityType
  }

  describe "business_entity_types by role's Tp" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessEntityType.changeset(%BusinessEntityType{}, %{})
      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessEntityType{}
        |> BusinessEntityType.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_entity_types/0 returns all business_entity_types" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      [data] = Services.list_business_entity_type()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_entity_type!/1 returns the business_entity_types with given id" do
      struct = insert(:tp_business_entity_type)
      data = Services.get_business_entity_type!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_entity_type/1 with valid data creates a business_entity_type" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessEntityType{} = business_entity_type} =
        Services.create_business_entity_type(params)
      assert %Ecto.Association.NotLoaded{} = business_entity_type.business_tax_returns

      [loaded] =
        Repo.preload([business_entity_type], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_entity_type.inserted_at
      assert loaded.updated_at                                               == business_entity_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_enity_type                == 50
    end

    test "create_business_entity_type/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_entity_type(params)
    end

    test "update_business_entity_type/2 with valid data updates the business_entity_type" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessEntityType{} = updated} =
        Services.update_business_entity_type(struct, params)

      assert updated.name                                                     == "updated some name"
      assert updated.price                                                    == nil
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_enity_type                == 50
    end

    test "update_business_entity_type/2 with invalid data returns error changeset" do
      struct = insert(:tp_business_entity_type)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_entity_type!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_entity_type(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_business_entity_type/1 deletes the business_entity_type" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessEntityType{}} =
        Services.delete_business_entity_type(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_entity_type!(struct.id)
      end
    end

    test "change_business_entity_type/1 returns a business_entity_type.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_entity_type(struct)
    end
  end

  describe "business_entity_types by role's Pro" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessEntityType.changeset(%BusinessEntityType{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessEntityType{}
        |> BusinessEntityType.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_entity_types/0 returns all business_entity_types" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)
      [data] = Services.list_business_entity_type()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_entity_type!/1 returns the business_entity_types with given id" do
      struct = insert(:pro_business_entity_type)
      data = Services.get_business_entity_type!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_entity_type/1 with valid data creates a business_entity_type" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "some name",
        price: 22,
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessEntityType{} = business_entity_type} =
        Services.create_business_entity_type(params)
      assert %Ecto.Association.NotLoaded{} = business_entity_type.business_tax_returns

      [loaded] =
        Repo.preload([business_entity_type], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.price                                                    == 22
      assert loaded.inserted_at                                              == business_entity_type.inserted_at
      assert loaded.updated_at                                               == business_entity_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_enity_type                == 50
    end

    test "create_business_entity_type/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_entity_type(params)
    end

    test "update_business_entity_type/2 with valid data updates the business_entity_type" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return.id, price: 33}

      assert {:ok, %BusinessEntityType{} = updated} =
        Services.update_business_entity_type(struct, params)

      assert updated.name                                                     == "updated some name"
      assert updated.price                                                    == 33
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_enity_type                == 50
    end

    test "update_business_entity_type/2 with invalid data returns error changeset" do
      struct = insert(:pro_business_entity_type)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_entity_type!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_entity_type(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_business_entity_type/1 deletes the business_entity_type" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessEntityType{}} =
        Services.delete_business_entity_type(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_entity_type!(struct.id)
      end
    end

    test "change_business_entity_type/1 returns a business_entity_type.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_entity_type(struct)
    end
  end
end
