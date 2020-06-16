defmodule Core.Services.BusinessTaxReturnTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessTaxReturn
  }

  alias Decimal, as: D

  describe "business_tax_returns via role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BusinessTaxReturn.changeset(%BusinessTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
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
      struct = insert(:tp_business_tax_return, user: user)
      [data] = Services.list_business_tax_return()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_tax_return!/1 returns the business_tax_return with given id" do
      struct = insert(:tp_business_tax_return)
      data = Services.get_business_tax_return!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
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
        Services.create_business_tax_return(params)

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

      assert loaded.user.active      == user.active
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.bio         == user.bio
      assert loaded.user.birthday    == user.birthday
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.init_setup  == user.init_setup
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.middle_name == user.middle_name
      assert loaded.user.phone       == user.phone
      assert loaded.user.role        == user.role
      assert loaded.user.provider    == user.provider
      assert loaded.user.sex         == user.sex
      assert loaded.user.ssn         == user.ssn
      assert loaded.user.street      == user.street
      assert loaded.user.zip         == user.zip
      assert loaded.user.inserted_at == user.inserted_at
      assert loaded.user.updated_at  == user.updated_at

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

      assert {:error, %Ecto.Changeset{}} = Services.create_business_tax_return(params)
    end

    test "create_business_tax_return/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Services.create_business_tax_return(params)
    end

    test "update_business_tax_return/2 with valid data updates the business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      struct = insert(:tp_business_tax_return, user: user)

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
        user_id:                                  user.id
      }

      assert {:ok, %BusinessTaxReturn{} = updated} =
        Services.update_business_tax_return(struct, params)

      assert updated.id                         == struct.id
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
      assert updated.inserted_at                == struct.inserted_at
      assert updated.updated_at                 == struct.updated_at
      assert updated.user_id                    == user.id

      assert updated.user.active      == user.active
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.role        == user.role
      assert updated.user.provider    == user.provider
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip
      assert updated.user.inserted_at == user.inserted_at
      assert updated.user.updated_at  == user.updated_at

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
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

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
        user_id:                                   user.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Services.update_business_tax_return(business_tax_return, params)

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
      assert updated.user_id                    == user.id

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
      struct = insert(:tp_business_tax_return, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_tax_return!(struct.id)
      assert {:error, %Ecto.Changeset{}} !=
        Services.update_business_tax_return(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_tax_return/1 deletes the business_tax_return" do
      user = insert(:tp_user)
      struct = insert(:tp_business_tax_return, user: user)
      assert {:ok, %BusinessTaxReturn{}} =
        Services.delete_business_tax_return(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_tax_return!(struct.id)
      end
    end

    test "change_business_tax_return/1 returns a business_tax_return changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_business_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Services.change_business_tax_return(struct)
    end
  end

  describe "business_tax_returns via role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = BusinessTaxReturn.changeset(%BusinessTaxReturn{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
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
      struct = insert(:pro_business_tax_return, user: user)
      [data] = Services.list_business_tax_return()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_tax_return!/1 returns the business_tax_return with given id" do
      struct = insert(:pro_business_tax_return)
      data = Services.get_business_tax_return!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
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
        Services.create_business_tax_return(params)

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

      assert loaded.user.active      == user.active
      assert loaded.user.avatar      == user.avatar
      assert loaded.user.bio         == user.bio
      assert loaded.user.birthday    == user.birthday
      assert loaded.user.email       == user.email
      assert loaded.user.first_name  == user.first_name
      assert loaded.user.init_setup  == user.init_setup
      assert loaded.user.last_name   == user.last_name
      assert loaded.user.middle_name == user.middle_name
      assert loaded.user.phone       == user.phone
      assert loaded.user.role        == user.role
      assert loaded.user.provider    == user.provider
      assert loaded.user.sex         == user.sex
      assert loaded.user.ssn         == user.ssn
      assert loaded.user.street      == user.street
      assert loaded.user.zip         == user.zip
      assert loaded.user.inserted_at == user.inserted_at
      assert loaded.user.updated_at  == user.updated_at

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

      assert {:error, %Ecto.Changeset{}} = Services.create_business_tax_return(params)
    end

    test "create_business_tax_return/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_tax_return(params)
    end

    test "update_business_tax_return/2 with valid data updates the business_tax_return" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        none_expat:   true,
        price_state:    33,
        price_tax_year: 33,
        user_id:   user.id
      }

      assert {:ok, %BusinessTaxReturn{} = updated} =
        Services.update_business_tax_return(business_tax_return, params)

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
      assert updated.user_id                    == user.id

      assert updated.user.active      == user.active
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.role        == user.role
      assert updated.user.provider    == user.provider
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip
      assert updated.user.inserted_at == user.inserted_at
      assert updated.user.updated_at  == user.updated_at

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
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        accounting_software: false,
        capital_asset_sale: false,
        church_hospital: false,
        dispose_asset: false,
        none_expat:   true,
        price_state:    33,
        price_tax_year: 33,
        user_id:   user.id
      }

      assert {:ok, %BusinessTaxReturn{} = business_tax_return} =
        Services.update_business_tax_return(business_tax_return, params)

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
      assert updated.user_id                    == user.id

      assert updated.user.active      == user.active
      assert updated.user.avatar      == user.avatar
      assert updated.user.bio         == user.bio
      assert updated.user.birthday    == user.birthday
      assert updated.user.email       == user.email
      assert updated.user.first_name  == user.first_name
      assert updated.user.init_setup  == user.init_setup
      assert updated.user.last_name   == user.last_name
      assert updated.user.middle_name == user.middle_name
      assert updated.user.phone       == user.phone
      assert updated.user.role        == user.role
      assert updated.user.provider    == user.provider
      assert updated.user.sex         == user.sex
      assert updated.user.ssn         == user.ssn
      assert updated.user.street      == user.street
      assert updated.user.zip         == user.zip
      assert updated.user.inserted_at == user.inserted_at
      assert updated.user.updated_at  == user.updated_at

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
      struct = insert(:pro_business_tax_return, user: user)
      params = %{user_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_tax_return!(struct.id)
      assert {:error, %Ecto.Changeset{}} !=
        Services.update_business_tax_return(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_tax_return/1 deletes the business_tax_return" do
      user = insert(:pro_user)
      struct = insert(:pro_business_tax_return, user: user)
      assert {:ok, %BusinessTaxReturn{}} =
        Services.delete_business_tax_return(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_tax_return!(struct.id)
      end
    end

    test "change_business_tax_return/1 returns a business_tax_return changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_business_tax_return, user: user)
      assert %Ecto.Changeset{} =
        Services.change_business_tax_return(struct)
    end
  end

  defp sort_by_id(values) do
    Enum.sort_by(values, &(&1.id))
  end
end
