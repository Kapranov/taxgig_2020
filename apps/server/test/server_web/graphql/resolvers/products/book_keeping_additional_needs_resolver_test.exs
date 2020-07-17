defmodule ServerWeb.GraphQL.Resolvers.Products.BookKeepingAdditionalNeedsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BookKeepingAdditionalNeedsResolver

  describe "#index" do
    it "returns BookKeepingAdditionalNeed by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingAdditionalNeedsResolver.list(nil, nil, context)

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

    it "returns BookKeepingAdditionalNeed by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, data} = BookKeepingAdditionalNeedsResolver.list(nil, nil, context)

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
    it "returns specific BookKeepingAdditionalNeed by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingAdditionalNeedsResolver.show(nil, %{id: struct.id}, context)

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

    it "returns specific BookKeepingAdditionalNeed by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingAdditionalNeedsResolver.show(nil, %{id: struct.id}, context)

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

    it "returns not found when BookKeepingAdditionalNeed does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingAdditionalNeedsResolver.show(nil, %{id: id}, context)
      assert error == "The BookKeepingAdditionalNeed #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingAdditionalNeedsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "returns specific BookKeepingAdditionalNeed by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingAdditionalNeedsResolver.find(nil, %{id: struct.id}, context)

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

    it "returns specific BookKeepingAdditionalNeed by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}

      {:ok, found} = BookKeepingAdditionalNeedsResolver.find(nil, %{id: struct.id}, context)

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

    it "returns not found when BookKeepingAdditionalNeed does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingAdditionalNeedsResolver.find(nil, %{id: id}, context)
      assert error == "The BookKeepingAdditionalNeed #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingAdditionalNeedsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BookKeepingAdditionalNeed an event by role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      args = %{
        book_keeping_id: book_keeping.id,
        name: "accounts payable"
      }

      {:ok, created} = BookKeepingAdditionalNeedsResolver.create(nil, args, context)

      assert created.book_keeping_id == book_keeping.id
      assert created.name            == :"accounts payable"
    end

    it "creates BookKeepingAdditionalNeed an event by role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      context = %{context: %{current_user: user}}

      args = %{
        book_keeping_id: book_keeping.id,
        name: "accounts payable",
        price: 22
      }

      {:ok, created} = BookKeepingAdditionalNeedsResolver.create(nil, args, context)

      assert created.book_keeping_id == book_keeping.id
      assert created.name            == :"accounts payable"
      assert created.price           == 22
    end


    it "returns error for missing params" do
      user = insert(:user)
      insert(:book_keeping, user: user)
      context = %{context: %{current_user: user}}
      args = %{book_keeping_id: nil, name: nil}
      {:error, error} = BookKeepingAdditionalNeedsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BookKeepingAdditionalNeed by id via role's Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      struct = insert(:tp_book_keeping_additional_need, %{name: "accounts payable", book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{name: "sales tax", book_keeping_id: book_keeping.id}
      args = %{id: struct.id, book_keeping_additional_need: params}
      {:ok, updated} = BookKeepingAdditionalNeedsResolver.update(nil, args, context)

      assert updated.id              == struct.id
      assert updated.book_keeping_id == book_keeping.id
      assert updated.name            == :"sales tax"
      assert updated.price           == nil
      assert updated.inserted_at     == struct.inserted_at
      assert updated.updated_at      == struct.updated_at
    end

    it "update specific BookKeepingAdditionalNeed by id via role's Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      struct = insert(:pro_book_keeping_additional_need, %{name: "accounts payable", book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{price: 33, name: "sales tax", book_keeping_id: book_keeping.id}
      args = %{id: struct.id, book_keeping_additional_need: params}
      {:ok, updated} = BookKeepingAdditionalNeedsResolver.update(nil, args, context)

      assert updated.id              == struct.id
      assert updated.book_keeping_id == book_keeping.id
      assert updated.name            == :"sales tax"
      assert updated.price           == 33
      assert updated.inserted_at     == struct.inserted_at
      assert updated.updated_at      == struct.updated_at
    end

    it "returns error for missing params via Tp" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, %{user: user})
      insert(:tp_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{name: nil, book_keeping_id: nil}
      args = %{id: nil, book_keeping_additional_need: params}
      {:error, error} = BookKeepingAdditionalNeedsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end

    it "returns error for missing params via Pro" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, %{user: user})
      insert(:pro_book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      params = %{price: nil, name: nil, book_keeping_id: nil}
      args = %{id: nil, book_keeping_additional_need: params}
      {:error, error} = BookKeepingAdditionalNeedsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BookKeepingAdditionalNeed by id" do
      user = insert(:tp_user)
      book_keeping = insert(:book_keeping, %{user: user})
      struct = insert(:book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:ok, delete} = BookKeepingAdditionalNeedsResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BookKeepingAdditionalNeed does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      {:error, error} = BookKeepingAdditionalNeedsResolver.delete(nil, %{id: id}, context)
      assert error == "The BookKeepingAdditionalNeed #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      book_keeping = insert(:book_keeping, %{user: user})
      insert(:book_keeping_additional_need, %{book_keepings: book_keeping})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BookKeepingAdditionalNeedsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
