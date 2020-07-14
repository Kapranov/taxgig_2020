defmodule Core.Services.BusinessTotalRevenueTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessTotalRevenue
  }

  describe "business_total_revenues by role's Tp" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessTotalRevenue.changeset(%BusinessTotalRevenue{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
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
      struct = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)
      [data] = Services.list_business_total_revenue()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_total_revenue!/1 returns the business_total_revenues with given id" do
      struct = insert(:tp_business_total_revenue)
      data = Services.get_business_total_revenue!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_total_revenue/1 with valid data creates a business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "$100K - $500K",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTotalRevenue{} = business_total_revenue} =
        Services.create_business_total_revenue(params)
      assert %Ecto.Association.NotLoaded{} = business_total_revenue.business_tax_returns

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert loaded.name                                                     == :"$100K - $500K"
      assert loaded.price                                                    == nil
      assert loaded.inserted_at                                              == business_total_revenue.inserted_at
      assert loaded.updated_at                                               == business_total_revenue.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_total_revenue             == 20
    end

    test "create_business_total_revenue/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_total_revenue(params)
    end

    test "update_business_total_revenue/2 with valid data updates the business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)

      params = %{name: "Less than $100K", business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessTotalRevenue{} = updated} =
        Services.update_business_total_revenue(struct, params)

      assert updated.name                                                     == :"Less than $100K"
      assert updated.price                                                    == nil
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_total_revenue             == 20
    end

    test "update_business_total_revenue/2 with invalid data returns error changeset" do
      struct = insert(:tp_business_total_revenue)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_total_revenue!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_total_revenue(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_total_revenue/1 deletes the business_total_revenue" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTotalRevenue{}} =
        Services.delete_business_total_revenue(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_total_revenue!(struct.id)
      end
    end

    test "change_business_total_revenue/1 returns a business_total_revenue.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_total_revenue, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_total_revenue(struct)
    end
  end

  describe "business_total_revenues by role's Pro" do
    test "requires name and business_tax_return_id via role's Pro" do
      changeset = BusinessTotalRevenue.changeset(%BusinessTotalRevenue{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
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
      struct = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)
      [data] = Services.list_business_total_revenue()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_total_revenue!/1 returns the business_total_revenues with given id" do
      struct = insert(:pro_business_total_revenue)
      data = Services.get_business_total_revenue!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_total_revenue/1 with valid data creates a business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "$100K - $500K",
        price: 22,
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessTotalRevenue{} = business_total_revenue} =
        Services.create_business_total_revenue(params)
      assert %Ecto.Association.NotLoaded{} = business_total_revenue.business_tax_returns

      [loaded] =
        Repo.preload([business_total_revenue], [:business_tax_returns])

      assert loaded.name                                                     == :"$100K - $500K"
      assert loaded.price                                                    == 22
      assert loaded.inserted_at                                              == business_total_revenue.inserted_at
      assert loaded.updated_at                                               == business_total_revenue.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_total_revenue             == 20
    end

    test "create_business_total_revenue/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_total_revenue(params)
    end

    test "update_business_total_revenue/2 with valid data updates the business_total_revenue" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)

      params = %{name: "Less than $100K", price: 33, business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessTotalRevenue{} = updated} =
        Services.update_business_total_revenue(struct, params)

      assert updated.name                                                     == :"Less than $100K"
      assert updated.price                                                    == 33
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_total_revenue              == 20
    end

    test "update_business_total_revenue/2 with invalid data returns error changeset" do
      struct = insert(:pro_business_total_revenue)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_total_revenue!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_total_revenue(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_total_revenue/1 deletes the business_total_revenue" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessTotalRevenue{}} =
        Services.delete_business_total_revenue(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_total_revenue!(struct.id)
      end
    end

    test "change_business_total_revenue/1 returns a business_total_revenue.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_total_revenue, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_total_revenue(struct)
    end
  end
end
