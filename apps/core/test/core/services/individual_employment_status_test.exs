defmodule Core.Services.IndividualEmploymentStatusTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.IndividualEmploymentStatus
  }
  alias Decimal, as: D

  describe "individual_employment_status by role's Tp" do
    test "requires name and individual_tax_return_id via role's Tp" do
      changeset = IndividualEmploymentStatus.changeset(%IndividualEmploymentStatus{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualEmploymentStatus{}
        |> IndividualEmploymentStatus.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_employment_statuses/0 returns all individual_employment_statuses via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_employment_status, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_employment_status
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_employment_status!/1 returns the individual_employment_status with given id" do
      struct = insert(:tp_individual_employment_status)
      data = Services.get_individual_employment_status!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_employment_status/1 with valid data creates a individual_employment_status" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{
        name: "some name",
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualEmploymentStatus{} = individual_employment_status} =
        Services.create_individual_employment_status(params)
      assert %Ecto.Association.NotLoaded{} = individual_employment_status.individual_tax_returns

      [loaded] =
        Repo.preload([individual_employment_status], [:individual_tax_returns])

      assert loaded.name                                               == "some name"
      assert loaded.price                                              == nil
      assert loaded.inserted_at                                        == individual_employment_status.inserted_at
      assert loaded.updated_at                                         == individual_employment_status.updated_at
      assert loaded.individual_tax_return_id                           == individual_tax_return.id
      assert match_value_relate.match_for_individual_employment_status == 35
      assert match_value_relate.value_for_individual_employment_status == D.new("180.0")
    end

    test "create_individual_employment_status/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_employment_status(params)
    end

    test "update_individual_employment_status/2 with valid data updates the individual_employment_status" do
      match_value_relate = insert(:match_value_relat)
      struct = insert(:tp_individual_employment_status)
      individual_tax_return = insert(:individual_tax_return)
      params = %{name: "updated some name", individual_tax_return_id: individual_tax_return.id}

      assert {:ok, %IndividualEmploymentStatus{} = updated} =
        Services.update_individual_employment_status(struct, params)

      assert updated.name                                               == "updated some name"
      assert updated.price                                              == nil
      assert updated.inserted_at                                        == struct.inserted_at
      assert updated.updated_at                                         == struct.updated_at
      assert updated.individual_tax_return_id                           == individual_tax_return.id
      assert match_value_relate.match_for_individual_employment_status  == 35
      assert match_value_relate.value_for_individual_employment_status  == D.new("180.0")
    end

    test "update_individual_employment_status/2 with invalid data returns error changeset" do
      struct = insert(:tp_individual_employment_status)
      params = %{name: nil, individual_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_employment_status!(struct.id)

      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_employment_status(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_employment_status/1 deletes the individual_employment_status" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_employment_status, individual_tax_returns: individual_tax_return)

      assert {:ok, %IndividualEmploymentStatus{}} =
        Services.delete_individual_employment_status(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_employment_status!(struct.id)
      end
    end

    test "change_individual_employment_status/1 returns a individual_employment_status changeset" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_employment_status, individual_tax_returns: individual_tax_return)

      assert %Ecto.Changeset{} =
        Services.change_individual_employment_status(struct)
    end
  end

  describe "individual_employment_status by role's Pro" do
    test "requires name and individual_tax_return_id via role's Pro" do
      changeset = IndividualEmploymentStatus.changeset(%IndividualEmploymentStatus{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualEmploymentStatus{}
        |> IndividualEmploymentStatus.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_employment_statuses/0 returns all individual_employment_statuses via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_employment_status, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_employment_status
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_employment_status!/1 returns the individual_employment_status with given id" do
      struct = insert(:pro_individual_employment_status)
      data = Services.get_individual_employment_status!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_employment_status/1 with valid data creates a individual_employment_status" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

      params = %{
        name: "some name",
        price: 22,
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualEmploymentStatus{} = individual_employment_status} =
        Services.create_individual_employment_status(params)
      assert %Ecto.Association.NotLoaded{} = individual_employment_status.individual_tax_returns

      [loaded] =
        Repo.preload([individual_employment_status], [:individual_tax_returns])

      assert loaded.name                                               == "some name"
      assert loaded.price                                              == 22
      assert loaded.inserted_at                                        == individual_employment_status.inserted_at
      assert loaded.updated_at                                         == individual_employment_status.updated_at
      assert loaded.individual_tax_return_id                           == individual_tax_return.id
      assert match_value_relate.match_for_individual_employment_status == 35
      assert match_value_relate.value_for_individual_employment_status == D.new("180.0")
    end

    test "create_individual_employment_status/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_employment_status(params)
    end

    test "update_individual_employment_status/2 with valid data updates the individual_employment_status" do
      match_value_relate = insert(:match_value_relat)
      struct = insert(:pro_individual_employment_status)
      individual_tax_return = insert(:individual_tax_return)
      params = %{name: "updated some name", price: 33, individual_tax_return_id: individual_tax_return.id}

      assert {:ok, %IndividualEmploymentStatus{} = updated} =
        Services.update_individual_employment_status(struct, params)

      assert updated.name                                              == "updated some name"
      assert updated.price                                             == 33
      assert updated.inserted_at                                       == struct.inserted_at
      assert updated.updated_at                                        == struct.updated_at
      assert updated.individual_tax_return_id                          == individual_tax_return.id
      assert match_value_relate.match_for_individual_employment_status == 35
      assert match_value_relate.value_for_individual_employment_status == D.new("180.0")
    end

    test "update_individual_employment_status/2 with invalid data returns error changeset" do
      struct = insert(:pro_individual_employment_status)
      params = %{name: nil, individual_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_employment_status!(struct.id)

      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_employment_status(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_employment_status/1 deletes the individual_employment_status" do
      struct = insert(:pro_individual_employment_status)

      assert {:ok, %IndividualEmploymentStatus{}} =
        Services.delete_individual_employment_status(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_employment_status!(struct.id)
      end
    end

    test "change_individual_employment_status/1 returns a individual_employment_status changeset" do
      struct = insert(:pro_individual_employment_status)

      assert %Ecto.Changeset{} =
        Services.change_individual_employment_status(struct)
    end
  end
end
