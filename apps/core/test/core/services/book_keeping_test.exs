defmodule Core.Services.BookKeepingTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeeping
  }

  alias Decimal, as: D

  describe "book_keeping by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeeping.changeset(%BookKeeping{}, %{})
      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %BookKeeping{}
        |> BookKeeping.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_book_keepings/0 returns all book_keepings" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, user: user)
      [data] = Services.list_book_keeping()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping!/1 returns the book_keeping with given id" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, user: user)
      data = Services.get_book_keeping!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping/1 with valid data creates a book_keeping" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)

      params = %{
        account_count: 22,
        balance_sheet: true,
        deadline: Date.utc_today(),
        financial_situation: "some financial situation",
        inventory: true,
        inventory_count: 22,
        payroll: true,
        tax_return_current: true,
        tax_year: ["2018", "2018", "2017", "2016", "2016"],
        user_id: user.id
      }

      assert {:ok, %BookKeeping{} = book_keeping} = Services.create_book_keeping(params)
      assert book_keeping.account_count                         == 22
      assert book_keeping.balance_sheet                         == true
      assert book_keeping.deadline                              == Date.utc_today()
      assert book_keeping.financial_situation                   == "some financial situation"
      assert book_keeping.inventory                             == true
      assert book_keeping.inventory_count                       == 22
      assert book_keeping.payroll                               == true
      assert book_keeping.price_payroll                         == nil
      assert book_keeping.tax_return_current                    == true
      assert book_keeping.tax_year                               == ["2016", "2017", "2018"]
      assert book_keeping.user_id                               == user.id
      assert match_value_relate.match_for_book_keeping_payroll  == 20
      assert match_value_relate.value_for_book_keeping_payroll  == D.new("80.0")
      assert match_value_relate.value_for_book_keeping_tax_year == D.new("150.0")
    end

    test "create_book_keeping/1 with invalid data with price_payroll by role's Tp returns error changeset" do
      user = insert(:tp_user)

      params = %{
        account_count: 22,
        balance_sheet: true,
        deadline: Date.utc_today(),
        financial_situation: "some financial situation",
        inventory: true,
        inventory_count: 22,
        payroll: true,
        price_payroll: 22,
        tax_return_current: true,
        tax_year: ["2018", "2017", "2016"],
        user_id: user.id
      }
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping(params)
    end

    test "create_book_keeping/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.create_book_keeping(params)
    end

    test "update_book_keeping/2 with valid data updates the book_keeping" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, user: user)

      params = %{
        account_count: 33,
        balance_sheet: false,
        dealine: Date.utc_today(),
        financial_situation: "updated financial situation",
        inventory: false,
        inventory_count: 33,
        payroll: false,
        tax_return_current: false,
        tax_year: ["2019", "2020", "2015", "2019", "2020"],
        user_id: user.id
      }

      assert {:ok, %BookKeeping{} = updated} =
        Services.update_book_keeping(struct, params)

      assert updated.account_count                              == 33
      assert updated.balance_sheet                              == false
      assert updated.deadline                                   == Date.utc_today()
      assert updated.financial_situation                        == "updated financial situation"
      assert updated.inventory                                  == false
      assert updated.inventory_count                            == 33
      assert updated.payroll                                    == false
      assert updated.price_payroll                              == nil
      assert updated.tax_return_current                         == false
      assert updated.tax_year                                   == ["2015", "2019", "2020"]
      assert updated.user_id                                    == user.id
      assert match_value_relate.match_for_book_keeping_payroll  == 20
      assert match_value_relate.value_for_book_keeping_payroll  == D.new("80.0")
      assert match_value_relate.value_for_book_keeping_tax_year == D.new("150.0")
    end

    test "update_book_keeping/2 with valid data updates and ignore price_payroll by role's Tp" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, user: user)

      params = %{
        account_count: 33,
        balance_sheet: false,
        deadline: Date.utc_today(),
        financial_situation: "updated financial situation",
        inventory: false,
        inventory_count: 33,
        payroll: false,
        price_payroll: 22,
        tax_return_current: false,
        tax_year: ["2019"],
        user_id: user.id
      }

      assert {:ok, %BookKeeping{} = updated} =
        Services.update_book_keeping(struct, params)

      assert updated.account_count                              == 33
      assert updated.balance_sheet                              == false
      assert updated.deadline                                   == Date.utc_today()
      assert updated.financial_situation                        == "updated financial situation"
      assert updated.inventory                                  == false
      assert updated.inventory_count                            == 33
      assert updated.payroll                                    == false
      assert updated.price_payroll                              == nil
      assert updated.tax_return_current                         == false
      assert updated.tax_year                                   == ["2019"]
      assert updated.user_id                                    == user.id
      assert match_value_relate.match_for_book_keeping_payroll  == 20
      assert match_value_relate.value_for_book_keeping_payroll  == D.new("80.0")
      assert match_value_relate.value_for_book_keeping_tax_year == D.new("150.0")
    end

    test "update_book_keeping/2 with ignore change user_id data updates the book_keeping" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)
      params = %{user_id: user.id}
      assert {:ok, %BookKeeping{} = book_keeping} =
        Services.update_book_keeping(struct, params)
      assert book_keeping.user_id == user.id
    end

    test "update_book_keeping/2 with invalid data returns not error changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping!(struct.id)
      assert %Ecto.Changeset{} != Services.update_book_keeping(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping/1 deletes the book_keeping" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, user: user)
      assert {:ok, %BookKeeping{}} = Services.delete_book_keeping(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping!(struct.id) end
    end

    test "change_book_keeping/1 returns a book_keeping changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, user: user)
      assert %Ecto.Changeset{} = Services.change_book_keeping(struct)
    end
  end

  describe "book_keeping by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = BookKeeping.changeset(%BookKeeping{}, %{})
      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %BookKeeping{}
        |> BookKeeping.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_book_keepings/0 returns all book_keepings" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)
      [data] = Services.list_book_keeping()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping!/1 returns the book_keeping with given id" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)
      data = Services.get_book_keeping!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping/1 with valid data creates a book_keeping" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)

      params = %{
        payroll: true,
        price_payroll: 22,
        user_id: user.id
      }

      assert {:ok, %BookKeeping{} = book_keeping} = Services.create_book_keeping(params)
      assert book_keeping.account_count                         == nil
      assert book_keeping.balance_sheet                         == nil
      assert book_keeping.deadline                              == nil
      assert book_keeping.financial_situation                   == nil
      assert book_keeping.inventory                             == nil
      assert book_keeping.inventory_count                       == nil
      assert book_keeping.payroll                               == true
      assert book_keeping.price_payroll                         == 22
      assert book_keeping.tax_return_current                    == nil
      assert book_keeping.tax_year                              == nil
      assert book_keeping.user_id                               == user.id
      assert match_value_relate.match_for_book_keeping_payroll  == 20
      assert match_value_relate.value_for_book_keeping_payroll  == D.new("80.0")
      assert match_value_relate.value_for_book_keeping_tax_year == D.new("150.0")
    end

    test "create_book_keeping/1 with invalid data some fields by role's Pro returns error changeset" do
      user = insert(:pro_user)

      params = %{
        account_count: 22,
        balance_sheet: true,
        deadline: Date.utc_today(),
        financial_situation: "some financial situation",
        inventory: true,
        inventory_count: 22,
        payroll: true,
        price_payroll: 22,
        tax_return_current: true,
        tax_year: ["2018", "2017", "2016"],
        user_id: user.id
      }

      assert {:error, %Ecto.Changeset{}} = Services.create_book_keeping(params)
    end

    test "create_book_keeping/1 if payroll equal false by role's Pro returns error changeset" do
      user = insert(:pro_user)

      params = %{
        payroll: false,
        price_payroll: 22,
        user_id: user.id
      }

      assert {:error, %Ecto.Changeset{}} != Services.create_book_keeping(params)
    end

    test "create_book_keeping/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping(params)
    end

    test "update_book_keeping/2 with valid data updates the book_keeping" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)

      params = %{
        payroll: false,
        price_payroll: 33,
        user_id: user.id
      }

      assert {:ok, %BookKeeping{} = updated} =
        Services.update_book_keeping(struct, params)

      assert updated.account_count                              == nil
      assert updated.balance_sheet                              == nil
      assert updated.deadline                                   == nil
      assert updated.financial_situation                        == nil
      assert updated.inventory                                  == nil
      assert updated.inventory_count                            == nil
      assert updated.payroll                                    == false
      assert updated.price_payroll                              == 33
      assert updated.tax_return_current                         == nil
      assert updated.tax_year                                   == nil
      assert updated.user_id                                    == user.id
      assert match_value_relate.match_for_book_keeping_payroll  == 20
      assert match_value_relate.value_for_book_keeping_payroll  == D.new("80.0")
      assert match_value_relate.value_for_book_keeping_tax_year == D.new("150.0")
    end

    test "update_book_keeping/2 with valid data updates and ignore some fields by role's Pro" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)

      params = %{
        account_count: 33,
        balance_sheet: false,
        financial_situation: "updated financial situation",
        inventory: false,
        inventory_count: 33,
        payroll: false,
        price_payroll: 22,
        tax_return_current: false,
        tax_year: ["2019"],
        user_id: user.id
      }

      assert {:ok, %BookKeeping{} = updated} =
        Services.update_book_keeping(struct, params)

      assert updated.account_count                              == nil
      assert updated.balance_sheet                              == nil
      assert updated.deadline                                   == nil
      assert updated.financial_situation                        == nil
      assert updated.inventory                                  == nil
      assert updated.inventory_count                            == nil
      assert updated.payroll                                    == false
      assert updated.price_payroll                              == 22
      assert updated.tax_return_current                         == nil
      assert updated.tax_year                                   == nil
      assert updated.user_id                                    == user.id
      assert match_value_relate.match_for_book_keeping_payroll  == 20
      assert match_value_relate.value_for_book_keeping_payroll  == D.new("80.0")
      assert match_value_relate.value_for_book_keeping_tax_year == D.new("150.0")
    end

    test "update_book_keeping/2 with ignore change user_id data updates the book_keeping" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)
      params = %{user_id: user.id}
      assert {:ok, %BookKeeping{} = updated} =
        Services.update_book_keeping(struct, params)
      assert updated.user_id == user.id
    end

    test "update_book_keeping/2 with invalid data returns not error changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_book_keeping!(struct.id)
      assert %Ecto.Changeset{} != Services.update_book_keeping(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_book_keeping/1 deletes the book_keeping" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)
      assert {:ok, %BookKeeping{}} = Services.delete_book_keeping(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping!(struct.id) end
    end

    test "change_book_keeping/1 returns a book_keeping changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, user: user)
      assert %Ecto.Changeset{} = Services.change_book_keeping(struct)
    end
  end
end
