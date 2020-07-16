defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualItemizedDeductionsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.IndividualItemizedDeductionsResolver

  describe "#index" do
    it "returns individualFilingStatuses via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualItemizedDeductionsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_itemized_deduction.id
      assert List.first(data).inserted_at == individual_itemized_deduction.inserted_at
      assert List.first(data).name        == individual_itemized_deduction.name
      assert List.first(data).price       == nil
      assert List.first(data).updated_at  == individual_itemized_deduction.updated_at

      assert List.first(data).individual_tax_return_id           == individual_itemized_deduction.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_itemized_deduction.id
      assert List.last(data).inserted_at == individual_itemized_deduction.inserted_at
      assert List.last(data).name        == individual_itemized_deduction.name
      assert List.last(data).price       == nil
      assert List.last(data).updated_at  == individual_itemized_deduction.updated_at

      assert List.last(data).individual_tax_return_id           == individual_itemized_deduction.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at
    end

    it "returns individualFilingStatuses via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualItemizedDeductionsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id          == individual_itemized_deduction.id
      assert List.first(data).inserted_at == individual_itemized_deduction.inserted_at
      assert List.first(data).name        == individual_itemized_deduction.name
      assert List.first(data).price       == individual_itemized_deduction.price
      assert List.first(data).updated_at  == individual_itemized_deduction.updated_at

      assert List.first(data).individual_tax_return_id           == individual_itemized_deduction.individual_tax_return_id
      assert List.first(data).individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert List.first(data).individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at

      assert List.last(data).id          == individual_itemized_deduction.id
      assert List.last(data).inserted_at == individual_itemized_deduction.inserted_at
      assert List.last(data).name        == individual_itemized_deduction.name
      assert List.last(data).price       == individual_itemized_deduction.price
      assert List.last(data).updated_at  == individual_itemized_deduction.updated_at

      assert List.last(data).individual_tax_return_id           == individual_itemized_deduction.individual_tax_return_id
      assert List.last(data).individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert List.last(data).individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at
    end
  end

  describe "#show" do
    it "returns specific individualFilingStatus by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:tp_individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualItemizedDeductionsResolver.show(nil, %{id: individual_itemized_deduction.id}, context)

      assert found.id          == individual_itemized_deduction.id
      assert found.inserted_at == individual_itemized_deduction.inserted_at
      assert found.name        == individual_itemized_deduction.name
      assert found.price       == nil
      assert found.updated_at  == individual_itemized_deduction.updated_at

      assert found.individual_tax_return_id           == individual_itemized_deduction.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at
    end

    it "returns specific individualFilingStatus by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualItemizedDeductionsResolver.show(nil, %{id: individual_itemized_deduction.id}, context)

      assert found.id          == individual_itemized_deduction.id
      assert found.inserted_at == individual_itemized_deduction.inserted_at
      assert found.name        == individual_itemized_deduction.name
      assert found.price       == individual_itemized_deduction.price
      assert found.updated_at  == individual_itemized_deduction.updated_at

      assert found.individual_tax_return_id           == individual_itemized_deduction.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at
    end

    it "returns not found when individualFilingStatus does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualItemizedDeductionsResolver.show(nil, %{id: id}, context)
      assert error == "The IndividualItemizedDeduction #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualItemizedDeductionsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific individualFilingStatus by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:tp_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualItemizedDeductionsResolver.find(nil, %{id: individual_itemized_deduction.id}, context)

      assert found.id          == individual_itemized_deduction.id
      assert found.inserted_at == individual_itemized_deduction.inserted_at
      assert found.name        == individual_itemized_deduction.name
      assert found.price       == nil
      assert found.updated_at  == individual_itemized_deduction.updated_at

      assert found.individual_tax_return_id           == individual_itemized_deduction.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at
    end

    it "find specific individualFilingStatus by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:pro_individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}

      {:ok, found} = IndividualItemizedDeductionsResolver.find(nil, %{id: individual_itemized_deduction.id}, context)

      assert found.id          == individual_itemized_deduction.id
      assert found.inserted_at == individual_itemized_deduction.inserted_at
      assert found.name        == individual_itemized_deduction.name
      assert found.price       == individual_itemized_deduction.price
      assert found.updated_at  == individual_itemized_deduction.updated_at

      assert found.individual_tax_return_id           == individual_itemized_deduction.individual_tax_returns.id
      assert found.individual_tax_returns.inserted_at == individual_itemized_deduction.individual_tax_returns.inserted_at
      assert found.individual_tax_returns.updated_at  == individual_itemized_deduction.individual_tax_returns.updated_at
    end

    it "returns not found when individualFilingStatus does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualItemizedDeductionsResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualItemizedDeduction #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = IndividualItemizedDeductionsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates individualFilingStatus an event by role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "Charitable contributions"
      }

      {:ok, created} = IndividualItemizedDeductionsResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == :"Charitable contributions"
      assert created.price                    == nil
    end

    it "creates individualFilingStatus an event by role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      args = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "Charitable contributions",
        price: 12
      }

      {:ok, created} = IndividualItemizedDeductionsResolver.create(nil, args, context)

      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.name                     == :"Charitable contributions"
      assert created.price                    == 12
    end


    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{individual_tax_return_id: nil, name: nil}
      {:error, error} = IndividualItemizedDeductionsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific IndividualItemizedDeductionsResolver by id via role's Tp" do
      user = insert(:tp_user)
      insert(:tp_individual_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:tp_individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "Medical and dental expenses"
      }

      args = %{id: individual_itemized_deduction.id, individual_itemized_deduction: params}
      {:ok, updated} = IndividualItemizedDeductionsResolver.update(nil, args, context)

      assert updated.id                       == individual_itemized_deduction.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_itemized_deduction.inserted_at
      assert updated.name                     == :"Medical and dental expenses"
      assert updated.price                    == nil
      assert updated.updated_at               == individual_itemized_deduction.updated_at
    end

    it "update specific IndividualItemizedDeductionsResolver by id via role's Pro" do
      user = insert(:pro_user)
      insert(:pro_individual_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      individual_itemized_deduction = insert(:pro_individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}

      params = %{
        individual_tax_return_id: individual_tax_return.id,
        name: "Medical and dental expenses",
        price: 13
      }

      args = %{id: individual_itemized_deduction.id, individual_itemized_deduction: params}
      {:ok, updated} = IndividualItemizedDeductionsResolver.update(nil, args, context)

      assert updated.id                       == individual_itemized_deduction.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.inserted_at              == individual_itemized_deduction.inserted_at
      assert updated.name                     == :"Medical and dental expenses"
      assert updated.price                    == 13
      assert updated.updated_at               == individual_itemized_deduction.updated_at
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      params = %{individual_tax_return_id: nil, name: nil}
      args = %{id: nil, individual_itemized_deduction: params}
      {:error, error} = IndividualItemizedDeductionsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific individualFilingStatus by id" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      individual_itemized_deduction = insert(:individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      context = %{context: %{current_user: user}}
      {:ok, delete} = IndividualItemizedDeductionsResolver.delete(nil, %{id: individual_itemized_deduction.id}, context)
      assert delete.id == individual_itemized_deduction.id
    end

    it "returns not found when individualFilingStatus does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualItemizedDeductionsResolver.delete(nil, %{id: id}, context)
      assert error == "The IndividualItemizedDeduction #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      insert(:individual_itemized_deduction, %{individual_tax_returns: individual_tax_return})
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualItemizedDeductionsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
