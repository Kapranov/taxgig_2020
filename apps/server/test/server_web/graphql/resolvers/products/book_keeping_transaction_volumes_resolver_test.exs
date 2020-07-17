defmodule ServerWeb.GraphQL.Resolvers.Products.BookKeepingTransactionVolumesResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BookKeepingTransactionVolumesResolver

  describe "#index" do
    it "returns BookKeepingNumberEmployee by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingTransactionVolumesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                                 == struct.id
      assert List.first(data).book_keeping_id                    == struct.book_keeping_id
      assert List.first(data).name                               == struct.name
      assert List.first(data).price                              == nil
      assert List.first(data).inserted_at                        == struct.inserted_at
      assert List.first(data).updated_at                         == struct.updated_at
      assert List.first(data).book_keepings.id                   == struct.book_keepings.id
      assert List.first(data).book_keepings.account_count        == struct.book_keepings.account_count
      assert List.first(data).book_keepings.balance_sheet        == struct.book_keepings.balance_sheet
      assert List.first(data).book_keepings.deadline             == struct.book_keepings.deadline
      assert List.first(data).book_keepings.financial_situation  == struct.book_keepings.financial_situation
      assert List.first(data).book_keepings.inventory            == struct.book_keepings.inventory
      assert List.first(data).book_keepings.inventory_count      == struct.book_keepings.inventory_count
      assert List.first(data).book_keepings.payroll              == struct.book_keepings.payroll
      assert List.first(data).book_keepings.price_payroll        == nil
      assert List.first(data).book_keepings.tax_return_current   == struct.book_keepings.tax_return_current
      assert List.first(data).book_keepings.tax_year             == struct.book_keepings.tax_year
      assert List.first(data).book_keepings.user_id              == struct.book_keepings.user_id
      assert List.first(data).book_keepings.inserted_at          == struct.book_keepings.inserted_at
      assert List.first(data).book_keepings.updated_at           == struct.book_keepings.updated_at
      assert List.first(data).book_keepings.user.id              == user.id
      assert List.first(data).book_keepings.user.email           == user.email
      assert List.first(data).book_keepings.user.role            == user.role
    end

    it "returns BookKeepingTransactionVolume by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingTransactionVolumesResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                                 == struct.id
      assert List.first(data).book_keeping_id                    == struct.book_keeping_id
      assert List.first(data).name                               == struct.name
      assert List.first(data).price                              == struct.price
      assert List.first(data).inserted_at                        == struct.inserted_at
      assert List.first(data).updated_at                         == struct.updated_at
      assert List.first(data).book_keepings.id                   == struct.book_keepings.id
      assert List.first(data).book_keepings.account_count        == struct.book_keepings.account_count
      assert List.first(data).book_keepings.balance_sheet        == struct.book_keepings.balance_sheet
      assert List.first(data).book_keepings.deadline             == struct.book_keepings.deadline
      assert List.first(data).book_keepings.financial_situation  == struct.book_keepings.financial_situation
      assert List.first(data).book_keepings.inventory            == struct.book_keepings.inventory
      assert List.first(data).book_keepings.inventory_count      == struct.book_keepings.inventory_count
      assert List.first(data).book_keepings.payroll              == struct.book_keepings.payroll
      assert List.first(data).book_keepings.price_payroll        == struct.book_keepings.price_payroll
      assert List.first(data).book_keepings.tax_return_current   == struct.book_keepings.tax_return_current
      assert List.first(data).book_keepings.tax_year             == struct.book_keepings.tax_year
      assert List.first(data).book_keepings.user_id              == struct.book_keepings.user_id
      assert List.first(data).book_keepings.inserted_at          == struct.book_keepings.inserted_at
      assert List.first(data).book_keepings.updated_at           == struct.book_keepings.updated_at
      assert List.first(data).book_keepings.user.id              == user.id
      assert List.first(data).book_keepings.user.email           == user.email
      assert List.first(data).book_keepings.user.role            == user.role
    end
  end

  describe "#show" do
    it "returns specific BookKeepingTransactionVolume by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingTransactionVolumesResolver.show(nil, %{id: struct.id}, context)

      assert found.id                                 == struct.id
      assert found.book_keeping_id                    == struct.book_keeping_id
      assert found.name                               == struct.name
      assert found.price                              == nil
      assert found.inserted_at                        == struct.inserted_at
      assert found.updated_at                         == struct.updated_at
      assert found.book_keepings.id                   == struct.book_keepings.id
      assert found.book_keepings.account_count        == struct.book_keepings.account_count
      assert found.book_keepings.balance_sheet        == struct.book_keepings.balance_sheet
      assert found.book_keepings.deadline             == struct.book_keepings.deadline
      assert found.book_keepings.financial_situation  == struct.book_keepings.financial_situation
      assert found.book_keepings.inventory            == struct.book_keepings.inventory
      assert found.book_keepings.inventory_count      == struct.book_keepings.inventory_count
      assert found.book_keepings.payroll              == struct.book_keepings.payroll
      assert found.book_keepings.price_payroll        == struct.book_keepings.price_payroll
      assert found.book_keepings.tax_return_current   == struct.book_keepings.tax_return_current
      assert found.book_keepings.tax_year             == struct.book_keepings.tax_year
      assert found.book_keepings.user_id              == struct.book_keepings.user_id
      assert found.book_keepings.inserted_at          == struct.book_keepings.inserted_at
      assert found.book_keepings.updated_at           == struct.book_keepings.updated_at
      assert found.book_keepings.user.id              == user.id
      assert found.book_keepings.user.email           == user.email
      assert found.book_keepings.user.role            == user.role
    end

    it "returns specific BookKeepingTransactionVolume by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingTransactionVolumesResolver.show(nil, %{id: struct.id}, context)

      assert found.id                                 == struct.id
      assert found.book_keeping_id                    == struct.book_keeping_id
      assert found.name                               == struct.name
      assert found.price                              == struct.price
      assert found.inserted_at                        == struct.inserted_at
      assert found.updated_at                         == struct.updated_at
      assert found.book_keepings.id                   == struct.book_keepings.id
      assert found.book_keepings.account_count        == struct.book_keepings.account_count
      assert found.book_keepings.balance_sheet        == struct.book_keepings.balance_sheet
      assert found.book_keepings.deadline             == struct.book_keepings.deadline
      assert found.book_keepings.financial_situation  == struct.book_keepings.financial_situation
      assert found.book_keepings.inventory            == struct.book_keepings.inventory
      assert found.book_keepings.inventory_count      == struct.book_keepings.inventory_count
      assert found.book_keepings.payroll              == struct.book_keepings.payroll
      assert found.book_keepings.price_payroll        == struct.book_keepings.price_payroll
      assert found.book_keepings.tax_return_current   == struct.book_keepings.tax_return_current
      assert found.book_keepings.tax_year             == struct.book_keepings.tax_year
      assert found.book_keepings.user_id              == struct.book_keepings.user_id
      assert found.book_keepings.inserted_at          == struct.book_keepings.inserted_at
      assert found.book_keepings.updated_at           == struct.book_keepings.updated_at
      assert found.book_keepings.user.id              == user.id
      assert found.book_keepings.user.email           == user.email
      assert found.book_keepings.user.role            == user.role
    end

    it "returns not found when BookKeepingTransactionVolume does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingTransactionVolumesResolver.show(nil, %{id: id}, context)
      assert error == "The BookKeepingTransactionVolume #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingTransactionVolumesResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "returns specific BookKeepingTransactionVolume by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingTransactionVolumesResolver.find(nil, %{id: struct.id}, context)

      assert found.id                                 == struct.id
      assert found.book_keeping_id                    == struct.book_keeping_id
      assert found.name                               == struct.name
      assert found.price                              == nil
      assert found.inserted_at                        == struct.inserted_at
      assert found.updated_at                         == struct.updated_at
      assert found.book_keepings.id                   == struct.book_keepings.id
      assert found.book_keepings.account_count        == struct.book_keepings.account_count
      assert found.book_keepings.balance_sheet        == struct.book_keepings.balance_sheet
      assert found.book_keepings.deadline             == struct.book_keepings.deadline
      assert found.book_keepings.financial_situation  == struct.book_keepings.financial_situation
      assert found.book_keepings.inventory            == struct.book_keepings.inventory
      assert found.book_keepings.inventory_count      == struct.book_keepings.inventory_count
      assert found.book_keepings.payroll              == struct.book_keepings.payroll
      assert found.book_keepings.price_payroll        == struct.book_keepings.price_payroll
      assert found.book_keepings.tax_return_current   == struct.book_keepings.tax_return_current
      assert found.book_keepings.tax_year             == struct.book_keepings.tax_year
      assert found.book_keepings.user_id              == struct.book_keepings.user_id
      assert found.book_keepings.inserted_at          == struct.book_keepings.inserted_at
      assert found.book_keepings.updated_at           == struct.book_keepings.updated_at
      assert found.book_keepings.user.id              == user.id
      assert found.book_keepings.user.email           == user.email
      assert found.book_keepings.user.role            == user.role
    end

    it "returns specific BookKeepingTransactionVolume by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingTransactionVolumesResolver.find(nil, %{id: struct.id}, context)

      assert found.id                                 == struct.id
      assert found.book_keeping_id                    == struct.book_keeping_id
      assert found.name                               == struct.name
      assert found.price                              == struct.price
      assert found.inserted_at                        == struct.inserted_at
      assert found.updated_at                         == struct.updated_at
      assert found.book_keepings.id                   == struct.book_keepings.id
      assert found.book_keepings.account_count        == struct.book_keepings.account_count
      assert found.book_keepings.balance_sheet        == struct.book_keepings.balance_sheet
      assert found.book_keepings.deadline             == struct.book_keepings.deadline
      assert found.book_keepings.financial_situation  == struct.book_keepings.financial_situation
      assert found.book_keepings.inventory            == struct.book_keepings.inventory
      assert found.book_keepings.inventory_count      == struct.book_keepings.inventory_count
      assert found.book_keepings.payroll              == struct.book_keepings.payroll
      assert found.book_keepings.price_payroll        == struct.book_keepings.price_payroll
      assert found.book_keepings.tax_return_current   == struct.book_keepings.tax_return_current
      assert found.book_keepings.tax_year             == struct.book_keepings.tax_year
      assert found.book_keepings.user_id              == struct.book_keepings.user_id
      assert found.book_keepings.inserted_at          == struct.book_keepings.inserted_at
      assert found.book_keepings.updated_at           == struct.book_keepings.updated_at
      assert found.book_keepings.user.id              == user.id
      assert found.book_keepings.user.email           == user.email
      assert found.book_keepings.user.role            == user.role
    end

    it "returns not found when BookKeepingTransactionVolume does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingTransactionVolumesResolver.find(nil, %{id: id}, context)
      assert error == "The BookKeepingTransactionVolume #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingTransactionVolumesResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BookKeepingTransactionVolume an event by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      args = %{
        book_keeping_id: book_keeping.id,
        name: "1-25"
      }

      {:ok, created} = BookKeepingTransactionVolumesResolver.create(nil, args, context)

      assert created.book_keeping_id == book_keeping.id
      assert created.name            == :"1-25"
    end

    it "creates BookKeepingTransactionVolume an event by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      args = %{
        book_keeping_id: book_keeping.id,
        name: "1-25",
        price: 22
      }

      {:ok, created} = BookKeepingTransactionVolumesResolver.create(nil, args, context)

      assert created.book_keeping_id == book_keeping.id
      assert created.name            == :"1-25"
      assert created.price           == 22
    end


    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      insert(:tp_book_keeping, user: user)
      context = %{context: %{current_user: user}}
      args = %{book_keeping_id: nil, name: nil}
      {:error, error} = BookKeepingTransactionVolumesResolver.create(nil, args, context)
      assert error == []
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      insert(:pro_book_keeping, user: user)
      context = %{context: %{current_user: user}}
      args = %{book_keeping_id: nil, name: nil, price: nil}
      {:error, error} = BookKeepingTransactionVolumesResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BookKeepingTransactionVolume by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_transaction_volume, %{name: "1-25", book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{name: "76-199", book_keeping_id: book_keeping.id}
      args = %{id: struct.id, book_keeping_transaction_volume: params}
      {:ok, updated} = BookKeepingTransactionVolumesResolver.update(nil, args, context)

      assert updated.id              == struct.id
      assert updated.book_keeping_id == book_keeping.id
      assert updated.name            == :"76-199"
      assert updated.price           == nil
      assert updated.inserted_at     == struct.inserted_at
      assert updated.updated_at      == struct.updated_at
    end

    it "update specific BookKeepingTransactionVolume by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_transaction_volume, %{name: "1-25", book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{price: 33, name: "76-199", book_keeping_id: book_keeping.id}
      args = %{id: struct.id, book_keeping_transaction_volume: params}
      {:ok, updated} = BookKeepingTransactionVolumesResolver.update(nil, args, context)

      assert updated.id              == struct.id
      assert updated.book_keeping_id == book_keeping.id
      assert updated.name            == :"76-199"
      assert updated.price           == 33
      assert updated.inserted_at     == struct.inserted_at
      assert updated.updated_at      == struct.updated_at
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      insert(:tp_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{name: nil, book_keeping_id: nil}
      args = %{id: nil, book_keeping_transaction_volume: params}
      {:error, error} = BookKeepingTransactionVolumesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      insert(:pro_book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{price: nil, name: nil, book_keeping_id: nil}
      args = %{id: nil, book_keeping_transaction_volume: params}
      {:error, error} = BookKeepingTransactionVolumesResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BookKeepingTransactionVolume by id" do
      user = insert(:tp_user)
      book_keeping = insert(:book_keeping, %{user: user})
      struct = insert(:book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:ok, delete} = BookKeepingTransactionVolumesResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BookKeepingTransactionVolume does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingTransactionVolumesResolver.delete(nil, %{id: id}, context)
      assert error == "The BookKeepingTransactionVolume #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_transaction_volume, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingTransactionVolumesResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
