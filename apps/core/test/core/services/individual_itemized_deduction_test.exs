defmodule Core.Services.IndividualItemizedDeductionTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.IndividualItemizedDeduction
  }

  describe "individual_itemized_deduction by role's Tp" do
    test "requires name and individual_tax_return_id via role's Tp" do
      changeset = IndividualItemizedDeduction.changeset(%IndividualItemizedDeduction{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualItemizedDeduction{}
        |> IndividualItemizedDeduction.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_itemized_deductions/0 returns all individual_itemized_deduction via role's Tp" do
      individual_tax_return = insert(:tp_individual_tax_return)
      struct = insert(:tp_individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_itemized_deduction
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_itemized_deduction!/1 returns the individual_itemized_deduction with given id" do
      struct = insert(:tp_individual_itemized_deduction)
      data = Services.get_individual_itemized_deduction!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_itemized_deduction/1 with valid data creates a individual_itemized_deduction" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{
        name: "some name",
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualItemizedDeduction{} = individual_itemized_deduction} =
        Services.create_individual_itemized_deduction(params)
      assert %Ecto.Association.NotLoaded{} = individual_itemized_deduction.individual_tax_returns

      [loaded] =
        Repo.preload([individual_itemized_deduction], [:individual_tax_returns])

      assert loaded.name                                                == "some name"
      assert loaded.price                                               == nil
      assert loaded.inserted_at                                         == individual_itemized_deduction.inserted_at
      assert loaded.updated_at                                          == individual_itemized_deduction.updated_at
      assert loaded.individual_tax_return_id                            == individual_tax_return.id
      assert match_value_relate.match_for_individual_itemized_deduction == 20
    end

    test "create_individual_itemized_deduction/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_itemized_deduction(params)
    end

    test "update_individual_itemized_deduction/2 with valid data updates the individual_itemized_deduction" do
      match_value_relate = insert(:match_value_relat)
      struct = insert(:tp_individual_itemized_deduction)
      individual_tax_return = insert(:individual_tax_return)

      params = %{name: "updated some name", individual_tax_return_id: individual_tax_return.id}

      assert {:ok, %IndividualItemizedDeduction{} = updated} =
        Services.update_individual_itemized_deduction(struct, params)

      assert updated.name                                               == "updated some name"
      assert updated.price                                              == nil
      assert updated.inserted_at                                        == struct.inserted_at
      assert updated.updated_at                                         == struct.updated_at
      assert updated.individual_tax_return_id                           == individual_tax_return.id
      assert match_value_relate.match_for_individual_itemized_deduction == 20
    end

    test "update_individual_itemized_deduction/2 with invalid data returns error changeset" do
      struct = insert(:tp_individual_itemized_deduction)
      params = %{name: nil, individual_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_itemized_deduction!(struct.id)

      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_itemized_deduction(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_itemized_deduction/1 deletes the individual_itemized_deduction" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_itemized_deduction, individual_tax_returns: individual_tax_return)

      assert {:ok, %IndividualItemizedDeduction{}} =
        Services.delete_individual_itemized_deduction(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_itemized_deduction!(struct.id)
      end
    end

    test "change_individual_itemized_deduction/1 returns a individual_itemized_deduction changeset" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      assert %Ecto.Changeset{} = Services.change_individual_itemized_deduction(struct)
    end
  end

  describe "individual_itemized_deduction by role's Pro" do
    test "requires name and individual_tax_return_id via role's Pro" do
      changeset = IndividualItemizedDeduction.changeset(%IndividualItemizedDeduction{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualItemizedDeduction{}
        |> IndividualItemizedDeduction.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_itemized_deductions/0 returns all individual_itemized_deduction via role's Pro" do
      individual_tax_return = insert(:pro_individual_tax_return)
      struct = insert(:pro_individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_itemized_deduction
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_itemized_deduction!/1 returns the individual_itemized_deduction with given id" do
      struct = insert(:pro_individual_itemized_deduction)
      data = Services.get_individual_itemized_deduction!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_itemized_deduction/1 with valid data creates a individual_itemized_deduction" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

      params = %{
        name: "some name",
        price: 90,
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualItemizedDeduction{} = individual_itemized_deduction} =
        Services.create_individual_itemized_deduction(params)
      assert %Ecto.Association.NotLoaded{} = individual_itemized_deduction.individual_tax_returns

      [loaded] =
        Repo.preload([individual_itemized_deduction], [:individual_tax_returns])

      assert loaded.name                                                == "some name"
      assert loaded.price                                               == 90
      assert loaded.inserted_at                                         == individual_itemized_deduction.inserted_at
      assert loaded.updated_at                                          == individual_itemized_deduction.updated_at
      assert loaded.individual_tax_return_id                            == individual_tax_return.id
      assert match_value_relate.match_for_individual_itemized_deduction == 20
    end

    test "create_individual_itemized_deduction/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_itemized_deduction(params)
    end

    test "update_individual_itemized_deduction/2 with valid data updates the individual_itemized_deduction" do
      match_value_relate = insert(:match_value_relat)
      struct = insert(:pro_individual_itemized_deduction)
      individual_tax_return = insert(:individual_tax_return)

      params = %{name: "updated some name", price: 99, individual_tax_return_id: individual_tax_return.id}

      assert {:ok, %IndividualItemizedDeduction{} = updated} =
        Services.update_individual_itemized_deduction(struct, params)

      assert updated.name                                               == "updated some name"
      assert updated.price                                              == 99
      assert updated.inserted_at                                        == struct.inserted_at
      assert updated.updated_at                                         == struct.updated_at
      assert updated.individual_tax_return_id                           == individual_tax_return.id
      assert match_value_relate.match_for_individual_itemized_deduction == 20
    end

    test "update_individual_itemized_deduction/2 with invalid data returns error changeset" do
      struct = insert(:pro_individual_itemized_deduction)
      params = %{name: nil, price: nil, individual_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_itemized_deduction!(struct.id)

      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_itemized_deduction(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_itemized_deduction/1 deletes the individual_itemized_deduction" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_itemized_deduction, individual_tax_returns: individual_tax_return)

      assert {:ok, %IndividualItemizedDeduction{}} =
        Services.delete_individual_itemized_deduction(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_itemized_deduction!(struct.id)
      end
    end

    test "change_individual_itemized_deduction/1 returns a individual_itemized_deduction changeset" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_itemized_deduction, individual_tax_returns: individual_tax_return)
      assert %Ecto.Changeset{} = Services.change_individual_itemized_deduction(struct)
    end
  end
end
