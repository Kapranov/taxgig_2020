defmodule Core.Seeder.Services do
  @moduledoc """
  Seeds for `Core.Services` context.
  """

  alias Core.{
    Accounts.User,
    Lookup.State,
    Repo,
    Services.BusinessTaxReturn,
    Services.BusinessEntityType,
    Services.BusinessForeignAccountCount,
    Services.BusinessForeignOwnershipCount,
    Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn,
    Services.MatchValueRelate
  }

  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(BusinessEntityType)
    Repo.delete_all(BusinessForeignAccountCount)
    Repo.delete_all(BusinessForeignOwnershipCount)
    Repo.delete_all(BusinessLlcType)
    Repo.delete_all(BusinessNumberEmployee)
    Repo.delete_all(BusinessTaxReturn)
    Repo.delete_all(BusinessTotalRevenue)
    Repo.delete_all(BusinessTransactionCount)
    Repo.delete_all(IndividualEmploymentStatus)
    Repo.delete_all(IndividualFilingStatus)
    Repo.delete_all(IndividualForeignAccountCount)
    Repo.delete_all(IndividualItemizedDeduction)
    Repo.delete_all(IndividualStockTransactionCount)
    Repo.delete_all(IndividualTaxReturn)
    Repo.delete_all(MatchValueRelate)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_match_value_relate()
    seed_business_tax_return()
    seed_business_entity_type()
    seed_business_foreign_account_count()
    seed_business_foreign_ownership_count()
    seed_business_llc_type()
    seed_business_number_employee()
    seed_business_total_revenue()
    seed_business_transaction_count()
    seed_individual_tax_return()
    seed_individual_employment_status()
    seed_individual_filing_status()
    seed_individual_foreign_account_count()
    seed_individual_itemized_deduction()
    seed_individual_stock_transaction_count()
  end

  @spec seed_match_value_relate() :: nil | Ecto.Schema.t()
  defp seed_match_value_relate do
    case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
      true -> nil
      false -> insert_match_value_relate()
    end
  end

  @spec insert_match_value_relate() :: Ecto.Schema.t()
  defp insert_match_value_relate do
    [
      Repo.insert!(%MatchValueRelate{
        match_for_book_keeping_additional_need:             20,
        match_for_book_keeping_annual_revenue:              25,
        match_for_book_keeping_industry:                    10,
        match_for_book_keeping_number_employee:             25,
        match_for_book_keeping_payroll:                     20,
        match_for_book_keeping_type_client:                 60,
        match_for_business_enity_type:                      50,
        match_for_business_number_of_employee:              20,
        match_for_business_total_revenue:                   20,
        match_for_individual_employment_status:             35,
        match_for_individual_filing_status:                 50,
        match_for_individual_foreign_account:               20,
        match_for_individual_home_owner:                    20,
        match_for_individual_itemized_deduction:            20,
        match_for_individual_living_abroad:                 20,
        match_for_individual_non_resident_earning:          20,
        match_for_individual_own_stock_crypto:              20,
        match_for_individual_rental_prop_income:            20,
        match_for_individual_stock_divident:                20,
        match_for_sale_tax_count:                           50,
        match_for_sale_tax_frequency:                       10,
        match_for_sale_tax_industry:                        10,
        value_for_book_keeping_payroll:                   80.0,
        value_for_book_keeping_tax_year:                 150.0,
        value_for_business_accounting_software:          29.99,
        value_for_business_dispose_property:             99.99,
        value_for_business_foreign_shareholder:          150.0,
        value_for_business_income_over_thousand:         99.99,
        value_for_business_invest_research:               20.0,
        value_for_business_k1_count:                       6.0,
        value_for_business_make_distribution:             20.0,
        value_for_business_state:                         50.0,
        value_for_business_tax_exemption:                400.0,
        value_for_business_total_asset_over:             150.0,
        value_for_individual_employment_status:          180.0,
        value_for_individual_foreign_account_limit:      199.0,
        value_for_individual_foreign_financial_interest: 299.0,
        value_for_individual_home_owner:                 120.0,
        value_for_individual_k1_count:                   17.99,
        value_for_individual_rental_prop_income:          30.0,
        value_for_individual_sole_prop_count:            180.0,
        value_for_individual_state:                       40.0,
        value_for_individual_tax_year:                    40.0,
        value_for_sale_tax_count:                         30.0
      })
    ]
  end

  @spec seed_business_tax_return() :: Ecto.Schema.t()
  defp seed_business_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user_id} = {Enum.at(user_ids, 0)}

     tp1 = User.find_by(email: "v.kobzan@gmail.com")
     tp2 = User.find_by(email: "o.puryshev@gmail.com")
     tp3 = User.find_by(email: "vlacho777@gmail.com")
    pro1 = User.find_by(email: "support@taxgig.com")
    pro2 = User.find_by(email: "op@taxgig.com")
    pro3 = User.find_by(email: "vk@taxgig.com")

    case Repo.aggregate(BusinessTaxReturn, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessTaxReturn{
            accounting_software: random_boolean(),
            capital_asset_sale: random_boolean(),
            church_hospital: random_boolean(),
            dispose_asset: random_boolean(),
            dispose_property: random_boolean(),
            educational_facility: random_boolean(),
            financial_situation: Lorem.sentence(),
            foreign_account_interest: random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest: random_boolean(),
            foreign_partner_count: random_integer(),
            foreign_shareholder: random_boolean(),
            foreign_value: random_boolean(),
            fundraising_over: random_boolean(),
            has_contribution: random_boolean(),
            has_loan: random_boolean(),
            income_over_thousand: random_boolean(),
            invest_research: random_boolean(),
            k1_count: random_integer(),
            lobbying: random_boolean(),
            make_distribution: random_boolean(),
            none_expat: random_boolean(),
            operate_facility: random_boolean(),
            price_state: random_integer(),
            price_tax_year: random_integer(),
            property_sale: random_boolean(),
            public_charity: random_boolean(),
            rental_property_count: random_integer(),
            reported_grant: random_boolean(),
            restricted_donation: random_boolean(),
            tax_exemption: random_boolean(),
            tax_year: random_year(),
            total_asset_less: random_boolean(),
            total_asset_over: random_boolean(),
            user_id: user_id
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software: random_boolean(),
            capital_asset_sale: random_boolean(),
            church_hospital: random_boolean(),
            dispose_asset: random_boolean(),
            dispose_property: random_boolean(),
            educational_facility: random_boolean(),
            financial_situation: Lorem.sentence(),
            foreign_account_interest: random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest: random_boolean(),
            foreign_partner_count: random_integer(),
            foreign_shareholder: random_boolean(),
            foreign_value: random_boolean(),
            fundraising_over: random_boolean(),
            has_contribution: random_boolean(),
            has_loan: random_boolean(),
            income_over_thousand: random_boolean(),
            invest_research: random_boolean(),
            k1_count: random_integer(),
            lobbying: random_boolean(),
            make_distribution: random_boolean(),
            none_expat: random_boolean(),
            operate_facility: random_boolean(),
            price_state: random_integer(),
            price_tax_year: random_integer(),
            property_sale: random_boolean(),
            public_charity: random_boolean(),
            rental_property_count: random_integer(),
            reported_grant: random_boolean(),
            restricted_donation: random_boolean(),
            state: random_state(),
            tax_exemption: random_boolean(),
            tax_year: random_year(),
            total_asset_less: random_boolean(),
            total_asset_over: random_boolean(),
            user_id: tp1.id
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software: random_boolean(),
            capital_asset_sale: random_boolean(),
            church_hospital: random_boolean(),
            dispose_asset: random_boolean(),
            dispose_property: random_boolean(),
            educational_facility: random_boolean(),
            financial_situation: Lorem.sentence(),
            foreign_account_interest: random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest: random_boolean(),
            foreign_partner_count: random_integer(),
            foreign_shareholder: random_boolean(),
            foreign_value: random_boolean(),
            fundraising_over: random_boolean(),
            has_contribution: random_boolean(),
            has_loan: random_boolean(),
            income_over_thousand: random_boolean(),
            invest_research: random_boolean(),
            k1_count: random_integer(),
            lobbying: random_boolean(),
            make_distribution: random_boolean(),
            none_expat: random_boolean(),
            operate_facility: random_boolean(),
            price_state: random_integer(),
            price_tax_year: random_integer(),
            property_sale: random_boolean(),
            public_charity: random_boolean(),
            rental_property_count: random_integer(),
            reported_grant: random_boolean(),
            restricted_donation: random_boolean(),
            state: random_state(),
            tax_exemption: random_boolean(),
            tax_year: random_year(),
            total_asset_less: random_boolean(),
            total_asset_over: random_boolean(),
            user_id: tp2.id
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software: random_boolean(),
            capital_asset_sale: random_boolean(),
            church_hospital: random_boolean(),
            dispose_asset: random_boolean(),
            dispose_property: random_boolean(),
            educational_facility: random_boolean(),
            financial_situation: Lorem.sentence(),
            foreign_account_interest: random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest: random_boolean(),
            foreign_partner_count: random_integer(),
            foreign_shareholder: random_boolean(),
            foreign_value: random_boolean(),
            fundraising_over: random_boolean(),
            has_contribution: random_boolean(),
            has_loan: random_boolean(),
            income_over_thousand: random_boolean(),
            invest_research: random_boolean(),
            k1_count: random_integer(),
            lobbying: random_boolean(),
            make_distribution: random_boolean(),
            none_expat: random_boolean(),
            operate_facility: random_boolean(),
            price_state: random_integer(),
            price_tax_year: random_integer(),
            property_sale: random_boolean(),
            public_charity: random_boolean(),
            rental_property_count: random_integer(),
            reported_grant: random_boolean(),
            restricted_donation: random_boolean(),
            state: random_state(),
            tax_exemption: random_boolean(),
            tax_year: random_year(),
            total_asset_less: random_boolean(),
            total_asset_over: random_boolean(),
            user_id: tp3.id
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software: random_boolean(),
            capital_asset_sale: random_boolean(),
            church_hospital: random_boolean(),
            dispose_asset: random_boolean(),
            dispose_property: random_boolean(),
            educational_facility: random_boolean(),
            financial_situation: Lorem.sentence(),
            foreign_account_interest: random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest: random_boolean(),
            foreign_partner_count: random_integer(),
            foreign_shareholder: random_boolean(),
            foreign_value: random_boolean(),
            fundraising_over: random_boolean(),
            has_contribution: random_boolean(),
            has_loan: random_boolean(),
            income_over_thousand: random_boolean(),
            invest_research: random_boolean(),
            k1_count: random_integer(),
            lobbying: random_boolean(),
            make_distribution: random_boolean(),
            none_expat: random_boolean(),
            operate_facility: random_boolean(),
            price_state: random_integer(),
            price_tax_year: random_integer(),
            property_sale: random_boolean(),
            public_charity: random_boolean(),
            rental_property_count: random_integer(),
            reported_grant: random_boolean(),
            restricted_donation: random_boolean(),
            tax_exemption: random_boolean(),
            tax_year: random_year(),
            total_asset_less: random_boolean(),
            total_asset_over: random_boolean(),
            user_id: pro1.id
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software: random_boolean(),
            capital_asset_sale: random_boolean(),
            church_hospital: random_boolean(),
            dispose_asset: random_boolean(),
            dispose_property: random_boolean(),
            educational_facility: random_boolean(),
            financial_situation: Lorem.sentence(),
            foreign_account_interest: random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest: random_boolean(),
            foreign_partner_count: random_integer(),
            foreign_shareholder: random_boolean(),
            foreign_value: random_boolean(),
            fundraising_over: random_boolean(),
            has_contribution: random_boolean(),
            has_loan: random_boolean(),
            income_over_thousand: random_boolean(),
            invest_research: random_boolean(),
            k1_count: random_integer(),
            lobbying: random_boolean(),
            make_distribution: random_boolean(),
            none_expat: random_boolean(),
            operate_facility: random_boolean(),
            price_state: random_integer(),
            price_tax_year: random_integer(),
            property_sale: random_boolean(),
            public_charity: random_boolean(),
            rental_property_count: random_integer(),
            reported_grant: random_boolean(),
            restricted_donation: random_boolean(),
            tax_exemption: random_boolean(),
            tax_year: random_year(),
            total_asset_less: random_boolean(),
            total_asset_over: random_boolean(),
            user_id: pro2.id
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software: random_boolean(),
            capital_asset_sale: random_boolean(),
            church_hospital: random_boolean(),
            dispose_asset: random_boolean(),
            dispose_property: random_boolean(),
            educational_facility: random_boolean(),
            financial_situation: Lorem.sentence(),
            foreign_account_interest: random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest: random_boolean(),
            foreign_partner_count: random_integer(),
            foreign_shareholder: random_boolean(),
            foreign_value: random_boolean(),
            fundraising_over: random_boolean(),
            has_contribution: random_boolean(),
            has_loan: random_boolean(),
            income_over_thousand: random_boolean(),
            invest_research: random_boolean(),
            k1_count: random_integer(),
            lobbying: random_boolean(),
            make_distribution: random_boolean(),
            none_expat: random_boolean(),
            operate_facility: random_boolean(),
            price_state: random_integer(),
            price_tax_year: random_integer(),
            property_sale: random_boolean(),
            public_charity: random_boolean(),
            rental_property_count: random_integer(),
            reported_grant: random_boolean(),
            restricted_donation: random_boolean(),
            tax_exemption: random_boolean(),
            tax_year: random_year(),
            total_asset_less: random_boolean(),
            total_asset_over: random_boolean(),
            user_id: pro3.id
          })
        ]
    end
  end

  @spec seed_business_entity_type() :: Ecto.Schema.t()
  defp seed_business_entity_type do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7} =
      {
        Enum.at(business_tax_returns_ids, 0),
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3),
        Enum.at(business_tax_returns_ids, 4),
        Enum.at(business_tax_returns_ids, 5),
        Enum.at(business_tax_returns_ids, 6)
      }

    case Repo.aggregate(BusinessEntityType, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id: btr1,
            name: random_name_entity_type(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id: btr2,
            name: random_name_entity_type()
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id: btr3,
            name: random_name_entity_type()
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id: btr4,
            name: random_name_entity_type()
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id: btr5,
            name: random_name_entity_type(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id: btr6,
            name: random_name_entity_type(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id: btr7,
            name: random_name_entity_type(),
            price: Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_business_foreign_account_count() :: Ecto.Schema.t()
  defp seed_business_foreign_account_count do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7} =
      {
        Enum.at(business_tax_returns_ids, 0),
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3),
        Enum.at(business_tax_returns_ids, 4),
        Enum.at(business_tax_returns_ids, 5),
        Enum.at(business_tax_returns_ids, 6)
      }

    case Repo.aggregate(BusinessForeignAccountCount, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr1,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr2,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr3,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr4,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr5,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr6,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr7,
            name: random_name_foreign_account_count()
          })
        ]
    end
  end

  @spec seed_business_foreign_ownership_count() :: Ecto.Schema.t()
  defp seed_business_foreign_ownership_count do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7} =
      {
        Enum.at(business_tax_returns_ids, 0),
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3),
        Enum.at(business_tax_returns_ids, 4),
        Enum.at(business_tax_returns_ids, 5),
        Enum.at(business_tax_returns_ids, 6)
      }

    case Repo.aggregate(BusinessForeignOwnershipCount, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr1,
            name: random_name_foreign_ownership_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr2,
            name: random_name_foreign_ownership_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr3,
            name: random_name_foreign_ownership_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr4,
            name: random_name_foreign_ownership_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr5,
            name: random_name_foreign_ownership_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr6,
            name: random_name_foreign_ownership_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr7,
            name: random_name_foreign_ownership_count()
          })
        ]
    end
  end

  @spec seed_business_llc_type() :: Ecto.Schema.t()
  defp seed_business_llc_type do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7} =
      {
        Enum.at(business_tax_returns_ids, 0),
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3),
        Enum.at(business_tax_returns_ids, 4),
        Enum.at(business_tax_returns_ids, 5),
        Enum.at(business_tax_returns_ids, 6)
      }

    case Repo.aggregate(BusinessLlcType, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessLlcType{
            business_tax_return_id: btr1,
            name: random_name_llc_type()
          }),
          Repo.insert!(%BusinessLlcType{
            business_tax_return_id: btr2,
            name: random_name_llc_type()
          }),
          Repo.insert!(%BusinessLlcType{
            business_tax_return_id: btr3,
            name: random_name_llc_type()
          }),
          Repo.insert!(%BusinessLlcType{
            business_tax_return_id: btr4,
            name: random_name_llc_type()
          }),
          Repo.insert!(%BusinessLlcType{
            business_tax_return_id: btr5,
            name: random_name_llc_type()
          }),
          Repo.insert!(%BusinessLlcType{
            business_tax_return_id: btr6,
            name: random_name_llc_type()
          }),
          Repo.insert!(%BusinessLlcType{
            business_tax_return_id: btr7,
            name: random_name_llc_type()
          })
        ]
    end
  end
  @spec seed_business_number_employee() :: Ecto.Schema.t()
  defp seed_business_number_employee do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7} =
      {
        Enum.at(business_tax_returns_ids, 0),
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3),
        Enum.at(business_tax_returns_ids, 4),
        Enum.at(business_tax_returns_ids, 5),
        Enum.at(business_tax_returns_ids, 6)
      }

    case Repo.aggregate(BusinessNumberEmployee, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr1,
            name: random_name_number_of_employee(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr2,
            name: random_name_number_of_employee()
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr3,
            name: random_name_number_of_employee()
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr4,
            name: random_name_number_of_employee()
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr5,
            name: random_name_number_of_employee(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr6,
            name: random_name_number_of_employee(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr7,
            name: random_name_number_of_employee(),
            price: Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_business_total_revenue() :: Ecto.Schema.t()
  defp seed_business_total_revenue do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7} =
      {
        Enum.at(business_tax_returns_ids, 0),
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3),
        Enum.at(business_tax_returns_ids, 4),
        Enum.at(business_tax_returns_ids, 5),
        Enum.at(business_tax_returns_ids, 6)
      }

    case Repo.aggregate(BusinessTotalRevenue, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr1,
            name: random_name_total_revenue(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr2,
            name: random_name_total_revenue()
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr3,
            name: random_name_total_revenue()
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr4,
            name: random_name_total_revenue()
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr5,
            name: random_name_total_revenue(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr6,
            name: random_name_total_revenue(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr7,
            name: random_name_total_revenue(),
            price: Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_business_transaction_count() :: Ecto.Schema.t()
  defp seed_business_transaction_count do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7} =
      {
        Enum.at(business_tax_returns_ids, 0),
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3),
        Enum.at(business_tax_returns_ids, 4),
        Enum.at(business_tax_returns_ids, 5),
        Enum.at(business_tax_returns_ids, 6)
      }

    case Repo.aggregate(BusinessTransactionCount, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id: btr1,
            name: random_name_transactions_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id: btr2,
            name: random_name_transactions_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id: btr3,
            name: random_name_transactions_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id: btr4,
            name: random_name_transactions_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id: btr5,
            name: random_name_transactions_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id: btr6,
            name: random_name_transactions_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id: btr7,
            name: random_name_transactions_count()
          })
        ]
    end
  end

  @spec seed_individual_tax_return() :: Ecto.Schema.t()
  defp seed_individual_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user_id} = {Enum.at(user_ids, 0)}

     tp1 = User.find_by(email: "v.kobzan@gmail.com")
     tp2 = User.find_by(email: "o.puryshev@gmail.com")
     tp3 = User.find_by(email: "vlacho777@gmail.com")
    pro1 = User.find_by(email: "support@taxgig.com")
    pro2 = User.find_by(email: "op@taxgig.com")
    pro3 = User.find_by(email: "vk@taxgig.com")

    case Repo.aggregate(IndividualTaxReturn, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%IndividualTaxReturn{
            foreign_account: random_boolean(),
            foreign_account_limit: random_boolean(),
            foreign_financial_interest: random_boolean(),
            home_owner: random_boolean(),
            k1_count: random_integer(),
            k1_income: random_boolean(),
            living_abroad: random_boolean(),
            non_resident_earning: random_boolean(),
            own_stock_crypto: random_boolean(),
            rental_property_count: random_integer(),
            rental_property_income: random_boolean(),
            sole_proprietorship_count: random_integer(),
            state: random_state(),
            stock_divident: random_boolean(),
            tax_year: random_year(),
            user_id: user_id
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account: true,
            foreign_account_limit: true,
            foreign_financial_interest: true,
            home_owner: true,
            k1_count: 10,
            k1_income: true,
            living_abroad: true,
            non_resident_earning: true,
            none_expat: false,
            own_stock_crypto: true,
            rental_property_count: 2,
            rental_property_income: true,
            sole_proprietorship_count: 3,
            state: ["Alabama", "Ohio", "New York"],
            stock_divident: true,
            tax_year: ["2018", "2017", "2016"],
            user_id: tp1.id
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account: true,
            foreign_account_limit: false,
            foreign_financial_interest: true,
            home_owner: false,
            k1_count: 2,
            k1_income: true,
            living_abroad: true,
            non_resident_earning: false,
            none_expat: false,
            own_stock_crypto: false,
            rental_property_count: 5,
            rental_property_income: true,
            sole_proprietorship_count: 1,
            state: ["Alabama", "Iowa"],
            stock_divident: false,
            tax_year: ["2018"],
            user_id: tp2.id
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account: true,
            foreign_account_limit: false,
            foreign_financial_interest: true,
            home_owner: true,
            k1_count: 0,
            k1_income: false,
            living_abroad: true,
            non_resident_earning: true,
            none_expat: false,
            own_stock_crypto: true,
            rental_property_count: 10,
            rental_property_income: false,
            sole_proprietorship_count: 9,
            state: ["Alabama", "Ohio", "New York", "Iowa", "New Jersey", "New Mexico"],
            stock_divident: true,
            tax_year: ["2018", "2017", "2016", "2015", "2019"],
            user_id: tp3.id
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account: false,
            home_owner: true,
            living_abroad: false,
            non_resident_earning: false,
            own_stock_crypto: false,
            price_home_owner: 80,
            price_rental_property_income: 150,
            price_sole_proprietorship_count: 100,
            price_state: 20,
            price_tax_year: 10,
            rental_property_income: true,
            stock_divident: false,
            user_id: pro1.id
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account: true,
            home_owner: true,
            living_abroad: true,
            non_resident_earning: true,
            own_stock_crypto: true,
            price_foreign_account: 250,
            price_home_owner: 120,
            price_living_abroad: 180,
            price_non_resident_earning: 500,
            price_own_stock_crypto: 255,
            price_rental_property_income: 345,
            price_sole_proprietorship_count: 165,
            price_state: 45,
            price_stock_divident: 185,
            price_tax_year: 50,
            rental_property_income: true,
            stock_divident: true,
            user_id: pro2.id
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account: false,
            home_owner: true,
            living_abroad: false,
            non_resident_earning: false,
            own_stock_crypto: true,
            price_home_owner: 85,
            price_own_stock_crypto: 135,
            price_rental_property_income: 75,
            price_state: 12,
            price_stock_divident: 115,
            price_tax_year: 10,
            rental_property_income: true,
            stock_divident: true,
            user_id: pro3.id
          }),
        ]
    end
  end

  @spec seed_individual_employment_status() :: Ecto.Schema.t()
  defp seed_individual_employment_status do
    individual_tax_returns_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7} =
      {
        Enum.at(individual_tax_returns_ids, 0),
        Enum.at(individual_tax_returns_ids, 1),
        Enum.at(individual_tax_returns_ids, 2),
        Enum.at(individual_tax_returns_ids, 3),
        Enum.at(individual_tax_returns_ids, 4),
        Enum.at(individual_tax_returns_ids, 5),
        Enum.at(individual_tax_returns_ids, 6)
      }

    case Repo.aggregate(IndividualEmploymentStatus, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id: itr1,
            name: random_name_employment_status(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id: itr2,
            name: random_name_employment_status()
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id: itr3,
            name: random_name_employment_status()
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id: itr4,
            name: random_name_employment_status()
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id: itr5,
            name: random_name_employment_status(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id: itr6,
            name: random_name_employment_status(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id: itr7,
            name: random_name_employment_status(),
            price: Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_individual_filing_status() :: Ecto.Schema.t()
  defp seed_individual_filing_status do
    individual_tax_returns_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7} =
      {
        Enum.at(individual_tax_returns_ids, 0),
        Enum.at(individual_tax_returns_ids, 1),
        Enum.at(individual_tax_returns_ids, 2),
        Enum.at(individual_tax_returns_ids, 3),
        Enum.at(individual_tax_returns_ids, 4),
        Enum.at(individual_tax_returns_ids, 5),
        Enum.at(individual_tax_returns_ids, 6)
      }

      case Repo.aggregate(IndividualFilingStatus, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id: itr1,
            name: random_name_filling_status(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id: itr2,
            name: random_name_filling_status()
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id: itr3,
            name: random_name_filling_status()
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id: itr4,
            name: "Head of Household"
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id: itr5,
            name: random_name_filling_status(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id: itr6,
            name: random_name_filling_status(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id: itr7,
            name: random_name_filling_status(),
            price: Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_individual_foreign_account_count() :: Ecto.Schema.t()
  defp seed_individual_foreign_account_count do
    individual_tax_returns_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7} =
      {
        Enum.at(individual_tax_returns_ids, 0),
        Enum.at(individual_tax_returns_ids, 1),
        Enum.at(individual_tax_returns_ids, 2),
        Enum.at(individual_tax_returns_ids, 3),
        Enum.at(individual_tax_returns_ids, 4),
        Enum.at(individual_tax_returns_ids, 5),
        Enum.at(individual_tax_returns_ids, 6)
      }

    case Repo.aggregate(IndividualForeignAccountCount, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr1,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr2,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr3,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr4,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr5,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr6,
            name: random_name_foreign_account_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr7,
            name: random_name_foreign_account_count()
          })
        ]
    end
  end

  @spec seed_individual_itemized_deduction() :: Ecto.Schema.t()
  defp seed_individual_itemized_deduction do
    individual_tax_returns_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7} =
      {
        Enum.at(individual_tax_returns_ids, 0),
        Enum.at(individual_tax_returns_ids, 1),
        Enum.at(individual_tax_returns_ids, 2),
        Enum.at(individual_tax_returns_ids, 3),
        Enum.at(individual_tax_returns_ids, 4),
        Enum.at(individual_tax_returns_ids, 5),
        Enum.at(individual_tax_returns_ids, 6)
      }

    case Repo.aggregate(IndividualItemizedDeduction, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id: itr1,
            name: random_name_itemized_deduction(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id: itr2,
            name: random_name_itemized_deduction()
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id: itr3,
            name: random_name_itemized_deduction()
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id: itr4,
            name: random_name_itemized_deduction()
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id: itr5,
            name: random_name_itemized_deduction(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id: itr6,
            name: random_name_itemized_deduction(),
            price: Enum.random(1..99)
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id: itr7,
            name: random_name_itemized_deduction(),
            price: Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_individual_stock_transaction_count() :: Ecto.Schema.t()
  defp seed_individual_stock_transaction_count do
    individual_tax_returns_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7} =
      {
        Enum.at(individual_tax_returns_ids, 0),
        Enum.at(individual_tax_returns_ids, 1),
        Enum.at(individual_tax_returns_ids, 2),
        Enum.at(individual_tax_returns_ids, 3),
        Enum.at(individual_tax_returns_ids, 4),
        Enum.at(individual_tax_returns_ids, 5),
        Enum.at(individual_tax_returns_ids, 6)
      }

    case Repo.aggregate(IndividualStockTransactionCount, :count, :id) > 0 do
      true ->
        nil
      false ->
        [
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id: itr1,
            name: random_name_stock_transaction_count()
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id: itr2,
            name: "6-50"
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id: itr3,
            name: "51-100"
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id: itr4,
            name: "100+"
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id: itr5,
            name: "51-100"
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id: itr6,
            name: "6-50"
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id: itr7,
            name: "1-5"
          })
        ]
    end
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_integer() :: integer()
  defp random_integer(n \\ 99) do
    Enum.random(1..n)
  end

  @spec random_state() :: String.t()
  defp random_state do
    name =
      Enum.map(Repo.all(State), fn(data) -> data.name end)

    numbers = 1..9
    number = Enum.random(numbers)

    for i <- 1..number, i > 0 do
      Enum.random(name)
      |> to_string
    end
    |> Enum.uniq()
  end

  @spec random_year() :: String.t()
  defp random_year do
    years = 2010..2020
    numbers = 1..9
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(years)
        |> Integer.to_string
      end

    Enum.uniq(result)
  end

  @spec random_name_entity_type() :: String.t()
  defp random_name_entity_type do
    names = [
      "C-Corp / Corporation",
      "LLC",
      "Non-profit corp",
      "Partnership",
      "S-Corp",
      "Sole proprietorship"
    ]

    Enum.random(names)
  end

  @spec random_name_foreign_ownership_count() :: String.t()
  defp random_name_foreign_ownership_count do
    names = [
      "1",
      "2-5",
      "5+"
    ]

    Enum.random(names)
  end

  @spec random_name_llc_type() :: String.t()
  defp random_name_llc_type do
    names = [
      "C-Corp / Corporation",
      "LLC",
      "Non-profit corp",
      "Partnership",
      "S-Corp"
    ]

    Enum.random(names)
  end

  @spec random_name_number_of_employee() :: String.t()
  defp random_name_number_of_employee do
    names = [
      "1 employee",
      "101 - 500 employees",
      "2 - 20 employees",
      "21 - 50 employees",
      "500+ employee",
      "51 - 100 employees"
    ]

    Enum.random(names)
  end

  @spec random_name_total_revenue() :: String.t()
  defp random_name_total_revenue do
    names = [
      "$100K - $500K",
      "$10M+",
      "$1M - $5M",
      "$500K - $1M",
      "$5M - $10M",
      "Less than $100K"
    ]

    Enum.random(names)
  end

  @spec random_name_transactions_count() :: String.t()
  defp random_name_transactions_count do
    names = [
      "1-10",
      "11-25",
      "26-75",
      "75+"
    ]

    Enum.random(names)
  end

  @spec random_name_employment_status() :: String.t()
  defp random_name_employment_status do
    names = [
      "employed",
      "self-employed",
      "unemployed"
    ]

    Enum.random(names)
  end

  @spec random_name_filling_status() :: String.t()
  defp random_name_filling_status do
    names = [
      "Head of Household",
      "Married filing jointly",
      "Married filing separately",
      "Qualifying widow(-er) with dependent child",
      "Single"
    ]

    Enum.random(names)
  end

  @spec random_name_foreign_account_count() :: String.t()
  defp random_name_foreign_account_count do
    names = [
      "1",
      "2-5",
      "5+"
    ]

    Enum.random(names)
  end

  @spec random_name_itemized_deduction() :: String.t()
  defp random_name_itemized_deduction do
    names = [
      "Charitable contributions",
      "Health insurance",
      "Medical and dental expenses"
    ]

    Enum.random(names)
  end

  @spec random_name_stock_transaction_count() :: String.t()
  defp random_name_stock_transaction_count do
    names = [
      "1-5",
      "100+",
      "51-100",
      "6-50"
    ]

    Enum.random(names)
  end
end
