defmodule Core.Services.BusinessIndustryTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessIndustry
  }

  describe "business_industries by role's Tp" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessIndustry.changeset(%BusinessIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessIndustry{}
        |> BusinessIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_industry/0 returns all business_industries" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_industry, business_tax_returns: business_tax_return)
      [data] = Services.list_business_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_industry!/1 returns the business_industries with given id" do
      struct = insert(:tp_business_industry)
      data = Services.get_business_industry!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_industry/1 with valid data creates a business_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: ["Agriculture/Farming"],
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessIndustry{} = business_industry} =
        Services.create_business_industry(params)
      assert %Ecto.Association.NotLoaded{} = business_industry.business_tax_returns

      [loaded] =
        Repo.preload([business_industry], [:business_tax_returns])

      assert loaded.name                                                     == [:"Agriculture/Farming"]
      assert loaded.inserted_at                                              == business_industry.inserted_at
      assert loaded.updated_at                                               == business_industry.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_industry                  == 10
    end

    test "create_business_industry/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_industry(params)
    end

    test "update_business_industry/2 with valid data updates the business_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_industry, business_tax_returns: business_tax_return, name: ["Agriculture/Farming"])

      params = %{name: ["Wholesale Distribution"]}

      assert {:ok, %BusinessIndustry{} = updated} =
        Services.update_business_industry(struct, params)

      assert updated.name                                                     == [:"Wholesale Distribution"]
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_industry                   == 10
    end

    test "update_business_industry/2 with invalid data returns error changeset" do
      struct = insert(:tp_business_industry)
      params = %{name: nil, business_tax_return_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_industry(struct, params)
    end

    test "delete_business_industry/1 deletes the business_industry" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_industry, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessIndustry{}} =
        Services.delete_business_industry(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_industry!(struct.id)
      end
    end

    test "change_business_llc_type/1 returns a business_industry.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_industry, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_industry(struct)
    end
  end

  describe "business_industry by role's Pro" do
    test "requires name and business_tax_return_id via role's Pro" do
      changeset = BusinessIndustry.changeset(%BusinessIndustry{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessIndustry{}
        |> BusinessIndustry.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_industry/0 returns all business_industries" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_industry, business_tax_returns: business_tax_return)
      [data] = Services.list_business_industry()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_industry!/1 returns the business_industries with given id" do
      struct = insert(:pro_business_industry)
      data = Services.get_business_industry!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_industry/1 with valid data creates a business_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: ["Agriculture/Farming", "Automotive Sales/Repair"],
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessIndustry{} = business_industry} =
        Services.create_business_industry(params)
      assert %Ecto.Association.NotLoaded{} = business_industry.business_tax_returns

      [loaded] =
        Repo.preload([business_industry], [:business_tax_returns])

      assert loaded.name                                                     == [:"Agriculture/Farming", :"Automotive Sales/Repair"]
      assert loaded.inserted_at                                              == business_industry.inserted_at
      assert loaded.updated_at                                               == business_industry.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_industry                  == 10
    end

    test "create_business_industry/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_industry(params)
    end

    test "update_business_industry/2 with valid data updates the business_industry" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_industry, business_tax_returns: business_tax_return, name: ["Agriculture/Farming"])

      params = %{name: ["Transportation"]}

      assert {:ok, %BusinessIndustry{} = updated} =
        Services.update_business_industry(struct, params)

      assert updated.name                                                     == [:"Transportation"]
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
      assert match_value_relate.match_for_business_industry                   == 10
    end

    test "update_business_industry/2 with invalid data returns error changeset" do
      struct = insert(:pro_business_industry)
      params = %{name: nil, business_tax_return_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_industry(struct, params)
    end

    test "delete_business_industry/1 deletes the business_industry" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_industry, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessIndustry{}} =
        Services.delete_business_industry(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_industry!(struct.id)
      end
    end

    test "change_business_industry/1 returns a business_industry.changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      struct = insert(:pro_business_industry, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_industry(struct)
    end
  end
end
