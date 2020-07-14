defmodule Core.Services.IndividualFilingStatusTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.IndividualFilingStatus
  }

  describe "individual_filing_status by role's Tp" do
    test "requires name and individual_tax_return_id via role's Tp" do
      changeset = IndividualFilingStatus.changeset(%IndividualFilingStatus{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualFilingStatus{}
        |> IndividualFilingStatus.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_filing_statuses/0 returns all individual_filing_status via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_filing_status, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_filing_status
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_filing_status!/1 returns the individual_filing_status with given id" do
      struct = insert(:tp_individual_filing_status)
      data = Services.get_individual_filing_status!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_filing_status/1 with valid data creates a individual_filing_status" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{
        name: "Head of Household",
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualFilingStatus{} = individual_filing_status} =
        Services.create_individual_filing_status(params)
      assert %Ecto.Association.NotLoaded{} = individual_filing_status.individual_tax_returns

      [loaded] =
        Repo.preload([individual_filing_status], [:individual_tax_returns])

      assert loaded.name                                               == :"Head of Household"
      assert loaded.price                                              == nil
      assert loaded.inserted_at                                        == individual_filing_status.inserted_at
      assert loaded.updated_at                                         == individual_filing_status.updated_at
      assert loaded.individual_tax_return_id                           == individual_tax_return.id
      assert match_value_relate.match_for_individual_filing_status     == 50
    end

    test "create_individual_filing_status/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_filing_status(params)
    end

    test "update_individual_filing_status/2 with valid data updates the individual_filing_status" do
      match_value_relate = insert(:match_value_relat)
      struct = insert(:tp_individual_filing_status)
      params = %{name: "Single", individual_tax_return_id: struct.individual_tax_return_id}

      assert {:ok, %IndividualFilingStatus{} = updated} =
        Services.update_individual_filing_status(struct, params)

      assert updated.name                                          == :Single
      assert updated.price                                         == nil
      assert updated.inserted_at                                   == struct.inserted_at
      assert updated.updated_at                                    == struct.updated_at
      assert updated.individual_tax_return_id                      == struct.individual_tax_return_id
      assert match_value_relate.match_for_individual_filing_status == 50
    end

    test "update_individual_filing_status/2 with invalid data returns error changeset" do
      struct = insert(:tp_individual_filing_status)
      params = %{name: nil, individual_tax_return_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_filing_status(struct, params)
    end

    test "delete_individual_filing_status/1 deletes the individual_filing_status" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_filing_status, individual_tax_returns: individual_tax_return)

      assert {:ok, %IndividualFilingStatus{}} =
        Services.delete_individual_filing_status(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_filing_status!(struct.id)
      end
    end

    test "change_individual_filing_status/1 returns a individual_filing_status changeset" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_filing_status = insert(:tp_individual_filing_status, individual_tax_returns: individual_tax_return)

      assert %Ecto.Changeset{} =
        Services.change_individual_filing_status(individual_filing_status)
    end
  end

  describe "individual_filing_status by role's Pro" do
    test "requires name and individual_tax_return_id via role's Pro" do
      changeset = IndividualFilingStatus.changeset(%IndividualFilingStatus{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualFilingStatus{}
        |> IndividualFilingStatus.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_filing_statuses/0 returns all individual_filing_status via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_filing_status, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_filing_status
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_filing_status!/1 returns the individual_filing_status with given id" do
      struct = insert(:pro_individual_filing_status)
      data = Services.get_individual_filing_status!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_filing_status/1 with valid data creates a individual_filing_status" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

      params = %{
        name: "Head of Household",
        price: 90,
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualFilingStatus{} = individual_filing_status} =
        Services.create_individual_filing_status(params)
      assert %Ecto.Association.NotLoaded{} = individual_filing_status.individual_tax_returns

      [loaded] =
        Repo.preload([individual_filing_status], [:individual_tax_returns])

      assert loaded.name                                               == :"Head of Household"
      assert loaded.price                                              == 90
      assert loaded.inserted_at                                        == individual_filing_status.inserted_at
      assert loaded.updated_at                                         == individual_filing_status.updated_at
      assert loaded.individual_tax_return_id                           == individual_tax_return.id
      assert match_value_relate.match_for_individual_filing_status     == 50
    end

    test "create_individual_filing_status/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_filing_status(params)
    end

    test "update_individual_filing_status/2 with valid data updates the individual_filing_status" do
      match_value_relate = insert(:match_value_relat)
      struct = insert(:pro_individual_filing_status)
      params = %{name: "Single", price: 99, individual_tax_return_id: struct.individual_tax_return_id}

      assert {:ok, %IndividualFilingStatus{} = updated} =
        Services.update_individual_filing_status(struct, params)

      assert updated.name                                          == :Single
      assert updated.price                                         == 99
      assert updated.inserted_at                                   == struct.inserted_at
      assert updated.updated_at                                    == struct.updated_at
      assert updated.individual_tax_return_id                      == struct.individual_tax_return_id
      assert match_value_relate.match_for_individual_filing_status == 50
    end

    test "update_individual_filing_status/2 with invalid data returns error changeset" do
      struct = insert(:pro_individual_filing_status)
      params = %{name: nil, individual_tax_return_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_filing_status(struct, params)
    end

    test "delete_individual_filing_status/1 deletes the individual_filing_status" do
      user = insert(:pro_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:pro_individual_filing_status, individual_tax_returns: individual_tax_return)

      assert {:ok, %IndividualFilingStatus{}} =
        Services.delete_individual_filing_status(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_filing_status!(struct.id)
      end
    end

    test "change_individual_filing_status/1 returns a individual_filing_status changeset" do
      user = insert(:pro_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      individual_filing_status = insert(:tp_individual_filing_status, individual_tax_returns: individual_tax_return)

      assert %Ecto.Changeset{} =
        Services.change_individual_filing_status(individual_filing_status)
    end
  end
end
