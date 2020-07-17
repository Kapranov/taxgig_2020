defmodule Core.Services.SaleTaxFrequencyTest do
  use Core.DataCase

  alias Core.{
    Services,
    Services.SaleTaxFrequency
  }

  describe "sale_tax_frequency  by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = SaleTaxFrequency.changeset(%SaleTaxFrequency{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:sale_tax_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, name: nil, sale_tax_id: nil}
      {result, changeset} =
        %SaleTaxFrequency{}
        |> SaleTaxFrequency.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:name, "can't be blank")
      changeset |> assert_error_message(:sale_tax_id, "can't be blank")
    end

    test "list_sale_tax_frequency/0 returns all sale_tax_frequencies" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_frequency, sale_taxes: sale_tax)
      [data] = Services.list_sale_tax_frequency()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_sale_tax_frequency!/1 returns the sale_tax_frequency with given id" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_frequency, sale_taxes: sale_tax)
      attrs = [:password, :password_cofirmation]
      data = Services.get_sale_tax_frequency!(struct.id)
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_sale_tax_frequency/1 with valid data creates a sale_tax_frequency" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)

      params = %{
        name: "Annually",
        sale_tax_id: sale_tax.id
      }

      assert {:ok, %SaleTaxFrequency{} = sale_tax_frequency} = Services.create_sale_tax_frequency(params)
      assert sale_tax_frequency.name                         == :Annually
      assert sale_tax_frequency.price                        == nil
      assert sale_tax_frequency.sale_tax_id                  == sale_tax.id
      assert match_value_relate.match_for_sale_tax_frequency == 10
    end

    test "create_sale_tax_frequency/1 with invalid data returns error changeset" do
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.create_sale_tax_frequency(params)
    end

    test "update_sale_tax_frequency/2 with valid data updates the sale_tax_frequency" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_frequency, sale_taxes: sale_tax, name: "Annually")

      params = %{
        name: "Quarterly",
        sale_tax_id: sale_tax.id
      }

      assert {:ok, %SaleTaxFrequency{} = updated} =
        Services.update_sale_tax_frequency(struct, params)
      assert updated.name                         == :Quarterly
      assert updated.price                        == nil
      assert updated.sale_tax_id                  == sale_tax.id
    end

    test "update_sale_tax_frequency/2 with invalid data returns error changeset" do
      struct = insert(:tp_sale_tax_frequency)
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} == Services.update_sale_tax_frequency(struct, params)
    end

    test "delete_sale_tax_frequency/1 deletes the sale_tax_frequency" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:tp_sale_tax_frequency, sale_taxes: sale_tax)
      assert {:ok, %SaleTaxFrequency{}} = Services.delete_sale_tax_frequency(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_sale_tax_frequency!(struct.id) end
    end

    test "change_sale_tax_frequency/1 returns a sale_tax_frequency changeset" do
      user = insert(:tp_user)
      sale_tax = insert(:tp_sale_tax, user: user)
      struct = insert(:sale_tax_frequency, sale_taxes: sale_tax)
      assert %Ecto.Changeset{} = Services.change_sale_tax_frequency(struct)
    end
  end

  describe "sale_tax_frequency  by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = SaleTaxFrequency.changeset(%SaleTaxFrequency{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:sale_tax_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, name: nil, sale_tax_id: nil}
      {result, changeset} =
        %SaleTaxFrequency{}
        |> SaleTaxFrequency.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:name, "can't be blank")
      changeset |> assert_error_message(:sale_tax_id, "can't be blank")
    end

    test "list_sale_tax_frequency/0 returns all sale_tax_frequencies" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_frequency, sale_taxes: sale_tax)
      [data] = Services.list_sale_tax_frequency()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_sale_tax_frequency!/1 returns the sale_tax_frequency with given id" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_frequency, sale_taxes: sale_tax)
      attrs = [:password, :password_cofirmation]
      data = Services.get_sale_tax_frequency!(struct.id)
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_sale_tax_frequency/1 with valid data creates a sale_tax_frequency" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)

      params = %{
        name: "Annually",
        price: 22,
        sale_tax_id: sale_tax.id
      }

      assert {:ok, %SaleTaxFrequency{} = sale_tax_frequency} = Services.create_sale_tax_frequency(params)
      assert sale_tax_frequency.name                         == :Annually
      assert sale_tax_frequency.price                        == 22
      assert sale_tax_frequency.sale_tax_id                  == sale_tax.id
      assert match_value_relate.match_for_sale_tax_frequency == 10
    end

    test "create_sale_tax_frequency/1 with invalid data returns error changeset" do
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.create_sale_tax_frequency(params)
    end

    test "update_sale_tax_frequency/2 with valid data updates the sale_tax_frequency" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_frequency, sale_taxes: sale_tax, name: "Annually")

      params = %{
        name: "Quarterly",
        price: 33,
        sale_tax_id: sale_tax.id
      }

      assert {:ok, %SaleTaxFrequency{} = updated} =
        Services.update_sale_tax_frequency(struct, params)
      assert updated.name                                    == :Quarterly
      assert updated.price                                   == 33
      assert updated.sale_tax_id                             == sale_tax.id
      assert match_value_relate.match_for_sale_tax_frequency == 10
    end

    test "update_sale_tax_frequency/2 with invalid data returns error changeset" do
      struct = insert(:pro_sale_tax_frequency)
      params = %{name: nil, sale_tax_id: nil}
      assert {:error, %Ecto.Changeset{}} == Services.update_sale_tax_frequency(struct, params)
    end

    test "delete_sale_tax_frequency/1 deletes the sale_tax_frequency" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_sale_tax_frequency, sale_taxes: sale_tax)
      assert {:ok, %SaleTaxFrequency{}} = Services.delete_sale_tax_frequency(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_sale_tax_frequency!(struct.id) end
    end

    test "change_sale_tax_frequency/1 returns a sale_tax_frequency changeset" do
      user = insert(:pro_user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:sale_tax_frequency, sale_taxes: sale_tax)
      assert %Ecto.Changeset{} = Services.change_sale_tax_frequency(struct)
    end
  end
end
