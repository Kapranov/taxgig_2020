defmodule Core.Services.IndividualIndustryTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.IndividualIndustry
  }

  describe "individual_industries by role's Tp" do
    test "requires name and individual_tax_return_id via role's Tp" do
      changeset = IndividualIndustry.changeset(%IndividualIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualIndustry{}
        |> IndividualIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_industry/0 returns all individual_industries" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_industry, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_industry!/1 returns the individual_industries with given id" do
      struct = insert(:tp_individual_industry)
      data = Services.get_individual_industry!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_industry/1 with valid data creates a individual_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{
        name: ["Agriculture/Farming"],
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualIndustry{} = individual_industry} =
        Services.create_individual_industry(params)
      assert %Ecto.Association.NotLoaded{} = individual_industry.individual_tax_returns

      [loaded] =
        Repo.preload([individual_industry], [:individual_tax_returns])

      assert loaded.name                                      == [:"Agriculture/Farming"]
      assert loaded.inserted_at                               == individual_industry.inserted_at
      assert loaded.updated_at                                == individual_industry.updated_at
      assert loaded.individual_tax_return_id                  == individual_tax_return.id
      assert match_value_relate.match_for_individual_industry == 10
    end

    test "create_individual_industry/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_industry(params)
    end

    test "update_individual_industry/2 with valid data updates the individual_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_industry, individual_tax_returns: individual_tax_return, name: ["Agriculture/Farming"])

      params = %{name: ["Wholesale Distribution"]}

      assert {:ok, %IndividualIndustry{} = updated} =
        Services.update_individual_industry(struct, params)

      assert updated.name                                     == [:"Wholesale Distribution"]
      assert updated.inserted_at                              == struct.inserted_at
      assert updated.updated_at                               == struct.updated_at
      assert updated.individual_tax_return_id                 == individual_tax_return.id
      assert match_value_relate.match_for_individual_industry == 10
    end

    test "update_individual_industry/2 with invalid data returns error changeset" do
      struct = insert(:tp_individual_industry)
      params = %{name: nil, individual_tax_return_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_industry(struct, params)
    end

    test "delete_individual_industry/1 deletes the individual_industry" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_industry, individual_tax_returns: individual_tax_return)
      assert {:ok, %IndividualIndustry{}} =
        Services.delete_individual_industry(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_industry!(struct.id)
      end
    end

    test "change_individual_industry/1 returns a individual_industry.changeset" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      struct = insert(:tp_individual_industry, individual_tax_returns: individual_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_individual_industry(struct)
    end
  end

  describe "individual_industry by role's Pro" do
    test "requires name and individual_tax_return_id via role's Pro" do
      changeset = IndividualIndustry.changeset(%IndividualIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:individual_tax_return_id, :required)
    end

    test "ensures individual_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, individual_tax_return_id: nil}
      {result, changeset} =
        %IndividualIndustry{}
        |> IndividualIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:individual_tax_return_id, "can't be blank")
    end

    test "list_individual_industry/0 returns all individual_industries" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_industry, individual_tax_returns: individual_tax_return)
      [data] = Services.list_individual_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_industry!/1 returns the individual_industries with given id" do
      struct = insert(:pro_individual_industry)
      data = Services.get_individual_industry!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_industry/1 with valid data creates a individual_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

      params = %{
        name: ["Agriculture/Farming", "Automotive Sales/Repair"],
        individual_tax_return_id: individual_tax_return.id
      }

      assert {:ok, %IndividualIndustry{} = individual_industry} =
        Services.create_individual_industry(params)
      assert %Ecto.Association.NotLoaded{} = individual_industry.individual_tax_returns

      [loaded] =
        Repo.preload([individual_industry], [:individual_tax_returns])

      assert loaded.name                                      == [:"Agriculture/Farming", :"Automotive Sales/Repair"]
      assert loaded.inserted_at                               == individual_industry.inserted_at
      assert loaded.updated_at                                == individual_industry.updated_at
      assert loaded.individual_tax_return_id                  == individual_tax_return.id
      assert match_value_relate.match_for_individual_industry == 10
    end

    test "create_individual_industry/1 with invalid data returns error changeset" do
      params = %{individual_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_individual_industry(params)
    end

    test "update_individual_industry/2 with valid data updates the individual_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_industry, individual_tax_returns: individual_tax_return, name: ["Agriculture/Farming"])

      params = %{name: ["Wholesale Distribution"]}

      assert {:ok, %IndividualIndustry{} = updated} =
        Services.update_individual_industry(struct, params)

      assert updated.name                                     == [:"Wholesale Distribution"]
      assert updated.inserted_at                              == struct.inserted_at
      assert updated.updated_at                               == struct.updated_at
      assert updated.individual_tax_return_id                 == individual_tax_return.id
      assert match_value_relate.match_for_individual_industry == 10
    end

    test "update_individual_industry/2 with invalid data returns error changeset" do
      struct = insert(:pro_individual_industry)
      params = %{name: nil, individual_tax_return_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_individual_industry(struct, params)
    end

    test "delete_individual_industry/1 deletes the individual_industry" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_industry, individual_tax_returns: individual_tax_return)
      assert {:ok, %IndividualIndustry{}} =
        Services.delete_individual_industry(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_industry!(struct.id)
      end
    end

    test "change_individual_industry/1 returns a individual_industry.changeset" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      struct = insert(:pro_individual_industry, individual_tax_returns: individual_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_individual_industry(struct)
    end
  end
end
