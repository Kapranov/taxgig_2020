defmodule ServerWeb.GraphQL.Resolvers.Products.BusinessTaxReturnsResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Products.BusinessTaxReturnsResolver

  describe "#index" do
    it "returns BusinessTaxReturns via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessTaxReturnsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id                         == business_tax_return.id
      assert List.first(data).accounting_software        == business_tax_return.accounting_software
      assert List.first(data).capital_asset_sale         == business_tax_return.capital_asset_sale
      assert List.first(data).church_hospital            == business_tax_return.church_hospital
      assert List.first(data).dispose_asset              == business_tax_return.dispose_asset
      assert List.first(data).deadline                   == business_tax_return.deadline
      assert List.first(data).dispose_property           == business_tax_return.dispose_property
      assert List.first(data).educational_facility       == business_tax_return.educational_facility
      assert List.first(data).financial_situation        == business_tax_return.financial_situation
      assert List.first(data).foreign_account_interest   == business_tax_return.foreign_account_interest
      assert List.first(data).foreign_account_value_more == business_tax_return.foreign_account_value_more
      assert List.first(data).foreign_entity_interest    == business_tax_return.foreign_entity_interest
      assert List.first(data).foreign_partner_count      == business_tax_return.foreign_partner_count
      assert List.first(data).foreign_shareholder        == business_tax_return.foreign_shareholder
      assert List.first(data).foreign_value              == business_tax_return.foreign_value
      assert List.first(data).fundraising_over           == business_tax_return.fundraising_over
      assert List.first(data).has_contribution           == business_tax_return.has_contribution
      assert List.first(data).has_loan                   == business_tax_return.has_loan
      assert List.first(data).income_over_thousand       == business_tax_return.income_over_thousand
      assert List.first(data).inserted_at                == business_tax_return.inserted_at
      assert List.first(data).invest_research            == business_tax_return.invest_research
      assert List.first(data).k1_count                   == business_tax_return.k1_count
      assert List.first(data).lobbying                   == business_tax_return.lobbying
      assert List.first(data).make_distribution          == business_tax_return.make_distribution
      assert List.first(data).none_expat                 == business_tax_return.none_expat
      assert List.first(data).operate_facility           == business_tax_return.operate_facility
      assert List.first(data).property_sale              == business_tax_return.property_sale
      assert List.first(data).public_charity             == business_tax_return.public_charity
      assert List.first(data).rental_property_count      == business_tax_return.rental_property_count
      assert List.first(data).reported_grant             == business_tax_return.reported_grant
      assert List.first(data).restricted_donation        == business_tax_return.restricted_donation
      assert List.first(data).state                      == business_tax_return.state
      assert List.first(data).tax_exemption              == business_tax_return.tax_exemption
      assert List.first(data).tax_year                   == business_tax_return.tax_year
      assert List.first(data).total_asset_less           == business_tax_return.total_asset_less
      assert List.first(data).total_asset_over           == business_tax_return.total_asset_over
      assert List.first(data).updated_at                 == business_tax_return.updated_at

      assert List.first(data).user_id          == business_tax_return.user_id
      assert List.first(data).user.active      == business_tax_return.user.active
      assert List.first(data).user.avatar      == business_tax_return.user.avatar
      assert List.first(data).user.bio         == business_tax_return.user.bio
      assert List.first(data).user.birthday    == business_tax_return.user.birthday
      assert List.first(data).user.email       == business_tax_return.user.email
      assert List.first(data).user.first_name  == business_tax_return.user.first_name
      assert List.first(data).user.init_setup  == business_tax_return.user.init_setup
      assert List.first(data).user.inserted_at == business_tax_return.user.inserted_at
      assert List.first(data).user.last_name   == business_tax_return.user.last_name
      assert List.first(data).user.middle_name == business_tax_return.user.middle_name
      assert List.first(data).user.phone       == business_tax_return.user.phone
      assert List.first(data).user.provider    == business_tax_return.user.provider
      assert List.first(data).user.role        == business_tax_return.user.role
      assert List.first(data).user.sex         == business_tax_return.user.sex
      assert List.first(data).user.ssn         == business_tax_return.user.ssn
      assert List.first(data).user.street      == business_tax_return.user.street
      assert List.first(data).user.updated_at  == business_tax_return.user.updated_at
      assert List.first(data).user.zip         == business_tax_return.user.zip

      assert List.last(data).id                         == business_tax_return.id
      assert List.last(data).accounting_software        == business_tax_return.accounting_software
      assert List.last(data).capital_asset_sale         == business_tax_return.capital_asset_sale
      assert List.last(data).church_hospital            == business_tax_return.church_hospital
      assert List.last(data).deadline                   == business_tax_return.deadline
      assert List.last(data).dispose_asset              == business_tax_return.dispose_asset
      assert List.last(data).dispose_property           == business_tax_return.dispose_property
      assert List.last(data).educational_facility       == business_tax_return.educational_facility
      assert List.last(data).financial_situation        == business_tax_return.financial_situation
      assert List.last(data).foreign_account_interest   == business_tax_return.foreign_account_interest
      assert List.last(data).foreign_account_value_more == business_tax_return.foreign_account_value_more
      assert List.last(data).foreign_entity_interest    == business_tax_return.foreign_entity_interest
      assert List.last(data).foreign_partner_count      == business_tax_return.foreign_partner_count
      assert List.last(data).foreign_shareholder        == business_tax_return.foreign_shareholder
      assert List.last(data).foreign_value              == business_tax_return.foreign_value
      assert List.last(data).fundraising_over           == business_tax_return.fundraising_over
      assert List.last(data).has_contribution           == business_tax_return.has_contribution
      assert List.last(data).has_loan                   == business_tax_return.has_loan
      assert List.last(data).income_over_thousand       == business_tax_return.income_over_thousand
      assert List.last(data).inserted_at                == business_tax_return.inserted_at
      assert List.last(data).invest_research            == business_tax_return.invest_research
      assert List.last(data).k1_count                   == business_tax_return.k1_count
      assert List.last(data).lobbying                   == business_tax_return.lobbying
      assert List.last(data).make_distribution          == business_tax_return.make_distribution
      assert List.last(data).none_expat                 == business_tax_return.none_expat
      assert List.last(data).operate_facility           == business_tax_return.operate_facility
      assert List.last(data).property_sale              == business_tax_return.property_sale
      assert List.last(data).public_charity             == business_tax_return.public_charity
      assert List.last(data).rental_property_count      == business_tax_return.rental_property_count
      assert List.last(data).reported_grant             == business_tax_return.reported_grant
      assert List.last(data).restricted_donation        == business_tax_return.restricted_donation
      assert List.last(data).state                      == business_tax_return.state
      assert List.last(data).tax_exemption              == business_tax_return.tax_exemption
      assert List.last(data).tax_year                   == business_tax_return.tax_year
      assert List.last(data).total_asset_less           == business_tax_return.total_asset_less
      assert List.last(data).total_asset_over           == business_tax_return.total_asset_over
      assert List.last(data).updated_at                 == business_tax_return.updated_at

      assert List.last(data).user_id          == business_tax_return.user_id
      assert List.last(data).user.active      == business_tax_return.user.active
      assert List.last(data).user.avatar      == business_tax_return.user.avatar
      assert List.last(data).user.bio         == business_tax_return.user.bio
      assert List.last(data).user.birthday    == business_tax_return.user.birthday
      assert List.last(data).user.email       == business_tax_return.user.email
      assert List.last(data).user.first_name  == business_tax_return.user.first_name
      assert List.last(data).user.init_setup  == business_tax_return.user.init_setup
      assert List.last(data).user.inserted_at == business_tax_return.user.inserted_at
      assert List.last(data).user.last_name   == business_tax_return.user.last_name
      assert List.last(data).user.middle_name == business_tax_return.user.middle_name
      assert List.last(data).user.phone       == business_tax_return.user.phone
      assert List.last(data).user.provider    == business_tax_return.user.provider
      assert List.last(data).user.role        == business_tax_return.user.role
      assert List.last(data).user.sex         == business_tax_return.user.sex
      assert List.last(data).user.ssn         == business_tax_return.user.ssn
      assert List.last(data).user.street      == business_tax_return.user.street
      assert List.last(data).user.updated_at  == business_tax_return.user.updated_at
      assert List.last(data).user.zip         == business_tax_return.user.zip
    end

    it "returns BusinessTaxReturns via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      {:ok, data} = BusinessTaxReturnsResolver.list(nil, nil, context)

      assert length(data) == 1

      assert List.first(data).id             == business_tax_return.id
      assert List.first(data).inserted_at    == business_tax_return.inserted_at
      assert List.first(data).none_expat     == business_tax_return.none_expat
      assert List.first(data).price_state    == business_tax_return.price_state
      assert List.first(data).price_tax_year == business_tax_return.price_tax_year
      assert List.first(data).updated_at     == business_tax_return.updated_at

      assert List.first(data).user_id          == business_tax_return.user_id
      assert List.first(data).user.active      == business_tax_return.user.active
      assert List.first(data).user.avatar      == business_tax_return.user.avatar
      assert List.first(data).user.bio         == business_tax_return.user.bio
      assert List.first(data).user.birthday    == business_tax_return.user.birthday
      assert List.first(data).user.email       == business_tax_return.user.email
      assert List.first(data).user.first_name  == business_tax_return.user.first_name
      assert List.first(data).user.init_setup  == business_tax_return.user.init_setup
      assert List.first(data).user.inserted_at == business_tax_return.user.inserted_at
      assert List.first(data).user.last_name   == business_tax_return.user.last_name
      assert List.first(data).user.middle_name == business_tax_return.user.middle_name
      assert List.first(data).user.phone       == business_tax_return.user.phone
      assert List.first(data).user.provider    == business_tax_return.user.provider
      assert List.first(data).user.role        == business_tax_return.user.role
      assert List.first(data).user.sex         == business_tax_return.user.sex
      assert List.first(data).user.ssn         == business_tax_return.user.ssn
      assert List.first(data).user.street      == business_tax_return.user.street
      assert List.first(data).user.updated_at  == business_tax_return.user.updated_at
      assert List.first(data).user.zip         == business_tax_return.user.zip

      assert List.last(data).id             == business_tax_return.id
      assert List.last(data).inserted_at    == business_tax_return.inserted_at
      assert List.last(data).none_expat     == business_tax_return.none_expat
      assert List.last(data).price_state    == business_tax_return.price_state
      assert List.last(data).price_tax_year == business_tax_return.price_tax_year
      assert List.last(data).updated_at     == business_tax_return.updated_at

      assert List.last(data).user_id          == business_tax_return.user_id
      assert List.last(data).user.active      == business_tax_return.user.active
      assert List.last(data).user.avatar      == business_tax_return.user.avatar
      assert List.last(data).user.bio         == business_tax_return.user.bio
      assert List.last(data).user.birthday    == business_tax_return.user.birthday
      assert List.last(data).user.email       == business_tax_return.user.email
      assert List.last(data).user.first_name  == business_tax_return.user.first_name
      assert List.last(data).user.init_setup  == business_tax_return.user.init_setup
      assert List.last(data).user.inserted_at == business_tax_return.user.inserted_at
      assert List.last(data).user.last_name   == business_tax_return.user.last_name
      assert List.last(data).user.middle_name == business_tax_return.user.middle_name
      assert List.last(data).user.phone       == business_tax_return.user.phone
      assert List.last(data).user.provider    == business_tax_return.user.provider
      assert List.last(data).user.role        == business_tax_return.user.role
      assert List.last(data).user.sex         == business_tax_return.user.sex
      assert List.last(data).user.ssn         == business_tax_return.user.ssn
      assert List.last(data).user.street      == business_tax_return.user.street
      assert List.last(data).user.updated_at  == business_tax_return.user.updated_at
      assert List.last(data).user.zip         == business_tax_return.user.zip
    end
  end

  describe "#show" do
    it "returns specific BusinessTaxReturn by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessTaxReturnsResolver.show(nil, %{id: business_tax_return.id}, context)

      assert found.id                         == business_tax_return.id
      assert found.accounting_software        == business_tax_return.accounting_software
      assert found.capital_asset_sale         == business_tax_return.capital_asset_sale
      assert found.church_hospital            == business_tax_return.church_hospital
      assert found.deadline                   == business_tax_return.deadline
      assert found.dispose_asset              == business_tax_return.dispose_asset
      assert found.dispose_property           == business_tax_return.dispose_property
      assert found.educational_facility       == business_tax_return.educational_facility
      assert found.financial_situation        == business_tax_return.financial_situation
      assert found.foreign_account_interest   == business_tax_return.foreign_account_interest
      assert found.foreign_account_value_more == business_tax_return.foreign_account_value_more
      assert found.foreign_entity_interest    == business_tax_return.foreign_entity_interest
      assert found.foreign_partner_count      == business_tax_return.foreign_partner_count
      assert found.foreign_shareholder        == business_tax_return.foreign_shareholder
      assert found.foreign_value              == business_tax_return.foreign_value
      assert found.fundraising_over           == business_tax_return.fundraising_over
      assert found.has_contribution           == business_tax_return.has_contribution
      assert found.has_loan                   == business_tax_return.has_loan
      assert found.income_over_thousand       == business_tax_return.income_over_thousand
      assert found.inserted_at                == business_tax_return.inserted_at
      assert found.invest_research            == business_tax_return.invest_research
      assert found.k1_count                   == business_tax_return.k1_count
      assert found.lobbying                   == business_tax_return.lobbying
      assert found.make_distribution          == business_tax_return.make_distribution
      assert found.none_expat                 == business_tax_return.none_expat
      assert found.operate_facility           == business_tax_return.operate_facility
      assert found.property_sale              == business_tax_return.property_sale
      assert found.public_charity             == business_tax_return.public_charity
      assert found.rental_property_count      == business_tax_return.rental_property_count
      assert found.reported_grant             == business_tax_return.reported_grant
      assert found.restricted_donation        == business_tax_return.restricted_donation
      assert found.state                      == business_tax_return.state
      assert found.tax_exemption              == business_tax_return.tax_exemption
      assert found.tax_year                   == business_tax_return.tax_year
      assert found.total_asset_less           == business_tax_return.total_asset_less
      assert found.total_asset_over           == business_tax_return.total_asset_over
      assert found.updated_at                 == business_tax_return.updated_at

      assert found.user_id          == business_tax_return.user_id
      assert found.user.active      == business_tax_return.user.active
      assert found.user.avatar      == business_tax_return.user.avatar
      assert found.user.bio         == business_tax_return.user.bio
      assert found.user.birthday    == business_tax_return.user.birthday
      assert found.user.email       == business_tax_return.user.email
      assert found.user.first_name  == business_tax_return.user.first_name
      assert found.user.init_setup  == business_tax_return.user.init_setup
      assert found.user.inserted_at == business_tax_return.user.inserted_at
      assert found.user.last_name   == business_tax_return.user.last_name
      assert found.user.middle_name == business_tax_return.user.middle_name
      assert found.user.phone       == business_tax_return.user.phone
      assert found.user.provider    == business_tax_return.user.provider
      assert found.user.role        == business_tax_return.user.role
      assert found.user.sex         == business_tax_return.user.sex
      assert found.user.ssn         == business_tax_return.user.ssn
      assert found.user.street      == business_tax_return.user.street
      assert found.user.updated_at  == business_tax_return.user.updated_at
      assert found.user.zip         == business_tax_return.user.zip
    end

    it "returns specific BusinessTaxReturn by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessTaxReturnsResolver.show(nil, %{id: business_tax_return.id}, context)

      assert found.id             == business_tax_return.id
      assert found.inserted_at    == business_tax_return.inserted_at
      assert found.none_expat     == business_tax_return.none_expat
      assert found.price_state    == business_tax_return.price_state
      assert found.price_tax_year == business_tax_return.price_tax_year
      assert found.updated_at     == business_tax_return.updated_at

      assert found.user_id          == business_tax_return.user_id
      assert found.user.active      == business_tax_return.user.active
      assert found.user.avatar      == business_tax_return.user.avatar
      assert found.user.bio         == business_tax_return.user.bio
      assert found.user.birthday    == business_tax_return.user.birthday
      assert found.user.email       == business_tax_return.user.email
      assert found.user.first_name  == business_tax_return.user.first_name
      assert found.user.init_setup  == business_tax_return.user.init_setup
      assert found.user.inserted_at == business_tax_return.user.inserted_at
      assert found.user.last_name   == business_tax_return.user.last_name
      assert found.user.middle_name == business_tax_return.user.middle_name
      assert found.user.phone       == business_tax_return.user.phone
      assert found.user.provider    == business_tax_return.user.provider
      assert found.user.role        == business_tax_return.user.role
      assert found.user.sex         == business_tax_return.user.sex
      assert found.user.ssn         == business_tax_return.user.ssn
      assert found.user.street      == business_tax_return.user.street
      assert found.user.updated_at  == business_tax_return.user.updated_at
      assert found.user.zip         == business_tax_return.user.zip
    end

    it "returns not found when BusinessTaxReturn does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessTaxReturnsResolver.show(nil, %{id: id}, context)
      assert error == "The BusinessTaxReturn #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessTaxReturnsResolver.show(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]
    end
  end

  describe "#find" do
    it "find specific BusinessTaxReturn by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessTaxReturnsResolver.find(nil, %{id: business_tax_return.id}, context)

      assert found.id                         == business_tax_return.id
      assert found.accounting_software        == business_tax_return.accounting_software
      assert found.capital_asset_sale         == business_tax_return.capital_asset_sale
      assert found.church_hospital            == business_tax_return.church_hospital
      assert found.deadline                   == business_tax_return.deadline
      assert found.dispose_asset              == business_tax_return.dispose_asset
      assert found.dispose_property           == business_tax_return.dispose_property
      assert found.educational_facility       == business_tax_return.educational_facility
      assert found.financial_situation        == business_tax_return.financial_situation
      assert found.foreign_account_interest   == business_tax_return.foreign_account_interest
      assert found.foreign_account_value_more == business_tax_return.foreign_account_value_more
      assert found.foreign_entity_interest    == business_tax_return.foreign_entity_interest
      assert found.foreign_partner_count      == business_tax_return.foreign_partner_count
      assert found.foreign_shareholder        == business_tax_return.foreign_shareholder
      assert found.foreign_value              == business_tax_return.foreign_value
      assert found.fundraising_over           == business_tax_return.fundraising_over
      assert found.has_contribution           == business_tax_return.has_contribution
      assert found.has_loan                   == business_tax_return.has_loan
      assert found.income_over_thousand       == business_tax_return.income_over_thousand
      assert found.inserted_at                == business_tax_return.inserted_at
      assert found.invest_research            == business_tax_return.invest_research
      assert found.k1_count                   == business_tax_return.k1_count
      assert found.lobbying                   == business_tax_return.lobbying
      assert found.make_distribution          == business_tax_return.make_distribution
      assert found.none_expat                 == business_tax_return.none_expat
      assert found.operate_facility           == business_tax_return.operate_facility
      assert found.property_sale              == business_tax_return.property_sale
      assert found.public_charity             == business_tax_return.public_charity
      assert found.rental_property_count      == business_tax_return.rental_property_count
      assert found.reported_grant             == business_tax_return.reported_grant
      assert found.restricted_donation        == business_tax_return.restricted_donation
      assert found.state                      == business_tax_return.state
      assert found.tax_exemption              == business_tax_return.tax_exemption
      assert found.tax_year                   == business_tax_return.tax_year
      assert found.total_asset_less           == business_tax_return.total_asset_less
      assert found.total_asset_over           == business_tax_return.total_asset_over
      assert found.updated_at                 == business_tax_return.updated_at

      assert found.user_id          == business_tax_return.user_id
      assert found.user.active      == business_tax_return.user.active
      assert found.user.avatar      == business_tax_return.user.avatar
      assert found.user.bio         == business_tax_return.user.bio
      assert found.user.birthday    == business_tax_return.user.birthday
      assert found.user.email       == business_tax_return.user.email
      assert found.user.first_name  == business_tax_return.user.first_name
      assert found.user.init_setup  == business_tax_return.user.init_setup
      assert found.user.inserted_at == business_tax_return.user.inserted_at
      assert found.user.last_name   == business_tax_return.user.last_name
      assert found.user.middle_name == business_tax_return.user.middle_name
      assert found.user.phone       == business_tax_return.user.phone
      assert found.user.provider    == business_tax_return.user.provider
      assert found.user.role        == business_tax_return.user.role
      assert found.user.sex         == business_tax_return.user.sex
      assert found.user.ssn         == business_tax_return.user.ssn
      assert found.user.street      == business_tax_return.user.street
      assert found.user.updated_at  == business_tax_return.user.updated_at
      assert found.user.zip         == business_tax_return.user.zip
    end

    it "find specific BusinessTaxReturn by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, found} = BusinessTaxReturnsResolver.find(nil, %{id: business_tax_return.id}, context)

      assert found.id             == business_tax_return.id
      assert found.inserted_at    == business_tax_return.inserted_at
      assert found.none_expat     == business_tax_return.none_expat
      assert found.price_state    == business_tax_return.price_state
      assert found.price_tax_year == business_tax_return.price_tax_year
      assert found.updated_at     == business_tax_return.updated_at

      assert found.user_id          == business_tax_return.user_id
      assert found.user.active      == business_tax_return.user.active
      assert found.user.avatar      == business_tax_return.user.avatar
      assert found.user.bio         == business_tax_return.user.bio
      assert found.user.birthday    == business_tax_return.user.birthday
      assert found.user.email       == business_tax_return.user.email
      assert found.user.first_name  == business_tax_return.user.first_name
      assert found.user.init_setup  == business_tax_return.user.init_setup
      assert found.user.inserted_at == business_tax_return.user.inserted_at
      assert found.user.last_name   == business_tax_return.user.last_name
      assert found.user.middle_name == business_tax_return.user.middle_name
      assert found.user.phone       == business_tax_return.user.phone
      assert found.user.provider    == business_tax_return.user.provider
      assert found.user.role        == business_tax_return.user.role
      assert found.user.sex         == business_tax_return.user.sex
      assert found.user.ssn         == business_tax_return.user.ssn
      assert found.user.street      == business_tax_return.user.street
      assert found.user.updated_at  == business_tax_return.user.updated_at
      assert found.user.zip         == business_tax_return.user.zip
    end

    it "returns not found when BusinessTaxReturn does not exist" do
      id = FlakeId.get()
      user = insert(:pro_user)
      insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessTaxReturnsResolver.find(nil, %{id: id}, context)
      assert error == "The BusinessTaxReturn #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:pro_user)
      insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil, filing_status: nil}
      {:error, error} = BusinessTaxReturnsResolver.find(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Find"]]
    end
  end

  describe "#create" do
    it "creates BusinessTaxReturn an event by role's Tp" do
      insert(:match_value_relat)
      user = insert(:tp_user)
      context = %{context: %{current_user: user}}

      args = %{
        accounting_software: true,
        capital_asset_sale: true,
        church_hospital: true,
        deadline: Date.utc_today(),
        dispose_asset: true,
        dispose_property: true,
        educational_facility: true,
        financial_situation: "some financial situation",
        foreign_account_interest: true,
        foreign_account_value_more: true,
        foreign_entity_interest: true,
        foreign_partner_count: 12,
        foreign_shareholder: true,
        foreign_value: true,
        fundraising_over: true,
        has_contribution: true,
        has_loan: true,
        income_over_thousand: true,
        invest_research: true,
        k1_count: 12,
        lobbying: true,
        make_distribution: true,
        none_expat: false,
        operate_facility: true,
        property_sale: true,
        public_charity: true,
        rental_property_count: 12,
        reported_grant: true,
        restricted_donation: true,
        state: ["Florida"],
        tax_exemption: true,
        tax_year: ["2019"],
        total_asset_less: true,
        total_asset_over: true,
        user_id: user.id
      }

      {:ok, created} = BusinessTaxReturnsResolver.create(nil, args, context)

      assert created.accounting_software        == true
      assert created.capital_asset_sale         == true
      assert created.church_hospital            == true
      assert created.deadline                   == Date.utc_today()
      assert created.dispose_asset              == true
      assert created.dispose_property           == true
      assert created.educational_facility       == true
      assert created.financial_situation        == "some financial situation"
      assert created.foreign_account_interest   == true
      assert created.foreign_account_value_more == true
      assert created.foreign_entity_interest    == true
      assert created.foreign_partner_count      == 12
      assert created.foreign_shareholder        == true
      assert created.foreign_value              == true
      assert created.fundraising_over           == true
      assert created.has_contribution           == true
      assert created.has_loan                   == true
      assert created.income_over_thousand       == true
      assert created.invest_research            == true
      assert created.k1_count                   == 12
      assert created.lobbying                   == true
      assert created.make_distribution          == true
      assert created.none_expat                 == false
      assert created.operate_facility           == true
      assert created.property_sale              == true
      assert created.public_charity             == true
      assert created.rental_property_count      == 12
      assert created.reported_grant             == true
      assert created.restricted_donation        == true
      assert created.state                      == ["Florida"]
      assert created.tax_exemption              == true
      assert created.tax_year                   == ["2019"]
      assert created.total_asset_less           == true
      assert created.total_asset_over           == true
      assert created.user_id                    == user.id
    end

    it "creates BusinessTaxReturn an event by role's Pro" do
      insert(:match_value_relat)
      user = insert(:pro_user)
      context = %{context: %{current_user: user}}

      args = %{
        none_expat: false,
        price_state: 12,
        price_tax_year: 12,
        user_id: user.id
      }

      {:ok, created} = BusinessTaxReturnsResolver.create(nil, args, context)

      assert created.none_expat     == false
      assert created.price_state    == 12
      assert created.price_tax_year == 12
      assert created.user_id        == user.id
    end

    it "returns error for missing params" do
      user = insert(:user)
      context = %{context: %{current_user: user}}
      args = %{}
      {:error, error} = BusinessTaxReturnsResolver.create(nil, args, context)
      assert error == []
    end
  end

  describe "#update" do
    it "update specific BusinessTaxReturnsResolver by id via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      params = %{
        accounting_software: false,
        capital_asset_sale: false,
        church_hospital: false,
        deadline: Date.utc_today(),
        dispose_asset: false,
        dispose_property: false,
        educational_facility: false,
        financial_situation: "updated some financial situation",
        foreign_account_interest: false,
        foreign_account_value_more: false,
        foreign_entity_interest: false,
        foreign_partner_count: 13,
        foreign_shareholder: false,
        foreign_value: false,
        fundraising_over: false,
        has_contribution: false,
        has_loan: false,
        income_over_thousand: false,
        invest_research: false,
        k1_count: 13,
        lobbying: false,
        make_distribution: false,
        none_expat: true,
        operate_facility: false,
        property_sale: false,
        public_charity: false,
        rental_property_count: 13,
        reported_grant: false,
        restricted_donation: false,
        state: ["Arizona"],
        tax_exemption: false,
        tax_year: ["2020"],
        total_asset_less: false,
        total_asset_over: false,
        user_id: user.id
      }

      args = %{id: business_tax_return.id, business_tax_return: params}
      {:ok, updated} = BusinessTaxReturnsResolver.update(nil, args, context)

      assert updated.id                         == business_tax_return.id
      assert updated.accounting_software        == false
      assert updated.capital_asset_sale         == false
      assert updated.church_hospital            == false
      assert updated.deadline                   == Date.utc_today()
      assert updated.dispose_asset              == false
      assert updated.dispose_property           == false
      assert updated.educational_facility       == false
      assert updated.financial_situation        == "updated some financial situation"
      assert updated.foreign_account_interest   == false
      assert updated.foreign_account_value_more == false
      assert updated.foreign_entity_interest    == false
      assert updated.foreign_partner_count      == 13
      assert updated.foreign_shareholder        == false
      assert updated.foreign_value              == false
      assert updated.fundraising_over           == false
      assert updated.has_contribution           == false
      assert updated.has_loan                   == false
      assert updated.income_over_thousand       == false
      assert updated.invest_research            == false
      assert updated.k1_count                   == 13
      assert updated.lobbying                   == false
      assert updated.make_distribution          == false
      assert updated.none_expat                 == true
      assert updated.operate_facility           == false
      assert updated.property_sale              == false
      assert updated.public_charity             == false
      assert updated.rental_property_count      == 13
      assert updated.reported_grant             == false
      assert updated.restricted_donation        == false
      assert updated.state                      == ["Arizona"]
      assert updated.tax_exemption              == false
      assert updated.tax_year                   == ["2020"]
      assert updated.total_asset_less           == false
      assert updated.total_asset_over           == false
    end

    it "update specific BusinessTaxReturnsResolver by id via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}

      params = %{
        none_expat: true,
        price_state: 13,
        price_tax_year: 13,
        user_id: user.id
      }

      args = %{id: business_tax_return.id, business_tax_return: params}
      {:ok, updated} = BusinessTaxReturnsResolver.update(nil, args, context)

      assert updated.id             == business_tax_return.id
      assert updated.none_expat     == true
      assert updated.price_state    == 13
      assert updated.price_tax_year == 13
    end


    it "nothing change for missing params via role's Tp" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      params = %{none_expat: false}
      args = %{id: business_tax_return.id, business_tax_return: params}
      {:ok, updated} = BusinessTaxReturnsResolver.update(nil, args, context)

      assert updated.id         == business_tax_return.id
      assert updated.none_expat == false
    end

    it "nothing change for missing params via role's Pro" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      params = %{none_expat: false}
      args = %{id: business_tax_return.id, business_tax_return: params}
      {:ok, updated} = BusinessTaxReturnsResolver.update(nil, args, context)

      assert updated.id         == business_tax_return.id
      assert updated.none_expat == false
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil, business_tax_return: nil}
      {:error, error} = BusinessTaxReturnsResolver.update(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]
    end
  end

  describe "#delete" do
    it "delete specific BusinessTaxReturn by id" do
      user = insert(:user)
      struct = insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:ok, delete} = BusinessTaxReturnsResolver.delete(nil, %{id: struct.id}, context)
      assert delete.id == struct.id
    end

    it "returns not found when BusinessTaxReturn does not exist" do
      id = FlakeId.get()
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      {:error, error} = BusinessTaxReturnsResolver.delete(nil, %{id: id}, context)
      assert error == "The BusinessTaxReturn #{id} not found!"
    end

    it "returns error for missing params" do
      user = insert(:user)
      insert(:business_tax_return, user: user)
      context = %{context: %{current_user: user}}
      args = %{id: nil}
      {:error, error} = BusinessTaxReturnsResolver.delete(nil, args, context)
      assert error == [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]
    end
  end
end
