defmodule Core.Services.BusinessForeignAccountCountTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessForeignAccountCount
  }

  describe "business_foreign_account_counts by role's Tp" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessForeignAccountCount.changeset(%BusinessForeignAccountCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
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
      struct = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)
      [data] = Services.list_business_foreign_account_count()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_foreign_account_count!/1 returns the business_foreign_account_count with given id" do
      struct = insert(:tp_business_foreign_account_count)
      data = Services.get_business_foreign_account_count!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_foreign_account_count/1 with valid data creates a business_foreign_account_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "1",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessForeignAccountCount{} = business_foreign_account_count} =
        Services.create_business_foreign_account_count(params)
      assert %Ecto.Association.NotLoaded{} = business_foreign_account_count.business_tax_returns

      [loaded] =
        Repo.preload([business_foreign_account_count], [:business_tax_returns])

      assert loaded.name                                                     == :"1"
      assert loaded.inserted_at                                              == business_foreign_account_count.inserted_at
      assert loaded.updated_at                                               == business_foreign_account_count.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_foreign_account_count/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_foreign_account_count(params)
    end

    test "update_business_foreign_account_count/2 with valid data updates the business_foreign_account_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)

      params = %{name: "5+", business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessForeignAccountCount{} = updated} =
        Services.update_business_foreign_account_count(struct, params)

      assert updated.name                                                     == :"5+"
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
    end

    test "update_business_foreign_account_count/2 with invalid data returns error changeset" do
      struct = insert(:tp_business_foreign_account_count)
      params = %{name: nil, business_tax_return_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_foreign_account_count(struct, params)
    end

    test "delete_business_foreign_account_count/1 deletes the business_foreign_account_count" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessForeignAccountCount{}} =
        Services.delete_business_foreign_account_count(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_foreign_account_count!(struct.id)
      end
    end

    test "change_business_foreign_account_count/1 returns a business_foreign_account_count changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_foreign_account_count, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_foreign_account_count(struct)
    end
  end

  describe "business_foreign_account_counts by role's Pro" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessForeignAccountCount.changeset(%BusinessForeignAccountCount{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessForeignAccountCount{}
        |> BusinessForeignAccountCount.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "create_business_foreign_account_count/1 with valid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "1",
        business_tax_return_id: business_tax_return.id
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_foreign_account_count(params)
    end
  end
end
