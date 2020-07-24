defmodule Core.Services.IndividualTaxReturnTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.IndividualTaxReturn
  }
  alias Decimal, as: D

  describe "individual_tax_returns via role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = IndividualTaxReturn.changeset(%IndividualTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
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
      struct = insert(:tp_individual_tax_return, user: user)
      [data] = Services.list_individual_tax_return()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_tax_return!/1 returns the individual_tax_return with given id" do
      user = insert(:tp_user)
      struct = insert(:tp_individual_tax_return, user: user)
      data = Services.get_individual_tax_return!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_individual_tax_return/1 with valid data creates a individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)

      params = %{
        deadline:             Date.utc_today(),
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
        Services.create_individual_tax_return(params)

      assert %Ecto.Association.NotLoaded{} = individual_tax_return.user

      [loaded] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert loaded.id                              == individual_tax_return.id
      assert loaded.deadline                        == Date.utc_today()
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

      assert loaded.user.active      == user.active
      assert loaded.user.admin       == user.admin
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.bio         == user.bio
      assert loaded.user.birthday    == user.birthday
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.init_setup  == user.init_setup
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.middle_name == user.middle_name
      assert loaded.user.phone       == user.phone
      assert loaded.user.provider    == user.provider
      assert loaded.user.role        == user.role
      assert loaded.user.sex         == user.sex
      assert loaded.user.ssn         == user.ssn
      assert loaded.user.street      == user.street
      assert loaded.user.zip         == user.zip

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
        deadline:             Date.utc_today(),
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

      assert {:error, %Ecto.Changeset{}} = Services.create_individual_tax_return(params)
    end

    test "create_individual_tax_return/1 with invalid data returns error changeset" do
      params = %{
        deadline:                   nil,
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
        Services.create_individual_tax_return(params)
    end

    test "update_individual_tax_return/2 with valid data updates the individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{
        deadline:             Date.utc_today(),
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
        user_id:                       user.id
      }


      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Services.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.deadline                        == Date.utc_today()
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
      assert updated.user_id                         == user.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.active      == user.active
      assert updated.user.admin       == user.admin
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.provider    == user.provider
      assert updated.user.role        == user.role
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip

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
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)

      params = %{
        deadline:             Date.utc_today(),
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
        user_id:                       user.id
      }


      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Services.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.deadline                        == Date.utc_today()
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
      assert updated.user_id                         == user.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.active      == user.active
      assert updated.user.admin       == user.admin
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.provider    == user.provider
      assert updated.user.role        == user.role
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip

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
      struct = insert(:tp_individual_tax_return, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_tax_return!(struct.id)
      assert {:error, %Ecto.Changeset{}} ==
        Services.update_individual_tax_return(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_tax_return/1 deletes the individual_tax_return" do
      user = insert(:tp_user)
      struct = insert(:tp_individual_tax_return, user: user)
      assert {:ok, %IndividualTaxReturn{}} =
        Services.delete_individual_tax_return(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_tax_return!(struct.id)
      end
    end

    test "change_individual_tax_return/1 returns a individual_tax_return changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_individual_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Services.change_individual_tax_return(struct)
    end
  end

  describe "individual_tax_returns via role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = IndividualTaxReturn.changeset(%IndividualTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
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
      struct = insert(:pro_individual_tax_return, user: user)
      [data] = Services.list_individual_tax_return()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_individual_tax_return!/1 returns the individual_tax_return with given id" do
      user = insert(:pro_user)
      struct = insert(:pro_individual_tax_return, user: user)
      data = Services.get_individual_tax_return!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
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
        Services.create_individual_tax_return(params)

      assert %Ecto.Association.NotLoaded{} = individual_tax_return.user

      [loaded] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert loaded.id                              == individual_tax_return.id
      assert loaded.deadline                        == nil
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

      assert loaded.user.active      == user.active
      assert loaded.user.admin       == user.admin
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.bio         == user.bio
      assert loaded.user.birthday    == user.birthday
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.init_setup  == user.init_setup
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.middle_name == user.middle_name
      assert loaded.user.phone       == user.phone
      assert loaded.user.provider    == user.provider
      assert loaded.user.role        == user.role
      assert loaded.user.sex         == user.sex
      assert loaded.user.ssn         == user.ssn
      assert loaded.user.street      == user.street
      assert loaded.user.zip         == user.zip

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
        deadline:             Date.utc_today(),
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

      assert {:error, %Ecto.Changeset{}} = Services.create_individual_tax_return(params)
    end

    test "create_individual_tax_return/1 with invalid data returns error changeset" do
      params = %{
        deadline:            Date.utc_today(),
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
        Services.create_individual_tax_return(params)
    end

    test "update_individual_tax_return/2 with valid data updates the individual_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

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
        user_id:                       user.id
      }

      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Services.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.deadline                        == nil
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
      assert updated.user_id                         == user.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.active      == user.active
      assert updated.user.admin       == user.admin
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.provider    == user.provider
      assert updated.user.role        == user.role
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip

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
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)

      params = %{
        deadline:             Date.utc_today(),
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
        user_id:                       user.id
      }

      assert {:ok, %IndividualTaxReturn{} = individual_tax_return} =
        Services.update_individual_tax_return(individual_tax_return, params)

      [updated] =
        Repo.preload([individual_tax_return], [:user])
        |> sort_by_id()

      assert updated.id                              == individual_tax_return.id
      assert updated.deadline                        == nil
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
      assert updated.user_id                         == user.id
      assert updated.inserted_at                     == individual_tax_return.inserted_at
      assert updated.updated_at                      == individual_tax_return.updated_at

      assert updated.user.active      == user.active
      assert updated.user.admin       == user.admin
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.provider    == user.provider
      assert updated.user.role        == user.role
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip

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
      struct = insert(:pro_individual_tax_return, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_individual_tax_return!(struct.id)
      assert {:error, %Ecto.Changeset{}} ==
        Services.update_individual_tax_return(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_individual_tax_return/1 deletes the individual_tax_return" do
      user = insert(:pro_user)
      struct = insert(:pro_individual_tax_return, user: user)
      assert {:ok, %IndividualTaxReturn{}} =
        Services.delete_individual_tax_return(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_individual_tax_return!(struct.id)
      end
    end

    test "change_individual_tax_return/1 returns a individual_tax_return changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_individual_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Services.change_individual_tax_return(struct)
    end

  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
