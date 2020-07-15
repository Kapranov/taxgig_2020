defmodule ServerWeb.GraphQL.Resolvers.Products.BookKeepingsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BookKeepingsResolver

  describe "#index" do
    it "returns BookKeeping by role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                   == struct.id
      assert List.first(data).account_count        == struct.account_count
      assert List.first(data).balance_sheet        == struct.balance_sheet
      assert List.first(data).deadline             == struct.deadline
      assert List.first(data).financial_situation  == struct.financial_situation
      assert List.first(data).inventory            == struct.inventory
      assert List.first(data).inventory_count      == struct.inventory_count
      assert List.first(data).payroll              == struct.payroll
      assert List.first(data).price_payroll        == nil
      assert List.first(data).tax_return_current   == struct.tax_return_current
      assert List.first(data).tax_year             == struct.tax_year
      assert List.first(data).user_id              == struct.user_id
      assert List.first(data).inserted_at          == struct.inserted_at
      assert List.first(data).updated_at           == struct.updated_at
      assert List.first(data).user.id              == user.id
      assert List.first(data).user.email           == user.email
      assert List.first(data).user.role            == user.role
    end

    it "returns BookKeeping by role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                   == struct.id
      assert List.first(data).account_count        == struct.account_count
      assert List.first(data).balance_sheet        == struct.balance_sheet
      assert List.first(data).deadline             == struct.deadline
      assert List.first(data).financial_situation  == struct.financial_situation
      assert List.first(data).inventory            == struct.inventory
      assert List.first(data).inventory_count      == struct.inventory_count
      assert List.first(data).payroll              == struct.payroll
      assert List.first(data).price_payroll        == struct.price_payroll
      assert List.first(data).tax_return_current   == struct.tax_return_current
      assert List.first(data).tax_year             == struct.tax_year
      assert List.first(data).user_id              == struct.user_id
      assert List.first(data).inserted_at          == struct.inserted_at
      assert List.first(data).updated_at           == struct.updated_at
      assert List.first(data).user.id              == user.id
      assert List.first(data).user.email           == user.email
      assert List.first(data).user.role            == user.role
    end
  end

  describe "#show" do
    it "returns specific BookKeeping by id via role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingsResolver.show(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.account_count        == struct.account_count
      assert found.balance_sheet        == struct.balance_sheet
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.inventory            == struct.inventory
      assert found.inventory_count      == struct.inventory_count
      assert found.payroll              == struct.payroll
      assert found.price_payroll        == struct.price_payroll
      assert found.tax_return_current   == struct.tax_return_current
      assert found.tax_year             == struct.tax_year
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns specific BookKeeping by id via role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingsResolver.show(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.account_count        == struct.account_count
      assert found.balance_sheet        == struct.balance_sheet
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.inventory            == struct.inventory
      assert found.inventory_count      == struct.inventory_count
      assert found.payroll              == struct.payroll
      assert found.price_payroll        == struct.price_payroll
      assert found.tax_return_current   == struct.tax_return_current
      assert found.tax_year             == struct.tax_year
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns not found when BookKeeping does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingsResolver.show(nil, %{id: id}, context)
      assert error == "The BookKeeping #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "returns specific BookKeeping by id via role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingsResolver.find(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.account_count        == struct.account_count
      assert found.balance_sheet        == struct.balance_sheet
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.inventory            == struct.inventory
      assert found.inventory_count      == struct.inventory_count
      assert found.payroll              == struct.payroll
      assert found.price_payroll        == struct.price_payroll
      assert found.tax_return_current   == struct.tax_return_current
      assert found.tax_year             == struct.tax_year
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns specific BookKeeping by id via role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingsResolver.find(nil, %{id: struct.id}, context)

      assert found.id                   == struct.id
      assert found.account_count        == struct.account_count
      assert found.balance_sheet        == struct.balance_sheet
      assert found.deadline             == struct.deadline
      assert found.financial_situation  == struct.financial_situation
      assert found.inventory            == struct.inventory
      assert found.inventory_count      == struct.inventory_count
      assert found.payroll              == struct.payroll
      assert found.price_payroll        == struct.price_payroll
      assert found.tax_return_current   == struct.tax_return_current
      assert found.tax_year             == struct.tax_year
      assert found.user_id              == struct.user_id
      assert found.inserted_at          == struct.inserted_at
      assert found.updated_at           == struct.updated_at
      assert found.user.id              == user.id
      assert found.user.email           == user.email
      assert found.user.role            == user.role
    end

    it "returns not found when BookKeeping does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingsResolver.find(nil, %{id: id}, context)
      assert error == "The BookKeeping #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BookKeeping an event by role's Tp" do
      user = insert(:tp_user)
      context = %{context: %{current_user: user}}

      args = %{
        account_count:                  99,
        balance_sheet:                true,
        deadline:         Date.utc_today(),
        financial_situation:   "some text",
        inventory:                    true,
        inventory_count:                99,
        payroll:                      true,
        tax_return_current:           true,
        tax_year: ["2015", "2016", "2017"],
        user_id: user.id
      }

      {:ok, created} = BookKeepingsResolver.create(nil, args, context)

      assert created.account_count        == 99
      assert created.balance_sheet        == true
      assert created.deadline             == Date.utc_today()
      assert created.financial_situation  == "some text"
      assert created.inventory            == true
      assert created.inventory_count      == 99
      assert created.payroll              == true
      assert created.price_payroll        == nil
      assert created.tax_return_current   == true
      assert created.tax_year             == ["2015", "2016", "2017"]
      assert created.user_id              == user.id
    end

    it "creates BookKeepingTypeClient an event by role's Pro" do
      user = insert(:pro_user)
      context = %{context: %{current_user: user}}

      args = %{
        payroll:     true,
        price_payroll: 99,
        user_id:  user.id
      }

      {:ok, created} = BookKeepingsResolver.create(nil, args, context)

      assert created.account_count        == nil
      assert created.balance_sheet        == nil
      assert created.deadline             == nil
      assert created.financial_situation  == nil
      assert created.inventory            == nil
      assert created.inventory_count      == nil
      assert created.payroll              == true
      assert created.price_payroll        == 99
      assert created.tax_return_current   == nil
      assert created.tax_year             == nil
      assert created.user_id              == user.id
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      context = %{context: %{current_user: user}}
      args = %{user_id: nil}
      {:error, error} = BookKeepingsResolver.create(nil, args, context)
      assert error == []
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      context = %{context: %{current_user: user}}
      args = %{user_id: nil}
      {:error, error} = BookKeepingsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BookKeeping by id via role's Tp" do
      user = insert(:tp_user)
      struct = insert(:tp_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{
        account_count:                   11,
        balance_sheet:                false,
        deadline:          Date.utc_today(),
        financial_situation: "updated text",
        inventory:                    false,
        inventory_count:                 11,
        payroll:                      false,
        tax_return_current:           false,
        tax_year:          ["2018", "2019"],
        user_id:                    user.id
      }
      args = %{id: struct.id, book_keeping: params}
      {:ok, updated} = BookKeepingsResolver.update(nil, args, context)

      assert updated.id                   == struct.id
      assert updated.account_count        == 11
      assert updated.balance_sheet        == false
      assert updated.deadline             == Date.utc_today()
      assert updated.financial_situation  == "updated text"
      assert updated.inventory            == false
      assert updated.inventory_count      == 11
      assert updated.payroll              == false
      assert updated.price_payroll        == nil
      assert updated.tax_return_current   == false
      assert updated.tax_year             == ["2018", "2019"]
      assert updated.user_id              == user.id
      assert updated.inserted_at          == struct.inserted_at
      assert updated.updated_at           == struct.updated_at
    end

    it "update specific BookKeepingTypeClient by id via role's Pro" do
      user = insert(:pro_user)
      struct = insert(:pro_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{
        payroll:    false,
        price_payroll: 11,
        user_id:  user.id
      }
      args = %{id: struct.id, book_keeping: params}
      {:ok, updated} = BookKeepingsResolver.update(nil, args, context)

      assert updated.id                   == struct.id
      assert updated.account_count        == nil
      assert updated.balance_sheet        == nil
      assert updated.deadline             == nil
      assert updated.financial_situation  == nil
      assert updated.inventory            == nil
      assert updated.inventory_count      == nil
      assert updated.payroll              == false
      assert updated.price_payroll        == 11
      assert updated.tax_return_current   == nil
      assert updated.tax_year             == nil
      assert updated.user_id              == user.id
      assert updated.inserted_at          == struct.inserted_at
      assert updated.updated_at           == struct.updated_at
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      insert(:tp_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{user_id: nil}
      args = %{id: nil, book_keeping: params}
      {:error, error} = BookKeepingsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      insert(:pro_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      params = %{user_id: nil}
      args = %{id: nil, book_keeping: params}
      {:error, error} = BookKeepingsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BookKeeping by id" do
      user = insert(:tp_user)
      struct = insert(:book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      {:ok, delete} = BookKeepingsResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BookKeeping does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingsResolver.delete(nil, %{id: id}, context)
      assert error == "The BookKeeping #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:book_keeping, %{user: user})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
