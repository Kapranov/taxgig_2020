defmodule Core.Seeder.Updated do
  @moduledoc """
  Seeds for `Core.Seeder.Updated` context.
  """

  alias Core.{
    Accounts.User,
    Lookup.State,
    Repo,
    Services,
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
    Services.SaleTaxIndustry
  }

  alias Faker.Lorem

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_match_value_relate()
    update_book_keeping()
    update_book_keeping_additional_need()
    update_book_keeping_annual_revenue()
    update_book_keeping_classify_inventory()
    update_book_keeping_industry()
    update_book_keeping_number_employee()
    update_book_keeping_transaction_volume()
    update_book_keeping_type_client()
    update_business_tax_return()
    update_business_entity_type()
    update_business_foreign_account_count()
    update_business_foreign_ownership_count()
    update_business_industry()
    update_business_llc_type()
    update_business_number_employee()
    update_business_total_revenue()
    update_business_transaction_count()
    update_individual_tax_return()
    update_individual_employment_status()
    update_individual_filing_status()
    update_individual_foreign_account_count()
    update_individual_industry()
    update_individual_itemized_deduction()
    update_individual_stock_transaction_count()
    update_sale_tax()
    update_sale_tax_frequency()
    update_sale_tax_industry()
  end

  defp update_match_value_relate do
    struct = Enum.map(Repo.all(MatchValueRelate), fn(data) -> [data] end)
    attrs = %{
      match_for_book_keeping_additional_need:             20,
      match_for_book_keeping_annual_revenue:              25,
      match_for_book_keeping_industry:                    10,
      match_for_book_keeping_number_employee:             25,
      match_for_book_keeping_payroll:                     20,
      match_for_book_keeping_type_client:                 60,
      match_for_business_enity_type:                      50,
      match_for_business_industry:                        10,
      match_for_business_number_of_employee:              20,
      match_for_business_total_revenue:                   20,
      match_for_individual_employment_status:             35,
      match_for_individual_filing_status:                 50,
      match_for_individual_foreign_account:               20,
      match_for_individual_home_owner:                    20,
      match_for_individual_industry:                      10,
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
    }

    case Repo.aggregate(MatchValueRelate, :count, :id) > 0 do
      false -> Services.create_match_value_relate(attrs)
       true -> Services.update_match_value_relate(struct, attrs)
    end
  end

  defp update_book_keeping do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    book_keepenig_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data end)

    {bk1, bk2, bk3, bk4, bk5, bk6} =
      {
        Enum.at(book_keepenig_ids, 1),
        Enum.at(book_keepenig_ids, 2),
        Enum.at(book_keepenig_ids, 3),
        Enum.at(book_keepenig_ids, 4),
        Enum.at(book_keepenig_ids, 5),
        Enum.at(book_keepenig_ids, 6)
      }
    [
      Services.update_book_keeping(bk1, %{
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
      Services.update_book_keeping(bk2, %{
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
      Services.update_book_keeping(bk3, %{
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
      Services.update_book_keeping(bk4, %{
        payroll:             random_boolean(),
        price_payroll:       random_integer(),
        user_id:                         pro1
      }),
      Services.update_book_keeping(bk5, %{
        payroll:             random_boolean(),
        price_payroll:       random_integer(),
        user_id:                         pro2
      }),
      Services.update_book_keeping(bk6, %{
        payroll:             random_boolean(),
        price_payroll:       random_integer(),
        user_id:                         pro3
      })
    ]
  end

  defp update_book_keeping_additional_need do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    book_keeping_additional_need_ids =
      Enum.map(Repo.all(BookKeepingAdditionalNeed), fn(data) -> data end)

    {ban1, ban2, ban3, ban4, ban5, ban6} =
      {
        Enum.at(book_keeping_additional_need_ids, 1),
        Enum.at(book_keeping_additional_need_ids, 2),
        Enum.at(book_keeping_additional_need_ids, 3),
        Enum.at(book_keeping_additional_need_ids, 4),
        Enum.at(book_keeping_additional_need_ids, 5),
        Enum.at(book_keeping_additional_need_ids, 6)
      }

    [
      Services.update_book_keeping_additional_need(ban1, %{
        book_keeping_id:                bk1,
        name: random_name_additional_need()
      }),
      Services.update_book_keeping_additional_need(ban2, %{
        book_keeping_id:                bk2,
        name: random_name_additional_need()
      }),
      Services.update_book_keeping_additional_need(ban3, %{
        book_keeping_id:                bk3,
        name: random_name_additional_need()
      }),
      Services.update_book_keeping_additional_need(ban4, %{
        book_keeping_id:                bk4,
        name: random_name_additional_need(),
        price:             random_integer()
      }),
      Services.update_book_keeping_additional_need(ban5, %{
        book_keeping_id:                bk5,
        name: random_name_additional_need(),
        price:             random_integer()
      }),
      Services.update_book_keeping_additional_need(ban6, %{
        book_keeping_id:                bk6,
        name: random_name_additional_need(),
        price:             random_integer()
      })
    ]
  end

  defp update_book_keeping_annual_revenue do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    book_keeping_annual_revenue_ids =
      Enum.map(Repo.all(BookKeepingAnnualRevenue), fn(data) -> data end)

    {bar1, bar2, bar3, bar4, bar5, bar6} =
      {
        Enum.at(book_keeping_annual_revenue_ids, 1),
        Enum.at(book_keeping_annual_revenue_ids, 2),
        Enum.at(book_keeping_annual_revenue_ids, 3),
        Enum.at(book_keeping_annual_revenue_ids, 4),
        Enum.at(book_keeping_annual_revenue_ids, 5),
        Enum.at(book_keeping_annual_revenue_ids, 6)
      }

    [
      Services.update_book_keeping_annual_revenue(bar1, %{
        book_keeping_id:        bk1,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar2, %{
        book_keeping_id:        bk2,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar3, %{
        book_keeping_id:        bk3,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar4, %{
        book_keeping_id:        bk4,
        name: random_name_revenue(),
        price:     random_integer()
      }),
      Services.update_book_keeping_annual_revenue(bar5, %{
        book_keeping_id:        bk5,
        name: random_name_revenue(),
        price:     random_integer()
      }),
      Services.update_book_keeping_annual_revenue(bar6, %{
        book_keeping_id:        bk6,
        name: random_name_revenue(),
        price:     random_integer()
      })
    ]
  end

  defp update_book_keeping_classify_inventory do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3)
      }

    book_keeping_classify_inventory_ids =
      Enum.map(Repo.all(BookKeepingClassifyInventory), fn(data) -> data end)

    {bci1, bci2, bci3} =
      {
        Enum.at(book_keeping_classify_inventory_ids, 0),
        Enum.at(book_keeping_classify_inventory_ids, 1),
        Enum.at(book_keeping_classify_inventory_ids, 2)
      }

    [
      Services.update_book_keeping_classify_inventory(bci1, %{
        book_keeping_id:                   bk1,
        name: random_name_classify_inventory()
      }),
      Services.update_book_keeping_classify_inventory(bci2, %{
        book_keeping_id:                   bk2,
        name: random_name_classify_inventory()
      }),
      Services.update_book_keeping_classify_inventory(bci3, %{
        book_keeping_id:                   bk3,
        name: random_name_classify_inventory()
      })
    ]
  end

  defp update_book_keeping_industry do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    book_keeping_industry_ids =
      Enum.map(Repo.all(BookKeepingIndustry), fn(data) -> data end)

    {bki1, bki2, bki3, bki4, bki5, bki6} =
      {
        Enum.at(book_keeping_industry_ids, 1),
        Enum.at(book_keeping_industry_ids, 2),
        Enum.at(book_keeping_industry_ids, 3),
        Enum.at(book_keeping_industry_ids, 4),
        Enum.at(book_keeping_industry_ids, 5),
        Enum.at(book_keeping_industry_ids, 6)
      }

    [
      Services.update_book_keeping_industry(bki1, %{
        book_keeping_id:                 bk1,
        name:  random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki2, %{
        book_keeping_id:                 bk2,
        name:  random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki3, %{
        book_keeping_id:                 bk3,
        name:  random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki4, %{
        book_keeping_id:                 bk4,
        name: random_name_for_pro_industry()
      }),
      Services.update_book_keeping_industry(bki5, %{
        book_keeping_id:                 bk5,
        name: random_name_for_pro_industry()
      }),
      Services.update_book_keeping_industry(bki6, %{
        book_keeping_id:                 bk6,
        name: random_name_for_pro_industry()
      })
    ]
  end

  defp update_book_keeping_number_employee do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    book_keeping_number_employee_ids =
      Enum.map(Repo.all(BookKeepingNumberEmployee), fn(data) -> data end)

    {bne1, bne2, bne3, bne4, bne5, bne6} =
      {
        Enum.at(book_keeping_number_employee_ids, 1),
        Enum.at(book_keeping_number_employee_ids, 2),
        Enum.at(book_keeping_number_employee_ids, 3),
        Enum.at(book_keeping_number_employee_ids, 4),
        Enum.at(book_keeping_number_employee_ids, 5),
        Enum.at(book_keeping_number_employee_ids, 6)
      }

    [
      Services.update_book_keeping_number_employee(bne1, %{
        book_keeping_id:         bk1,
        name: random_name_employee()
      }),
      Services.update_book_keeping_number_employee(bne2, %{
        book_keeping_id:         bk2,
        name: random_name_employee()
      }),
      Services.update_book_keeping_number_employee(bne3, %{
        book_keeping_id:         bk3,
        name: random_name_employee()
      }),
      Services.update_book_keeping_number_employee(bne4, %{
        book_keeping_id:         bk4,
        name: random_name_employee(),
        price:      random_integer()
      }),
      Services.update_book_keeping_number_employee(bne5, %{
        book_keeping_id:         bk5,
        name: random_name_employee(),
        price:      random_integer()
      }),
      Services.update_book_keeping_number_employee(bne6, %{
        book_keeping_id:         bk6,
        name: random_name_employee(),
        price:      random_integer()
      })
    ]
  end

  defp update_book_keeping_transaction_volume do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    book_keeping_transaction_volume_ids =
      Enum.map(Repo.all(BookKeepingTransactionVolume), fn(data) -> data end)

    {btv1, btv2, btv3, btv4, btv5, btv6} =
      {
        Enum.at(book_keeping_transaction_volume_ids, 1),
        Enum.at(book_keeping_transaction_volume_ids, 2),
        Enum.at(book_keeping_transaction_volume_ids, 3),
        Enum.at(book_keeping_transaction_volume_ids, 4),
        Enum.at(book_keeping_transaction_volume_ids, 5),
        Enum.at(book_keeping_transaction_volume_ids, 6)
      }

    [
      Services.update_book_keeping_transaction_volume(btv1, %{
        book_keeping_id:                   bk1,
        name: random_name_transaction_volume()
      }),
      Services.update_book_keeping_transaction_volume(btv2, %{
        book_keeping_id:                   bk2,
        name: random_name_transaction_volume()
      }),
      Services.update_book_keeping_transaction_volume(btv3, %{
        book_keeping_id:                   bk3,
        name: random_name_transaction_volume()
      }),
      Services.update_book_keeping_transaction_volume(btv4, %{
        book_keeping_id:                   bk4,
        name: random_name_transaction_volume(),
        price:                random_integer()
      }),
      Services.update_book_keeping_transaction_volume(btv5, %{
        book_keeping_id:                   bk5,
        name: random_name_transaction_volume(),
        price:                random_integer()
      }),
      Services.update_book_keeping_transaction_volume(btv6, %{
        book_keeping_id:                   bk6,
        name: random_name_transaction_volume(),
        price:                random_integer()
      })
    ]
  end

  defp update_book_keeping_type_client do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6)
      }

    book_keeping_type_client_ids =
      Enum.map(Repo.all(BookKeepingTypeClient), fn(data) -> data end)

    {bkt1, bkt2, bkt3, bkt4, bkt5, bkt6} =
      {
        Enum.at(book_keeping_type_client_ids, 1),
        Enum.at(book_keeping_type_client_ids, 2),
        Enum.at(book_keeping_type_client_ids, 3),
        Enum.at(book_keeping_type_client_ids, 4),
        Enum.at(book_keeping_type_client_ids, 5),
        Enum.at(book_keeping_type_client_ids, 6)
      }

    [
      Services.update_book_keeping_type_client(bkt1, %{
        book_keeping_id:            bk1,
        name: random_name_type_client()
      }),
      Services.update_book_keeping_type_client(bkt2, %{
        book_keeping_id:            bk2,
        name: random_name_type_client()
      }),
      Services.update_book_keeping_type_client(bkt3, %{
        book_keeping_id:            bk3,
        name: random_name_type_client()
      }),
      Services.update_book_keeping_type_client(bkt4, %{
        book_keeping_id:            bk4,
        name: random_name_type_client(),
        price:         random_integer()
      }),
      Services.update_book_keeping_type_client(bkt5, %{
        book_keeping_id:            bk5,
        name: random_name_type_client(),
        price:         random_integer()
      }),
      Services.update_book_keeping_type_client(bkt6, %{
        book_keeping_id:            bk6,
        name: random_name_type_client(),
        price:         random_integer()
      })
    ]
  end

  defp update_business_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    [
      Services.update_business_tax_return(btr1, %{
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
      Services.update_business_tax_return(btr2, %{
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
      Services.update_business_tax_return(btr3, %{
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
      Services.update_business_tax_return(btr4, %{
        accounting_software:        random_boolean(),
        capital_asset_sale:         random_boolean(),
        church_hospital:            random_boolean(),
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
        tax_exemption:              random_boolean(),
        tax_year:                      random_year(),
        total_asset_less:           random_boolean(),
        total_asset_over:           random_boolean(),
        user_id:                                pro1
      }),
      Services.update_business_tax_return(btr5, %{
        accounting_software:        random_boolean(),
        capital_asset_sale:         random_boolean(),
        church_hospital:            random_boolean(),
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
        tax_exemption:              random_boolean(),
        tax_year:                      random_year(),
        total_asset_less:           random_boolean(),
        total_asset_over:           random_boolean(),
        user_id:                                pro2
      }),
      Services.update_business_tax_return(btr6, %{
        accounting_software:        random_boolean(),
        capital_asset_sale:         random_boolean(),
        church_hospital:            random_boolean(),
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
        tax_exemption:              random_boolean(),
        tax_year:                      random_year(),
        total_asset_less:           random_boolean(),
        total_asset_over:           random_boolean(),
        user_id:                                pro3
      })
    ]
  end

  defp update_business_entity_type do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_entity_type_ids =
      Enum.map(Repo.all(BusinessEntityType), fn(data) -> data end)

    {bet1, bet2, bet3, bet4, bet5, bet6} =
      {
        Enum.at(business_entity_type_ids, 1),
        Enum.at(business_entity_type_ids, 2),
        Enum.at(business_entity_type_ids, 3),
        Enum.at(business_entity_type_ids, 4),
        Enum.at(business_entity_type_ids, 5),
        Enum.at(business_entity_type_ids, 6)
      }

    [
      Services.update_business_entity_type(bet1, %{
        business_tax_return_id:    btr1,
        name: random_name_entity_type()
      }),
      Services.update_business_entity_type(bet2, %{
        business_tax_return_id:    btr2,
        name: random_name_entity_type()
      }),
      Services.update_business_entity_type(bet3, %{
        business_tax_return_id:    btr3,
        name: random_name_entity_type()
      }),
      Services.update_business_entity_type(bet4, %{
        business_tax_return_id:    btr4,
        name: random_name_entity_type(),
        price:       Enum.random(1..99)
      }),
      Services.update_business_entity_type(bet5, %{
        business_tax_return_id:    btr5,
        name: random_name_entity_type(),
        price:       Enum.random(1..99)
      }),
      Services.update_business_entity_type(bet6, %{
        business_tax_return_id:    btr6,
        name: random_name_entity_type(),
        price:       Enum.random(1..99)
      })
    ]
  end

  defp update_business_foreign_account_count do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_foreign_account_count_ids =
      Enum.map(Repo.all(BusinessForeignAccountCount), fn(data) -> data end)

    {bfa1, bfa2, bfa3, bfa4, bfa5, bfa6} =
      {
        Enum.at(business_foreign_account_count_ids, 1),
        Enum.at(business_foreign_account_count_ids, 2),
        Enum.at(business_foreign_account_count_ids, 3),
        Enum.at(business_foreign_account_count_ids, 4),
        Enum.at(business_foreign_account_count_ids, 5),
        Enum.at(business_foreign_account_count_ids, 6)
      }

    [
      Services.update_business_foreign_account_count(bfa1, %{
        business_tax_return_id: btr1,
        name:    random_name_count()
      }),
      Services.update_business_foreign_account_count(bfa2, %{
        business_tax_return_id: btr2,
        name:    random_name_count()
      }),
      Services.update_business_foreign_account_count(bfa3, %{
        business_tax_return_id: btr3,
        name:    random_name_count()
      }),
      Services.update_business_foreign_account_count(bfa4, %{
        business_tax_return_id: btr4,
        name:    random_name_count()
      }),
      Services.update_business_foreign_account_count(bfa5, %{
        business_tax_return_id: btr5,
        name:    random_name_count()
      }),
      Services.update_business_foreign_account_count(bfa6, %{
        business_tax_return_id: btr6,
        name:    random_name_count()
      })
    ]
  end

  defp update_business_foreign_ownership_count do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_foreign_ownership_count_ids =
      Enum.map(Repo.all(BusinessForeignOwnershipCount), fn(data) -> data end)

    {bfo1, bfo2, bfo3, bfo4, bfo5, bfo6} =
      {
        Enum.at(business_foreign_ownership_count_ids, 1),
        Enum.at(business_foreign_ownership_count_ids, 2),
        Enum.at(business_foreign_ownership_count_ids, 3),
        Enum.at(business_foreign_ownership_count_ids, 4),
        Enum.at(business_foreign_ownership_count_ids, 5),
        Enum.at(business_foreign_ownership_count_ids, 6)
      }

    [
      Services.update_business_foreign_ownership_count(bfo1, %{
        business_tax_return_id: btr1,
        name:    random_name_count()
      }),
      Services.update_business_foreign_ownership_count(bfo2, %{
        business_tax_return_id: btr2,
        name:    random_name_count()
      }),
      Services.update_business_foreign_ownership_count(bfo3, %{
        business_tax_return_id: btr3,
        name:    random_name_count()
      }),
      Services.update_business_foreign_ownership_count(bfo4, %{
        business_tax_return_id: btr4,
        name:    random_name_count()
      }),
      Services.update_business_foreign_ownership_count(bfo5, %{
        business_tax_return_id: btr5,
        name:    random_name_count()
      }),
      Services.update_business_foreign_ownership_count(bfo6, %{
        business_tax_return_id: btr6,
        name:    random_name_count()
      })
    ]
  end

  defp update_business_industry do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_industry_ids =
      Enum.map(Repo.all(BusinessIndustry), fn(data) -> data end)

    {bi1, bi2, bi3, bi4, bi5, bi6} =
      {
        Enum.at(business_industry_ids, 1),
        Enum.at(business_industry_ids, 2),
        Enum.at(business_industry_ids, 3),
        Enum.at(business_industry_ids, 4),
        Enum.at(business_industry_ids, 5),
        Enum.at(business_industry_ids, 6)
      }

    [
      Services.update_business_industry(bi1, %{
        business_tax_return_id:         btr1,
        name:  random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi2, %{
        business_tax_return_id:         btr2,
        name:  random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi3, %{
        business_tax_return_id:         btr3,
        name:  random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi4, %{
        business_tax_return_id:         btr4,
        name: random_name_for_pro_industry()
      }),
      Services.update_business_industry(bi5, %{
        business_tax_return_id:         btr5,
        name: random_name_for_pro_industry()
      }),
      Services.update_business_industry(bi6, %{
        business_tax_return_id:         btr6,
        name: random_name_for_pro_industry()
      })
    ]
  end

  defp update_business_llc_type do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_llc_type_ids =
      Enum.map(Repo.all(BusinessLlcType), fn(data) -> data end)

    {blt1, blt2, blt3, blt4, blt5, blt6} =
      {
        Enum.at(business_llc_type_ids, 1),
        Enum.at(business_llc_type_ids, 2),
        Enum.at(business_llc_type_ids, 3),
        Enum.at(business_llc_type_ids, 4),
        Enum.at(business_llc_type_ids, 5),
        Enum.at(business_llc_type_ids, 6)
      }

    [
      Services.update_business_llc_type(blt1, %{
        business_tax_return_id: btr1,
        name: random_name_llc_type()
      }),
      Services.update_business_llc_type(blt2, %{
        business_tax_return_id: btr2,
        name: random_name_llc_type()
      }),
      Services.update_business_llc_type(blt3, %{
        business_tax_return_id: btr3,
        name: random_name_llc_type()
      }),
      Services.update_business_llc_type(blt4, %{
        business_tax_return_id: btr4,
        name: random_name_llc_type()
      }),
      Services.update_business_llc_type(blt5, %{
        business_tax_return_id: btr5,
        name: random_name_llc_type()
      }),
      Services.update_business_llc_type(blt6, %{
        business_tax_return_id: btr6,
        name: random_name_llc_type()
      })
    ]
  end

  defp update_business_number_employee do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_number_employee_ids =
      Enum.map(Repo.all(BusinessNumberEmployee), fn(data) -> data end)

    {bne1, bne2, bne3, bne4, bne5, bne6} =
      {
        Enum.at(business_number_employee_ids, 1),
        Enum.at(business_number_employee_ids, 2),
        Enum.at(business_number_employee_ids, 3),
        Enum.at(business_number_employee_ids, 4),
        Enum.at(business_number_employee_ids, 5),
        Enum.at(business_number_employee_ids, 6)
      }

    [
      Services.update_business_number_employee(bne1, %{
        business_tax_return_id: btr1,
        name: random_name_employee()
      }),
      Services.update_business_number_employee(bne2, %{
        business_tax_return_id: btr2,
        name: random_name_employee()
      }),
      Services.update_business_number_employee(bne3, %{
        business_tax_return_id: btr3,
        name: random_name_employee()
      }),
      Services.update_business_number_employee(bne4, %{
        business_tax_return_id: btr4,
        name: random_name_employee(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_number_employee(bne5, %{
        business_tax_return_id: btr5,
        name: random_name_employee(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_number_employee(bne6, %{
        business_tax_return_id: btr6,
        name: random_name_employee(),
        price:    Enum.random(1..99)
      })
    ]
  end

  defp update_business_total_revenue do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_total_revenue_ids =
      Enum.map(Repo.all(BusinessTotalRevenue), fn(data) -> data end)

    {bor1, bor2, bor3, bor4, bor5, bor6} =
      {
        Enum.at(business_total_revenue_ids, 1),
        Enum.at(business_total_revenue_ids, 2),
        Enum.at(business_total_revenue_ids, 3),
        Enum.at(business_total_revenue_ids, 4),
        Enum.at(business_total_revenue_ids, 5),
        Enum.at(business_total_revenue_ids, 6)
      }

    [
      Services.update_business_total_revenue(bor1, %{
        business_tax_return_id: btr1,
        name:  random_name_revenue()
      }),
      Services.update_business_total_revenue(bor2, %{
        business_tax_return_id: btr2,
        name:  random_name_revenue()
      }),
      Services.update_business_total_revenue(bor3, %{
        business_tax_return_id: btr3,
        name:  random_name_revenue()
      }),
      Services.update_business_total_revenue(bor4, %{
        business_tax_return_id: btr4,
        name:  random_name_revenue(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_total_revenue(bor5, %{
        business_tax_return_id: btr5,
        name:  random_name_revenue(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_total_revenue(bor6, %{
        business_tax_return_id: btr6,
        name:  random_name_revenue(),
        price:    Enum.random(1..99)
      })
    ]
  end

  defp update_business_transaction_count do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6)
      }

    business_transaction_count_ids =
      Enum.map(Repo.all(BusinessTransactionCount), fn(data) -> data end)

    {btc1, btc2, btc3, btc4, btc5, btc6} =
      {
        Enum.at(business_transaction_count_ids, 1),
        Enum.at(business_transaction_count_ids, 2),
        Enum.at(business_transaction_count_ids, 3),
        Enum.at(business_transaction_count_ids, 4),
        Enum.at(business_transaction_count_ids, 5),
        Enum.at(business_transaction_count_ids, 6)
      }

    [
      Services.update_business_transaction_count(btc1, %{
        business_tax_return_id:           btr1,
        name: random_name_transactions_count()
      }),
      Services.update_business_transaction_count(btc2, %{
        business_tax_return_id:           btr2,
        name: random_name_transactions_count()
      }),
      Services.update_business_transaction_count(btc3, %{
        business_tax_return_id:           btr3,
        name: random_name_transactions_count()
      }),
      Services.update_business_transaction_count(btc4, %{
        business_tax_return_id:           btr4,
        name: random_name_transactions_count()
      }),
      Services.update_business_transaction_count(btc5, %{
        business_tax_return_id:           btr5,
        name: random_name_transactions_count()
      }),
      Services.update_business_transaction_count(btc6, %{
        business_tax_return_id:           btr6,
        name: random_name_transactions_count()
      })
    ]
  end

  defp update_individual_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data end)

    {itr1, itr2, itr3, itr4, itr5, itr6} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6)
      }

    [
      Services.update_individual_tax_return(itr1, %{
        deadline:       Date.utc_today(),
        foreign_account:                  true,
        foreign_account_limit:            true,
        foreign_financial_interest:       true,
        home_owner:                       true,
        k1_count:                           10,
        k1_income:                        true,
        living_abroad:                    true,
        non_resident_earning:             true,
        none_expat:                      false,
        own_stock_crypto:                 true,
        rental_property_count:               2,
        rental_property_income:           true,
        sole_proprietorship_count:           3,
        state: ["Alabama", "Ohio", "New York"],
        stock_divident:                   true,
        tax_year:     ["2018", "2017", "2016"],
        user_id:                           tp1
      }),
      Services.update_individual_tax_return(itr2, %{
        deadline:             Date.utc_today(),
        foreign_account:                  true,
        foreign_account_limit:           false,
        foreign_financial_interest:       true,
        home_owner:                      false,
        k1_count:                            2,
        k1_income:                        true,
        living_abroad:                    true,
        non_resident_earning:            false,
        none_expat:                      false,
        own_stock_crypto:                false,
        rental_property_count:               5,
        rental_property_income:           true,
        sole_proprietorship_count:           1,
        state:             ["Alabama", "Iowa"],
        stock_divident:                  false,
        tax_year:                     ["2018"],
        user_id:                           tp2
      }),
      Services.update_individual_tax_return(itr3, %{
        deadline:             Date.utc_today(),
        foreign_account:                                                      true,
        foreign_account_limit:                                               false,
        foreign_financial_interest:                                           true,
        home_owner:                                                           true,
        k1_count:                                                                0,
        k1_income:                                                           false,
        living_abroad:                                                        true,
        non_resident_earning:                                                 true,
        none_expat:                                                          false,
        own_stock_crypto:                                                     true,
        rental_property_count:                                                  10,
        rental_property_income:                                              false,
        sole_proprietorship_count:                                               9,
        state: ["Alabama", "Ohio", "New York", "Iowa", "New Jersey", "New Mexico"],
        stock_divident:                                                       true,
        tax_year:                         ["2018", "2017", "2016", "2015", "2019"],
        user_id:                                                               tp3
      }),
      Services.update_individual_tax_return(itr4, %{
        foreign_account:               false,
        home_owner:                     true,
        living_abroad:                 false,
        non_resident_earning:          false,
        own_stock_crypto:              false,
        price_home_owner:                 80,
        price_rental_property_income:    150,
        price_sole_proprietorship_count: 100,
        price_state:                      20,
        price_tax_year:                   10,
        rental_property_income:         true,
        stock_divident:                false,
        user_id:                        pro1
      }),
      Services.update_individual_tax_return(itr5, %{
        foreign_account:                true,
        home_owner:                     true,
        living_abroad:                  true,
        non_resident_earning:           true,
        own_stock_crypto:               true,
        price_foreign_account:           250,
        price_home_owner:                120,
        price_living_abroad:             180,
        price_non_resident_earning:      500,
        price_own_stock_crypto:          255,
        price_rental_property_income:    345,
        price_sole_proprietorship_count: 165,
        price_state:                      45,
        price_stock_divident:            185,
        price_tax_year:                   50,
        rental_property_income:         true,
        stock_divident:                 true,
        user_id:                        pro2
      }),
      Services.update_individual_tax_return(itr6, %{
        foreign_account:           false,
        home_owner:                 true,
        living_abroad:             false,
        non_resident_earning:      false,
        own_stock_crypto:           true,
        price_home_owner:             85,
        price_own_stock_crypto:      135,
        price_rental_property_income: 75,
        price_state:                  12,
        price_stock_divident:        115,
        price_tax_year:               10,
        rental_property_income:     true,
        stock_divident:             true,
        user_id:                    pro3
      })
    ]
  end

  defp update_individual_employment_status do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6)
      }

    individual_employment_status_ids =
      Enum.map(Repo.all(IndividualEmploymentStatus), fn(data) -> data end)

    {ies1, ies2, ies3, ies4, ies5, ies6} =
      {
        Enum.at(individual_employment_status_ids, 1),
        Enum.at(individual_employment_status_ids, 2),
        Enum.at(individual_employment_status_ids, 3),
        Enum.at(individual_employment_status_ids, 4),
        Enum.at(individual_employment_status_ids, 5),
        Enum.at(individual_employment_status_ids, 6)
      }

    [
      Services.update_individual_employment_status(ies1, %{
        individual_tax_return_id:        itr1,
        name: random_name_employment_status()
      }),
      Services.update_individual_employment_status(ies2, %{
        individual_tax_return_id:        itr2,
        name: random_name_employment_status()
      }),
      Services.update_individual_employment_status(ies3, %{
        individual_tax_return_id:        itr3,
        name: random_name_employment_status()
      }),
      Services.update_individual_employment_status(ies4, %{
        individual_tax_return_id:        itr4,
        name: random_name_employment_status(),
        price:             Enum.random(1..99)
      }),
      Services.update_individual_employment_status(ies5, %{
        individual_tax_return_id:        itr5,
        name: random_name_employment_status(),
        price:             Enum.random(1..99)
      }),
      Services.update_individual_employment_status(ies6, %{
        individual_tax_return_id:        itr6,
        name: random_name_employment_status(),
        price:             Enum.random(1..99)
      })
    ]
  end

  defp update_individual_filing_status do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6)
      }

    individual_filing_status_ids =
      Enum.map(Repo.all(IndividualFilingStatus), fn(data) -> data end)

    {ifs1, ifs2, ifs3, ifs4, ifs5, ifs6} =
      {
        Enum.at(individual_filing_status_ids, 1),
        Enum.at(individual_filing_status_ids, 2),
        Enum.at(individual_filing_status_ids, 3),
        Enum.at(individual_filing_status_ids, 4),
        Enum.at(individual_filing_status_ids, 5),
        Enum.at(individual_filing_status_ids, 6)
      }

    [
      Services.update_individual_filing_status(ifs1, %{
        individual_tax_return_id:     itr1,
        name: random_name_filling_status()
      }),
      Services.update_individual_filing_status(ifs2, %{
        individual_tax_return_id:     itr2,
        name: random_name_filling_status()
      }),
      Services.update_individual_filing_status(ifs3, %{
        individual_tax_return_id:     itr3,
        name:          "Head of Household"
      }),
      Services.update_individual_filing_status(ifs4, %{
        individual_tax_return_id:     itr4,
        name: random_name_filling_status(),
        price:          Enum.random(1..99)
      }),
      Services.update_individual_filing_status(ifs5, %{
        individual_tax_return_id:     itr5,
        name: random_name_filling_status(),
        price:          Enum.random(1..99)
      }),
      Services.update_individual_filing_status(ifs6, %{
        individual_tax_return_id:     itr6,
        name: random_name_filling_status(),
        price:          Enum.random(1..99)
      })
    ]
  end

  defp update_individual_foreign_account_count do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6)
      }

    individual_foreign_account_count_ids =
      Enum.map(Repo.all(IndividualForeignAccountCount), fn(data) -> data end)

    {ifa1, ifa2, ifa3, ifa4, ifa5, ifa6} =
      {
        Enum.at(individual_foreign_account_count_ids, 1),
        Enum.at(individual_foreign_account_count_ids, 2),
        Enum.at(individual_foreign_account_count_ids, 3),
        Enum.at(individual_foreign_account_count_ids, 4),
        Enum.at(individual_foreign_account_count_ids, 5),
        Enum.at(individual_foreign_account_count_ids, 6)
      }

    [
      Services.update_individual_foreign_account_count(ifa1, %{
        individual_tax_return_id: itr1,
        name:      random_name_count()
      }),
      Services.update_individual_foreign_account_count(ifa2, %{
        individual_tax_return_id: itr2,
        name:      random_name_count()
      }),
      Services.update_individual_foreign_account_count(ifa3, %{
        individual_tax_return_id: itr3,
        name:      random_name_count()
      }),
      Services.update_individual_foreign_account_count(ifa4, %{
        individual_tax_return_id: itr4,
        name:      random_name_count()
      }),
      Services.update_individual_foreign_account_count(ifa5, %{
        individual_tax_return_id: itr5,
        name:      random_name_count()
      }),
      Services.update_individual_foreign_account_count(ifa6, %{
        individual_tax_return_id: itr6,
        name:      random_name_count()
      })
    ]
  end

  defp update_individual_industry do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6)
      }

    individual_industry_ids =
      Enum.map(Repo.all(IndividualIndustry), fn(data) -> data end)

    {ii1, ii2, ii3, ii4, ii5, ii6} =
      {
        Enum.at(individual_industry_ids, 1),
        Enum.at(individual_industry_ids, 2),
        Enum.at(individual_industry_ids, 3),
        Enum.at(individual_industry_ids, 4),
        Enum.at(individual_industry_ids, 5),
        Enum.at(individual_industry_ids, 6)
      }

    [
      Services.update_individual_industry(ii1, %{
        individual_tax_return_id:       itr1,
        name:  random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii2, %{
        individual_tax_return_id:       itr2,
        name:  random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii3, %{
        individual_tax_return_id:       itr3,
        name:  random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii4, %{
        individual_tax_return_id:       itr4,
        name: random_name_for_pro_industry()
      }),
      Services.update_individual_industry(ii5, %{
        individual_tax_return_id:       itr5,
        name: random_name_for_pro_industry()
      }),
      Services.update_individual_industry(ii6, %{
        individual_tax_return_id:       itr6,
        name: random_name_for_pro_industry()
      })
    ]
  end

  defp update_individual_itemized_deduction do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6)
      }

    individual_itemized_deduction_ids =
      Enum.map(Repo.all(IndividualItemizedDeduction), fn(data) -> data end)

    {iid1, iid2, iid3, iid4, iid5, iid6} =
      {
        Enum.at(individual_itemized_deduction_ids, 1),
        Enum.at(individual_itemized_deduction_ids, 2),
        Enum.at(individual_itemized_deduction_ids, 3),
        Enum.at(individual_itemized_deduction_ids, 4),
        Enum.at(individual_itemized_deduction_ids, 5),
        Enum.at(individual_itemized_deduction_ids, 6)
      }

    [
      Services.update_individual_itemized_deduction(iid1, %{
        individual_tax_return_id:         itr1,
        name: random_name_itemized_deduction()
      }),
      Services.update_individual_itemized_deduction(iid2, %{
        individual_tax_return_id:         itr2,
        name: random_name_itemized_deduction()
      }),
      Services.update_individual_itemized_deduction(iid3, %{
        individual_tax_return_id:         itr3,
        name: random_name_itemized_deduction()
      }),
      Services.update_individual_itemized_deduction(iid4, %{
        individual_tax_return_id:         itr4,
        name: random_name_itemized_deduction(),
        price:              Enum.random(1..99)
      }),
      Services.update_individual_itemized_deduction(iid5, %{
        individual_tax_return_id:         itr5,
        name: random_name_itemized_deduction(),
        price:              Enum.random(1..99)
      }),
      Services.update_individual_itemized_deduction(iid6, %{
        individual_tax_return_id:         itr6,
        name: random_name_itemized_deduction(),
        price:              Enum.random(1..99)
      })
    ]
  end

  defp update_individual_stock_transaction_count do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6)
      }

    individual_stock_transaction_count_ids =
      Enum.map(Repo.all(IndividualStockTransactionCount), fn(data) -> data end)

    {itc1, itc2, itc3, itc4, itc5, itc6} =
      {
        Enum.at(individual_stock_transaction_count_ids, 1),
        Enum.at(individual_stock_transaction_count_ids, 2),
        Enum.at(individual_stock_transaction_count_ids, 3),
        Enum.at(individual_stock_transaction_count_ids, 4),
        Enum.at(individual_stock_transaction_count_ids, 5),
        Enum.at(individual_stock_transaction_count_ids, 6)
      }

    [
      Services.update_individual_stock_transaction_count(itc1, %{
        individual_tax_return_id: itr1,
        name:                   "6-50"
      }),
      Services.update_individual_stock_transaction_count(itc2, %{
        individual_tax_return_id: itr2,
        name:                 "51-100"
      }),
      Services.update_individual_stock_transaction_count(itc3, %{
        individual_tax_return_id: itr3,
        name:                   "100+"
      }),
      Services.update_individual_stock_transaction_count(itc4, %{
        individual_tax_return_id: itr4,
        name:                 "51-100"
      }),
      Services.update_individual_stock_transaction_count(itc5, %{
        individual_tax_return_id: itr5,
        name:                   "6-50"
      }),
      Services.update_individual_stock_transaction_count(itc6, %{
        individual_tax_return_id: itr6,
        name:                    "1-5"
      })
    ]
  end

  defp update_sale_tax do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6)
    }

    sale_tax_ids =
      Enum.map(Repo.all(SaleTax), fn(data) -> data end)

    {st1, st2, st3, st4, st5, st6} =
      {
        Enum.at(sale_tax_ids, 1),
        Enum.at(sale_tax_ids, 2),
        Enum.at(sale_tax_ids, 3),
        Enum.at(sale_tax_ids, 4),
        Enum.at(sale_tax_ids, 5),
        Enum.at(sale_tax_ids, 6)
      }

    [
      Services.update_sale_tax(st1, %{
        deadline:            Date.utc_today(),
        financial_situation: "some situation",
        sale_tax_count:                     5,
        state:        ["Alabama", "New York"],
        user_id:                          tp1
      }),
      Services.update_sale_tax(st2, %{
        deadline:             Date.utc_today(),
        financial_situation:  Lorem.sentence(),
        sale_tax_count:       random_integer(),
        state:                  random_state(),
        user_id:                           tp2
      }),
      Services.update_sale_tax(st3, %{
        deadline:             Date.utc_today(),
        financial_situation:  Lorem.sentence(),
        sale_tax_count:       random_integer(),
        state:                  random_state(),
        user_id:                           tp3
      }),
      Services.update_sale_tax(st4, %{
        price_sale_tax_count:               45,
        user_id:                          pro1
      }),
      Services.update_sale_tax(st5, %{
        price_sale_tax_count: random_integer(),
        user_id:                          pro2
      }),
      Services.update_sale_tax(st6, %{
        price_sale_tax_count: random_integer(),
        user_id:                          pro3
      })
    ]
  end

  defp update_sale_tax_frequency do
    sale_tax_ids =
      Enum.map(Repo.all(SaleTax), fn(data) -> data.id end)

    {st1, st2, st3, st4, st5, st6} =
      {
        Enum.at(sale_tax_ids, 1),
        Enum.at(sale_tax_ids, 2),
        Enum.at(sale_tax_ids, 3),
        Enum.at(sale_tax_ids, 4),
        Enum.at(sale_tax_ids, 5),
        Enum.at(sale_tax_ids, 6)
      }

    sale_tax_frequency_ids =
      Enum.map(Repo.all(SaleTaxFrequency), fn(data) -> data end)

    {stf1, stf2, stf3, stf4, stf5, stf6} =
      {
        Enum.at(sale_tax_frequency_ids, 1),
        Enum.at(sale_tax_frequency_ids, 2),
        Enum.at(sale_tax_frequency_ids, 3),
        Enum.at(sale_tax_frequency_ids, 4),
        Enum.at(sale_tax_frequency_ids, 5),
        Enum.at(sale_tax_frequency_ids, 6)
      }

    [
      Services.update_sale_tax_frequency(stf1, %{
        name:                  "Annually",
        sale_tax_id:                  st1
      }),
      Services.update_sale_tax_frequency(stf2, %{
        name: random_name_tax_frequency(),
        sale_tax_id:                  st2
      }),
      Services.update_sale_tax_frequency(stf3, %{
        name: random_name_tax_frequency(),
        sale_tax_id: st3
      }),
      Services.update_sale_tax_frequency(stf4, %{
        name:                  "Annually",
        price:                        150,
        sale_tax_id:                  st4
      }),
      Services.update_sale_tax_frequency(stf5, %{
        name: random_name_tax_frequency(),
        price:           random_integer(),
        sale_tax_id:                  st5
      }),
      Services.update_sale_tax_frequency(stf6, %{
        name: random_name_tax_frequency(),
        price:           random_integer(),
        sale_tax_id:                  st6
      })
    ]
  end

  defp update_sale_tax_industry do
    sale_tax_ids =
      Enum.map(Repo.all(SaleTax), fn(data) -> data.id end)

    {st1, st2, st3, st4, st5, st6} =
      {
        Enum.at(sale_tax_ids, 1),
        Enum.at(sale_tax_ids, 2),
        Enum.at(sale_tax_ids, 3),
        Enum.at(sale_tax_ids, 4),
        Enum.at(sale_tax_ids, 5),
        Enum.at(sale_tax_ids, 6)
      }

    sale_tax_industry_ids =
      Enum.map(Repo.all(SaleTaxIndustry), fn(data) -> data end)

    {sti1, sti2, sti3, sti4, sti5, sti6} =
      {
        Enum.at(sale_tax_industry_ids, 1),
        Enum.at(sale_tax_industry_ids, 2),
        Enum.at(sale_tax_industry_ids, 3),
        Enum.at(sale_tax_industry_ids, 4),
        Enum.at(sale_tax_industry_ids, 5),
        Enum.at(sale_tax_industry_ids, 6)
      }

    [
      Services.update_sale_tax_industry(sti1, %{
        name: random_name_for_tp_industry(),
        sale_tax_id:                    st1
      }),
      Services.update_sale_tax_industry(sti2, %{
        name: random_name_for_tp_industry(),
        sale_tax_id:                    st2
      }),
      Services.update_sale_tax_industry(sti3, %{
        name: random_name_for_tp_industry(),
        sale_tax_id:                    st3
      }),
      Services.update_sale_tax_industry(sti4, %{
        name: random_name_for_pro_industry(),
        sale_tax_id:                     st4
      }),
      Services.update_sale_tax_industry(sti5, %{
        name: random_name_for_pro_industry(),
        sale_tax_id:                     st5
      }),
      Services.update_sale_tax_industry(sti6, %{
        name: random_name_for_pro_industry(),
        sale_tax_id:                     st6
      })
    ]
  end

  defp random_integer(n \\ 99) do
    Enum.random(1..n)
  end

  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

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

  defp random_state do
    name = Enum.map(Repo.all(State), fn(data) -> data.name end)
    numbers = 1..9
    number = Enum.random(numbers)

    for i <- 1..number, i > 0 do
      Enum.random(name)
      |> to_string
    end
    |> Enum.uniq()
  end

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

  defp random_name_classify_inventory do
    names = ["Assets", "Expenses"]
    numbers = 1..1
    number = Enum.random(numbers)
    result = for i <- 1..number, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

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

    result =
      for i <- 0..1, i > 0 do
        Enum.random(names)
      end

    Enum.uniq(result)
  end

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

    Enum.uniq(result)
  end

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

  defp random_name_transaction_volume do
    names = ["1-25", "200+", "26-75", "76-199"]
    Enum.random(names)
  end

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

  defp random_name_count do
    names = ["1", "2-5", "5+"]

    Enum.random(names)
  end

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

  defp random_name_transactions_count do
    names = ["1-10", "11-25", "26-75", "75+"]
    Enum.random(names)
  end

  defp random_name_employment_status do
    names = ["employed", "self-employed", "unemployed"]
    Enum.random(names)
  end

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

  defp random_name_itemized_deduction do
    names = [
      "Charitable contributions",
      "Health insurance",
      "Medical and dental expenses"
    ]

    Enum.random(names)
  end

  defp random_name_tax_frequency do
    names = ["Annually", "Monthly", "Quaterly"]
    Enum.random(names)
  end
end
