defmodule Core.Services.SaleTaxIndustryTest do
  use Core.DataCase

  alias Core.{
    Services,
    Services.SaleTaxIndustry
  }

  describe "sale_tax_industry by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = SaleTaxIndustry.changeset(%SaleTaxIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:sale_tax_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, name: nil, sale_tax_id: nil}
      {result, changeset} =
        %SaleTaxIndustry{}
        |> SaleTaxIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:name, "can't be blank")
      changeset |> assert_error_message(:sale_tax_id, "can't be blank")
    end

    test "list_sale_tax_industry/0 returns all sale_tax_industries" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_industry, sale_taxes: sale_tax)
      [data] = Services.list_sale_tax_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_sale_tax_industry!/1 returns the sale_tax_industry with given id" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_industry, sale_taxes: sale_tax)
      attrs = [:password, :password_cofirmation]
      data = Services.get_sale_tax_industry!(struct.id)
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_sale_tax_industry/1 with valid data creates a sale_tax_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      params = %{name: ["Agriculture/Farming"], sale_tax_id: sale_tax.id}

      assert {:ok, %SaleTaxIndustry{} = sale_tax_industry} = Services.create_sale_tax_industry(params)
      assert sale_tax_industry.name                         == [:"Agriculture/Farming"]
      assert sale_tax_industry.sale_tax_id                  == sale_tax.id
      assert match_value_relate.match_for_sale_tax_industry == 10
    end

    test "create_sale_tax_industry/1 with invalid data returns error changeset" do
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.create_sale_tax_industry(params)
    end

    test "update_sale_tax_industry/2 with valid data updates the sale_tax_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_industry, sale_taxes: sale_tax)

      params = %{name: ["Wholesale Distribution"]}

      assert {:ok, %SaleTaxIndustry{} = updated} =
        Services.update_sale_tax_industry(struct, params)
      assert updated.name                                   == [:"Wholesale Distribution"]
      assert struct.sale_tax_id                             == sale_tax.id
      assert match_value_relate.match_for_sale_tax_industry == 10
    end

    test "update_sale_tax_industry/2 with invalid data returns error changeset" do
      struct = insert(:tp_sale_tax_industry)
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.update_sale_tax_industry(struct, params)
    end

    test "delete_sale_tax_industry/1 deletes the sale_tax_industry" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_industry, sale_taxes: sale_tax)
      assert {:ok, %SaleTaxIndustry{}} = Services.delete_sale_tax_industry(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_sale_tax_industry!(struct.id) end
    end

    test "change_sale_tax_industry/1 returns a sale_tax_industry changeset" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_industry, sale_taxes: sale_tax)
      assert %Ecto.Changeset{} = Services.change_sale_tax_industry(struct)
    end
  end

  describe "sale_tax_industry by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = SaleTaxIndustry.changeset(%SaleTaxIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:sale_tax_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, name: nil, sale_tax_id: nil}
      {result, changeset} =
        %SaleTaxIndustry{}
        |> SaleTaxIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:name, "can't be blank")
      changeset |> assert_error_message(:sale_tax_id, "can't be blank")
    end

    test "list_sale_tax_industry/0 returns all sale_tax_industries" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_industry, sale_taxes: sale_tax)
      [data] = Services.list_sale_tax_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_sale_tax_industry!/1 returns the sale_tax_industry with given id" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_industry, sale_taxes: sale_tax)
      attrs = [:password, :password_cofirmation]
      data = Services.get_sale_tax_industry!(struct.id)
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_sale_tax_industry/1 with valid data creates a sale_tax_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      params = %{name: ["Agriculture/Farming", "Automotive Sales/Repair"], sale_tax_id: sale_tax.id}

      assert {:ok, %SaleTaxIndustry{} = sale_tax_industry} = Services.create_sale_tax_industry(params)
      assert sale_tax_industry.name                         == [:"Agriculture/Farming", :"Automotive Sales/Repair"]
      assert sale_tax_industry.sale_tax_id                  == sale_tax.id
      assert match_value_relate.match_for_sale_tax_industry == 10
    end

    test "create_sale_tax_industry/1 with invalid data returns error changeset" do
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.create_sale_tax_industry(params)
    end

    test "update_sale_tax_industry/2 with valid data updates the sale_tax_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_industry, sale_taxes: sale_tax)

      params = %{name: ["Wholesale Distribution"]}

      assert {:ok, %SaleTaxIndustry{} = updated} =
        Services.update_sale_tax_industry(struct, params)
      assert updated.name                                   == [:"Wholesale Distribution"]
      assert struct.sale_tax_id                             == sale_tax.id
      assert match_value_relate.match_for_sale_tax_industry == 10
    end

    test "update_sale_tax_industry/2 with invalid data returns error changeset" do
      struct = insert(:pro_sale_tax_industry)
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.update_sale_tax_industry(struct, params)
    end

    test "delete_sale_tax_industry/1 deletes the sale_tax_industry" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_industry, sale_taxes: sale_tax)
      assert {:ok, %SaleTaxIndustry{}} = Services.delete_sale_tax_industry(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_sale_tax_industry!(struct.id) end
    end

    test "change_sale_tax_industry/1 returns a sale_tax_industry changeset" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_industry, sale_taxes: sale_tax)
      assert %Ecto.Changeset{} = Services.change_sale_tax_industry(struct)
    end
  end
end
