defmodule ServerWeb.GraphQL.Resolvers.Products.IndividualTaxReturnsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.IndividualTaxReturnsResolver

  describe "#index" do
    it "returns IndividualTaxReturns via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualTaxReturnsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                         == individual_tax_return.id
      assert List.first(data).foreign_account            == individual_tax_return.foreign_account
      assert List.first(data).foreign_account_limit      == individual_tax_return.foreign_account_limit
      assert List.first(data).foreign_financial_interest == individual_tax_return.foreign_financial_interest
      assert List.first(data).home_owner                 == individual_tax_return.home_owner
      assert List.first(data).inserted_at                == individual_tax_return.inserted_at
      assert List.first(data).k1_count                   == individual_tax_return.k1_count
      assert List.first(data).k1_income                  == individual_tax_return.k1_income
      assert List.first(data).living_abroad              == individual_tax_return.living_abroad
      assert List.first(data).non_resident_earning       == individual_tax_return.non_resident_earning
      assert List.first(data).none_expat                 == individual_tax_return.none_expat
      assert List.first(data).own_stock_crypto           == individual_tax_return.own_stock_crypto
      assert List.first(data).rental_property_count      == individual_tax_return.rental_property_count
      assert List.first(data).rental_property_income     == individual_tax_return.rental_property_income
      assert List.first(data).sole_proprietorship_count  == individual_tax_return.sole_proprietorship_count
      assert List.first(data).state                      == individual_tax_return.state
      assert List.first(data).stock_divident             == individual_tax_return.stock_divident
      assert List.first(data).tax_year                   == individual_tax_return.tax_year
      assert List.first(data).updated_at                 == individual_tax_return.updated_at

      assert List.first(data).user_id          == individual_tax_return.user_id
      assert List.first(data).user.active      == individual_tax_return.user.active
      assert List.first(data).user.avatar      == individual_tax_return.user.avatar
      assert List.first(data).user.bio         == individual_tax_return.user.bio
      assert List.first(data).user.birthday    == individual_tax_return.user.birthday
      assert List.first(data).user.email       == individual_tax_return.user.email
      assert List.first(data).user.first_name  == individual_tax_return.user.first_name
      assert List.first(data).user.init_setup  == individual_tax_return.user.init_setup
      assert List.first(data).user.inserted_at == individual_tax_return.user.inserted_at
      assert List.first(data).user.last_name   == individual_tax_return.user.last_name
      assert List.first(data).user.middle_name == individual_tax_return.user.middle_name
      assert List.first(data).user.phone       == individual_tax_return.user.phone
      assert List.first(data).user.provider    == individual_tax_return.user.provider
      assert List.first(data).user.role        == individual_tax_return.user.role
      assert List.first(data).user.sex         == individual_tax_return.user.sex
      assert List.first(data).user.ssn         == individual_tax_return.user.ssn
      assert List.first(data).user.street      == individual_tax_return.user.street
      assert List.first(data).user.updated_at  == individual_tax_return.user.updated_at
      assert List.first(data).user.zip         == individual_tax_return.user.zip

      assert List.last(data).id                          == individual_tax_return.id
      assert List.last(data).foreign_account             == individual_tax_return.foreign_account
      assert List.last(data).foreign_account_limit       == individual_tax_return.foreign_account_limit
      assert List.last(data).foreign_financial_interest  == individual_tax_return.foreign_financial_interest
      assert List.last(data).home_owner                  == individual_tax_return.home_owner
      assert List.last(data).inserted_at                 == individual_tax_return.inserted_at
      assert List.last(data).k1_count                    == individual_tax_return.k1_count
      assert List.last(data).k1_income                   == individual_tax_return.k1_income
      assert List.last(data).living_abroad               == individual_tax_return.living_abroad
      assert List.last(data).non_resident_earning        == individual_tax_return.non_resident_earning
      assert List.last(data).none_expat                  == individual_tax_return.none_expat
      assert List.last(data).own_stock_crypto            == individual_tax_return.own_stock_crypto
      assert List.last(data).rental_property_count       == individual_tax_return.rental_property_count
      assert List.last(data).rental_property_income      == individual_tax_return.rental_property_income
      assert List.last(data).sole_proprietorship_count   == individual_tax_return.sole_proprietorship_count
      assert List.last(data).state                       == individual_tax_return.state
      assert List.last(data).stock_divident              == individual_tax_return.stock_divident
      assert List.last(data).tax_year                    == individual_tax_return.tax_year
      assert List.last(data).updated_at                  == individual_tax_return.updated_at

      assert List.last(data).user_id          == individual_tax_return.user_id
      assert List.last(data).user.active      == individual_tax_return.user.active
      assert List.last(data).user.avatar      == individual_tax_return.user.avatar
      assert List.last(data).user.bio         == individual_tax_return.user.bio
      assert List.last(data).user.birthday    == individual_tax_return.user.birthday
      assert List.last(data).user.email       == individual_tax_return.user.email
      assert List.last(data).user.first_name  == individual_tax_return.user.first_name
      assert List.last(data).user.init_setup  == individual_tax_return.user.init_setup
      assert List.last(data).user.inserted_at == individual_tax_return.user.inserted_at
      assert List.last(data).user.last_name   == individual_tax_return.user.last_name
      assert List.last(data).user.middle_name == individual_tax_return.user.middle_name
      assert List.last(data).user.phone       == individual_tax_return.user.phone
      assert List.last(data).user.provider    == individual_tax_return.user.provider
      assert List.last(data).user.role        == individual_tax_return.user.role
      assert List.last(data).user.sex         == individual_tax_return.user.sex
      assert List.last(data).user.ssn         == individual_tax_return.user.ssn
      assert List.last(data).user.street      == individual_tax_return.user.street
      assert List.last(data).user.updated_at  == individual_tax_return.user.updated_at
      assert List.last(data).user.zip         == individual_tax_return.user.zip
    end

    it "returns IndividualTaxReturns via role's Pro" do
      user = insert(:tp_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      {:ok, data} = IndividualTaxReturnsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                              == individual_tax_return.id
      assert List.first(data).foreign_account                 == individual_tax_return.foreign_account
      assert List.first(data).home_owner                      == individual_tax_return.home_owner
      assert List.first(data).inserted_at                     == individual_tax_return.inserted_at
      assert List.first(data).living_abroad                   == individual_tax_return.living_abroad
      assert List.first(data).non_resident_earning            == individual_tax_return.non_resident_earning
      assert List.first(data).none_expat                      == individual_tax_return.none_expat
      assert List.first(data).own_stock_crypto                == individual_tax_return.own_stock_crypto
      assert List.first(data).price_foreign_account           == individual_tax_return.price_foreign_account
      assert List.first(data).price_home_owner                == individual_tax_return.price_home_owner
      assert List.first(data).price_living_abroad             == individual_tax_return.price_living_abroad
      assert List.first(data).price_non_resident_earning      == individual_tax_return.price_non_resident_earning
      assert List.first(data).price_own_stock_crypto          == individual_tax_return.price_own_stock_crypto
      assert List.first(data).price_rental_property_income    == individual_tax_return.price_rental_property_income
      assert List.first(data).price_sole_proprietorship_count == individual_tax_return.price_sole_proprietorship_count
      assert List.first(data).price_state                     == individual_tax_return.price_state
      assert List.first(data).price_stock_divident            == individual_tax_return.price_stock_divident
      assert List.first(data).price_tax_year                  == individual_tax_return.price_tax_year
      assert List.first(data).rental_property_income          == individual_tax_return.rental_property_income
      assert List.first(data).stock_divident                  == individual_tax_return.stock_divident
      assert List.first(data).updated_at                      == individual_tax_return.updated_at

      assert List.first(data).user_id          == individual_tax_return.user_id
      assert List.first(data).user.active      == individual_tax_return.user.active
      assert List.first(data).user.avatar      == individual_tax_return.user.avatar
      assert List.first(data).user.bio         == individual_tax_return.user.bio
      assert List.first(data).user.birthday    == individual_tax_return.user.birthday
      assert List.first(data).user.email       == individual_tax_return.user.email
      assert List.first(data).user.first_name  == individual_tax_return.user.first_name
      assert List.first(data).user.init_setup  == individual_tax_return.user.init_setup
      assert List.first(data).user.inserted_at == individual_tax_return.user.inserted_at
      assert List.first(data).user.last_name   == individual_tax_return.user.last_name
      assert List.first(data).user.middle_name == individual_tax_return.user.middle_name
      assert List.first(data).user.phone       == individual_tax_return.user.phone
      assert List.first(data).user.provider    == individual_tax_return.user.provider
      assert List.first(data).user.role        == individual_tax_return.user.role
      assert List.first(data).user.sex         == individual_tax_return.user.sex
      assert List.first(data).user.ssn         == individual_tax_return.user.ssn
      assert List.first(data).user.street      == individual_tax_return.user.street
      assert List.first(data).user.updated_at  == individual_tax_return.user.updated_at
      assert List.first(data).user.zip         == individual_tax_return.user.zip

      assert List.last(data).id                              == individual_tax_return.id
      assert List.last(data).foreign_account                 == individual_tax_return.foreign_account
      assert List.last(data).home_owner                      == individual_tax_return.home_owner
      assert List.last(data).inserted_at                     == individual_tax_return.inserted_at
      assert List.last(data).living_abroad                   == individual_tax_return.living_abroad
      assert List.last(data).non_resident_earning            == individual_tax_return.non_resident_earning
      assert List.last(data).none_expat                      == individual_tax_return.none_expat
      assert List.last(data).own_stock_crypto                == individual_tax_return.own_stock_crypto
      assert List.last(data).price_foreign_account           == individual_tax_return.price_foreign_account
      assert List.last(data).price_home_owner                == individual_tax_return.price_home_owner
      assert List.last(data).price_living_abroad             == individual_tax_return.price_living_abroad
      assert List.last(data).price_non_resident_earning      == individual_tax_return.price_non_resident_earning
      assert List.last(data).price_own_stock_crypto          == individual_tax_return.price_own_stock_crypto
      assert List.last(data).price_rental_property_income    == individual_tax_return.price_rental_property_income
      assert List.last(data).price_sole_proprietorship_count == individual_tax_return.price_sole_proprietorship_count
      assert List.last(data).price_state                     == individual_tax_return.price_state
      assert List.last(data).price_stock_divident            == individual_tax_return.price_stock_divident
      assert List.last(data).price_tax_year                  == individual_tax_return.price_tax_year
      assert List.last(data).rental_property_income          == individual_tax_return.rental_property_income
      assert List.last(data).stock_divident                  == individual_tax_return.stock_divident
      assert List.last(data).updated_at                      == individual_tax_return.updated_at

      assert List.last(data).user_id          == individual_tax_return.user_id
      assert List.last(data).user.active      == individual_tax_return.user.active
      assert List.last(data).user.avatar      == individual_tax_return.user.avatar
      assert List.last(data).user.bio         == individual_tax_return.user.bio
      assert List.last(data).user.birthday    == individual_tax_return.user.birthday
      assert List.last(data).user.email       == individual_tax_return.user.email
      assert List.last(data).user.first_name  == individual_tax_return.user.first_name
      assert List.last(data).user.init_setup  == individual_tax_return.user.init_setup
      assert List.last(data).user.inserted_at == individual_tax_return.user.inserted_at
      assert List.last(data).user.last_name   == individual_tax_return.user.last_name
      assert List.last(data).user.middle_name == individual_tax_return.user.middle_name
      assert List.last(data).user.phone       == individual_tax_return.user.phone
      assert List.last(data).user.provider    == individual_tax_return.user.provider
      assert List.last(data).user.role        == individual_tax_return.user.role
      assert List.last(data).user.sex         == individual_tax_return.user.sex
      assert List.last(data).user.ssn         == individual_tax_return.user.ssn
      assert List.last(data).user.street      == individual_tax_return.user.street
      assert List.last(data).user.updated_at  == individual_tax_return.user.updated_at
      assert List.last(data).user.zip         == individual_tax_return.user.zip
    end
  end

  describe "#show" do
    it "returns specific IndividualTaxReturn by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualTaxReturnsResolver.show(nil, %{id: individual_tax_return.id}, context)

      assert found.id                         == individual_tax_return.id
      assert found.foreign_account            == individual_tax_return.foreign_account
      assert found.foreign_account_limit      == individual_tax_return.foreign_account_limit
      assert found.foreign_financial_interest == individual_tax_return.foreign_financial_interest
      assert found.home_owner                 == individual_tax_return.home_owner
      assert found.inserted_at                == individual_tax_return.inserted_at
      assert found.k1_count                   == individual_tax_return.k1_count
      assert found.k1_income                  == individual_tax_return.k1_income
      assert found.living_abroad              == individual_tax_return.living_abroad
      assert found.non_resident_earning       == individual_tax_return.non_resident_earning
      assert found.none_expat                 == individual_tax_return.none_expat
      assert found.own_stock_crypto           == individual_tax_return.own_stock_crypto
      assert found.rental_property_count      == individual_tax_return.rental_property_count
      assert found.rental_property_income     == individual_tax_return.rental_property_income
      assert found.sole_proprietorship_count  == individual_tax_return.sole_proprietorship_count
      assert found.state                      == individual_tax_return.state
      assert found.stock_divident             == individual_tax_return.stock_divident
      assert found.tax_year                   == individual_tax_return.tax_year
      assert found.updated_at                 == individual_tax_return.updated_at

      assert found.user_id          == individual_tax_return.user_id
      assert found.user.active      == individual_tax_return.user.active
      assert found.user.avatar      == individual_tax_return.user.avatar
      assert found.user.bio         == individual_tax_return.user.bio
      assert found.user.birthday    == individual_tax_return.user.birthday
      assert found.user.email       == individual_tax_return.user.email
      assert found.user.first_name  == individual_tax_return.user.first_name
      assert found.user.init_setup  == individual_tax_return.user.init_setup
      assert found.user.inserted_at == individual_tax_return.user.inserted_at
      assert found.user.last_name   == individual_tax_return.user.last_name
      assert found.user.middle_name == individual_tax_return.user.middle_name
      assert found.user.phone       == individual_tax_return.user.phone
      assert found.user.provider    == individual_tax_return.user.provider
      assert found.user.role        == individual_tax_return.user.role
      assert found.user.sex         == individual_tax_return.user.sex
      assert found.user.ssn         == individual_tax_return.user.ssn
      assert found.user.street      == individual_tax_return.user.street
      assert found.user.updated_at  == individual_tax_return.user.updated_at
      assert found.user.zip         == individual_tax_return.user.zip
    end

    it "returns specific IndividualTaxReturn by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualTaxReturnsResolver.show(nil, %{id: individual_tax_return.id}, context)

      assert found.id                              == individual_tax_return.id
      assert found.foreign_account                 == individual_tax_return.foreign_account
      assert found.home_owner                      == individual_tax_return.home_owner
      assert found.inserted_at                     == individual_tax_return.inserted_at
      assert found.living_abroad                   == individual_tax_return.living_abroad
      assert found.non_resident_earning            == individual_tax_return.non_resident_earning
      assert found.none_expat                      == individual_tax_return.none_expat
      assert found.own_stock_crypto                == individual_tax_return.own_stock_crypto
      assert found.price_foreign_account           == individual_tax_return.price_foreign_account
      assert found.price_home_owner                == individual_tax_return.price_home_owner
      assert found.price_living_abroad             == individual_tax_return.price_living_abroad
      assert found.price_non_resident_earning      == individual_tax_return.price_non_resident_earning
      assert found.price_own_stock_crypto          == individual_tax_return.price_own_stock_crypto
      assert found.price_rental_property_income    == individual_tax_return.price_rental_property_income
      assert found.price_sole_proprietorship_count == individual_tax_return.price_sole_proprietorship_count
      assert found.price_state                     == individual_tax_return.price_state
      assert found.price_stock_divident            == individual_tax_return.price_stock_divident
      assert found.price_tax_year                  == individual_tax_return.price_tax_year
      assert found.rental_property_income          == individual_tax_return.rental_property_income
      assert found.stock_divident                  == individual_tax_return.stock_divident
      assert found.updated_at                      == individual_tax_return.updated_at

      assert found.user_id          == individual_tax_return.user_id
      assert found.user.active      == individual_tax_return.user.active
      assert found.user.avatar      == individual_tax_return.user.avatar
      assert found.user.bio         == individual_tax_return.user.bio
      assert found.user.birthday    == individual_tax_return.user.birthday
      assert found.user.email       == individual_tax_return.user.email
      assert found.user.first_name  == individual_tax_return.user.first_name
      assert found.user.init_setup  == individual_tax_return.user.init_setup
      assert found.user.inserted_at == individual_tax_return.user.inserted_at
      assert found.user.last_name   == individual_tax_return.user.last_name
      assert found.user.middle_name == individual_tax_return.user.middle_name
      assert found.user.phone       == individual_tax_return.user.phone
      assert found.user.provider    == individual_tax_return.user.provider
      assert found.user.role        == individual_tax_return.user.role
      assert found.user.sex         == individual_tax_return.user.sex
      assert found.user.ssn         == individual_tax_return.user.ssn
      assert found.user.street      == individual_tax_return.user.street
      assert found.user.updated_at  == individual_tax_return.user.updated_at
      assert found.user.zip         == individual_tax_return.user.zip
    end

    it "returns not found when IndividualTaxReturn does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualTaxReturnsResolver.show(nil, %{id: id}, context)
      assert error == "The IndividualTaxReturn #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualTaxReturnsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific IndividualTaxReturn by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualTaxReturnsResolver.find(nil, %{id: individual_tax_return.id}, context)

      assert found.id                         == individual_tax_return.id
      assert found.foreign_account            == individual_tax_return.foreign_account
      assert found.foreign_account_limit      == individual_tax_return.foreign_account_limit
      assert found.foreign_financial_interest == individual_tax_return.foreign_financial_interest
      assert found.home_owner                 == individual_tax_return.home_owner
      assert found.inserted_at                == individual_tax_return.inserted_at
      assert found.k1_count                   == individual_tax_return.k1_count
      assert found.k1_income                  == individual_tax_return.k1_income
      assert found.living_abroad              == individual_tax_return.living_abroad
      assert found.non_resident_earning       == individual_tax_return.non_resident_earning
      assert found.none_expat                 == individual_tax_return.none_expat
      assert found.own_stock_crypto           == individual_tax_return.own_stock_crypto
      assert found.rental_property_count      == individual_tax_return.rental_property_count
      assert found.rental_property_income     == individual_tax_return.rental_property_income
      assert found.sole_proprietorship_count  == individual_tax_return.sole_proprietorship_count
      assert found.state                      == individual_tax_return.state
      assert found.stock_divident             == individual_tax_return.stock_divident
      assert found.tax_year                   == individual_tax_return.tax_year
      assert found.updated_at                 == individual_tax_return.updated_at

      assert found.user_id          == individual_tax_return.user_id
      assert found.user.active      == individual_tax_return.user.active
      assert found.user.avatar      == individual_tax_return.user.avatar
      assert found.user.bio         == individual_tax_return.user.bio
      assert found.user.birthday    == individual_tax_return.user.birthday
      assert found.user.email       == individual_tax_return.user.email
      assert found.user.first_name  == individual_tax_return.user.first_name
      assert found.user.init_setup  == individual_tax_return.user.init_setup
      assert found.user.inserted_at == individual_tax_return.user.inserted_at
      assert found.user.last_name   == individual_tax_return.user.last_name
      assert found.user.middle_name == individual_tax_return.user.middle_name
      assert found.user.phone       == individual_tax_return.user.phone
      assert found.user.provider    == individual_tax_return.user.provider
      assert found.user.role        == individual_tax_return.user.role
      assert found.user.sex         == individual_tax_return.user.sex
      assert found.user.ssn         == individual_tax_return.user.ssn
      assert found.user.street      == individual_tax_return.user.street
      assert found.user.updated_at  == individual_tax_return.user.updated_at
      assert found.user.zip         == individual_tax_return.user.zip
    end

    it "find specific IndividualTaxReturn by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = IndividualTaxReturnsResolver.find(nil, %{id: individual_tax_return.id}, context)

      assert found.id                              == individual_tax_return.id
      assert found.foreign_account                 == individual_tax_return.foreign_account
      assert found.home_owner                      == individual_tax_return.home_owner
      assert found.inserted_at                     == individual_tax_return.inserted_at
      assert found.living_abroad                   == individual_tax_return.living_abroad
      assert found.non_resident_earning            == individual_tax_return.non_resident_earning
      assert found.none_expat                      == individual_tax_return.none_expat
      assert found.own_stock_crypto                == individual_tax_return.own_stock_crypto
      assert found.price_foreign_account           == individual_tax_return.price_foreign_account
      assert found.price_home_owner                == individual_tax_return.price_home_owner
      assert found.price_living_abroad             == individual_tax_return.price_living_abroad
      assert found.price_non_resident_earning      == individual_tax_return.price_non_resident_earning
      assert found.price_own_stock_crypto          == individual_tax_return.price_own_stock_crypto
      assert found.price_rental_property_income    == individual_tax_return.price_rental_property_income
      assert found.price_sole_proprietorship_count == individual_tax_return.price_sole_proprietorship_count
      assert found.price_state                     == individual_tax_return.price_state
      assert found.price_stock_divident            == individual_tax_return.price_stock_divident
      assert found.price_tax_year                  == individual_tax_return.price_tax_year
      assert found.rental_property_income          == individual_tax_return.rental_property_income
      assert found.stock_divident                  == individual_tax_return.stock_divident
      assert found.updated_at                      == individual_tax_return.updated_at

      assert found.user_id          == individual_tax_return.user_id
      assert found.user.active      == individual_tax_return.user.active
      assert found.user.avatar      == individual_tax_return.user.avatar
      assert found.user.bio         == individual_tax_return.user.bio
      assert found.user.birthday    == individual_tax_return.user.birthday
      assert found.user.email       == individual_tax_return.user.email
      assert found.user.first_name  == individual_tax_return.user.first_name
      assert found.user.init_setup  == individual_tax_return.user.init_setup
      assert found.user.inserted_at == individual_tax_return.user.inserted_at
      assert found.user.last_name   == individual_tax_return.user.last_name
      assert found.user.middle_name == individual_tax_return.user.middle_name
      assert found.user.phone       == individual_tax_return.user.phone
      assert found.user.provider    == individual_tax_return.user.provider
      assert found.user.role        == individual_tax_return.user.role
      assert found.user.sex         == individual_tax_return.user.sex
      assert found.user.ssn         == individual_tax_return.user.ssn
      assert found.user.street      == individual_tax_return.user.street
      assert found.user.updated_at  == individual_tax_return.user.updated_at
      assert found.user.zip         == individual_tax_return.user.zip
    end

    it "returns not found when IndividualTaxReturn does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualTaxReturnsResolver.find(nil, %{id: id}, context)
      assert error == "The IndividualTaxReturn #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = IndividualTaxReturnsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates IndividualTaxReturn an event by role's Tp" do
      user = insert(:tp_user)
      context = %{context: %{current_user: user}}

      args = %{
        foreign_account: true,
        foreign_account_limit: true,
        foreign_financial_interest: true,
        home_owner: true,
        k1_count: 12,
        k1_income: true,
        living_abroad: true,
        non_resident_earning: true,
        none_expat: false,
        own_stock_crypto: true,
        rental_property_count: 12,
        rental_property_income: true,
        sole_proprietorship_count: 12,
        state: ["Florida"],
        stock_divident: true,
        tax_year: ["2019"],
        user_id: user.id
      }

      {:ok, created} = IndividualTaxReturnsResolver.create(nil, args, context)

      assert created.foreign_account            == true
      assert created.foreign_account_limit      == true
      assert created.foreign_financial_interest == true
      assert created.home_owner                 == true
      assert created.k1_count                   == 12
      assert created.k1_income                  == true
      assert created.living_abroad              == true
      assert created.non_resident_earning       == true
      assert created.none_expat                 == false
      assert created.own_stock_crypto           == true
      assert created.rental_property_count      == 12
      assert created.rental_property_income     == true
      assert created.sole_proprietorship_count  == 12
      assert created.state                      == ["Florida"]
      assert created.stock_divident             == true
      assert created.tax_year                   == ["2019"]
      assert created.user_id                    == user.id
    end

    it "creates IndividualTaxReturn an event by role's Pro" do
      user = insert(:pro_user)
      context = %{context: %{current_user: user}}

      args = %{
        foreign_account: true,
        home_owner: true,
        living_abroad: true,
        non_resident_earning: true,
        none_expat: false,
        own_stock_crypto: true,
        price_foreign_account: 12,
        price_home_owner: 12,
        price_living_abroad: 12,
        price_non_resident_earning: 12,
        price_own_stock_crypto: 12,
        price_rental_property_income: 12,
        price_sole_proprietorship_count: 12,
        price_state: 12,
        price_stock_divident: 12,
        price_tax_year: 12,
        rental_property_income: true,
        stock_divident: true,
        user_id: user.id
      }

      {:ok, created} = IndividualTaxReturnsResolver.create(nil, args, context)

      assert created.foreign_account                 == true
      assert created.home_owner                      == true
      assert created.living_abroad                   == true
      assert created.non_resident_earning            == true
      assert created.none_expat                      == false
      assert created.own_stock_crypto                == true
      assert created.price_foreign_account           == 12
      assert created.price_home_owner                == 12
      assert created.price_living_abroad             == 12
      assert created.price_non_resident_earning      == 12
      assert created.price_own_stock_crypto          == 12
      assert created.price_rental_property_income    == 12
      assert created.price_sole_proprietorship_count == 12
      assert created.price_state                     == 12
      assert created.price_stock_divident            == 12
      assert created.price_tax_year                  == 12
      assert created.rental_property_income          == true
      assert created.stock_divident                  == true
      assert created.user_id                         == user.id
    end

    it "returns error for missing params" do
      user = insert(:user)
      context = %{context: %{current_user: user}}
      args = %{}
      {:error, error} = IndividualTaxReturnsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific IndividualTaxReturnsResolver by id via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      params = %{
        foreign_account: false,
        foreign_account_limit: false,
        foreign_financial_interest: false,
        home_owner: false,
        k1_count: 13,
        k1_income: false,
        living_abroad: false,
        non_resident_earning: false,
        none_expat: true,
        own_stock_crypto: false,
        rental_property_count: 13,
        rental_property_income: false,
        sole_proprietorship_count: 13,
        state: ["Arizona"],
        stock_divident: false,
        tax_year: ["2020"],
        user_id: user.id
      }

      args = %{id: individual_tax_return.id, individual_tax_return: params}
      {:ok, updated} = IndividualTaxReturnsResolver.update(nil, args, context)

      assert updated.id                         == individual_tax_return.id
      assert updated.foreign_account            == false
      assert updated.foreign_account_limit      == false
      assert updated.foreign_financial_interest == false
      assert updated.home_owner                 == false
      assert updated.k1_count                   == 13
      assert updated.k1_income                  == false
      assert updated.living_abroad              == false
      assert updated.non_resident_earning       == false
      assert updated.none_expat                 == true
      assert updated.own_stock_crypto           == false
      assert updated.rental_property_count      == 13
      assert updated.rental_property_income     == false
      assert updated.sole_proprietorship_count  == 13
      assert updated.state                      == ["Arizona"]
      assert updated.stock_divident             == false
      assert updated.tax_year                   == ["2020"]
    end

    it "update specific IndividualTaxReturnsResolver by id via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}

      params = %{
        foreign_account: false,
        home_owner: false,
        living_abroad: false,
        non_resident_earning: false,
        none_expat: true,
        own_stock_crypto: false,
        price_foreign_account: 13,
        price_home_owner: 13,
        price_living_abroad: 13,
        price_non_resident_earning: 13,
        price_own_stock_crypto: 13,
        price_rental_property_income: 13,
        price_sole_proprietorship_count: 13,
        price_state: 13,
        price_stock_divident: 13,
        price_tax_year: 13,
        rental_property_income: false,
        stock_divident: false,
        user_id: user.id
      }

      args = %{id: individual_tax_return.id, individual_tax_return: params}
      {:ok, updated} = IndividualTaxReturnsResolver.update(nil, args, context)

      assert updated.id                              == individual_tax_return.id
      assert updated.foreign_account                 == false
      assert updated.home_owner                      == false
      assert updated.living_abroad                   == false
      assert updated.non_resident_earning            == false
      assert updated.none_expat                      == true
      assert updated.own_stock_crypto                == false
      assert updated.price_foreign_account           == 13
      assert updated.price_home_owner                == 13
      assert updated.price_living_abroad             == 13
      assert updated.price_non_resident_earning      == 13
      assert updated.price_own_stock_crypto          == 13
      assert updated.price_rental_property_income    == 13
      assert updated.price_sole_proprietorship_count == 13
      assert updated.price_state                     == 13
      assert updated.price_stock_divident            == 13
      assert updated.price_tax_year                  == 13
      assert updated.rental_property_income          == false
      assert updated.stock_divident                  == false
    end

    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      params = %{k1_count: 13}
      args = %{id: individual_tax_return.id, individual_tax_return: params}
      {:ok, updated} = IndividualTaxReturnsResolver.update(nil, args, context)
      assert updated.id       == individual_tax_return.id
      assert updated.k1_count == 13
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      params = %{price_home_owner: 13}
      args = %{id: individual_tax_return.id, individual_tax_return: params}
      {:ok, updated} = IndividualTaxReturnsResolver.update(nil, args, context)
      assert updated.id               == individual_tax_return.id
      assert updated.price_home_owner == 13
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil, individual_tax_return: nil}
      {:error, error} = IndividualTaxReturnsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific IndividualTaxReturn by id" do
      user = insert(:user)
      individual_tax_return = insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, delete} = IndividualTaxReturnsResolver.delete(nil, %{id: individual_tax_return.id}, context)
      assert delete.id == individual_tax_return.id
    end

    it "returns not found when IndividualTaxReturn does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:error, error} = IndividualTaxReturnsResolver.delete(nil, %{id: id}, context)
      assert error == "The IndividualTaxReturn #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:individual_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = IndividualTaxReturnsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
