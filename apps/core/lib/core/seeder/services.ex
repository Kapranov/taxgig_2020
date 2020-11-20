defmodule Core.Seeder.Services do
  @moduledoc """
  Seeds for `Core.Services` context.
  """

  alias Core.{
    Accounts.User,
    Contracts.Project,
    Lookup.State,
    Repo,
    Services.BookKeeping,
    Services.BookKeepingAdditionalNeed,
    Services.BookKeepingAnnualRevenue,
    Services.BookKeepingClassifyInventory,
    Services.BookKeepingIndustry,
    Services.BookKeepingNumberEmployee,
    Services.BookKeepingTransactionVolume,
    Services.BookKeepingTypeClient,
    Services.BusinessEntityType,
    Services.BusinessForeignAccountCount,
    Services.BusinessForeignOwnershipCount,
    Services.BusinessIndustry,
    Services.BusinessLlcType,
    Services.BusinessNumberEmployee,
    Services.BusinessTaxReturn,
    Services.BusinessTotalRevenue,
    Services.BusinessTransactionCount,
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualIndustry,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn,
    Services.MatchValueRelate,
    Services.SaleTax,
    Services.SaleTaxFrequency,
    Services.SaleTaxIndustry,
    Services.ServiceLink
  }

  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    Repo.delete_all(BookKeeping)
    Repo.delete_all(BookKeepingAdditionalNeed)
    Repo.delete_all(BookKeepingAnnualRevenue)
    Repo.delete_all(BookKeepingClassifyInventory)
    Repo.delete_all(BookKeepingIndustry)
    Repo.delete_all(BookKeepingNumberEmployee)
    Repo.delete_all(BookKeepingTransactionVolume)
    Repo.delete_all(BookKeepingTypeClient)
    Repo.delete_all(BusinessEntityType)
    Repo.delete_all(BusinessForeignAccountCount)
    Repo.delete_all(BusinessForeignOwnershipCount)
    Repo.delete_all(BusinessIndustry)
    Repo.delete_all(BusinessLlcType)
    Repo.delete_all(BusinessNumberEmployee)
    Repo.delete_all(BusinessTaxReturn)
    Repo.delete_all(BusinessTotalRevenue)
    Repo.delete_all(BusinessTransactionCount)
    Repo.delete_all(IndividualEmploymentStatus)
    Repo.delete_all(IndividualFilingStatus)
    Repo.delete_all(IndividualForeignAccountCount)
    Repo.delete_all(IndividualIndustry)
    Repo.delete_all(IndividualItemizedDeduction)
    Repo.delete_all(IndividualStockTransactionCount)
    Repo.delete_all(IndividualTaxReturn)
    Repo.delete_all(MatchValueRelate)
    Repo.delete_all(SaleTax)
    Repo.delete_all(SaleTaxFrequency)
    Repo.delete_all(SaleTaxIndustry)
    Repo.delete_all(ServiceLink)
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_match_value_relate()
    seed_book_keeping()
    seed_business_tax_return()
    seed_individual_tax_return()
    seed_sale_tax()
    seed_book_keeping_additional_need()
    seed_book_keeping_annual_revenue()
    seed_book_keeping_classify_inventory()
    seed_book_keeping_industry()
    seed_book_keeping_number_employee()
    seed_book_keeping_transaction_volume()
    seed_book_keeping_type_client()
    seed_business_entity_type()
    seed_business_foreign_account_count()
    seed_business_foreign_ownership_count()
    seed_business_industry()
    seed_business_llc_type()
    seed_business_number_employee()
    seed_business_total_revenue()
    seed_business_transaction_count()
    seed_individual_employment_status()
    seed_individual_filing_status()
    seed_individual_foreign_account_count()
    seed_individual_industry()
    seed_individual_itemized_deduction()
    seed_individual_stock_transaction_count()
    seed_sale_tax_frequency()
    seed_sale_tax_industry()
    seed_service_link()
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
        match_for_book_keeping_additional_need:        random_integer(),
        match_for_book_keeping_annual_revenue:         random_integer(),
        match_for_book_keeping_industry:               random_integer(),
        match_for_book_keeping_number_employee:        random_integer(),
        match_for_book_keeping_payroll:                random_integer(),
        match_for_book_keeping_type_client:            random_integer(),
        match_for_business_enity_type:                 random_integer(),
        match_for_business_industry:                   random_integer(),
        match_for_business_number_of_employee:         random_integer(),
        match_for_business_total_revenue:              random_integer(),
        match_for_individual_employment_status:        random_integer(),
        match_for_individual_filing_status:            random_integer(),
        match_for_individual_foreign_account:          random_integer(),
        match_for_individual_home_owner:               random_integer(),
        match_for_individual_industry:                 random_integer(),
        match_for_individual_itemized_deduction:       random_integer(),
        match_for_individual_living_abroad:            random_integer(),
        match_for_individual_non_resident_earning:     random_integer(),
        match_for_individual_own_stock_crypto:         random_integer(),
        match_for_individual_rental_prop_income:       random_integer(),
        match_for_individual_stock_divident:           random_integer(),
        match_for_sale_tax_count:                      random_integer(),
        match_for_sale_tax_frequency:                  random_integer(),
        match_for_sale_tax_industry:                   random_integer(),
        value_for_book_keeping_payroll:                  random_float(),
        value_for_book_keeping_tax_year:                 random_float(),
        value_for_business_accounting_software:          random_float(),
        value_for_business_dispose_property:             random_float(),
        value_for_business_foreign_shareholder:          random_float(),
        value_for_business_income_over_thousand:         random_float(),
        value_for_business_invest_research:              random_float(),
        value_for_business_k1_count:                     random_float(),
        value_for_business_make_distribution:            random_float(),
        value_for_business_state:                        random_float(),
        value_for_business_tax_exemption:                random_float(),
        value_for_business_total_asset_over:             random_float(),
        value_for_individual_employment_status:          random_float(),
        value_for_individual_foreign_account_limit:      random_float(),
        value_for_individual_foreign_financial_interest: random_float(),
        value_for_individual_home_owner:                 random_float(),
        value_for_individual_k1_count:                   random_float(),
        value_for_individual_rental_prop_income:         random_float(),
        value_for_individual_sole_prop_count:            random_float(),
        value_for_individual_state:                      random_float(),
        value_for_individual_tax_year:                   random_float(),
        value_for_sale_tax_count:                        random_float()
      })
    ]
  end

  @spec seed_book_keeping() :: Ecto.Schema.t()
  defp seed_book_keeping() do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    case Repo.aggregate(BookKeeping, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeeping{
            payroll:       random_boolean(),
            price_payroll: random_integer(),
            user_id:                   user
          }),
          Repo.insert!(%BookKeeping{
            account_count:       random_integer(),
            balance_sheet:       random_boolean(),
            deadline:            Date.utc_today(),
            financial_situation: Lorem.sentence(),
            inventory:           random_boolean(),
            inventory_count:     random_integer(),
            payroll:             random_boolean(),
            tax_return_current:  random_boolean(),
            tax_year:               random_year(),
            user_id:                          tp1
          }),
          Repo.insert!(%BookKeeping{
            account_count:       random_integer(),
            balance_sheet:       random_boolean(),
            deadline:            Date.utc_today(),
            financial_situation: Lorem.sentence(),
            inventory:           random_boolean(),
            inventory_count:     random_integer(),
            payroll:             random_boolean(),
            tax_return_current:  random_boolean(),
            tax_year:               random_year(),
            user_id:                          tp2
          }),
          Repo.insert!(%BookKeeping{
            account_count:       random_integer(),
            balance_sheet:       random_boolean(),
            deadline:            Date.utc_today(),
            financial_situation: Lorem.sentence(),
            inventory:           random_boolean(),
            inventory_count:     random_integer(),
            payroll:             random_boolean(),
            tax_return_current:  random_boolean(),
            tax_year:               random_year(),
            user_id:                          tp3
          }),
          Repo.insert!(%BookKeeping{
            payroll:       random_boolean(),
            price_payroll: random_integer(),
            user_id:                   pro1
          }),
          Repo.insert!(%BookKeeping{
            payroll:       random_boolean(),
            price_payroll: random_integer(),
            user_id:                   pro2
          }),
          Repo.insert!(%BookKeeping{
            payroll:       random_boolean(),
            price_payroll: random_integer(),
            user_id:                   pro3
          })
        ]
    end
  end

  @spec seed_book_keeping_additional_need() :: Ecto.Schema.t()
  defp seed_book_keeping_additional_need() do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7} =
      {
        Enum.at(book_keeping_ids, 0),
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    case Repo.aggregate(BookKeepingAdditionalNeed, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeepingAdditionalNeed{
            book_keeping_id:                bk1,
            name: random_name_additional_need(),
            price:             random_integer()
          }),
          Repo.insert!(%BookKeepingAdditionalNeed{
            book_keeping_id:                bk2,
            name: random_name_additional_need()
          }),
          Repo.insert!(%BookKeepingAdditionalNeed{
            book_keeping_id:                bk3,
            name: random_name_additional_need()
          }),
          Repo.insert!(%BookKeepingAdditionalNeed{
            book_keeping_id:                bk4,
            name: random_name_additional_need()
          }),
          Repo.insert!(%BookKeepingAdditionalNeed{
            book_keeping_id:                bk5,
            name: random_name_additional_need(),
            price:             random_integer()
          }),
          Repo.insert!(%BookKeepingAdditionalNeed{
            book_keeping_id:                bk6,
            name: random_name_additional_need(),
            price:             random_integer()
          }),
          Repo.insert!(%BookKeepingAdditionalNeed{
            book_keeping_id:                bk7,
            name: random_name_additional_need(),
            price:             random_integer()
          })
        ]
    end
  end

  @spec seed_book_keeping_annual_revenue() :: Ecto.Schema.t()
  defp seed_book_keeping_annual_revenue() do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7} =
      {
        Enum.at(book_keeping_ids, 0),
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    case Repo.aggregate(BookKeepingAnnualRevenue, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeepingAnnualRevenue{
            book_keeping_id:        bk1,
            name: random_name_revenue(),
            price:     random_integer()
          }),
          Repo.insert!(%BookKeepingAnnualRevenue{
            book_keeping_id:        bk2,
            name: random_name_revenue()
          }),
          Repo.insert!(%BookKeepingAnnualRevenue{
            book_keeping_id:        bk3,
            name: random_name_revenue()
          }),
          Repo.insert!(%BookKeepingAnnualRevenue{
            book_keeping_id:        bk4,
            name: random_name_revenue()
          }),
          Repo.insert!(%BookKeepingAnnualRevenue{
            book_keeping_id:        bk5,
            name: random_name_revenue(),
            price:     random_integer()
          }),
          Repo.insert!(%BookKeepingAnnualRevenue{
            book_keeping_id:        bk6,
            name: random_name_revenue(),
            price:     random_integer()
          }),
          Repo.insert!(%BookKeepingAnnualRevenue{
            book_keeping_id:        bk7,
            name: random_name_revenue(),
            price:     random_integer()
          })
        ]
    end
  end

  @spec seed_book_keeping_classify_inventory() :: Ecto.Schema.t()
  defp seed_book_keeping_classify_inventory() do
    book_keepenig_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3} = {
      Enum.at(book_keepenig_ids, 1),
      Enum.at(book_keepenig_ids, 2),
      Enum.at(book_keepenig_ids, 3)
    }

    case Repo.aggregate(BookKeepingClassifyInventory, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeepingClassifyInventory{
            book_keeping_id:                   bk1,
            name: random_name_classify_inventory()
          }),
          Repo.insert!(%BookKeepingClassifyInventory{
            book_keeping_id:                   bk2,
            name: random_name_classify_inventory()
          }),
          Repo.insert!(%BookKeepingClassifyInventory{
            book_keeping_id:                   bk3,
            name: random_name_classify_inventory()
          })
        ]
    end
  end

  @spec seed_book_keeping_industry() :: Ecto.Schema.t()
  defp seed_book_keeping_industry() do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7} =
      {
        Enum.at(book_keeping_ids, 0),
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    case Repo.aggregate(BookKeepingIndustry, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeepingIndustry{
            book_keeping_id:                 bk1,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%BookKeepingIndustry{
            book_keeping_id:                bk2,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%BookKeepingIndustry{
            book_keeping_id:                bk3,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%BookKeepingIndustry{
            book_keeping_id:                bk4,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%BookKeepingIndustry{
            book_keeping_id:                 bk5,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%BookKeepingIndustry{
            book_keeping_id:                 bk6,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%BookKeepingIndustry{
            book_keeping_id:                 bk7,
            name: random_name_for_pro_industry()
          })
        ]
    end
  end

  @spec seed_book_keeping_number_employee() :: Ecto.Schema.t()
  defp seed_book_keeping_number_employee() do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7} =
      {
        Enum.at(book_keeping_ids, 0),
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    case Repo.aggregate(BookKeepingNumberEmployee, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeepingNumberEmployee{
            book_keeping_id:         bk1,
            name: random_name_employee(),
            price:      random_integer()
          }),
          Repo.insert!(%BookKeepingNumberEmployee{
            book_keeping_id:         bk2,
            name: random_name_employee()
          }),
          Repo.insert!(%BookKeepingNumberEmployee{
            book_keeping_id:         bk3,
            name: random_name_employee()
          }),
          Repo.insert!(%BookKeepingNumberEmployee{
            book_keeping_id:         bk4,
            name: random_name_employee()
          }),
          Repo.insert!(%BookKeepingNumberEmployee{
            book_keeping_id:         bk5,
            name: random_name_employee(),
            price:      random_integer()
          }),
          Repo.insert!(%BookKeepingNumberEmployee{
            book_keeping_id:         bk6,
            name: random_name_employee(),
            price:      random_integer()
          }),
          Repo.insert!(%BookKeepingNumberEmployee{
            book_keeping_id:         bk7,
            name: random_name_employee(),
            price:      random_integer()
          })
        ]
    end
  end

  @spec seed_book_keeping_transaction_volume() :: Ecto.Schema.t()
  defp seed_book_keeping_transaction_volume() do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7} =
      {
        Enum.at(book_keeping_ids, 0),
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    case Repo.aggregate(BookKeepingTransactionVolume, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeepingTransactionVolume{
            book_keeping_id:                   bk1,
            name: random_name_transaction_volume(),
            price:                random_integer()
          }),
          Repo.insert!(%BookKeepingTransactionVolume{
            book_keeping_id:                   bk2,
            name: random_name_transaction_volume()
          }),
          Repo.insert!(%BookKeepingTransactionVolume{
            book_keeping_id:                   bk3,
            name: random_name_transaction_volume()
          }),
          Repo.insert!(%BookKeepingTransactionVolume{
            book_keeping_id:                   bk4,
            name: random_name_transaction_volume()
          }),
          Repo.insert!(%BookKeepingTransactionVolume{
            book_keeping_id:                   bk5,
            name: random_name_transaction_volume(),
            price:                random_integer()
          }),
          Repo.insert!(%BookKeepingTransactionVolume{
            book_keeping_id:                   bk6,
            name: random_name_transaction_volume(),
            price:                random_integer()
          }),
          Repo.insert!(%BookKeepingTransactionVolume{
            book_keeping_id:                   bk7,
            name: random_name_transaction_volume(),
            price:                random_integer()
          })
        ]
    end
  end

  @spec seed_book_keeping_type_client() :: Ecto.Schema.t()
  defp seed_book_keeping_type_client() do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7} =
      {
        Enum.at(book_keeping_ids, 0),
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    case Repo.aggregate(BookKeepingTypeClient, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BookKeepingTypeClient{
            book_keeping_id:            bk1,
            name: random_name_type_client(),
            price:         random_integer()
          }),
          Repo.insert!(%BookKeepingTypeClient{
            book_keeping_id:            bk2,
            name: random_name_type_client()
          }),
          Repo.insert!(%BookKeepingTypeClient{
            book_keeping_id:            bk3,
            name: random_name_type_client()
          }),
          Repo.insert!(%BookKeepingTypeClient{
            book_keeping_id:            bk4,
            name: random_name_type_client()
          }),
          Repo.insert!(%BookKeepingTypeClient{
            book_keeping_id:            bk5,
            name: random_name_type_client(),
            price:         random_integer()
          }),
          Repo.insert!(%BookKeepingTypeClient{
            book_keeping_id:            bk6,
            name: random_name_type_client(),
            price:         random_integer()
          }),
          Repo.insert!(%BookKeepingTypeClient{
            book_keeping_id:            bk7,
            name: random_name_type_client(),
            price:         random_integer()
          })
        ]
    end
  end

  @spec seed_business_tax_return() :: Ecto.Schema.t()
  defp seed_business_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    case Repo.aggregate(BusinessTaxReturn, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessTaxReturn{
            none_expat:     random_boolean(),
            price_state:    random_integer(),
            price_tax_year: random_integer(),
            user_id:                    user
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software:        random_boolean(),
            capital_asset_sale:         random_boolean(),
            church_hospital:            random_boolean(),
            deadline:                   Date.utc_today(),
            dispose_asset:              random_boolean(),
            dispose_property:           random_boolean(),
            educational_facility:       random_boolean(),
            financial_situation:        Lorem.sentence(),
            foreign_account_interest:   random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest:    random_boolean(),
            foreign_partner_count:      random_integer(),
            foreign_shareholder:        random_boolean(),
            foreign_value:              random_boolean(),
            fundraising_over:           random_boolean(),
            has_contribution:           random_boolean(),
            has_loan:                   random_boolean(),
            income_over_thousand:       random_boolean(),
            invest_research:            random_boolean(),
            k1_count:                   random_integer(),
            lobbying:                   random_boolean(),
            make_distribution:          random_boolean(),
            none_expat:                 random_boolean(),
            operate_facility:           random_boolean(),
            price_state:                random_integer(),
            price_tax_year:             random_integer(),
            property_sale:              random_boolean(),
            public_charity:             random_boolean(),
            rental_property_count:      random_integer(),
            reported_grant:             random_boolean(),
            restricted_donation:        random_boolean(),
            state:                        random_state(),
            tax_exemption:              random_boolean(),
            tax_year:                      random_year(),
            total_asset_less:           random_boolean(),
            total_asset_over:           random_boolean(),
            user_id:                                 tp1
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software:        random_boolean(),
            capital_asset_sale:         random_boolean(),
            church_hospital:            random_boolean(),
            deadline:                   Date.utc_today(),
            dispose_asset:              random_boolean(),
            dispose_property:           random_boolean(),
            educational_facility:       random_boolean(),
            financial_situation:        Lorem.sentence(),
            foreign_account_interest:   random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest:    random_boolean(),
            foreign_partner_count:      random_integer(),
            foreign_shareholder:        random_boolean(),
            foreign_value:              random_boolean(),
            fundraising_over:           random_boolean(),
            has_contribution:           random_boolean(),
            has_loan:                   random_boolean(),
            income_over_thousand:       random_boolean(),
            invest_research:            random_boolean(),
            k1_count:                   random_integer(),
            lobbying:                   random_boolean(),
            make_distribution:          random_boolean(),
            none_expat:                 random_boolean(),
            operate_facility:           random_boolean(),
            price_state:                random_integer(),
            price_tax_year:             random_integer(),
            property_sale:              random_boolean(),
            public_charity:             random_boolean(),
            rental_property_count:      random_integer(),
            reported_grant:             random_boolean(),
            restricted_donation:        random_boolean(),
            state:                        random_state(),
            tax_exemption:              random_boolean(),
            tax_year:                      random_year(),
            total_asset_less:           random_boolean(),
            total_asset_over:           random_boolean(),
            user_id:                                 tp2
          }),
          Repo.insert!(%BusinessTaxReturn{
            accounting_software:        random_boolean(),
            capital_asset_sale:         random_boolean(),
            church_hospital:            random_boolean(),
            deadline:                   Date.utc_today(),
            dispose_asset:              random_boolean(),
            dispose_property:           random_boolean(),
            educational_facility:       random_boolean(),
            financial_situation:        Lorem.sentence(),
            foreign_account_interest:   random_boolean(),
            foreign_account_value_more: random_boolean(),
            foreign_entity_interest:    random_boolean(),
            foreign_partner_count:      random_integer(),
            foreign_shareholder:        random_boolean(),
            foreign_value:              random_boolean(),
            fundraising_over:           random_boolean(),
            has_contribution:           random_boolean(),
            has_loan:                   random_boolean(),
            income_over_thousand:       random_boolean(),
            invest_research:            random_boolean(),
            k1_count:                   random_integer(),
            lobbying:                   random_boolean(),
            make_distribution:          random_boolean(),
            none_expat:                 random_boolean(),
            operate_facility:           random_boolean(),
            price_state:                random_integer(),
            price_tax_year:             random_integer(),
            property_sale:              random_boolean(),
            public_charity:             random_boolean(),
            rental_property_count:      random_integer(),
            reported_grant:             random_boolean(),
            restricted_donation:        random_boolean(),
            state:                        random_state(),
            tax_exemption:              random_boolean(),
            tax_year:                      random_year(),
            total_asset_less:           random_boolean(),
            total_asset_over:           random_boolean(),
            user_id:                                 tp3
          }),
          Repo.insert!(%BusinessTaxReturn{
            none_expat:     random_boolean(),
            price_state:    random_integer(),
            price_tax_year: random_integer(),
            user_id:                    pro1
          }),
          Repo.insert!(%BusinessTaxReturn{
            none_expat:     random_boolean(),
            price_state:    random_integer(),
            price_tax_year: random_integer(),
            user_id:                    pro2
          }),
          Repo.insert!(%BusinessTaxReturn{
            none_expat:     random_boolean(),
            price_state:    random_integer(),
            price_tax_year: random_integer(),
            user_id:                    pro3
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
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id:    btr1,
            name: random_name_entity_type(),
            price:       Enum.random(1..99)
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id:    btr2,
            name: random_name_entity_type()
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id:    btr3,
            name: random_name_entity_type()
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id:    btr4,
            name: random_name_entity_type()
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id:    btr5,
            name: random_name_entity_type(),
            price:       Enum.random(1..99)
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id:    btr6,
            name: random_name_entity_type(),
            price:       Enum.random(1..99)
          }),
          Repo.insert!(%BusinessEntityType{
            business_tax_return_id:    btr7,
            name: random_name_entity_type(),
            price:       Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_business_foreign_account_count() :: Ecto.Schema.t()
  defp seed_business_foreign_account_count do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3} =
      {
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3)
      }

    case Repo.aggregate(BusinessForeignAccountCount, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr1,
            name:    random_name_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr2,
            name:    random_name_count()
          }),
          Repo.insert!(%BusinessForeignAccountCount{
            business_tax_return_id: btr3,
            name:    random_name_count()
          })
        ]
    end
  end

  @spec seed_business_foreign_ownership_count() :: Ecto.Schema.t()
  defp seed_business_foreign_ownership_count do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3} =
      {
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3)
      }

    case Repo.aggregate(BusinessForeignOwnershipCount, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr1,
            name:    random_name_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr2,
            name:    random_name_count()
          }),
          Repo.insert!(%BusinessForeignOwnershipCount{
            business_tax_return_id: btr3,
            name:    random_name_count()
          })
        ]
    end
  end

  @spec seed_business_industry() :: Ecto.Schema.t()
  defp seed_business_industry do
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

    case Repo.aggregate(BusinessIndustry, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessIndustry{
            business_tax_return_id:         btr1,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%BusinessIndustry{
            business_tax_return_id:        btr2,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%BusinessIndustry{
            business_tax_return_id:        btr3,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%BusinessIndustry{
            business_tax_return_id:        btr4,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%BusinessIndustry{
            business_tax_return_id:         btr5,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%BusinessIndustry{
            business_tax_return_id:         btr6,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%BusinessIndustry{
            business_tax_return_id:         btr7,
            name: random_name_for_pro_industry()
          })
        ]
    end
  end

  @spec seed_business_llc_type() :: Ecto.Schema.t()
  defp seed_business_llc_type do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3} =
      {
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3)
      }

    case Repo.aggregate(BusinessLlcType, :count, :id) > 0 do
       true -> nil
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
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr1,
            name: random_name_employee(),
            price:    Enum.random(1..99)
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr2,
            name: random_name_employee()
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr3,
            name: random_name_employee()
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr4,
            name: random_name_employee()
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr5,
            name: random_name_employee(),
            price:    Enum.random(1..99)
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr6,
            name: random_name_employee(),
            price:    Enum.random(1..99)
          }),
          Repo.insert!(%BusinessNumberEmployee{
            business_tax_return_id: btr7,
            name: random_name_employee(),
            price:    Enum.random(1..99)
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
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr1,
            name:  random_name_revenue(),
            price:    Enum.random(1..99)
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr2,
            name:  random_name_revenue()
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr3,
            name:  random_name_revenue()
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr4,
            name:  random_name_revenue()
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr5,
            name:  random_name_revenue(),
            price:    Enum.random(1..99)
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr6,
            name:  random_name_revenue(),
            price:    Enum.random(1..99)
          }),
          Repo.insert!(%BusinessTotalRevenue{
            business_tax_return_id: btr7,
            name:  random_name_revenue(),
            price:    Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_business_transaction_count() :: Ecto.Schema.t()
  defp seed_business_transaction_count do
    business_tax_returns_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3} =
      {
        Enum.at(business_tax_returns_ids, 1),
        Enum.at(business_tax_returns_ids, 2),
        Enum.at(business_tax_returns_ids, 3)
      }

    case Repo.aggregate(BusinessTransactionCount, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id:          btr1,
            name: random_name_transaction_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id:          btr2,
            name: random_name_transaction_count()
          }),
          Repo.insert!(%BusinessTransactionCount{
            business_tax_return_id:          btr3,
            name: random_name_transaction_count()
          })
        ]
    end
  end

  @spec seed_individual_tax_return() :: Ecto.Schema.t()
  defp seed_individual_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    case Repo.aggregate(IndividualTaxReturn, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%IndividualTaxReturn{
            foreign_account:                 random_boolean(),
            home_owner:                      random_boolean(),
            living_abroad:                   random_boolean(),
            non_resident_earning:            random_boolean(),
            none_expat:                      random_boolean(),
            own_stock_crypto:                random_boolean(),
            price_foreign_account:           random_integer(),
            price_home_owner:                random_integer(),
            price_living_abroad:             random_integer(),
            price_non_resident_earning:      random_integer(),
            price_own_stock_crypto:          random_integer(),
            price_rental_property_income:    random_integer(),
            price_sole_proprietorship_count: random_integer(),
            price_state:                     random_integer(),
            price_stock_divident:            random_integer(),
            price_tax_year:                  random_integer(),
            rental_property_income:          random_boolean(),
            stock_divident:                  random_boolean(),
            user_id:                                     user
          }),
          Repo.insert!(%IndividualTaxReturn{
            deadline:                   Date.utc_today(),
            foreign_account:            random_boolean(),
            foreign_account_limit:      random_boolean(),
            foreign_financial_interest: random_boolean(),
            home_owner:                 random_boolean(),
            k1_count:                   random_integer(),
            k1_income:                  random_boolean(),
            living_abroad:              random_boolean(),
            non_resident_earning:       random_boolean(),
            none_expat:                 random_boolean(),
            own_stock_crypto:           random_boolean(),
            rental_property_count:      random_integer(),
            rental_property_income:     random_boolean(),
            sole_proprietorship_count:  random_integer(),
            state:                        random_state(),
            stock_divident:             random_boolean(),
            tax_year:                      random_year(),
            user_id:                                 tp1
          }),
          Repo.insert!(%IndividualTaxReturn{
            deadline:                   Date.utc_today(),
            foreign_account:            random_boolean(),
            foreign_account_limit:      random_boolean(),
            foreign_financial_interest: random_boolean(),
            home_owner:                 random_boolean(),
            k1_count:                   random_integer(),
            k1_income:                  random_boolean(),
            living_abroad:              random_boolean(),
            non_resident_earning:       random_boolean(),
            none_expat:                 random_boolean(),
            own_stock_crypto:           random_boolean(),
            rental_property_count:      random_integer(),
            rental_property_income:     random_boolean(),
            sole_proprietorship_count:  random_integer(),
            state:                        random_state(),
            stock_divident:             random_boolean(),
            tax_year:                      random_year(),
            user_id:                                 tp2
          }),
          Repo.insert!(%IndividualTaxReturn{
            deadline:                   Date.utc_today(),
            foreign_account:            random_boolean(),
            foreign_account_limit:      random_boolean(),
            foreign_financial_interest: random_boolean(),
            home_owner:                 random_boolean(),
            k1_count:                   random_integer(),
            k1_income:                  random_boolean(),
            living_abroad:              random_boolean(),
            non_resident_earning:       random_boolean(),
            none_expat:                 random_boolean(),
            own_stock_crypto:           random_boolean(),
            rental_property_count:      random_integer(),
            rental_property_income:     random_boolean(),
            sole_proprietorship_count:  random_integer(),
            state:                        random_state(),
            stock_divident:             random_boolean(),
            tax_year:                      random_year(),
            user_id:                                 tp3
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account:                 random_boolean(),
            home_owner:                      random_boolean(),
            living_abroad:                   random_boolean(),
            non_resident_earning:            random_boolean(),
            none_expat:                      random_boolean(),
            own_stock_crypto:                random_boolean(),
            price_foreign_account:           random_integer(),
            price_home_owner:                random_integer(),
            price_living_abroad:             random_integer(),
            price_non_resident_earning:      random_integer(),
            price_own_stock_crypto:          random_integer(),
            price_rental_property_income:    random_integer(),
            price_sole_proprietorship_count: random_integer(),
            price_state:                     random_integer(),
            price_stock_divident:            random_integer(),
            price_tax_year:                  random_integer(),
            rental_property_income:          random_boolean(),
            stock_divident:                  random_boolean(),
            user_id:                                     pro1
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account:                 random_boolean(),
            home_owner:                      random_boolean(),
            living_abroad:                   random_boolean(),
            non_resident_earning:            random_boolean(),
            none_expat:                      random_boolean(),
            own_stock_crypto:                random_boolean(),
            price_foreign_account:           random_integer(),
            price_home_owner:                random_integer(),
            price_living_abroad:             random_integer(),
            price_non_resident_earning:      random_integer(),
            price_own_stock_crypto:          random_integer(),
            price_rental_property_income:    random_integer(),
            price_sole_proprietorship_count: random_integer(),
            price_state:                     random_integer(),
            price_stock_divident:            random_integer(),
            price_tax_year:                  random_integer(),
            rental_property_income:          random_boolean(),
            stock_divident:                  random_boolean(),
            user_id:                                     pro2
          }),
          Repo.insert!(%IndividualTaxReturn{
            foreign_account:                 random_boolean(),
            home_owner:                      random_boolean(),
            living_abroad:                   random_boolean(),
            non_resident_earning:            random_boolean(),
            none_expat:                      random_boolean(),
            own_stock_crypto:                random_boolean(),
            price_foreign_account:           random_integer(),
            price_home_owner:                random_integer(),
            price_living_abroad:             random_integer(),
            price_non_resident_earning:      random_integer(),
            price_own_stock_crypto:          random_integer(),
            price_rental_property_income:    random_integer(),
            price_sole_proprietorship_count: random_integer(),
            price_state:                     random_integer(),
            price_stock_divident:            random_integer(),
            price_tax_year:                  random_integer(),
            rental_property_income:          random_boolean(),
            stock_divident:                  random_boolean(),
            user_id:                                     pro3
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
       true -> nil
      false ->
        [
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id:        itr1,
            name: random_name_employment_status(),
            price:             Enum.random(1..99)
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id:        itr2,
            name: random_name_employment_status()
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id:        itr3,
            name: random_name_employment_status()
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id:        itr4,
            name: random_name_employment_status()
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id:        itr5,
            name: random_name_employment_status(),
            price:             Enum.random(1..99)
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id:        itr6,
            name: random_name_employment_status(),
            price:             Enum.random(1..99)
          }),
          Repo.insert!(%IndividualEmploymentStatus{
            individual_tax_return_id:        itr7,
            name: random_name_employment_status(),
            price:             Enum.random(1..99)
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
       true -> nil
      false ->
        [
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id:     itr1,
            name: random_name_filling_status(),
            price:          Enum.random(1..99)
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id:     itr2,
            name: random_name_filling_status()
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id:     itr3,
            name: random_name_filling_status()
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id:     itr4,
            name: random_name_filling_status()
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id:     itr5,
            name: random_name_filling_status(),
            price:          Enum.random(1..99)
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id:     itr6,
            name: random_name_filling_status(),
            price:          Enum.random(1..99)
          }),
          Repo.insert!(%IndividualFilingStatus{
            individual_tax_return_id:     itr7,
            name: random_name_filling_status(),
            price:          Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_individual_foreign_account_count() :: Ecto.Schema.t()
  defp seed_individual_foreign_account_count do
    individual_tax_returns_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3} =
      {
        Enum.at(individual_tax_returns_ids, 1),
        Enum.at(individual_tax_returns_ids, 2),
        Enum.at(individual_tax_returns_ids, 3)
      }

    case Repo.aggregate(IndividualForeignAccountCount, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr1,
            name:      random_name_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr2,
            name:      random_name_count()
          }),
          Repo.insert!(%IndividualForeignAccountCount{
            individual_tax_return_id: itr3,
            name:      random_name_count()
          })
        ]
    end
  end

  @spec seed_individual_industry() :: Ecto.Schema.t()
  defp seed_individual_industry do
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

    case Repo.aggregate(IndividualIndustry, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%IndividualIndustry{
            individual_tax_return_id:       itr1,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%IndividualIndustry{
            individual_tax_return_id:      itr2,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%IndividualIndustry{
            individual_tax_return_id:      itr3,
            name: random_name_for_tp_industry()
          }),
          Repo.insert!(%IndividualIndustry{
            individual_tax_return_id:      itr4,
            name: random_name_for_tp_industry()

          }),
          Repo.insert!(%IndividualIndustry{
            individual_tax_return_id:       itr5,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%IndividualIndustry{
            individual_tax_return_id:       itr6,
            name: random_name_for_pro_industry()
          }),
          Repo.insert!(%IndividualIndustry{
            individual_tax_return_id:       itr7,
            name: random_name_for_pro_industry()
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
       true -> nil
      false ->
        [
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id:         itr1,
            name: random_name_itemized_deduction(),
            price:              Enum.random(1..99)
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id:         itr2,
            name: random_name_itemized_deduction()
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id:         itr3,
            name: random_name_itemized_deduction()
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id:         itr4,
            name: random_name_itemized_deduction()
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id:         itr5,
            name: random_name_itemized_deduction(),
            price:              Enum.random(1..99)
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id:         itr6,
            name: random_name_itemized_deduction(),
            price:              Enum.random(1..99)
          }),
          Repo.insert!(%IndividualItemizedDeduction{
            individual_tax_return_id:         itr7,
            name: random_name_itemized_deduction(),
            price:              Enum.random(1..99)
          })
        ]
    end
  end

  @spec seed_individual_stock_transaction_count() :: Ecto.Schema.t()
  defp seed_individual_stock_transaction_count do
    individual_tax_returns_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3} =
      {
        Enum.at(individual_tax_returns_ids, 1),
        Enum.at(individual_tax_returns_ids, 2),
        Enum.at(individual_tax_returns_ids, 3)
      }

    case Repo.aggregate(IndividualStockTransactionCount, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id:              itr1,
            name: random_name_stock_transaction_count()
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id:              itr2,
            name: random_name_stock_transaction_count()
          }),
          Repo.insert!(%IndividualStockTransactionCount{
            individual_tax_return_id:              itr3,
            name: random_name_stock_transaction_count()
          })
        ]
    end
  end

  @spec seed_sale_tax() :: Ecto.Schema.t()
  defp seed_sale_tax do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {user, tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 0),
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    case Repo.aggregate(SaleTax, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%SaleTax{
            price_sale_tax_count: random_integer(),
            user_id:                          user
          }),
          Repo.insert!(%SaleTax{
            deadline:             Date.utc_today(),
            financial_situation:  Lorem.sentence(),
            sale_tax_count:       random_integer(),
            state:                  random_state(),
            user_id:                           tp1
          }),
          Repo.insert!(%SaleTax{
            deadline:             Date.utc_today(),
            financial_situation:  Lorem.sentence(),
            sale_tax_count:       random_integer(),
            state:                  random_state(),
            user_id:                           tp2
          }),
          Repo.insert!(%SaleTax{
            deadline:             Date.utc_today(),
            financial_situation:  Lorem.sentence(),
            sale_tax_count:       random_integer(),
            state:                  random_state(),
            user_id:                           tp3
          }),
          Repo.insert!(%SaleTax{
            price_sale_tax_count: random_integer(),
            user_id:                          pro1
          }),
          Repo.insert!(%SaleTax{
            price_sale_tax_count: random_integer(),
            user_id:                          pro2
          }),
          Repo.insert!(%SaleTax{
            price_sale_tax_count: random_integer(),
            user_id:                          pro3
          })
        ]
    end
  end

  @spec seed_sale_tax_frequency() :: Ecto.Schema.t()
  defp seed_sale_tax_frequency do
    sale_tax_ids =
      Enum.map(Repo.all(SaleTax), fn(data) -> data.id end)

    {st1, st2, st3, st4, st5, st6, st7} =
      {
        Enum.at(sale_tax_ids, 0),
        Enum.at(sale_tax_ids, 1),
        Enum.at(sale_tax_ids, 2),
        Enum.at(sale_tax_ids, 3),
        Enum.at(sale_tax_ids, 4),
        Enum.at(sale_tax_ids, 5),
        Enum.at(sale_tax_ids, 6)
      }

    case Repo.aggregate(SaleTaxFrequency, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%SaleTaxFrequency{
            name: random_name_tax_frequency(),
            price:           random_integer(),
            sale_tax_id:                  st1
          }),
          Repo.insert!(%SaleTaxFrequency{
            name: random_name_tax_frequency(),
            sale_tax_id:                  st2
          }),
          Repo.insert!(%SaleTaxFrequency{
            name: random_name_tax_frequency(),
            sale_tax_id:                  st3
          }),
          Repo.insert!(%SaleTaxFrequency{
            name: random_name_tax_frequency(),
            sale_tax_id:                  st4
          }),
          Repo.insert!(%SaleTaxFrequency{
            name: random_name_tax_frequency(),
            price:           random_integer(),
            sale_tax_id:                  st5
          }),
          Repo.insert!(%SaleTaxFrequency{
            name: random_name_tax_frequency(),
            price:           random_integer(),
            sale_tax_id:                  st6
          }),
          Repo.insert!(%SaleTaxFrequency{
            name: random_name_tax_frequency(),
            price:           random_integer(),
            sale_tax_id:                  st7
          })
        ]
    end
  end

  @spec seed_sale_tax_industry() :: Ecto.Schema.t()
  defp seed_sale_tax_industry do
    sale_tax_ids =
      Enum.map(Repo.all(SaleTax), fn(data) -> data.id end)

    {st1, st2, st3, st4, st5, st6, st7} =
      {
        Enum.at(sale_tax_ids, 0),
        Enum.at(sale_tax_ids, 1),
        Enum.at(sale_tax_ids, 2),
        Enum.at(sale_tax_ids, 3),
        Enum.at(sale_tax_ids, 4),
        Enum.at(sale_tax_ids, 5),
        Enum.at(sale_tax_ids, 6)
      }

    case Repo.aggregate(SaleTaxIndustry, :count, :id) > 0 do
       true -> nil
      false ->
        [
          Repo.insert!(%SaleTaxIndustry{
            name: random_name_for_pro_tax_industry(),
            sale_tax_id: st1
          }),
          Repo.insert!(%SaleTaxIndustry{
            name: random_name_for_tp_tax_industry(),
            sale_tax_id:                        st2
          }),
          Repo.insert!(%SaleTaxIndustry{
            name: random_name_for_tp_tax_industry(),
            sale_tax_id:                        st3
          }),
          Repo.insert!(%SaleTaxIndustry{
            name: random_name_for_tp_tax_industry(),
            sale_tax_id:                        st4
          }),

          Repo.insert!(%SaleTaxIndustry{
            name: random_name_for_tp_tax_industry(),
            sale_tax_id:                        st5
          }),
          Repo.insert!(%SaleTaxIndustry{
            name: random_name_for_pro_tax_industry(),
            sale_tax_id:                         st6
          }),
          Repo.insert!(%SaleTaxIndustry{
            name: random_name_for_pro_tax_industry(),
            sale_tax_id:                         st7
          })
        ]
    end
  end

  @spec seed_service_link() :: Ecto.Schema.t()
  defp seed_service_link do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7} =
      {
        Enum.at(book_keeping_ids, 0),
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

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

    sale_tax_ids =
      Enum.map(Repo.all(SaleTax), fn(data) -> data.id end)

    {st1, st2, st3, st4, st5, st6, st7} =
      {
        Enum.at(sale_tax_ids, 0),
        Enum.at(sale_tax_ids, 1),
        Enum.at(sale_tax_ids, 2),
        Enum.at(sale_tax_ids, 3),
        Enum.at(sale_tax_ids, 4),
        Enum.at(sale_tax_ids, 5),
        Enum.at(sale_tax_ids, 6)
      }

    project_ids =
      Enum.map(Repo.all(Project), fn(data) -> data.id end)

    {prj1, prj2, prj3, prj4, prj5, prj6, prj7} =
      {
        Enum.at(project_ids, 0),
        Enum.at(project_ids, 1),
        Enum.at(project_ids, 2),
        Enum.at(project_ids, 3),
        Enum.at(project_ids, 4),
        Enum.at(project_ids, 5),
        Enum.at(project_ids, 6)
      }

    Repo.insert!(%ServiceLink{
      book_keeping_id:          bk1,
      business_tax_return_id:   btr1,
      individual_tax_return_id: itr1,
      project_id:               prj1,
      sale_tax_id:              st1
    })
    Repo.insert!(%ServiceLink{
      book_keeping_id:          bk2,
      business_tax_return_id:   btr2,
      individual_tax_return_id: itr2,
      project_id:               prj2,
      sale_tax_id:              st2
    })
    Repo.insert!(%ServiceLink{
      book_keeping_id:          bk3,
      business_tax_return_id:   btr3,
      individual_tax_return_id: itr3,
      project_id:               prj3,
      sale_tax_id:              st3
    })
    Repo.insert!(%ServiceLink{
      book_keeping_id:          bk4,
      business_tax_return_id:   btr4,
      individual_tax_return_id: itr4,
      project_id:               prj4,
      sale_tax_id:              st4
    })
    Repo.insert!(%ServiceLink{
      book_keeping_id:          bk5,
      business_tax_return_id:   btr5,
      individual_tax_return_id: itr5,
      project_id:               prj5,
      sale_tax_id:              st5
    })
    Repo.insert!(%ServiceLink{
      book_keeping_id:          bk6,
      business_tax_return_id:   btr6,
      individual_tax_return_id: itr6,
      project_id:               prj6,
      sale_tax_id:              st6
    })
    Repo.insert!(%ServiceLink{
      book_keeping_id:          bk7,
      business_tax_return_id:   btr7,
      individual_tax_return_id: itr7,
      project_id:               prj7,
      sale_tax_id:              st7
    })
  end

  @spec random_float() :: float()
  def random_float do
    :random.uniform() * 100
    |> Float.round(2)
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
  def random_state do
    names = Enum.map(Repo.all(State), fn(data) -> data.name end)
    numbers = 1..59
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
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

  @spec random_name_additional_need :: String.t()
  defp random_name_additional_need do
    names = [
      "accounts payable",
      "accounts receivable",
      "bank reconciliation",
      "financial report preparation",
      "sales tax"
    ]

    Enum.random(names)
  end

  @spec random_name_revenue :: String.t()
  defp random_name_revenue do
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

  @spec random_name_classify_inventory :: String.t()
  def random_name_classify_inventory do
    names = ["Assets", "Expenses"]
    numbers = 1..1
    number = Enum.random(numbers)
    [result] =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_name_for_tp_industry :: [String.t]
  defp random_name_for_tp_industry do
    names = [
      "Agriculture/Farming",
      "Automotive Sales/Repair",
      "Computer/Software/IT",
      "Construction/Contractors",
      "Consulting",
      "Design/Architecture/Engineering",
      "Education",
      "Financial Services",
      "Government Agency",
      "Hospitality",
      "Insurance/Brokerage",
      "Lawn Care/Landscaping",
      "Legal",
      "Manufacturing",
      "Medical/Dental/Health Services",
      "Non Profit",
      "Property Management",
      "Real Estate/Development",
      "Restaurant/Bar",
      "Retail",
      "Salon/Beauty",
      "Telecommunications",
      "Transportation",
      "Wholesale Distribution"
    ]

    numbers = 1..1
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_name_for_pro_industry :: [String.t()]
  defp random_name_for_pro_industry do
    names = [
      "Agriculture/Farming",
      "Automotive Sales/Repair",
      "Computer/Software/IT",
      "Construction/Contractors",
      "Consulting",
      "Design/Architecture/Engineering",
      "Education",
      "Financial Services",
      "Government Agency",
      "Hospitality",
      "Insurance/Brokerage",
      "Lawn Care/Landscaping",
      "Legal",
      "Manufacturing",
      "Medical/Dental/Health Services",
      "Non Profit",
      "Property Management",
      "Real Estate/Development",
      "Restaurant/Bar",
      "Retail",
      "Salon/Beauty",
      "Telecommunications",
      "Transportation",
      "Wholesale Distribution"
    ]

    numbers = 1..24
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_name_employee() :: String.t()
  defp random_name_employee do
    names = [
      "1 employee",
      "101 - 500 employees",
      "2 - 20 employees",
      "21 - 50 employees",
      "500+ employees",
      "51 - 100 employees"
    ]

    Enum.random(names)
  end

  @spec random_name_transaction_volume :: String.t()
  defp random_name_transaction_volume do
    names = ["1-25", "200+", "26-75", "76-199"]
    Enum.random(names)
  end

  @spec random_name_type_client() :: String.t()
  defp random_name_type_client do
    names = [
      "C-Corp / Corporation",
      "Individual or Sole proprietorship",
      "LLC",
      "Non-profit corp",
      "Partnership",
      "S-Corp"
    ]

    Enum.random(names)
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

  @spec random_name_count :: String.t()
  defp random_name_count do
    names = ["1", "2-5", "5+"]
    Enum.random(names)
  end

  @spec random_name_transaction_count() :: String.t()
  defp random_name_transaction_count do
    names = ["1-10", "11-25", "26-75", "75+"]
    Enum.random(names)
  end

  @spec random_name_employment_status :: String.t()
  defp random_name_employment_status do
    names = ["employed", "self-employed", "unemployed"]
    Enum.random(names)
  end

  @spec random_name_filling_status :: String.t()
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

  @spec random_name_itemized_deduction :: String.t()
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
    names = ["1-5", "6-50", "51-100", "100+"]
    Enum.random(names)
  end

  @spec random_name_tax_frequency :: String.t()
  defp random_name_tax_frequency do
    names = ["Annually", "Monthly", "Quarterly"]
    Enum.random(names)
  end

  @spec random_name_for_tp_tax_industry :: [String.t()]
  defp random_name_for_tp_tax_industry do
    names = [
      "Agriculture/Farming",
      "Automotive Sales/Repair",
      "Computer/Software/IT",
      "Construction/Contractors",
      "Consulting",
      "Design/Architecture/Engineering",
      "Education",
      "Financial Services",
      "Government Agency",
      "Hospitality",
      "Insurance/Brokerage",
      "Lawn Care/Landscaping",
      "Legal",
      "Manufacturing",
      "Medical/Dental/Health Services",
      "Non Profit",
      "Property Management",
      "Real Estate/Development",
      "Restaurant/Bar",
      "Retail",
      "Salon/Beauty",
      "Telecommunications",
      "Transportation",
      "Wholesale Distribution"
    ]

    numbers = 1..1
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_name_for_pro_tax_industry :: [String.t()]
  defp random_name_for_pro_tax_industry do
    names = [
      "Agriculture/Farming",
      "Automotive Sales/Repair",
      "Computer/Software/IT",
      "Construction/Contractors",
      "Consulting",
      "Design/Architecture/Engineering",
      "Education",
      "Financial Services",
      "Government Agency",
      "Hospitality",
      "Insurance/Brokerage",
      "Lawn Care/Landscaping",
      "Legal",
      "Manufacturing",
      "Medical/Dental/Health Services",
      "Non Profit",
      "Property Management",
      "Real Estate/Development",
      "Restaurant/Bar",
      "Retail",
      "Salon/Beauty",
      "Telecommunications",
      "Transportation",
      "Wholesale Distribution"
    ]

    numbers = 1..24
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end
end
