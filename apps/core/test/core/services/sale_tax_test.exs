defmodule Core.Services.SaleTaxTest do
  use Core.DataCase

  alias Core.{
    Services,
    Services.SaleTax
  }

  alias Decimal, as: D

  describe "sale_tax by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = SaleTax.changeset(%SaleTax{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %SaleTax{}
        |> SaleTax.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_sale_taxe/0 returns all sale_taxes" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, user: user)
      [data] = Services.list_sale_taxe()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_sale_tax!/1 returns the sale_tax with given id" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, user: user)
      data = Services.get_sale_tax!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_sale_tax/1 with valid data creates a sale_tax" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)

      params = %{
        deadline: Date.utc_today(),
        financial_situation: "some financial situation",
        sale_tax_count: 22,
        state: ["Alabama", "New York"],
        user_id: user.id
      }

      assert {:ok, %SaleTax{} = sale_tax} = Services.create_sale_tax(params)
      assert sale_tax.deadline                           == Date.utc_today()
      assert sale_tax.financial_situation                == "some financial situation"
      assert sale_tax.price_sale_tax_count               == nil
      assert sale_tax.sale_tax_count                     == 22
      assert sale_tax.state                              == ["Alabama", "New York"]
      assert sale_tax.user_id                            == user.id
      assert match_value_relate.match_for_sale_tax_count == 50
      assert match_value_relate.value_for_sale_tax_count == D.new("30.0")
    end

    test "create_sale_tax/1 with invalid data returns error changeset" do
      params = %{
        deadline: nil,
        financial_situation: nil,
        sale_tax_count: nil,
        state: [{}],
        user_id: nil
      }

      assert {:error, %Ecto.Changeset{}} = Services.create_sale_tax(params)
    end

    test "create_sale_tax/1 with invalid data with price_sale_tax_count by role's Tp returns error changeset" do
      user = insert(:tp_user)

      params = %{
        deadline: Date.utc_today(),
        financial_situation: "some financial situation",
        price_sale_tax_count: 22,
        sale_tax_count: 22,
        state: [{"Alabama", "New York"}],
        user_id: user.id
      }
      assert {:error, %Ecto.Changeset{}} = Services.create_sale_tax(params)
    end

    test "update_sale_tax/2 with valid data updates the sale_tax" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, user: user)

      params = %{
        deadline: Date.utc_today(),
        financial_situation: "updated financial situation",
        sale_tax_count: 33,
        state: ["Arizona", "Iowa"],
        user_id: user.id
      }

      assert {:ok, %SaleTax{} = updated} = Services.update_sale_tax(struct, params)
      assert updated.deadline                            == Date.utc_today()
      assert updated.financial_situation                 == "updated financial situation"
      assert updated.price_sale_tax_count                == nil
      assert updated.sale_tax_count                      == 33
      assert updated.state                               == ["Arizona", "Iowa"]
      assert updated.user_id                             == user.id
      assert match_value_relate.match_for_sale_tax_count == 50
      assert match_value_relate.value_for_sale_tax_count == D.new("30.0")
    end

    test "update_sale_tax/2 with valid data updates and ignore some fields by role's Tp" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, user: user)

      params = %{
        deadline: Date.utc_today(),
        financial_situation: "updated financial situation",
        price_sale_tax_count: 33,
        sale_tax_count: 33,
        state: ["Arizona", "Iowa"],
        user_id: user.id
      }

      assert {:ok, %SaleTax{} = updated} = Services.update_sale_tax(struct, params)
      assert updated.deadline                            == Date.utc_today()
      assert updated.financial_situation                 == "updated financial situation"
      assert updated.price_sale_tax_count                == nil
      assert updated.sale_tax_count                      == 33
      assert updated.state                               == ["Arizona", "Iowa"]
      assert updated.user_id                             == user.id
      assert match_value_relate.match_for_sale_tax_count == 50
      assert match_value_relate.value_for_sale_tax_count == D.new("30.0")
    end

    test "update_sale_tax/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_sale_tax!(struct.id)
      assert {:error, %Ecto.Changeset{}} = Services.update_sale_tax(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_sale_tax/1 deletes the sale_tax" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, user: user)
      assert {:ok, %SaleTax{}} = Services.delete_sale_tax(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_sale_tax!(struct.id) end
    end

    test "change_sale_tax/1 returns a sale_tax changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_sale_tax, user: user)
      assert %Ecto.Changeset{} = Services.change_sale_tax(struct)
    end
  end

  describe "sale_tax by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = SaleTax.changeset(%SaleTax{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %SaleTax{}
        |> SaleTax.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_sale_taxe/0 returns all sale_taxes" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, user: user)
      [data] = Services.list_sale_taxe()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_sale_tax!/1 returns the sale_tax with given id" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, user: user)
      data = Services.get_sale_tax!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_sale_tax/1 with valid data creates a sale_tax" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)

      params = %{
        price_sale_tax_count: 22,
        user_id: user.id
      }

      assert {:ok, %SaleTax{} = sale_tax} = Services.create_sale_tax(params)
      assert sale_tax.deadline                           == nil
      assert sale_tax.financial_situation                == nil
      assert sale_tax.price_sale_tax_count               == 22
      assert sale_tax.sale_tax_count                     == nil
      assert sale_tax.state                              == nil
      assert sale_tax.user_id                            == user.id
      assert match_value_relate.match_for_sale_tax_count == 50
      assert match_value_relate.value_for_sale_tax_count == D.new("30.0")
    end

    test "create_sale_tax/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.create_sale_tax(params)
    end

    test "update_sale_tax/2 with valid data updates the sale_tax" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, user: user)

      params = %{
        price_sale_tax_count: 33,
        user_id: user.id
      }

      assert {:ok, %SaleTax{} = updated} = Services.update_sale_tax(struct, params)
      assert updated.deadline                            == nil
      assert updated.financial_situation                 == nil
      assert updated.price_sale_tax_count                == 33
      assert updated.sale_tax_count                      == nil
      assert updated.state                               == nil
      assert updated.user_id                             == user.id
      assert match_value_relate.match_for_sale_tax_count == 50
      assert match_value_relate.value_for_sale_tax_count == D.new("30.0")
    end

    test "update_sale_tax/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_sale_tax!(struct.id)
      assert {:error, %Ecto.Changeset{}} == Services.update_sale_tax(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_sale_tax/1 deletes the sale_tax" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, user: user)
      assert {:ok, %SaleTax{}} = Services.delete_sale_tax(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_sale_tax!(struct.id) end
    end

    test "change_sale_tax/1 returns a sale_tax changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_sale_tax, user: user)
      assert %Ecto.Changeset{} = Services.change_sale_tax(struct)
    end
  end
end
