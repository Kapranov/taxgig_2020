defmodule Community.TaxesTest do
  use Community.DataCase

  import Community.Factory

  alias Community.Taxes
  alias Decimal, as: D

  describe "individual_tax_returns via role's Tp" do
    alias Community.Taxes.IndividualTaxReturn

    test "requires user_id via role's Tp" do
      changeset = IndividualTaxReturn.changeset(%IndividualTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %IndividualTaxReturn{}
        |> IndividualTaxReturn.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_individual_tax_returns/0 returns all individual_tax_returns" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      assert Taxes.list_individual_tax_returns() ==
        Repo.preload([individual_tax_return], [:user]) |> sort_by_id()
    end

    test "get_individual_tax_return!/1 returns the individual_tax_return with given id" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      assert Taxes.get_individual_tax_return!(individual_tax_return.id) ==
        Repo.preload(individual_tax_return, [:user])
    end

    test "create_individual_tax_return/1 with valid data creates a individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)

      params = %{
        foreign_account:                  true,
        foreign_account_limit:            true,
        foreign_financial_interest:       true,
        home_owner:                       true,
        k1_count:                           22,
        k1_income:                        true,
        living_abroad:                    true,
        non_resident_earning:             true,
        none_expat:                      false,
        own_stock_crypto:                 true,
        rental_property_count:              22,
        rental_property_income:           true,
        sole_proprietorship_count:          22,
        state: ["Alabama", "Ohio", "New York"],
        stock_divident:                   true,
        tax_year:     ["2018", "2017", "2016"],
        user_id: user.id
      }

      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Taxes.create_individual_tax_return(params)

      assert %Ecto.Association.NotLoaded{} = individual_tax_return.user

      [loaded] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert loaded.id                              == individual_tax_return.id
      assert loaded.foreign_account                 == true
      assert loaded.foreign_account_limit           == true
      assert loaded.foreign_financial_interest      == true
      assert loaded.home_owner                      == true
      assert loaded.k1_count                        == 22
      assert loaded.k1_income                       == true
      assert loaded.living_abroad                   == true
      assert loaded.non_resident_earning            == true
      assert loaded.none_expat                      == false
      assert loaded.own_stock_crypto                == true
      assert loaded.price_foreign_account           == nil
      assert loaded.price_home_owner                == nil
      assert loaded.price_living_abroad             == nil
      assert loaded.price_non_resident_earning      == nil
      assert loaded.price_own_stock_crypto          == nil
      assert loaded.price_rental_property_income    == nil
      assert loaded.price_sole_proprietorship_count == nil
      assert loaded.price_state                     == nil
      assert loaded.price_stock_divident            == nil
      assert loaded.price_tax_year                  == nil
      assert loaded.rental_property_count           == 22
      assert loaded.rental_property_income          == true
      assert loaded.sole_proprietorship_count       == 22
      assert loaded.state                           == ["Alabama", "Ohio", "New York"]
      assert loaded.stock_divident                  == true
      assert loaded.tax_year                        == ["2018", "2017", "2016"]
      assert loaded.user_id                         == user.id
      assert loaded.inserted_at                     == individual_tax_return.inserted_at
      assert loaded.updated_at                      == individual_tax_return.updated_at

      assert loaded.user.admin       == user.admin
      assert loaded.user.api_token   == user.api_token
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.banner      == user.banner
      assert loaded.user.bio         == user.bio
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.from_github == user.from_github
      assert loaded.user.geo_city    == user.geo_city
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.locale      == user.locale
      assert loaded.user.logo        == user.logo
      assert loaded.user.name        == user.name
      assert loaded.user.provider    == user.provider
      assert loaded.user.remote_ip   == user.remote_ip
      assert loaded.user.role        == user.role
      assert loaded.user.sex         == user.sex
      assert loaded.user.username    == user.username

      assert match_value_relate.match_for_individual_foreign_account            == 20
      assert match_value_relate.match_for_individual_home_owner                 == 20
      assert match_value_relate.match_for_individual_living_abroad              == 20
      assert match_value_relate.match_for_individual_non_resident_earning       == 20
      assert match_value_relate.match_for_individual_own_stock_crypto           == 20
      assert match_value_relate.match_for_individual_rental_prop_income         == 20
      assert match_value_relate.match_for_individual_stock_divident             == 20
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("199.0")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("299.0")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("120.0")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("17.99")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("30.0")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("180.0")
      assert match_value_relate.value_for_individual_state                      == D.new("40.0")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("40.0")
    end

    test "create_individual_tax_return/1 with not correct some fields data updates the individual_tax_return" do
      user = insert(:tp_user)

      params = %{
        foreign_account:                  true,
        foreign_account_limit:            true,
        foreign_financial_interest:       true,
        home_owner:                       true,
        k1_count:                           22,
        k1_income:                        true,
        living_abroad:                    true,
        non_resident_earning:             true,
        none_expat:                      false,
        own_stock_crypto:                 true,
        price_foreign_account:              33,
        price_home_owner:                   33,
        price_living_abroad:                33,
        price_non_resident_earning:         33,
        price_own_stock_crypto:             33,
        price_rental_property_income:       33,
        price_sole_proprietorship_count:    33,
        price_state:                        33,
        price_stock_divident:               33,
        price_tax_year:                     33,
        rental_property_count:              22,
        rental_property_income:           true,
        sole_proprietorship_count:          22,
        state: ["Alabama", "Ohio", "New York"],
        stock_divident:                   true,
        tax_year:     ["2018", "2017", "2016"],
        user_id:                        user.id
      }

      assert {:error, %Ecto.Changeset{}} = Taxes.create_individual_tax_return(params)
    end

    test "create_individual_tax_return/1 with invalid data returns error changeset" do
      params = %{
        foreign_account:            nil,
        foreign_account_limit:      nil,
        foreign_financial_interest: nil,
        home_owner:                 nil,
        k1_count:                   nil,
        k1_income:                  nil,
        living_abroad:              nil,
        non_resident_earning:       nil,
        none_expat:                 nil,
        own_stock_crypto:           nil,
        rental_property_count:      nil,
        rental_property_income:     nil,
        sole_proprietorship_count:  nil,
        state:                      nil,
        stock_divident:             nil,
        tax_year:                   nil,
        user_id:                    nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Taxes.create_individual_tax_return(params)
    end

    test "update_individual_tax_return/2 with valid data updates the individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user_a)

      params = %{
        foreign_account:                 false,
        foreign_account_limit:           false,
        foreign_financial_interest:      false,
        home_owner:                      false,
        k1_count:                           33,
        k1_income:                       false,
        living_abroad:                   false,
        non_resident_earning:            false,
        none_expat:                       true,
        own_stock_crypto:                false,
        rental_property_count:              33,
        rental_property_income:          false,
        sole_proprietorship_count:          33,
        state:             ["Arizona", "Iowa"],
        stock_divident:                  false,
        tax_year:             ["2018", "2019"],
        user_id:                      user_b.id
      }


      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Taxes.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.foreign_account                 == false
      assert updated.foreign_account_limit           == false
      assert updated.foreign_financial_interest      == false
      assert updated.home_owner                      == false
      assert updated.k1_count                        == 33
      assert updated.k1_income                       == false
      assert updated.living_abroad                   == false
      assert updated.non_resident_earning            == false
      assert updated.none_expat                      == true
      assert updated.own_stock_crypto                == false
      assert updated.price_foreign_account           == nil
      assert updated.price_home_owner                == nil
      assert updated.price_living_abroad             == nil
      assert updated.price_non_resident_earning      == nil
      assert updated.price_own_stock_crypto          == nil
      assert updated.price_rental_property_income    == nil
      assert updated.price_sole_proprietorship_count == nil
      assert updated.price_state                     == nil
      assert updated.price_stock_divident            == nil
      assert updated.price_tax_year                  == nil
      assert updated.rental_property_count           == 33
      assert updated.rental_property_income          == false
      assert updated.sole_proprietorship_count       == 33
      assert updated.state                           == ["Arizona", "Iowa"]
      assert updated.stock_divident                  == false
      assert updated.tax_year                        == ["2018", "2019"]
      assert updated.user_id                         == user_a.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.match_for_individual_foreign_account            == 20
      assert match_value_relate.match_for_individual_home_owner                 == 20
      assert match_value_relate.match_for_individual_living_abroad              == 20
      assert match_value_relate.match_for_individual_non_resident_earning       == 20
      assert match_value_relate.match_for_individual_own_stock_crypto           == 20
      assert match_value_relate.match_for_individual_rental_prop_income         == 20
      assert match_value_relate.match_for_individual_stock_divident             == 20
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("199.0")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("299.0")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("120.0")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("17.99")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("30.0")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("180.0")
      assert match_value_relate.value_for_individual_state                      == D.new("40.0")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("40.0")
    end

    test "update_individual_tax_return/2 with not correct some fields data updates the individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user_a)

      params = %{
        foreign_account:                 false,
        foreign_account_limit:           false,
        foreign_financial_interest:      false,
        home_owner:                      false,
        k1_count:                           33,
        k1_income:                       false,
        living_abroad:                   false,
        non_resident_earning:            false,
        none_expat:                       true,
        own_stock_crypto:                false,
        price_foreign_account:              33,
        price_home_owner:                   33,
        price_living_abroad:                33,
        price_non_resident_earning:         33,
        price_own_stock_crypto:             33,
        price_rental_property_income:       33,
        price_sole_proprietorship_count:    33,
        price_state:                        33,
        price_stock_divident:               33,
        price_tax_year:                     33,
        rental_property_count:              33,
        rental_property_income:          false,
        sole_proprietorship_count:          33,
        state:             ["Arizona", "Iowa"],
        stock_divident:                  false,
        tax_year:             ["2018", "2019"],
        user_id:                      user_b.id
      }


      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Taxes.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.foreign_account                 == false
      assert updated.foreign_account_limit           == false
      assert updated.foreign_financial_interest      == false
      assert updated.home_owner                      == false
      assert updated.k1_count                        == 33
      assert updated.k1_income                       == false
      assert updated.living_abroad                   == false
      assert updated.non_resident_earning            == false
      assert updated.none_expat                      == true
      assert updated.own_stock_crypto                == false
      assert updated.price_foreign_account           == nil
      assert updated.price_home_owner                == nil
      assert updated.price_living_abroad             == nil
      assert updated.price_non_resident_earning      == nil
      assert updated.price_own_stock_crypto          == nil
      assert updated.price_rental_property_income    == nil
      assert updated.price_sole_proprietorship_count == nil
      assert updated.price_state                     == nil
      assert updated.price_stock_divident            == nil
      assert updated.price_tax_year                  == nil
      assert updated.rental_property_count           == 33
      assert updated.rental_property_income          == false
      assert updated.sole_proprietorship_count       == 33
      assert updated.state                           == ["Arizona", "Iowa"]
      assert updated.stock_divident                  == false
      assert updated.tax_year                        == ["2018", "2019"]
      assert updated.user_id                         == user_a.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.match_for_individual_foreign_account            == 20
      assert match_value_relate.match_for_individual_home_owner                 == 20
      assert match_value_relate.match_for_individual_living_abroad              == 20
      assert match_value_relate.match_for_individual_non_resident_earning       == 20
      assert match_value_relate.match_for_individual_own_stock_crypto           == 20
      assert match_value_relate.match_for_individual_rental_prop_income         == 20
      assert match_value_relate.match_for_individual_stock_divident             == 20
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("199.0")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("299.0")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("120.0")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("17.99")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("30.0")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("180.0")
      assert match_value_relate.value_for_individual_state                      == D.new("40.0")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("40.0")
    end

    test "update_individual_tax_return/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{user_id: nil}

      assert {:error, %Ecto.Changeset{}} !=
        Taxes.update_individual_tax_return(individual_tax_return, params)
      assert individual_tax_return == Taxes.get_individual_tax_return!(individual_tax_return.id)
    end

    test "delete_individual_tax_return/1 deletes the individual_tax_return" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      assert {:ok, %IndividualTaxReturn{}} =
        Taxes.delete_individual_tax_return(individual_tax_return)
      assert_raise Ecto.NoResultsError, fn ->
        Taxes.get_individual_tax_return!(individual_tax_return.id)
      end
    end

    test "change_individual_tax_return/1 returns a individual_tax_return changeset" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Taxes.change_individual_tax_return(individual_tax_return)
    end
  end

  describe "individual_tax_returns via role's Pro" do
    alias Community.Taxes.IndividualTaxReturn

    test "requires user_id via role's Pro" do
      changeset = IndividualTaxReturn.changeset(%IndividualTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %IndividualTaxReturn{}
        |> IndividualTaxReturn.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_individual_tax_returns/0 returns all individual_tax_returns" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      assert Taxes.list_individual_tax_returns() ==
        Repo.preload([individual_tax_return], [:user]) |> sort_by_id()
    end

    test "get_individual_tax_return!/1 returns the individual_tax_return with given id" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      assert Taxes.get_individual_tax_return!(individual_tax_return.id) ==
        Repo.preload(individual_tax_return, [:user])
    end

    test "create_individual_tax_return/1 with valid data creates a individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)

      params = %{
        foreign_account:                  true,
        home_owner:                       true,
        living_abroad:                    true,
        non_resident_earning:             true,
        none_expat:                      false,
        own_stock_crypto:                 true,
        price_foreign_account:              22,
        price_home_owner:                   22,
        price_living_abroad:                22,
        price_non_resident_earning:         22,
        price_own_stock_crypto:             22,
        price_rental_property_income:       22,
        price_sole_proprietorship_count:    22,
        price_state:                        22,
        price_stock_divident:               22,
        price_tax_year:                     22,
        rental_property_income:           true,
        stock_divident:                   true,
        user_id:                        user.id
      }

      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Taxes.create_individual_tax_return(params)

      assert %Ecto.Association.NotLoaded{} = individual_tax_return.user

      [loaded] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert loaded.id                              == individual_tax_return.id
      assert loaded.foreign_account                 == true
      assert loaded.foreign_account_limit           == nil
      assert loaded.foreign_financial_interest      == nil
      assert loaded.home_owner                      == true
      assert loaded.k1_count                        == nil
      assert loaded.k1_income                       == nil
      assert loaded.living_abroad                   == true
      assert loaded.non_resident_earning            == true
      assert loaded.none_expat                      == false
      assert loaded.own_stock_crypto                == true
      assert loaded.price_foreign_account           == 22
      assert loaded.price_home_owner                == 22
      assert loaded.price_living_abroad             == 22
      assert loaded.price_non_resident_earning      == 22
      assert loaded.price_own_stock_crypto          == 22
      assert loaded.price_rental_property_income    == 22
      assert loaded.price_sole_proprietorship_count == 22
      assert loaded.price_state                     == 22
      assert loaded.price_stock_divident            == 22
      assert loaded.price_tax_year                  == 22
      assert loaded.rental_property_count           == nil
      assert loaded.rental_property_income          == true
      assert loaded.sole_proprietorship_count       == nil
      assert loaded.state                           == nil
      assert loaded.stock_divident                  == true
      assert loaded.tax_year                        == nil
      assert loaded.user_id                         == user.id
      assert loaded.inserted_at                     == individual_tax_return.inserted_at
      assert loaded.updated_at                      == individual_tax_return.updated_at

      assert loaded.user.admin       == user.admin
      assert loaded.user.api_token   == user.api_token
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.banner      == user.banner
      assert loaded.user.bio         == user.bio
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.from_github == user.from_github
      assert loaded.user.geo_city    == user.geo_city
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.locale      == user.locale
      assert loaded.user.logo        == user.logo
      assert loaded.user.name        == user.name
      assert loaded.user.provider    == user.provider
      assert loaded.user.remote_ip   == user.remote_ip
      assert loaded.user.role        == user.role
      assert loaded.user.sex         == user.sex
      assert loaded.user.username    == user.username

      assert match_value_relate.match_for_individual_foreign_account            == 20
      assert match_value_relate.match_for_individual_home_owner                 == 20
      assert match_value_relate.match_for_individual_living_abroad              == 20
      assert match_value_relate.match_for_individual_non_resident_earning       == 20
      assert match_value_relate.match_for_individual_own_stock_crypto           == 20
      assert match_value_relate.match_for_individual_rental_prop_income         == 20
      assert match_value_relate.match_for_individual_stock_divident             == 20
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("199.0")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("299.0")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("120.0")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("17.99")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("30.0")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("180.0")
      assert match_value_relate.value_for_individual_state                      == D.new("40.0")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("40.0")
    end

    test "create_individual_tax_return/1 with not correct some fields data updates the individual_tax_return" do
      user = insert(:tp_user)

      params = %{
        foreign_account:                  true,
        foreign_account_limit:            true,
        foreign_financial_interest:       true,
        home_owner:                       true,
        k1_count:                           22,
        k1_income:                        true,
        living_abroad:                    true,
        non_resident_earning:             true,
        none_expat:                      false,
        own_stock_crypto:                 true,
        price_foreign_account:              33,
        price_home_owner:                   33,
        price_living_abroad:                33,
        price_non_resident_earning:         33,
        price_own_stock_crypto:             33,
        price_rental_property_income:       33,
        price_sole_proprietorship_count:    33,
        price_state:                        33,
        price_stock_divident:               33,
        price_tax_year:                     33,
        rental_property_count:              22,
        rental_property_income:           true,
        sole_proprietorship_count:          22,
        state: ["Alabama", "Ohio", "New York"],
        stock_divident:                   true,
        tax_year:     ["2018", "2017", "2016"],
        user_id:                        user.id
      }

      assert {:error, %Ecto.Changeset{}} = Taxes.create_individual_tax_return(params)
    end

    test "create_individual_tax_return/1 with invalid data returns error changeset" do
      params = %{
        foreign_account:                  nil,
        home_owner:                       nil,
        living_abroad:                    nil,
        non_resident_earning:             nil,
        none_expat:                       nil,
        own_stock_crypto:                 nil,
        price_foreign_account:            nil,
        price_home_owner:                 nil,
        price_living_abroad:              nil,
        price_non_resident_earning:       nil,
        price_own_stock_crypto:           nil,
        price_rental_property_income:     nil,
        price_sole_proprietorship_count:  nil,
        price_state:                      nil,
        price_stock_divident:             nil,
        price_tax_year:                   nil,
        rental_property_income:           nil,
        stock_divident:                   nil,
        user_id:                          nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Taxes.create_individual_tax_return(params)
    end

    test "update_individual_tax_return/2 with valid data updates the individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user_a)

      params = %{
        foreign_account:                 false,
        home_owner:                      false,
        living_abroad:                   false,
        non_resident_earning:            false,
        none_expat:                       true,
        own_stock_crypto:                false,
        price_foreign_account:              33,
        price_home_owner:                   33,
        price_living_abroad:                33,
        price_non_resident_earning:         33,
        price_own_stock_crypto:             33,
        price_rental_property_income:       33,
        price_sole_proprietorship_count:    33,
        price_state:                        33,
        price_stock_divident:               33,
        price_tax_year:                     33,
        rental_property_income:          false,
        stock_divident:                  false,
        user_id:                      user_b.id
      }

      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Taxes.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.foreign_account                 == false
      assert updated.foreign_account_limit           == nil
      assert updated.foreign_financial_interest      == nil
      assert updated.home_owner                      == false
      assert updated.k1_count                        == nil
      assert updated.k1_income                       == nil
      assert updated.living_abroad                   == false
      assert updated.non_resident_earning            == false
      assert updated.none_expat                      == true
      assert updated.own_stock_crypto                == false
      assert updated.price_foreign_account           == 33
      assert updated.price_home_owner                == 33
      assert updated.price_living_abroad             == 33
      assert updated.price_non_resident_earning      == 33
      assert updated.price_own_stock_crypto          == 33
      assert updated.price_rental_property_income    == 33
      assert updated.price_sole_proprietorship_count == 33
      assert updated.price_state                     == 33
      assert updated.price_stock_divident            == 33
      assert updated.price_tax_year                  == 33
      assert updated.rental_property_count           == nil
      assert updated.rental_property_income          == false
      assert updated.sole_proprietorship_count       == nil
      assert updated.state                           == nil
      assert updated.stock_divident                  == false
      assert updated.tax_year                        == nil
      assert updated.user_id                         == user_a.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.match_for_individual_foreign_account            == 20
      assert match_value_relate.match_for_individual_home_owner                 == 20
      assert match_value_relate.match_for_individual_living_abroad              == 20
      assert match_value_relate.match_for_individual_non_resident_earning       == 20
      assert match_value_relate.match_for_individual_own_stock_crypto           == 20
      assert match_value_relate.match_for_individual_rental_prop_income         == 20
      assert match_value_relate.match_for_individual_stock_divident             == 20
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("199.0")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("299.0")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("120.0")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("17.99")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("30.0")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("180.0")
      assert match_value_relate.value_for_individual_state                      == D.new("40.0")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("40.0")
    end

    test "update_individual_tax_return/2 with not correct some fields data updates the individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user_a)

      params = %{
        foreign_account:                 false,
        foreign_account_limit:           false,
        foreign_financial_interest:      false,
        home_owner:                      false,
        k1_count:                           33,
        k1_income:                       false,
        living_abroad:                   false,
        non_resident_earning:            false,
        none_expat:                       true,
        own_stock_crypto:                false,
        price_foreign_account:              33,
        price_home_owner:                   33,
        price_living_abroad:                33,
        price_non_resident_earning:         33,
        price_own_stock_crypto:             33,
        price_rental_property_income:       33,
        price_sole_proprietorship_count:    33,
        price_state:                        33,
        price_stock_divident:               33,
        price_tax_year:                     33,
        rental_property_count:              33,
        rental_property_income:          false,
        sole_proprietorship_count:          33,
        state:             ["Arizona", "Iowa"],
        stock_divident:                  false,
        tax_year:             ["2018", "2019"],
        user_id:                      user_b.id
      }

      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Taxes.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.foreign_account                 == false
      assert updated.foreign_account_limit           == nil
      assert updated.foreign_financial_interest      == nil
      assert updated.home_owner                      == false
      assert updated.k1_count                        == nil
      assert updated.k1_income                       == nil
      assert updated.living_abroad                   == false
      assert updated.non_resident_earning            == false
      assert updated.none_expat                      == true
      assert updated.own_stock_crypto                == false
      assert updated.price_foreign_account           == 33
      assert updated.price_home_owner                == 33
      assert updated.price_living_abroad             == 33
      assert updated.price_non_resident_earning      == 33
      assert updated.price_own_stock_crypto          == 33
      assert updated.price_rental_property_income    == 33
      assert updated.price_sole_proprietorship_count == 33
      assert updated.price_state                     == 33
      assert updated.price_stock_divident            == 33
      assert updated.price_tax_year                  == 33
      assert updated.rental_property_count           == nil
      assert updated.rental_property_income          == false
      assert updated.sole_proprietorship_count       == nil
      assert updated.state                           == nil
      assert updated.stock_divident                  == false
      assert updated.tax_year                        == nil
      assert updated.user_id                         == user_a.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.match_for_individual_foreign_account            == 20
      assert match_value_relate.match_for_individual_home_owner                 == 20
      assert match_value_relate.match_for_individual_living_abroad              == 20
      assert match_value_relate.match_for_individual_non_resident_earning       == 20
      assert match_value_relate.match_for_individual_own_stock_crypto           == 20
      assert match_value_relate.match_for_individual_rental_prop_income         == 20
      assert match_value_relate.match_for_individual_stock_divident             == 20
      assert match_value_relate.value_for_individual_foreign_account_limit      == D.new("199.0")
      assert match_value_relate.value_for_individual_foreign_financial_interest == D.new("299.0")
      assert match_value_relate.value_for_individual_home_owner                 == D.new("120.0")
      assert match_value_relate.value_for_individual_k1_count                   == D.new("17.99")
      assert match_value_relate.value_for_individual_rental_prop_income         == D.new("30.0")
      assert match_value_relate.value_for_individual_sole_prop_count            == D.new("180.0")
      assert match_value_relate.value_for_individual_state                      == D.new("40.0")
      assert match_value_relate.value_for_individual_tax_year                   == D.new("40.0")
    end

    test "update_individual_tax_return/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

      params = %{user_id: nil}

      assert {:error, %Ecto.Changeset{}} !=
        Taxes.update_individual_tax_return(individual_tax_return, params)
      assert individual_tax_return == Taxes.get_individual_tax_return!(individual_tax_return.id)
    end

    test "delete_individual_tax_return/1 deletes the individual_tax_return" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      assert {:ok, %IndividualTaxReturn{}} =
        Taxes.delete_individual_tax_return(individual_tax_return)
      assert_raise Ecto.NoResultsError, fn ->
        Taxes.get_individual_tax_return!(individual_tax_return.id)
      end
    end

    test "change_individual_tax_return/1 returns a individual_tax_return changeset" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Taxes.change_individual_tax_return(individual_tax_return)
    end
  end

  describe "business_tax_returns via role's Tp" do
    alias Community.Taxes.BusinessTaxReturn

    test "requires user_id via role's Tp" do
      changeset = BusinessTaxReturn.changeset(%BusinessTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %BusinessTaxReturn{}
        |> BusinessTaxReturn.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_business_tax_returns/0 returns all business_tax_returns" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      assert Taxes.list_business_tax_returns() ==
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()
    end

    test "get_business_tax_return!/1 returns the business_tax_return with given id" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      assert Taxes.get_business_tax_return!(business_tax_return.id) ==
        Repo.preload(business_tax_return, [:user])
    end

    test "create_business_tax_return/1 with valid data creates a business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)

      params = %{
        accounting_software:                       true,
        capital_asset_sale:                        true,
        church_hospital:                           true,
        dispose_asset:                             true,
        dispose_property:                          true,
        educational_facility:                      true,
        financial_situation: "some financial situation",
        foreign_account_interest:                  true,
        foreign_account_value_more:                true,
        foreign_entity_interest:                   true,
        foreign_partner_count:                       22,
        foreign_shareholder:                       true,
        foreign_value:                             true,
        fundraising_over:                          true,
        has_contribution:                          true,
        has_loan:                                  true,
        income_over_thousand:                      true,
        invest_research:                           true,
        k1_count:                                    22,
        lobbying:                                  true,
        make_distribution:                         true,
        none_expat:                               false,
        operate_facility:                          true,
        property_sale:                             true,
        public_charity:                            true,
        rental_property_count:                       22,
        reported_grant:                            true,
        restricted_donation:                       true,
        state:          ["Alabama", "Ohio", "New York"],
        tax_exemption:                             true,
        tax_year:              ["2018", "2017", "2016"],
        total_asset_less:                          true,
        total_asset_over:                          true,
        user_id:                                 user.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Taxes.create_business_tax_return(params)

      assert %Ecto.Association.NotLoaded{} = business_tax_return.user

      [loaded] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert loaded.id                         == business_tax_return.id
      assert loaded.accounting_software        == true
      assert loaded.capital_asset_sale         == true
      assert loaded.church_hospital            == true
      assert loaded.dispose_asset              == true
      assert loaded.dispose_property           == true
      assert loaded.educational_facility       == true
      assert loaded.financial_situation        == "some financial situation"
      assert loaded.foreign_account_interest   == true
      assert loaded.foreign_account_value_more == true
      assert loaded.foreign_entity_interest    == true
      assert loaded.foreign_partner_count      == 22
      assert loaded.foreign_shareholder        == true
      assert loaded.foreign_value              == true
      assert loaded.fundraising_over           == true
      assert loaded.has_contribution           == true
      assert loaded.has_loan                   == true
      assert loaded.income_over_thousand       == true
      assert loaded.invest_research            == true
      assert loaded.k1_count                   == 22
      assert loaded.lobbying                   == true
      assert loaded.make_distribution          == true
      assert loaded.none_expat                 == false
      assert loaded.operate_facility           == true
      assert loaded.price_state                == nil
      assert loaded.price_tax_year             == nil
      assert loaded.property_sale              == true
      assert loaded.public_charity             == true
      assert loaded.rental_property_count      == 22
      assert loaded.reported_grant             == true
      assert loaded.restricted_donation        == true
      assert loaded.state                      == ["Alabama", "Ohio", "New York"]
      assert loaded.tax_exemption              == true
      assert loaded.tax_year                   == ["2018", "2017", "2016"]
      assert loaded.total_asset_less           == true
      assert loaded.total_asset_over           == true
      assert loaded.inserted_at                == business_tax_return.inserted_at
      assert loaded.updated_at                 == business_tax_return.updated_at
      assert loaded.user_id                    == user.id

      assert loaded.user.admin       == user.admin
      assert loaded.user.api_token   == user.api_token
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.banner      == user.banner
      assert loaded.user.bio         == user.bio
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.from_github == user.from_github
      assert loaded.user.geo_city    == user.geo_city
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.locale      == user.locale
      assert loaded.user.logo        == user.logo
      assert loaded.user.name        == user.name
      assert loaded.user.provider    == user.provider
      assert loaded.user.remote_ip   == user.remote_ip
      assert loaded.user.role        == user.role
      assert loaded.user.sex         == user.sex
      assert loaded.user.username    == user.username

      assert match_value_relate.value_for_business_accounting_software  == D.new("29.99")
      assert match_value_relate.value_for_business_dispose_property     == D.new("99.99")
      assert match_value_relate.value_for_business_foreign_shareholder  == D.new("150.0")
      assert match_value_relate.value_for_business_income_over_thousand == D.new("99.99")
      assert match_value_relate.value_for_business_invest_research      == D.new("20.0")
      assert match_value_relate.value_for_business_k1_count             == D.new("6.0")
      assert match_value_relate.value_for_business_make_distribution    == D.new("20.0")
      assert match_value_relate.value_for_business_state                == D.new("50.0")
      assert match_value_relate.value_for_business_tax_exemption        == D.new("400.0")
      assert match_value_relate.value_for_business_total_asset_over     == D.new("150.0")
    end

    test "create_business_tax_return/1 with not correct some fields data updates the business_tax_return" do
      user = insert(:tp_user)

      params = %{
        accounting_software:                       true,
        capital_asset_sale:                        true,
        church_hospital:                           true,
        dispose_asset:                             true,
        dispose_property:                          true,
        educational_facility:                      true,
        financial_situation: "some financial situation",
        foreign_account_interest:                  true,
        foreign_account_value_more:                true,
        foreign_entity_interest:                   true,
        foreign_partner_count:                       22,
        foreign_shareholder:                       true,
        foreign_value:                             true,
        fundraising_over:                          true,
        has_contribution:                          true,
        has_loan:                                  true,
        income_over_thousand:                      true,
        invest_research:                           true,
        k1_count:                                    22,
        lobbying:                                  true,
        make_distribution:                         true,
        none_expat:                               false,
        operate_facility:                          true,
        price_state:                                 33,
        price_tax_year:                              33,
        property_sale:                             true,
        public_charity:                            true,
        rental_property_count:                       22,
        reported_grant:                            true,
        restricted_donation:                       true,
        state:          ["Alabama", "Ohio", "New York"],
        tax_exemption:                             true,
        tax_year:              ["2018", "2017", "2016"],
        total_asset_less:                          true,
        total_asset_over:                          true,
        user_id:                                 user.id
      }

      assert {:error, %Ecto.Changeset{}} = Taxes.create_business_tax_return(params)
    end

    test "create_business_tax_return/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Taxes.create_business_tax_return(params)
    end

    test "update_business_tax_return/2 with valid data updates the business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user_a)

      params = %{
        accounting_software:                         false,
        capital_asset_sale:                          false,
        church_hospital:                             false,
        dispose_asset:                               false,
        dispose_property:                            false,
        educational_facility:                        false,
        financial_situation: "updated financial situation",
        foreign_account_interest:                    false,
        foreign_account_value_more:                  false,
        foreign_entity_interest:                     false,
        foreign_partner_count:                          33,
        foreign_shareholder:                         false,
        foreign_value:                               false,
        fundraising_over:                            false,
        has_contribution:                            false,
        has_loan:                                    false,
        income_over_thousand:                        false,
        invest_research:                             false,
        k1_count:                                       33,
        lobbying:                                    false,
        make_distribution:                           false,
        none_expat:                                   true,
        operate_facility:                            false,
        property_sale:                               false,
        public_charity:                              false,
        rental_property_count:                          33,
        reported_grant:                              false,
        restricted_donation:                         false,
        state:                         ["Arizona", "Iowa"],
        tax_exemption:                               false,
        tax_year:                         ["2018", "2019"],
        total_asset_less:                            false,
        total_asset_over:                            false,
        user_id:                                  user_b.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Taxes.update_business_tax_return(business_tax_return, params)

      [updated] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                         == business_tax_return.id
      assert updated.accounting_software        == false
      assert updated.capital_asset_sale         == false
      assert updated.church_hospital            == false
      assert updated.dispose_asset              == false
      assert updated.dispose_property           == false
      assert updated.educational_facility       == false
      assert updated.financial_situation        == "updated financial situation"
      assert updated.foreign_account_interest   == false
      assert updated.foreign_account_value_more == false
      assert updated.foreign_entity_interest    == false
      assert updated.foreign_partner_count      == 33
      assert updated.foreign_shareholder        == false
      assert updated.foreign_value              == false
      assert updated.fundraising_over           == false
      assert updated.has_contribution           == false
      assert updated.has_loan                   == false
      assert updated.income_over_thousand       == false
      assert updated.invest_research            == false
      assert updated.k1_count                   == 33
      assert updated.lobbying                   == false
      assert updated.make_distribution          == false
      assert updated.none_expat                 == true
      assert updated.operate_facility           == false
      assert updated.price_state                == nil
      assert updated.price_tax_year             == nil
      assert updated.property_sale              == false
      assert updated.public_charity             == false
      assert updated.rental_property_count      == 33
      assert updated.reported_grant             == false
      assert updated.restricted_donation        == false
      assert updated.state                      == ["Arizona", "Iowa"]
      assert updated.tax_exemption              == false
      assert updated.tax_year                   == ["2018", "2019"]
      assert updated.total_asset_less           == false
      assert updated.total_asset_over           == false
      assert updated.inserted_at                == business_tax_return.inserted_at
      assert updated.updated_at                 == business_tax_return.updated_at
      assert updated.user_id                    == user_a.id

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.value_for_business_accounting_software  == D.new("29.99")
      assert match_value_relate.value_for_business_dispose_property     == D.new("99.99")
      assert match_value_relate.value_for_business_foreign_shareholder  == D.new("150.0")
      assert match_value_relate.value_for_business_income_over_thousand == D.new("99.99")
      assert match_value_relate.value_for_business_invest_research      == D.new("20.0")
      assert match_value_relate.value_for_business_k1_count             == D.new("6.0")
      assert match_value_relate.value_for_business_make_distribution    == D.new("20.0")
      assert match_value_relate.value_for_business_state                == D.new("50.0")
      assert match_value_relate.value_for_business_tax_exemption        == D.new("400.0")
      assert match_value_relate.value_for_business_total_asset_over     == D.new("150.0")
    end

    test "update_business_tax_return/2 with not correct some fields data updates the business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:tp_user)
      user_b = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user_a)

      params = %{
        accounting_software:                         false,
        capital_asset_sale:                          false,
        church_hospital:                             false,
        dispose_asset:                               false,
        dispose_property:                            false,
        educational_facility:                        false,
        financial_situation: "updated financial situation",
        foreign_account_interest:                    false,
        foreign_account_value_more:                  false,
        foreign_entity_interest:                     false,
        foreign_partner_count:                          33,
        foreign_shareholder:                         false,
        foreign_value:                               false,
        fundraising_over:                            false,
        has_contribution:                            false,
        has_loan:                                    false,
        income_over_thousand:                        false,
        invest_research:                             false,
        k1_count:                                       33,
        lobbying:                                    false,
        make_distribution:                           false,
        none_expat:                                   true,
        operate_facility:                            false,
        price_state:                                    33,
        price_tax_year:                                 33,
        property_sale:                               false,
        public_charity:                              false,
        rental_property_count:                          33,
        reported_grant:                              false,
        restricted_donation:                         false,
        state:                         ["Arizona", "Iowa"],
        tax_exemption:                               false,
        tax_year:                         ["2018", "2019"],
        total_asset_less:                            false,
        total_asset_over:                            false,
        user_id:                                  user_b.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Taxes.update_business_tax_return(business_tax_return, params)

      [updated] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                         == business_tax_return.id
      assert updated.accounting_software        == false
      assert updated.capital_asset_sale         == false
      assert updated.church_hospital            == false
      assert updated.dispose_asset              == false
      assert updated.dispose_property           == false
      assert updated.educational_facility       == false
      assert updated.financial_situation        == "updated financial situation"
      assert updated.foreign_account_interest   == false
      assert updated.foreign_account_value_more == false
      assert updated.foreign_entity_interest    == false
      assert updated.foreign_partner_count      == 33
      assert updated.foreign_shareholder        == false
      assert updated.foreign_value              == false
      assert updated.fundraising_over           == false
      assert updated.has_contribution           == false
      assert updated.has_loan                   == false
      assert updated.income_over_thousand       == false
      assert updated.invest_research            == false
      assert updated.k1_count                   == 33
      assert updated.lobbying                   == false
      assert updated.make_distribution          == false
      assert updated.none_expat                 == true
      assert updated.operate_facility           == false
      assert updated.price_state                == nil
      assert updated.price_tax_year             == nil
      assert updated.property_sale              == false
      assert updated.public_charity             == false
      assert updated.rental_property_count      == 33
      assert updated.reported_grant             == false
      assert updated.restricted_donation        == false
      assert updated.state                      == ["Arizona", "Iowa"]
      assert updated.tax_exemption              == false
      assert updated.tax_year                   == ["2018", "2019"]
      assert updated.total_asset_less           == false
      assert updated.total_asset_over           == false
      assert updated.inserted_at                == business_tax_return.inserted_at
      assert updated.updated_at                 == business_tax_return.updated_at
      assert updated.user_id                    == user_a.id

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.value_for_business_accounting_software  == D.new("29.99")
      assert match_value_relate.value_for_business_dispose_property     == D.new("99.99")
      assert match_value_relate.value_for_business_foreign_shareholder  == D.new("150.0")
      assert match_value_relate.value_for_business_income_over_thousand == D.new("99.99")
      assert match_value_relate.value_for_business_invest_research      == D.new("20.0")
      assert match_value_relate.value_for_business_k1_count             == D.new("6.0")
      assert match_value_relate.value_for_business_make_distribution    == D.new("20.0")
      assert match_value_relate.value_for_business_state                == D.new("50.0")
      assert match_value_relate.value_for_business_tax_exemption        == D.new("400.0")
      assert match_value_relate.value_for_business_total_asset_over     == D.new("150.0")
    end

    test "update_business_tax_return/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{user_id: nil}

      [loaded] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert {:error, %Ecto.Changeset{}} !=
        Taxes.update_business_tax_return(business_tax_return, params)
      assert loaded == Taxes.get_business_tax_return!(business_tax_return.id)
    end

    test "delete_business_tax_return/1 deletes the business_tax_return" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      assert {:ok, %BusinessTaxReturn{}} =
        Taxes.delete_business_tax_return(business_tax_return)
      assert_raise Ecto.NoResultsError, fn ->
        Taxes.get_business_tax_return!(business_tax_return.id)
      end
    end

    test "change_business_tax_return/1 returns a business_tax_return changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Taxes.change_business_tax_return(business_tax_return)
    end
  end

  describe "business_tax_returns via role's Pro" do
    alias Community.Taxes.BusinessTaxReturn

    test "requires user_id via role's Pro" do
      changeset = BusinessTaxReturn.changeset(%BusinessTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = Ecto.UUID.generate
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %BusinessTaxReturn{}
        |> BusinessTaxReturn.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_business_tax_returns/0 returns all business_tax_returns" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      assert Taxes.list_business_tax_returns() ==
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()
    end

    test "get_business_tax_return!/1 returns the business_tax_return with given id" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      assert Taxes.get_business_tax_return!(business_tax_return.id) ==
        Repo.preload(business_tax_return, [:user])
    end

    test "create_business_tax_return/1 with valid data creates a business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)

      params = %{
        none_expat:  false,
        price_state:    22,
        price_tax_year: 22,
        user_id:    user.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Taxes.create_business_tax_return(params)

      assert %Ecto.Association.NotLoaded{} = business_tax_return.user

      [loaded] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert loaded.id                         == business_tax_return.id
      assert loaded.accounting_software        == nil
      assert loaded.capital_asset_sale         == nil
      assert loaded.church_hospital            == nil
      assert loaded.dispose_asset              == nil
      assert loaded.dispose_property           == nil
      assert loaded.educational_facility       == nil
      assert loaded.financial_situation        == nil
      assert loaded.foreign_account_interest   == nil
      assert loaded.foreign_account_value_more == nil
      assert loaded.foreign_entity_interest    == nil
      assert loaded.foreign_partner_count      == nil
      assert loaded.foreign_shareholder        == nil
      assert loaded.foreign_value              == nil
      assert loaded.fundraising_over           == nil
      assert loaded.has_contribution           == nil
      assert loaded.has_loan                   == nil
      assert loaded.income_over_thousand       == nil
      assert loaded.invest_research            == nil
      assert loaded.k1_count                   == nil
      assert loaded.lobbying                   == nil
      assert loaded.make_distribution          == nil
      assert loaded.none_expat                 == false
      assert loaded.operate_facility           == nil
      assert loaded.price_state                == 22
      assert loaded.price_tax_year             == 22
      assert loaded.property_sale              == nil
      assert loaded.public_charity             == nil
      assert loaded.rental_property_count      == nil
      assert loaded.reported_grant             == nil
      assert loaded.restricted_donation        == nil
      assert loaded.state                      == nil
      assert loaded.tax_exemption              == nil
      assert loaded.tax_year                   == nil
      assert loaded.total_asset_less           == nil
      assert loaded.total_asset_over           == nil
      assert loaded.inserted_at                == business_tax_return.inserted_at
      assert loaded.updated_at                 == business_tax_return.updated_at
      assert loaded.user_id                    == user.id

      assert loaded.user.admin       == user.admin
      assert loaded.user.api_token   == user.api_token
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.banner      == user.banner
      assert loaded.user.bio         == user.bio
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.from_github == user.from_github
      assert loaded.user.geo_city    == user.geo_city
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.locale      == user.locale
      assert loaded.user.logo        == user.logo
      assert loaded.user.name        == user.name
      assert loaded.user.provider    == user.provider
      assert loaded.user.remote_ip   == user.remote_ip
      assert loaded.user.role        == user.role
      assert loaded.user.sex         == user.sex
      assert loaded.user.username    == user.username

      assert match_value_relate.value_for_business_accounting_software  == D.new("29.99")
      assert match_value_relate.value_for_business_dispose_property     == D.new("99.99")
      assert match_value_relate.value_for_business_foreign_shareholder  == D.new("150.0")
      assert match_value_relate.value_for_business_income_over_thousand == D.new("99.99")
      assert match_value_relate.value_for_business_invest_research      == D.new("20.0")
      assert match_value_relate.value_for_business_k1_count             == D.new("6.0")
      assert match_value_relate.value_for_business_make_distribution    == D.new("20.0")
      assert match_value_relate.value_for_business_state                == D.new("50.0")
      assert match_value_relate.value_for_business_tax_exemption        == D.new("400.0")
      assert match_value_relate.value_for_business_total_asset_over     == D.new("150.0")
    end

    test "create_business_tax_return/1 with not correct some fields data updates the business_tax_return" do
      user = insert(:tp_user)

      params = %{
        accounting_software:                       true,
        capital_asset_sale:                        true,
        church_hospital:                           true,
        dispose_asset:                             true,
        dispose_property:                          true,
        educational_facility:                      true,
        financial_situation: "some financial situation",
        foreign_account_interest:                  true,
        foreign_account_value_more:                true,
        foreign_entity_interest:                   true,
        foreign_partner_count:                       22,
        foreign_shareholder:                       true,
        foreign_value:                             true,
        fundraising_over:                          true,
        has_contribution:                          true,
        has_loan:                                  true,
        income_over_thousand:                      true,
        invest_research:                           true,
        k1_count:                                    22,
        lobbying:                                  true,
        make_distribution:                         true,
        none_expat:                               false,
        operate_facility:                          true,
        price_state:                                 33,
        price_tax_year:                              33,
        property_sale:                             true,
        public_charity:                            true,
        rental_property_count:                       22,
        reported_grant:                            true,
        restricted_donation:                       true,
        state:          ["Alabama", "Ohio", "New York"],
        tax_exemption:                             true,
        tax_year:              ["2018", "2017", "2016"],
        total_asset_less:                          true,
        total_asset_over:                          true,
        user_id:                                 user.id
      }

      assert {:error, %Ecto.Changeset{}} = Taxes.create_business_tax_return(params)
    end

    test "create_business_tax_return/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Taxes.create_business_tax_return(params)
    end

    test "update_business_tax_return/2 with valid data updates the business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user_a)

      params = %{
        none_expat:   true,
        price_state:    33,
        price_tax_year: 33,
        user_id:  user_b.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Taxes.update_business_tax_return(business_tax_return, params)

      [updated] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                         == business_tax_return.id
      assert updated.accounting_software        == nil
      assert updated.capital_asset_sale         == nil
      assert updated.church_hospital            == nil
      assert updated.dispose_asset              == nil
      assert updated.dispose_property           == nil
      assert updated.educational_facility       == nil
      assert updated.financial_situation        == nil
      assert updated.foreign_account_interest   == nil
      assert updated.foreign_account_value_more == nil
      assert updated.foreign_entity_interest    == nil
      assert updated.foreign_partner_count      == nil
      assert updated.foreign_shareholder        == nil
      assert updated.foreign_value              == nil
      assert updated.fundraising_over           == nil
      assert updated.has_contribution           == nil
      assert updated.has_loan                   == nil
      assert updated.income_over_thousand       == nil
      assert updated.invest_research            == nil
      assert updated.k1_count                   == nil
      assert updated.lobbying                   == nil
      assert updated.make_distribution          == nil
      assert updated.none_expat                 == true
      assert updated.operate_facility           == nil
      assert updated.price_state                == 33
      assert updated.price_tax_year             == 33
      assert updated.property_sale              == nil
      assert updated.public_charity             == nil
      assert updated.rental_property_count      == nil
      assert updated.reported_grant             == nil
      assert updated.restricted_donation        == nil
      assert updated.state                      == nil
      assert updated.tax_exemption              == nil
      assert updated.tax_year                   == nil
      assert updated.total_asset_less           == nil
      assert updated.total_asset_over           == nil
      assert updated.inserted_at                == business_tax_return.inserted_at
      assert updated.updated_at                 == business_tax_return.updated_at
      assert updated.user_id                    == user_a.id

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.value_for_business_accounting_software  == D.new("29.99")
      assert match_value_relate.value_for_business_dispose_property     == D.new("99.99")
      assert match_value_relate.value_for_business_foreign_shareholder  == D.new("150.0")
      assert match_value_relate.value_for_business_income_over_thousand == D.new("99.99")
      assert match_value_relate.value_for_business_invest_research      == D.new("20.0")
      assert match_value_relate.value_for_business_k1_count             == D.new("6.0")
      assert match_value_relate.value_for_business_make_distribution    == D.new("20.0")
      assert match_value_relate.value_for_business_state                == D.new("50.0")
      assert match_value_relate.value_for_business_tax_exemption        == D.new("400.0")
      assert match_value_relate.value_for_business_total_asset_over     == D.new("150.0")
    end

    test "update_business_tax_return/2 with not correct some fields data updates the business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user_a = insert(:pro_user)
      user_b = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user_a)

      params = %{
        accounting_software: false,
        capital_asset_sale: false,
        church_hospital: false,
        dispose_asset: false,
        none_expat:   true,
        price_state:    33,
        price_tax_year: 33,
        user_id:  user_b.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Taxes.update_business_tax_return(business_tax_return, params)

      [updated] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                         == business_tax_return.id
      assert updated.accounting_software        == nil
      assert updated.capital_asset_sale         == nil
      assert updated.church_hospital            == nil
      assert updated.dispose_asset              == nil
      assert updated.dispose_property           == nil
      assert updated.educational_facility       == nil
      assert updated.financial_situation        == nil
      assert updated.foreign_account_interest   == nil
      assert updated.foreign_account_value_more == nil
      assert updated.foreign_entity_interest    == nil
      assert updated.foreign_partner_count      == nil
      assert updated.foreign_shareholder        == nil
      assert updated.foreign_value              == nil
      assert updated.fundraising_over           == nil
      assert updated.has_contribution           == nil
      assert updated.has_loan                   == nil
      assert updated.income_over_thousand       == nil
      assert updated.invest_research            == nil
      assert updated.k1_count                   == nil
      assert updated.lobbying                   == nil
      assert updated.make_distribution          == nil
      assert updated.none_expat                 == true
      assert updated.operate_facility           == nil
      assert updated.price_state                == 33
      assert updated.price_tax_year             == 33
      assert updated.property_sale              == nil
      assert updated.public_charity             == nil
      assert updated.rental_property_count      == nil
      assert updated.reported_grant             == nil
      assert updated.restricted_donation        == nil
      assert updated.state                      == nil
      assert updated.tax_exemption              == nil
      assert updated.tax_year                   == nil
      assert updated.total_asset_less           == nil
      assert updated.total_asset_over           == nil
      assert updated.inserted_at                == business_tax_return.inserted_at
      assert updated.updated_at                 == business_tax_return.updated_at
      assert updated.user_id                    == user_a.id

      assert updated.user.admin       == user_a.admin
      assert updated.user.api_token   == user_a.api_token
      assert updated.user.avatar      == user_a.avatar
      assert updated.user.banner      == user_a.banner
      assert updated.user.bio         == user_a.bio
      assert updated.user.email       == user_a.email
      assert updated.user.first_name  == user_a.first_name
      assert updated.user.from_github == user_a.from_github
      assert updated.user.geo_city    == user_a.geo_city
      assert updated.user.last_name   == user_a.last_name
      assert updated.user.locale      == user_a.locale
      assert updated.user.logo        == user_a.logo
      assert updated.user.name        == user_a.name
      assert updated.user.provider    == user_a.provider
      assert updated.user.remote_ip   == user_a.remote_ip
      assert updated.user.role        == user_a.role
      assert updated.user.sex         == user_a.sex
      assert updated.user.username    == user_a.username

      assert match_value_relate.value_for_business_accounting_software  == D.new("29.99")
      assert match_value_relate.value_for_business_dispose_property     == D.new("99.99")
      assert match_value_relate.value_for_business_foreign_shareholder  == D.new("150.0")
      assert match_value_relate.value_for_business_income_over_thousand == D.new("99.99")
      assert match_value_relate.value_for_business_invest_research      == D.new("20.0")
      assert match_value_relate.value_for_business_k1_count             == D.new("6.0")
      assert match_value_relate.value_for_business_make_distribution    == D.new("20.0")
      assert match_value_relate.value_for_business_state                == D.new("50.0")
      assert match_value_relate.value_for_business_tax_exemption        == D.new("400.0")
      assert match_value_relate.value_for_business_total_asset_over     == D.new("150.0")
    end

    test "update_business_tax_return/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{user_id: nil}

      [loaded] =
        Repo.preload([business_tax_return], [:user])
        |> sort_by_id()

      assert {:error, %Ecto.Changeset{}} !=
        Taxes.update_business_tax_return(business_tax_return, params)
      assert loaded == Taxes.get_business_tax_return!(business_tax_return.id)
    end

    test "delete_business_tax_return/1 deletes the business_tax_return" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      assert {:ok, %BusinessTaxReturn{}} =
        Taxes.delete_business_tax_return(business_tax_return)
      assert_raise Ecto.NoResultsError, fn ->
        Taxes.get_business_tax_return!(business_tax_return.id)
      end
    end

    test "change_business_tax_return/1 returns a business_tax_return changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Taxes.change_business_tax_return(business_tax_return)
    end
  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
