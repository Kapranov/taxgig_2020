defmodule Community.CategoriesTest do
  use Community.DataCase

  import Community.Factory

  alias Community.Categories
  alias Decimal, as: D

  describe "business_entity_types by role's Tp" do
    alias Community.Categories.BusinessEntityType

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessEntityType.changeset(%BusinessEntityType{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
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
      business_entity_type = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      assert Categories.list_business_entity_types() ==
        Repo.preload([business_entity_type], [:business_tax_returns])
    end

    test "get_business_entity_type!/1 returns the business_entity_types with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      assert Categories.get_business_entity_type!(business_entity_type.id) ==
        Repo.preload(business_entity_type, [:business_tax_returns])
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
        Categories.create_business_entity_type(params)
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
        Categories.create_business_entity_type(params)
    end

    test "update_business_entity_type/2 with valid data updates the business_entity_type" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return_a = insert(:tp_business_tax_return, user: user_a)
      business_tax_return_b = insert(:tp_business_tax_return, user: user_b)
      business_entity_type  = insert(:tp_business_entity_type, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessEntityType{} = business_entity_type} =
        Categories.update_business_entity_type(business_entity_type, params)

      [loaded] =
        Repo.preload([business_entity_type], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_entity_type.inserted_at
      assert loaded.updated_at                                               == business_entity_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
      assert match_value_relate.match_for_business_enity_type                == 50
    end

    test "update_business_entity_type/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_entity_type], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_entity_type(business_entity_type, params)
      assert loaded ==
        Categories.get_business_entity_type!(business_entity_type.id)
    end

    test "delete_business_business_entity_type/1 deletes the business_entity_type" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessEntityType{}} =
        Categories.delete_business_entity_type(business_entity_type)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_entity_type!(business_entity_type.id)
      end
    end

    test "change_business_entity_type/1 returns a business_entity_type.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_entity_type = insert(:tp_business_entity_type, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_entity_type(business_entity_type)
    end
  end

  describe "business_entity_types by role's Pro" do
    alias Community.Categories.BusinessEntityType

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessEntityType.changeset(%BusinessEntityType{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
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
      business_entity_type = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)
      assert Categories.list_business_entity_types() ==
        Repo.preload([business_entity_type], [:business_tax_returns])
    end

    test "get_business_entity_type!/1 returns the business_entity_types with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)
      assert Categories.get_business_entity_type!(business_entity_type.id) ==
        Repo.preload(business_entity_type, [:business_tax_returns])
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
        Categories.create_business_entity_type(params)
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
        Categories.create_business_entity_type(params)
    end

    test "update_business_entity_type/2 with valid data updates the business_entity_type" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return_a = insert(:pro_business_tax_return, user: user_a)
      business_tax_return_b = insert(:pro_business_tax_return, user: user_b)
      business_entity_type  = insert(:pro_business_entity_type, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", price: 33, business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessEntityType{} = business_entity_type} =
        Categories.update_business_entity_type(business_entity_type, params)

      [loaded] =
        Repo.preload([business_entity_type], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.price                                                    == 33
      assert loaded.inserted_at                                              == business_entity_type.inserted_at
      assert loaded.updated_at                                               == business_entity_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
      assert match_value_relate.match_for_business_enity_type                == 50
    end

    test "update_business_entity_type/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_entity_type], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_entity_type(business_entity_type, params)
      assert loaded ==
        Categories.get_business_entity_type!(business_entity_type.id)
    end

    test "delete_business_business_entity_type/1 deletes the business_entity_type" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessEntityType{}} =
        Categories.delete_business_entity_type(business_entity_type)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_entity_type!(business_entity_type.id)
      end
    end

    test "change_business_entity_type/1 returns a business_entity_type.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_entity_type = insert(:pro_business_entity_type, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_entity_type(business_entity_type)
    end
  end

  describe "business_foreign_account_counts by role's Tp" do
    alias Community.Categories.BusinessForeignAccountCount

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessForeignAccountCount.changeset(%BusinessForeignAccountCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessForeignAccountCount{}
        |> BusinessForeignAccountCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_foreign_account_counts/0 returns all business_foreign_account_counts" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_account_count = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert Categories.list_business_foreign_account_counts() ==
        Repo.preload([business_foreign_account_count], [:business_tax_returns])
    end

    test "get_business_foreign_account_count!/1 returns the business_foreign_account_count with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_account_count = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert Categories.get_business_foreign_account_count!(business_foreign_account_count.id) ==
        Repo.preload(business_foreign_account_count, [:business_tax_returns])
    end

    test "create_business_foreign_account_count/1 with valid data creates a business_foreign_account_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessForeignAccountCount{} = business_foreign_account_count} =
        Categories.create_business_foreign_account_count(params)
      assert %Ecto.Association.NotLoaded{} = business_foreign_account_count.business_tax_returns

      [loaded] =
        Repo.preload([business_foreign_account_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_foreign_account_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_account_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_foreign_account_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_foreign_account_count(params)
    end

    test "update_business_foreign_account_count/2 with valid data updates the business_foreign_account_count" do
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return_a = insert(:tp_business_tax_return, user: user_a)
      business_tax_return_b = insert(:tp_business_tax_return, user: user_b)
      business_foreign_account_count = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessForeignAccountCount{} = business_foreign_account_count} =
        Categories.update_business_foreign_account_count(business_foreign_account_count, params)

      [loaded] =
        Repo.preload([business_foreign_account_count], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_foreign_account_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_account_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_foreign_account_count/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_account_count = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_foreign_account_count], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_foreign_account_count(business_foreign_account_count, params)
      assert loaded ==
        Categories.get_business_foreign_account_count!(business_foreign_account_count.id)
    end

    test "delete_business_foreign_account_count/1 deletes the business_foreign_account_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_account_count = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessForeignAccountCount{}} =
        Categories.delete_business_foreign_account_count(business_foreign_account_count)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_foreign_account_count!(business_foreign_account_count.id)
      end
    end

    test "change_business_foreign_account_count/1 returns a business_foreign_account_count changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_account_count = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_foreign_account_count(business_foreign_account_count)
    end
  end

  describe "business_foreign_account_counts by role's Pro" do
    alias Community.Categories.BusinessForeignAccountCount

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessForeignAccountCount.changeset(%BusinessForeignAccountCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessForeignAccountCount{}
        |> BusinessForeignAccountCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_foreign_account_counts/0 returns all business_foreign_account_counts" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_account_count = insert(:pro_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert Categories.list_business_foreign_account_counts() ==
        Repo.preload([business_foreign_account_count], [:business_tax_returns])
    end

    test "get_business_foreign_account_count!/1 returns the business_foreign_account_count with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_account_count = insert(:pro_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert Categories.get_business_foreign_account_count!(business_foreign_account_count.id) ==
        Repo.preload(business_foreign_account_count, [:business_tax_returns])
    end

    test "create_business_foreign_account_count/1 with valid data creates a business_foreign_account_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessForeignAccountCount{} = business_foreign_account_count} =
        Categories.create_business_foreign_account_count(params)
      assert %Ecto.Association.NotLoaded{} = business_foreign_account_count.business_tax_returns

      [loaded] =
        Repo.preload([business_foreign_account_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_foreign_account_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_account_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_foreign_account_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_foreign_account_count(params)
    end

    test "update_business_foreign_account_count/2 with valid data updates the business_foreign_account_count" do
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return_a = insert(:pro_business_tax_return, user: user_a)
      business_tax_return_b = insert(:pro_business_tax_return, user: user_b)
      business_foreign_account_count = insert(:pro_business_foreign_account_count, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessForeignAccountCount{} = business_foreign_account_count} =
        Categories.update_business_foreign_account_count(business_foreign_account_count, params)

      [loaded] =
        Repo.preload([business_foreign_account_count], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_foreign_account_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_account_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_foreign_account_count/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_account_count = insert(:pro_business_foreign_account_count, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_foreign_account_count], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_foreign_account_count(business_foreign_account_count, params)
      assert loaded ==
        Categories.get_business_foreign_account_count!(business_foreign_account_count.id)
    end

    test "delete_business_foreign_account_count/1 deletes the business_foreign_account_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_account_count = insert(:pro_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessForeignAccountCount{}} =
        Categories.delete_business_foreign_account_count(business_foreign_account_count)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_foreign_account_count!(business_foreign_account_count.id)
      end
    end

    test "change_business_foreign_account_count/1 returns a business_foreign_account_count changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_account_count = insert(:pro_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_foreign_account_count(business_foreign_account_count)
    end
  end

  describe "business_foreign_ownership_counts by role's Tp" do
    alias Community.Categories.BusinessForeignOwnershipCount

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessForeignOwnershipCount.changeset(%BusinessForeignOwnershipCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessForeignOwnershipCount{}
        |> BusinessForeignOwnershipCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_foreign_ownership_counts/0 returns all business_foreign_ownership_counts" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert Categories.list_business_foreign_ownership_counts() ==
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])
    end

    test "get_business_foreign_ownership_count!/1 returns the business_foreign_ownership_count with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert Categories.get_business_foreign_ownership_count!(business_foreign_ownership_count.id) ==
        Repo.preload(business_foreign_ownership_count, [:business_tax_returns])
    end

    test "create_business_foreign_ownership_count/1 with valid data creates a business_foreign_account_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessForeignOwnershipCount{} = business_foreign_ownership_count} =
        Categories.create_business_foreign_ownership_count(params)
      assert %Ecto.Association.NotLoaded{} = business_foreign_ownership_count.business_tax_returns

      [loaded] =
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_foreign_ownership_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_ownership_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_foreign_ownership_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_foreign_ownership_count(params)
    end

    test "update_business_foreign_ownership_count/2 with valid data updates the business_foreign_ownership_count" do
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return_a = insert(:tp_business_tax_return, user: user_a)
      business_tax_return_b = insert(:tp_business_tax_return, user: user_b)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessForeignOwnershipCount{} = business_foreign_ownership_count} =
        Categories.update_business_foreign_ownership_count(business_foreign_ownership_count, params)

      [loaded] =
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_foreign_ownership_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_ownership_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_foreign_ownership_count/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_foreign_ownership_count(business_foreign_ownership_count, params)
      assert loaded ==
        Categories.get_business_foreign_ownership_count!(business_foreign_ownership_count.id)
    end

    test "delete_business_foreign_ownership_count/1 deletes the business_foreign_ownership_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessForeignOwnershipCount{}} =
        Categories.delete_business_foreign_ownership_count(business_foreign_ownership_count)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_foreign_ownership_count!(business_foreign_ownership_count.id)
      end
    end

    test "change_business_foreign_ownership_count/1 returns a business_foreign_ownership_count changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:tp_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_foreign_ownership_count(business_foreign_ownership_count)
    end
  end

  describe "business_foreign_ownership_counts by role's Pro" do
    alias Community.Categories.BusinessForeignOwnershipCount

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessForeignOwnershipCount.changeset(%BusinessForeignOwnershipCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessForeignOwnershipCount{}
        |> BusinessForeignOwnershipCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_foreign_ownership_counts/0 returns all business_foreign_ownership_counts" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:pro_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert Categories.list_business_foreign_ownership_counts() ==
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])
    end

    test "get_business_foreign_ownership_count!/1 returns the business_foreign_ownership_count with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:pro_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert Categories.get_business_foreign_ownership_count!(business_foreign_ownership_count.id) ==
        Repo.preload(business_foreign_ownership_count, [:business_tax_returns])
    end

    test "create_business_foreign_ownership_count/1 with valid data creates a business_foreign_account_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessForeignOwnershipCount{} = business_foreign_ownership_count} =
        Categories.create_business_foreign_ownership_count(params)
      assert %Ecto.Association.NotLoaded{} = business_foreign_ownership_count.business_tax_returns

      [loaded] =
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_foreign_ownership_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_ownership_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_foreign_ownership_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_foreign_ownership_count(params)
    end

    test "update_business_foreign_ownership_count/2 with valid data updates the business_foreign_ownership_count" do
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return_a = insert(:pro_business_tax_return, user: user_a)
      business_tax_return_b = insert(:pro_business_tax_return, user: user_b)
      business_foreign_ownership_count = insert(:pro_business_foreign_ownership_count, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessForeignOwnershipCount{} = business_foreign_ownership_count} =
        Categories.update_business_foreign_ownership_count(business_foreign_ownership_count, params)

      [loaded] =
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_foreign_ownership_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_ownership_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_foreign_ownership_count/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:pro_business_foreign_ownership_count, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_foreign_ownership_count], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_foreign_ownership_count(business_foreign_ownership_count, params)
      assert loaded ==
        Categories.get_business_foreign_ownership_count!(business_foreign_ownership_count.id)
    end

    test "delete_business_foreign_ownership_count/1 deletes the business_foreign_ownership_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:pro_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessForeignOwnershipCount{}} =
        Categories.delete_business_foreign_ownership_count(business_foreign_ownership_count)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_foreign_ownership_count!(business_foreign_ownership_count.id)
      end
    end

    test "change_business_foreign_ownership_count/1 returns a business_foreign_ownership_count changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_foreign_ownership_count = insert(:pro_business_foreign_ownership_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_foreign_ownership_count(business_foreign_ownership_count)
    end
  end

  describe "business_llc_types by role's Tp" do
    alias Community.Categories.BusinessLlcType

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessLlcType.changeset(%BusinessLlcType{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessLlcType{}
        |> BusinessLlcType.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_llc_types/0 returns all business_llc_types" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      assert Categories.list_business_llc_types() ==
        Repo.preload([business_llc_type], [:business_tax_returns])
    end

    test "get_business_llc_type!/1 returns the business_llc_types with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      assert Categories.get_business_llc_type!(business_llc_type.id) ==
        Repo.preload(business_llc_type, [:business_tax_returns])
    end

    test "create_business_llc_type/1 with valid data creates a business_llc_type" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessLlcType{} = business_llc_type} =
        Categories.create_business_llc_type(params)
      assert %Ecto.Association.NotLoaded{} = business_llc_type.business_tax_returns

      [loaded] =
        Repo.preload([business_llc_type], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_llc_type.inserted_at
      assert loaded.updated_at                                               == business_llc_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_llc_type/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_llc_type(params)
    end

    test "update_business_llc_type/2 with valid data updates the business_llc_type" do
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return_a = insert(:tp_business_tax_return, user: user_a)
      business_tax_return_b = insert(:tp_business_tax_return, user: user_b)
      business_llc_type = insert(:tp_business_llc_type, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessLlcType{} = business_llc_type} =
        Categories.update_business_llc_type(business_llc_type, params)

      [loaded] =
        Repo.preload([business_llc_type], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_llc_type.inserted_at
      assert loaded.updated_at                                               == business_llc_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_llc_type/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_llc_type], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_llc_type(business_llc_type, params)
      assert loaded ==
        Categories.get_business_llc_type!(business_llc_type.id)
    end

    test "delete_business_llc_type/1 deletes the business_llc_type" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessLlcType{}} =
        Categories.delete_business_llc_type(business_llc_type)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_llc_type!(business_llc_type.id)
      end
    end

    test "change_business_llc_type/1 returns a business_llc_type.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_llc_type = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_llc_type(business_llc_type)
    end
  end

  describe "business_llc_types by role's Pro" do
    alias Community.Categories.BusinessLlcType

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessLlcType.changeset(%BusinessLlcType{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessLlcType{}
        |> BusinessLlcType.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_llc_types/0 returns all business_llc_types" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_llc_type = insert(:pro_business_llc_type, business_tax_returns: business_tax_return)
      assert Categories.list_business_llc_types() ==
        Repo.preload([business_llc_type], [:business_tax_returns])
    end

    test "get_business_llc_type!/1 returns the business_llc_types with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_llc_type = insert(:pro_business_llc_type, business_tax_returns: business_tax_return)
      assert Categories.get_business_llc_type!(business_llc_type.id) ==
        Repo.preload(business_llc_type, [:business_tax_returns])
    end

    test "create_business_llc_type/1 with valid data creates a business_llc_type" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessLlcType{} = business_llc_type} =
        Categories.create_business_llc_type(params)
      assert %Ecto.Association.NotLoaded{} = business_llc_type.business_tax_returns

      [loaded] =
        Repo.preload([business_llc_type], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_llc_type.inserted_at
      assert loaded.updated_at                                               == business_llc_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_llc_type/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_llc_type(params)
    end

    test "update_business_llc_type/2 with valid data updates the business_llc_type" do
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return_a = insert(:pro_business_tax_return, user: user_a)
      business_tax_return_b = insert(:pro_business_tax_return, user: user_b)
      business_llc_type = insert(:pro_business_llc_type, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessLlcType{} = business_llc_type} =
        Categories.update_business_llc_type(business_llc_type, params)

      [loaded] =
        Repo.preload([business_llc_type], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_llc_type.inserted_at
      assert loaded.updated_at                                               == business_llc_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_llc_type/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_llc_type = insert(:pro_business_llc_type, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_llc_type], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_llc_type(business_llc_type, params)
      assert loaded ==
        Categories.get_business_llc_type!(business_llc_type.id)
    end

    test "delete_business_llc_type/1 deletes the business_llc_type" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_llc_type = insert(:pro_business_llc_type, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessLlcType{}} =
        Categories.delete_business_llc_type(business_llc_type)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_llc_type!(business_llc_type.id)
      end
    end

    test "change_business_llc_type/1 returns a business_llc_type.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_llc_type = insert(:pro_business_llc_type, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_llc_type(business_llc_type)
    end
  end

  describe "business_number_employees by role's Tp" do
    alias Community.Categories.BusinessNumberEmployee

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessNumberEmployee.changeset(%BusinessNumberEmployee{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
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
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      assert Categories.list_business_number_employees() ==
        Repo.preload([business_number_employee], [:business_tax_returns])
    end

    test "get_business_number_employee!/1 returns the business_number_employee with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      assert Categories.get_business_number_employee!(business_number_employee.id) ==
        Repo.preload(business_number_employee, [:business_tax_returns])
    end

    test "create_business_number_employee/1 with valid data creates a business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessNumberEmployee{} = business_number_employee} =
        Categories.create_business_number_employee(params)
      assert %Ecto.Association.NotLoaded{} = business_number_employee.business_tax_returns

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_number_employee.inserted_at
      assert loaded.updated_at                                               == business_number_employee.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "create_business_number_employee/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_number_employee(params)
    end

    test "update_business_number_employee/2 with valid data updates the business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return_a = insert(:tp_business_tax_return, user: user_a)
      business_tax_return_b = insert(:tp_business_tax_return, user: user_b)
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessNumberEmployee{} = business_number_employee} =
        Categories.update_business_number_employee(business_number_employee, params)

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_number_employee.inserted_at
      assert loaded.updated_at                                               == business_number_employee.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "update_business_number_employee/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_number_employee(business_number_employee, params)
      assert loaded ==
        Categories.get_business_number_employee!(business_number_employee.id)
    end

    test "delete_business_number_employee/1 deletes the business_number_employee" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessNumberEmployee{}} =
        Categories.delete_business_number_employee(business_number_employee)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_number_employee!(business_number_employee.id)
      end
    end

    test "change_business_number_employee/1 returns a business_number_employee.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_number_employee = insert(:tp_business_number_employee, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_number_employee(business_number_employee)
    end
  end

  describe "business_number_employees by role's Pro" do
    alias Community.Categories.BusinessNumberEmployee

    test "list_business_number_employees/0 returns all business_number_employees" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      assert Categories.list_business_number_employees() ==
        Repo.preload([business_number_employee], [:business_tax_returns])
    end

    test "get_business_number_employee!/1 returns the business_number_employee with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      assert Categories.get_business_number_employee!(business_number_employee.id) ==
        Repo.preload(business_number_employee, [:business_tax_returns])
    end

    test "create_business_number_employee/1 with valid data creates a business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "some name",
        price: 22,
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessNumberEmployee{} = business_number_employee} =
        Categories.create_business_number_employee(params)
      assert %Ecto.Association.NotLoaded{} = business_number_employee.business_tax_returns

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.price                                                    == 22
      assert loaded.inserted_at                                              == business_number_employee.inserted_at
      assert loaded.updated_at                                               == business_number_employee.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "create_business_number_employee/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_number_employee(params)
    end

    test "update_business_number_employee/2 with valid data updates the business_number_employee" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return_a = insert(:pro_business_tax_return, user: user_a)
      business_tax_return_b = insert(:pro_business_tax_return, user: user_b)
      business_number_employee = insert(:pro_business_number_employee, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", price: 33, business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessNumberEmployee{} = business_number_employee} =
        Categories.update_business_number_employee(business_number_employee, params)

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.price                                                    == 33
      assert loaded.inserted_at                                              == business_number_employee.inserted_at
      assert loaded.updated_at                                               == business_number_employee.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
      assert match_value_relate.match_for_business_number_of_employee        == 20
    end

    test "update_business_number_employee/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_number_employee], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_number_employee(business_number_employee, params)
      assert loaded ==
        Categories.get_business_number_employee!(business_number_employee.id)
    end

    test "delete_business_number_employee/1 deletes the business_number_employee" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessNumberEmployee{}} =
        Categories.delete_business_number_employee(business_number_employee)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_number_employee!(business_number_employee.id)
      end
    end

    test "change_business_number_employee/1 returns a business_number_employee.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_number_employee = insert(:pro_business_number_employee, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_number_employee(business_number_employee)
    end
  end

  describe "business_total_revenues by role's Tp" do
    alias Community.Categories.BusinessTotalRevenue

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessTotalRevenue.changeset(%BusinessTotalRevenue{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessTotalRevenue{}
        |> BusinessTotalRevenue.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_total_revenues/0 returns all business_total_revenues" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_total_revenue = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)
      assert Categories.list_business_total_revenues() ==
        Repo.preload([business_total_revenue], [:business_tax_returns])
    end

    test "get_business_total_revenue!/1 returns the business_total_revenues with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_total_revenue = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)
      assert Categories.get_business_total_revenue!(business_total_revenue.id) ==
        Repo.preload(business_total_revenue, [:business_tax_returns])
    end

    test "create_business_total_revenue/1 with valid data creates a business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTotalRevenue{} = business_total_revenue} =
        Categories.create_business_total_revenue(params)
      assert %Ecto.Association.NotLoaded{} = business_total_revenue.business_tax_returns

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_total_revenue.inserted_at
      assert loaded.updated_at                                               == business_total_revenue.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_total_revenue             == 20
    end

    test "create_business_total_revenue/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_total_revenue(params)
    end

    test "update_business_total_revenue/2 with valid data updates the business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return_a = insert(:tp_business_tax_return, user: user_a)
      business_tax_return_b = insert(:tp_business_tax_return, user: user_b)
      business_total_revenue = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessTotalRevenue{} = business_total_revenue} =
        Categories.update_business_total_revenue(business_total_revenue, params)

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_total_revenue.inserted_at
      assert loaded.updated_at                                               == business_total_revenue.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
      assert match_value_relate.match_for_business_total_revenue             == 20
    end

    test "update_business_total_revenue/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_total_revenue = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_total_revenue(business_total_revenue, params)
      assert loaded ==
        Categories.get_business_total_revenue!(business_total_revenue.id)
    end

    test "delete_business_total_revenue/1 deletes the business_total_revenue" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_total_revenue = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTotalRevenue{}} =
        Categories.delete_business_total_revenue(business_total_revenue)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_total_revenue!(business_total_revenue.id)
      end
    end

    test "change_business_total_revenue/1 returns a business_total_revenue.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_total_revenue = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_total_revenue(business_total_revenue)
    end
  end

  describe "business_total_revenues by role's Pro" do
    alias Community.Categories.BusinessTotalRevenue

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessTotalRevenue.changeset(%BusinessTotalRevenue{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessTotalRevenue{}
        |> BusinessTotalRevenue.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_total_revenues/0 returns all business_total_revenues" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_total_revenue = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)
      assert Categories.list_business_total_revenues() ==
        Repo.preload([business_total_revenue], [:business_tax_returns])
    end

    test "get_business_total_revenue!/1 returns the business_total_revenues with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_total_revenue = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)
      assert Categories.get_business_total_revenue!(business_total_revenue.id) ==
        Repo.preload(business_total_revenue, [:business_tax_returns])
    end

    test "create_business_total_revenue/1 with valid data creates a business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "some name",
        price: 22,
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTotalRevenue{} = business_total_revenue} =
        Categories.create_business_total_revenue(params)
      assert %Ecto.Association.NotLoaded{} = business_total_revenue.business_tax_returns

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.price                                                    == 22
      assert loaded.inserted_at                                              == business_total_revenue.inserted_at
      assert loaded.updated_at                                               == business_total_revenue.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_total_revenue             == 20
    end

    test "create_business_total_revenue/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_total_revenue(params)
    end

    test "update_business_total_revenue/2 with valid data updates the business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return_a = insert(:pro_business_tax_return, user: user_a)
      business_tax_return_b = insert(:pro_business_tax_return, user: user_b)
      business_total_revenue = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", price: 33, business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessTotalRevenue{} = business_total_revenue} =
        Categories.update_business_total_revenue(business_total_revenue, params)

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.price                                                    == 33
      assert loaded.inserted_at                                              == business_total_revenue.inserted_at
      assert loaded.updated_at                                               == business_total_revenue.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
      assert match_value_relate.match_for_business_total_revenue             == 20
    end

    test "update_business_total_revenue/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_total_revenue = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_total_revenue(business_total_revenue, params)
      assert loaded ==
        Categories.get_business_total_revenue!(business_total_revenue.id)
    end

    test "delete_business_total_revenue/1 deletes the business_total_revenue" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_total_revenue = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTotalRevenue{}} =
        Categories.delete_business_total_revenue(business_total_revenue)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_total_revenue!(business_total_revenue.id)
      end
    end

    test "change_business_total_revenue/1 returns a business_total_revenue.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_total_revenue = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_total_revenue(business_total_revenue)
    end
  end

  describe "business_transaction_counts by role's Tp" do
    alias Community.Categories.BusinessTransactionCount

    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessTransactionCount.changeset(%BusinessTransactionCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessTransactionCount{}
        |> BusinessTransactionCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_transaction_counts/0 returns all business_transaction_counts" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      assert Categories.list_business_transaction_counts() ==
        Repo.preload([business_transaction_count], [:business_tax_returns])
    end

    test "get_business_transaction_count!/1 returns the business_transaction_counts with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      assert Categories.get_business_transaction_count!(business_transaction_count.id) ==
        Repo.preload(business_transaction_count, [:business_tax_returns])
    end

    test "create_business_transaction_count/1 with valid data creates a business_transaction_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTransactionCount{} = business_transaction_count} =
        Categories.create_business_transaction_count(params)
      assert %Ecto.Association.NotLoaded{} = business_transaction_count.business_tax_returns

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_transaction_count.inserted_at
      assert loaded.updated_at                                               == business_transaction_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_transaction_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_transaction_count(params)
    end

    test "update_business_transaction_count/2 with valid data updates the business_transaction_count" do
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return_a = insert(:tp_business_tax_return, user: user_a)
      business_tax_return_b = insert(:tp_business_tax_return, user: user_b)
      business_transaction_count = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessTransactionCount{} = business_transaction_count} =
        Categories.update_business_transaction_count(business_transaction_count, params)

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_transaction_count.inserted_at
      assert loaded.updated_at                                               == business_transaction_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_transaction_count/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_transaction_count(business_transaction_count, params)
      assert loaded ==
        Categories.get_business_transaction_count!(business_transaction_count.id)
    end

    test "delete_business_transaction_count/1 deletes the business_transaction_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTransactionCount{}} =
        Categories.delete_business_transaction_count(business_transaction_count)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_transaction_count!(business_transaction_count.id)
      end
    end

    test "change_business_transaction_count/1 returns a business_transaction_count.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      business_transaction_count = insert(:tp_business_transaction_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_transaction_count(business_transaction_count)
    end
  end

  describe "business_transaction_counts by role's Pro" do
    alias Community.Categories.BusinessTransactionCount

    test "requires name and business_tax_return_id via role's Pro" do
      changeset = BusinessTransactionCount.changeset(%BusinessTransactionCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessTransactionCount{}
        |> BusinessTransactionCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_transaction_counts/0 returns all business_transaction_counts" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_transaction_count = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)
      assert Categories.list_business_transaction_counts() ==
        Repo.preload([business_transaction_count], [:business_tax_returns])
    end

    test "get_business_transaction_count!/1 returns the business_transaction_counts with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_transaction_count = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)
      assert Categories.get_business_transaction_count!(business_transaction_count.id) ==
        Repo.preload(business_transaction_count, [:business_tax_returns])
    end

    test "create_business_transaction_count/1 with valid data creates a business_transaction_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "some name",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTransactionCount{} = business_transaction_count} =
        Categories.create_business_transaction_count(params)
      assert %Ecto.Association.NotLoaded{} = business_transaction_count.business_tax_returns

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert loaded.name                                                     == "some name"
      assert loaded.inserted_at                                              == business_transaction_count.inserted_at
      assert loaded.updated_at                                               == business_transaction_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_transaction_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_business_transaction_count(params)
    end

    test "update_business_transaction_count/2 with valid data updates the business_transaction_count" do
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return_a = insert(:pro_business_tax_return, user: user_a)
      business_tax_return_b = insert(:pro_business_tax_return, user: user_b)
      business_transaction_count = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return_a)

      params = %{name: "updated some name", business_tax_return_id: business_tax_return_b.id}

      assert {:ok, %BusinessTransactionCount{} = business_transaction_count} =
        Categories.update_business_transaction_count(business_transaction_count, params)

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert loaded.name                                                     == "updated some name"
      assert loaded.inserted_at                                              == business_transaction_count.inserted_at
      assert loaded.updated_at                                               == business_transaction_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return_b.id
    end

    test "update_business_transaction_count/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_transaction_count = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)

      params = %{name: nil, business_tax_return_id: nil}

      [loaded] =
        Repo.preload([business_transaction_count], [:business_tax_returns])

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_business_transaction_count(business_transaction_count, params)
      assert loaded ==
        Categories.get_business_transaction_count!(business_transaction_count.id)
    end

    test "delete_business_transaction_count/1 deletes the business_transaction_count" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_transaction_count = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTransactionCount{}} =
        Categories.delete_business_transaction_count(business_transaction_count)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_business_transaction_count!(business_transaction_count.id)
      end
    end

    test "change_business_transaction_count/1 returns a business_transaction_count.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      business_transaction_count = insert(:pro_business_transaction_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Categories.change_business_transaction_count(business_transaction_count)
    end
  end

  describe "match_value_relates" do
    alias Community.Categories.MatchValueRelate

    test "list_match_value_relates/0 returns all match_value_relates" do
      match_value_relate = insert(:match_value_relat)
      assert Categories.list_match_value_relates() == [match_value_relate]
    end

    test "get_match_value_relate!/1 returns the match_value_relate with given id" do
      match_value_relate = insert(:match_value_relat)
      assert Categories.get_match_value_relate!(match_value_relate.id) ==
        match_value_relate
    end

    test "create_match_value_relate/1 with valid data creates a match_value_relate" do
      params = %{
        match_for_book_keeping_additional_need:            42,
        match_for_book_keeping_annual_revenue:             42,
        match_for_book_keeping_industry:                   42,
        match_for_book_keeping_number_employee:            42,
        match_for_book_keeping_payroll:                    42,
        match_for_book_keeping_type_client:                42,
        match_for_business_enity_type:                     42,
        match_for_business_number_of_employee:             42,
        match_for_business_total_revenue:                  42,
        match_for_individual_employment_status:            42,
        match_for_individual_filing_status:                42,
        match_for_individual_foreign_account:              42,
        match_for_individual_home_owner:                   42,
        match_for_individual_itemized_deduction:           42,
        match_for_individual_living_abroad:                42,
        match_for_individual_non_resident_earning:         42,
        match_for_individual_own_stock_crypto:             42,
        match_for_individual_rental_prop_income:           42,
        match_for_individual_stock_divident:               42,
        match_for_sale_tax_count:                          42,
        match_for_sale_tax_frequency:                      42,
        match_for_sale_tax_industry:                       42,
        value_for_book_keeping_payroll:                  12.5,
        value_for_book_keeping_tax_year:                 12.5,
        value_for_business_accounting_software:          12.5,
        value_for_business_dispose_property:             12.5,
        value_for_business_foreign_shareholder:          12.5,
        value_for_business_income_over_thousand:         12.5,
        value_for_business_invest_research:              12.5,
        value_for_business_k1_count:                     12.5,
        value_for_business_make_distribution:            12.5,
        value_for_business_state:                        12.5,
        value_for_business_tax_exemption:                12.5,
        value_for_business_total_asset_over:             12.5,
        value_for_individual_employment_status:          12.5,
        value_for_individual_foreign_account_limit:      12.5,
        value_for_individual_foreign_financial_interest: 12.5,
        value_for_individual_home_owner:                 12.5,
        value_for_individual_k1_count:                   12.5,
        value_for_individual_rental_prop_income:         12.5,
        value_for_individual_sole_prop_count:            12.5,
        value_for_individual_state:                      12.5,
        value_for_individual_tax_year:                   12.5,
        value_for_sale_tax_count:                        12.5
      }

      assert {:ok, %MatchValueRelate{} = match_value_relate} =
        Categories.create_match_value_relate(params)

      assert match_value_relate.match_for_book_keeping_additional_need          == 42
      assert match_value_relate.match_for_book_keeping_annual_revenue           == 42
      assert match_value_relate.match_for_book_keeping_industry                 == 42
      assert match_value_relate.match_for_book_keeping_number_employee          == 42
      assert match_value_relate.match_for_book_keeping_payroll                  == 42
      assert match_value_relate.match_for_book_keeping_type_client              == 42
      assert match_value_relate.match_for_business_enity_type                   == 42
      assert match_value_relate.match_for_business_number_of_employee           == 42
      assert match_value_relate.match_for_business_total_revenue                == 42
      assert match_value_relate.match_for_individual_employment_status          == 42
      assert match_value_relate.match_for_individual_filing_status              == 42
      assert match_value_relate.match_for_individual_foreign_account            == 42
      assert match_value_relate.match_for_individual_home_owner                 == 42
      assert match_value_relate.match_for_individual_itemized_deduction         == 42
      assert match_value_relate.match_for_individual_living_abroad              == 42
      assert match_value_relate.match_for_individual_non_resident_earning       == 42
      assert match_value_relate.match_for_individual_own_stock_crypto           == 42
      assert match_value_relate.match_for_individual_rental_prop_income         == 42
      assert match_value_relate.match_for_individual_stock_divident             == 42
      assert match_value_relate.match_for_sale_tax_count                        == 42
      assert match_value_relate.match_for_sale_tax_frequency                    == 42
      assert match_value_relate.match_for_sale_tax_industry                     == 42
      assert match_value_relate.value_for_book_keeping_payroll                  == D.new("12.5")
      assert match_value_relate.value_for_book_keeping_tax_year                 == D.new("12.5")
      assert match_value_relate.value_for_business_accounting_software          == D.new("12.5")
      assert match_value_relate.value_for_business_dispose_property             == D.new("12.5")
      assert match_value_relate.value_for_business_foreign_shareholder          == D.new("12.5")
      assert match_value_relate.value_for_business_income_over_thousand         == D.new("12.5")
      assert match_value_relate.value_for_business_invest_research              == D.new("12.5")
      assert match_value_relate.value_for_business_k1_count                     == D.new("12.5")
      assert match_value_relate.value_for_business_make_distribution            == D.new("12.5")
      assert match_value_relate.value_for_business_state                        == D.new("12.5")
      assert match_value_relate.value_for_business_tax_exemption                == D.new("12.5")
      assert match_value_relate.value_for_business_total_asset_over             == D.new("12.5")
      assert match_value_relate.value_for_individual_employment_status          == D.new("12.5")
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("12.5")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("12.5")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("12.5")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("12.5")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("12.5")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("12.5")
      assert match_value_relate.value_for_individual_state                      == D.new("12.5")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("12.5")
      assert match_value_relate.value_for_sale_tax_count                        == D.new("12.5")
      assert match_value_relate.inserted_at                                     == match_value_relate.inserted_at
      assert match_value_relate.updated_at                                      == match_value_relate.updated_at
    end

    test "create_match_value_relate/1 with valid data if the record none exist" do
      params = %{
        match_for_book_keeping_additional_need:            42,
        match_for_book_keeping_annual_revenue:             42,
        match_for_book_keeping_industry:                   42,
        match_for_book_keeping_number_employee:            42,
        match_for_book_keeping_payroll:                    42,
        match_for_book_keeping_type_client:                42,
        match_for_business_enity_type:                     42,
        match_for_business_number_of_employee:             42,
        match_for_business_total_revenue:                  42,
        match_for_individual_employment_status:            42,
        match_for_individual_filing_status:                42,
        match_for_individual_foreign_account:              42,
        match_for_individual_home_owner:                   42,
        match_for_individual_itemized_deduction:           42,
        match_for_individual_living_abroad:                42,
        match_for_individual_non_resident_earning:         42,
        match_for_individual_own_stock_crypto:             42,
        match_for_individual_rental_prop_income:           42,
        match_for_individual_stock_divident:               42,
        match_for_sale_tax_count:                          42,
        match_for_sale_tax_frequency:                      42,
        match_for_sale_tax_industry:                       42,
        value_for_book_keeping_payroll:                  12.5,
        value_for_book_keeping_tax_year:                 12.5,
        value_for_business_accounting_software:          12.5,
        value_for_business_dispose_property:             12.5,
        value_for_business_foreign_shareholder:          12.5,
        value_for_business_income_over_thousand:         12.5,
        value_for_business_invest_research:              12.5,
        value_for_business_k1_count:                     12.5,
        value_for_business_make_distribution:            12.5,
        value_for_business_state:                        12.5,
        value_for_business_tax_exemption:                12.5,
        value_for_business_total_asset_over:             12.5,
        value_for_individual_employment_status:          12.5,
        value_for_individual_foreign_account_limit:      12.5,
        value_for_individual_foreign_financial_interest: 12.5,
        value_for_individual_home_owner:                 12.5,
        value_for_individual_k1_count:                   12.5,
        value_for_individual_rental_prop_income:         12.5,
        value_for_individual_sole_prop_count:            12.5,
        value_for_individual_state:                      12.5,
        value_for_individual_tax_year:                   12.5,
        value_for_sale_tax_count:                        12.5
      }

      assert {:ok, %MatchValueRelate{}} =
        Categories.create_match_value_relate(params)
      assert {:error, %Ecto.Changeset{}} =
        Categories.create_match_value_relate(params)
    end

    test "create_match_value_relate/1 with invalid data returns error changeset" do
      params = %{
        match_for_book_keeping_additional_need:          nil,
        match_for_book_keeping_annual_revenue:           nil,
        match_for_book_keeping_industry:                 nil,
        match_for_book_keeping_number_employee:          nil,
        match_for_book_keeping_payroll:                  nil,
        match_for_book_keeping_type_client:              nil,
        match_for_business_enity_type:                   nil,
        match_for_business_number_of_employee:           nil,
        match_for_business_total_revenue:                nil,
        match_for_individual_employment_status:          nil,
        match_for_individual_filing_status:              nil,
        match_for_individual_foreign_account:            nil,
        match_for_individual_home_owner:                 nil,
        match_for_individual_itemized_deduction:         nil,
        match_for_individual_living_abroad:              nil,
        match_for_individual_non_resident_earning:       nil,
        match_for_individual_own_stock_crypto:           nil,
        match_for_individual_rental_prop_income:         nil,
        match_for_individual_stock_divident:             nil,
        match_for_sale_tax_count:                        nil,
        match_for_sale_tax_frequency:                    nil,
        match_for_sale_tax_industry:                     nil,
        value_for_book_keeping_payroll:                  nil,
        value_for_book_keeping_tax_year:                 nil,
        value_for_business_accounting_software:          nil,
        value_for_business_dispose_property:             nil,
        value_for_business_foreign_shareholder:          nil,
        value_for_business_income_over_thousand:         nil,
        value_for_business_invest_research:              nil,
        value_for_business_k1_count:                     nil,
        value_for_business_make_distribution:            nil,
        value_for_business_state:                        nil,
        value_for_business_tax_exemption:                nil,
        value_for_business_total_asset_over:             nil,
        value_for_individual_employment_status:          nil,
        value_for_individual_foreign_account_limit:      nil,
        value_for_individual_foreign_financial_interest: nil,
        value_for_individual_home_owner:                 nil,
        value_for_individual_k1_count:                   nil,
        value_for_individual_rental_prop_income:         nil,
        value_for_individual_sole_prop_count:            nil,
        value_for_individual_state:                      nil,
        value_for_individual_tax_year:                   nil,
        value_for_sale_tax_count:                        nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Categories.create_match_value_relate(params)
    end

    test "update_match_value_relate/2 with valid data updates the match_value_relate" do
      match_value_relate = insert(:match_value_relat)

      params = %{
        match_for_book_keeping_additional_need:            43,
        match_for_book_keeping_annual_revenue:             43,
        match_for_book_keeping_industry:                   43,
        match_for_book_keeping_number_employee:            43,
        match_for_book_keeping_payroll:                    43,
        match_for_book_keeping_type_client:                43,
        match_for_business_enity_type:                     43,
        match_for_business_number_of_employee:             43,
        match_for_business_total_revenue:                  43,
        match_for_individual_employment_status:            43,
        match_for_individual_filing_status:                43,
        match_for_individual_foreign_account:              43,
        match_for_individual_home_owner:                   43,
        match_for_individual_itemized_deduction:           43,
        match_for_individual_living_abroad:                43,
        match_for_individual_non_resident_earning:         43,
        match_for_individual_own_stock_crypto:             43,
        match_for_individual_rental_prop_income:           43,
        match_for_individual_stock_divident:               43,
        match_for_sale_tax_count:                          43,
        match_for_sale_tax_frequency:                      43,
        match_for_sale_tax_industry:                       43,
        value_for_book_keeping_payroll:                  13.5,
        value_for_book_keeping_tax_year:                 13.5,
        value_for_business_accounting_software:          13.5,
        value_for_business_dispose_property:             13.5,
        value_for_business_foreign_shareholder:          13.5,
        value_for_business_income_over_thousand:         13.5,
        value_for_business_invest_research:              13.5,
        value_for_business_k1_count:                     13.5,
        value_for_business_make_distribution:            13.5,
        value_for_business_state:                        13.5,
        value_for_business_tax_exemption:                13.5,
        value_for_business_total_asset_over:             13.5,
        value_for_individual_employment_status:          13.5,
        value_for_individual_foreign_account_limit:      13.5,
        value_for_individual_foreign_financial_interest: 13.5,
        value_for_individual_home_owner:                 13.5,
        value_for_individual_k1_count:                   13.5,
        value_for_individual_rental_prop_income:         13.5,
        value_for_individual_sole_prop_count:            13.5,
        value_for_individual_state:                      13.5,
        value_for_individual_tax_year:                   13.5,
        value_for_sale_tax_count:                        13.5
      }

      assert {:ok, %MatchValueRelate{} = updated_match_value_relate} =
        Categories.update_match_value_relate(match_value_relate, params)

      assert updated_match_value_relate.match_for_business_enity_type                   == 43
      assert updated_match_value_relate.match_for_book_keeping_additional_need          == 43
      assert updated_match_value_relate.match_for_book_keeping_annual_revenue           == 43
      assert updated_match_value_relate.match_for_book_keeping_industry                 == 43
      assert updated_match_value_relate.match_for_book_keeping_number_employee          == 43
      assert updated_match_value_relate.match_for_book_keeping_payroll                  == 43
      assert updated_match_value_relate.match_for_book_keeping_type_client              == 43
      assert updated_match_value_relate.match_for_business_enity_type                   == 43
      assert updated_match_value_relate.match_for_business_number_of_employee           == 43
      assert updated_match_value_relate.match_for_business_total_revenue                == 43
      assert updated_match_value_relate.match_for_individual_employment_status          == 43
      assert updated_match_value_relate.match_for_individual_filing_status              == 43
      assert updated_match_value_relate.match_for_individual_foreign_account            == 43
      assert updated_match_value_relate.match_for_individual_home_owner                 == 43
      assert updated_match_value_relate.match_for_individual_itemized_deduction         == 43
      assert updated_match_value_relate.match_for_individual_living_abroad              == 43
      assert updated_match_value_relate.match_for_individual_non_resident_earning       == 43
      assert updated_match_value_relate.match_for_individual_own_stock_crypto           == 43
      assert updated_match_value_relate.match_for_individual_rental_prop_income         == 43
      assert updated_match_value_relate.match_for_individual_stock_divident             == 43
      assert updated_match_value_relate.match_for_sale_tax_count                        == 43
      assert updated_match_value_relate.match_for_sale_tax_frequency                    == 43
      assert updated_match_value_relate.match_for_sale_tax_industry                     == 43
      assert updated_match_value_relate.value_for_book_keeping_payroll                  == D.new("13.5")
      assert updated_match_value_relate.value_for_book_keeping_tax_year                 == D.new("13.5")
      assert updated_match_value_relate.value_for_business_accounting_software          == D.new("13.5")
      assert updated_match_value_relate.value_for_business_dispose_property             == D.new("13.5")
      assert updated_match_value_relate.value_for_business_foreign_shareholder          == D.new("13.5")
      assert updated_match_value_relate.value_for_business_income_over_thousand         == D.new("13.5")
      assert updated_match_value_relate.value_for_business_invest_research              == D.new("13.5")
      assert updated_match_value_relate.value_for_business_k1_count                     == D.new("13.5")
      assert updated_match_value_relate.value_for_business_make_distribution            == D.new("13.5")
      assert updated_match_value_relate.value_for_business_state                        == D.new("13.5")
      assert updated_match_value_relate.value_for_business_tax_exemption                == D.new("13.5")
      assert updated_match_value_relate.value_for_business_total_asset_over             == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_employment_status          == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_foreign_account_limit      == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_foreign_financial_interest == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_home_owner                 == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_k1_count                   == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_rental_prop_income         == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_sole_prop_count            == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_state                      == D.new("13.5")
      assert updated_match_value_relate.value_for_individual_tax_year                   == D.new("13.5")
      assert updated_match_value_relate.value_for_sale_tax_count                        == D.new("13.5")
      assert updated_match_value_relate.inserted_at                                     == match_value_relate.inserted_at
      assert updated_match_value_relate.updated_at                                      == match_value_relate.updated_at
    end

    test "update_match_value_relate/2 with invalid data returns error changeset" do
      match_value_relate = insert(:match_value_relat)
      params = %{
        match_for_book_keeping_additional_need:          nil,
        match_for_book_keeping_annual_revenue:           nil,
        match_for_book_keeping_industry:                 nil,
        match_for_book_keeping_number_employee:          nil,
        match_for_book_keeping_payroll:                  nil,
        match_for_book_keeping_type_client:              nil,
        match_for_business_enity_type:                   nil,
        match_for_business_number_of_employee:           nil,
        match_for_business_total_revenue:                nil,
        match_for_individual_employment_status:          nil,
        match_for_individual_filing_status:              nil,
        match_for_individual_foreign_account:            nil,
        match_for_individual_home_owner:                 nil,
        match_for_individual_itemized_deduction:         nil,
        match_for_individual_living_abroad:              nil,
        match_for_individual_non_resident_earning:       nil,
        match_for_individual_own_stock_crypto:           nil,
        match_for_individual_rental_prop_income:         nil,
        match_for_individual_stock_divident:             nil,
        match_for_sale_tax_count:                        nil,
        match_for_sale_tax_frequency:                    nil,
        match_for_sale_tax_industry:                     nil,
        value_for_book_keeping_payroll:                  nil,
        value_for_book_keeping_tax_year:                 nil,
        value_for_business_accounting_software:          nil,
        value_for_business_dispose_property:             nil,
        value_for_business_foreign_shareholder:          nil,
        value_for_business_income_over_thousand:         nil,
        value_for_business_invest_research:              nil,
        value_for_business_k1_count:                     nil,
        value_for_business_make_distribution:            nil,
        value_for_business_state:                        nil,
        value_for_business_tax_exemption:                nil,
        value_for_business_total_asset_over:             nil,
        value_for_individual_employment_status:          nil,
        value_for_individual_foreign_account_limit:      nil,
        value_for_individual_foreign_financial_interest: nil,
        value_for_individual_home_owner:                 nil,
        value_for_individual_k1_count:                   nil,
        value_for_individual_rental_prop_income:         nil,
        value_for_individual_sole_prop_count:            nil,
        value_for_individual_state:                      nil,
        value_for_individual_tax_year:                   nil,
        value_for_sale_tax_count:                        nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Categories.update_match_value_relate(match_value_relate, params)
      assert match_value_relate ==
        Categories.get_match_value_relate!(match_value_relate.id)
    end

    test "delete_match_value_relate/1 deletes the match_value_relate" do
      match_value_relate = insert(:match_value_relat)
      assert {:ok, %MatchValueRelate{}} =
        Categories.delete_match_value_relate(match_value_relate)
      assert_raise Ecto.NoResultsError, fn ->
        Categories.get_match_value_relate!(match_value_relate.id)
      end
    end

    test "change_match_value_relate/1 returns a match_value_relate changeset" do
      match_value_relate = insert(:match_value_relat)
      assert %Ecto.Changeset{} =
        Categories.change_match_value_relate(match_value_relate)
    end
  end
end
