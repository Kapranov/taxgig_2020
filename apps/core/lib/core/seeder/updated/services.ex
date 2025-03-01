defmodule Core.Seeder.Updated.Services do
  @moduledoc """
  An update are seeds whole services.
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

  @spec update_match_value_relate() :: Ecto.Schema.t()
  defp update_match_value_relate do
    [struct] = Enum.map(Repo.all(MatchValueRelate), fn(data) -> data end)
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

  @spec update_book_keeping() :: Ecto.Schema.t()
  defp update_book_keeping do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, tp4, tp5, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    book_keepenig_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data end)

    {:ok, date} = Date.new(2020, 05,02)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7, bk8} =
      {
        Enum.at(book_keepenig_ids, 1),
        Enum.at(book_keepenig_ids, 2),
        Enum.at(book_keepenig_ids, 3),
        Enum.at(book_keepenig_ids, 4),
        Enum.at(book_keepenig_ids, 5),
        Enum.at(book_keepenig_ids, 6),
        Enum.at(book_keepenig_ids, 7),
        Enum.at(book_keepenig_ids, 8)
      }
    [
      Services.update_book_keeping(bk1, %{
        account_count:       random_integer(),
        balance_sheet:       random_boolean(),
        deadline:                        date,
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
        account_count:       random_integer(),
        balance_sheet:       random_boolean(),
        deadline:            Date.utc_today(),
        financial_situation: Lorem.sentence(),
        inventory:           random_boolean(),
        inventory_count:     random_integer(),
        payroll:             random_boolean(),
        tax_return_current:  random_boolean(),
        tax_year:               random_year(),
        user_id:                          tp4
      }),
      Services.update_book_keeping(bk5, %{
        account_count:       random_integer(),
        balance_sheet:       random_boolean(),
        deadline:            Date.utc_today(),
        financial_situation: Lorem.sentence(),
        inventory:           random_boolean(),
        inventory_count:     random_integer(),
        payroll:             random_boolean(),
        tax_return_current:  random_boolean(),
        tax_year:               random_year(),
        user_id:                          tp5
      }),
      Services.update_book_keeping(bk6, %{
        payroll:       random_boolean(),
        price_payroll: random_integer(),
        user_id:                   pro1
      }),
      Services.update_book_keeping(bk7, %{
        payroll:       random_boolean(),
        price_payroll: random_integer(),
        user_id:                   pro2
      }),
      Services.update_book_keeping(bk8, %{
        payroll:       random_boolean(),
        price_payroll: random_integer(),
        user_id:                   pro3
      })
    ]
  end

  @spec update_book_keeping_additional_need() :: Ecto.Schema.t()
  defp update_book_keeping_additional_need do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7, bk8} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6),
        Enum.at(book_keeping_ids, 7),
        Enum.at(book_keeping_ids, 8)
      }

    book_keeping_additional_need_ids =
      Enum.map(Repo.all(BookKeepingAdditionalNeed), fn(data) -> data end)

    {ban1, ban2, ban3, ban4, ban5, ban6, ban7, ban8} =
      {
        Enum.at(book_keeping_additional_need_ids, 1),
        Enum.at(book_keeping_additional_need_ids, 2),
        Enum.at(book_keeping_additional_need_ids, 3),
        Enum.at(book_keeping_additional_need_ids, 4),
        Enum.at(book_keeping_additional_need_ids, 5),
        Enum.at(book_keeping_additional_need_ids, 6),
        Enum.at(book_keeping_additional_need_ids, 7),
        Enum.at(book_keeping_additional_need_ids, 8)
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
        name: random_name_additional_need()
      }),
      Services.update_book_keeping_additional_need(ban5, %{
        book_keeping_id:                bk5,
        name: random_name_additional_need()
      }),
      Services.update_book_keeping_additional_need(ban6, %{
        book_keeping_id:                 bk6,
        name:  random_name_additional_need(),
        price:              random_integer()
      }),
      Services.update_book_keeping_additional_need(ban7, %{
        book_keeping_id: bk7,
        name: random_name_additional_need(),
        price:             random_integer()
      }),
      Services.update_book_keeping_additional_need(ban8, %{
        book_keeping_id: bk8,
        name: random_name_additional_need(),
        price:             random_integer()
      })
    ]
  end

  @spec update_book_keeping_annual_revenue() :: Ecto.Schema.t()
  defp update_book_keeping_annual_revenue do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7, bk8} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6),
        Enum.at(book_keeping_ids, 7),
        Enum.at(book_keeping_ids, 8)
      }

    book_keeping_annual_revenue_ids =
      Enum.map(Repo.all(BookKeepingAnnualRevenue), fn(data) -> data end)

    {bar1, bar2, bar3, bar4, bar5, bar6, bar7, bar8} =
      {
        Enum.at(book_keeping_annual_revenue_ids, 1),
        Enum.at(book_keeping_annual_revenue_ids, 2),
        Enum.at(book_keeping_annual_revenue_ids, 3),
        Enum.at(book_keeping_annual_revenue_ids, 4),
        Enum.at(book_keeping_annual_revenue_ids, 5),
        Enum.at(book_keeping_annual_revenue_ids, 6),
        Enum.at(book_keeping_annual_revenue_ids, 7),
        Enum.at(book_keeping_annual_revenue_ids, 8)
      }

    [
      Services.update_book_keeping_annual_revenue(bar1, %{
        book_keeping_id: bk1,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar2, %{
        book_keeping_id: bk2,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar3, %{
        book_keeping_id: bk3,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar4, %{
        book_keeping_id: bk4,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar5, %{
        book_keeping_id: bk5,
        name: random_name_revenue()
      }),
      Services.update_book_keeping_annual_revenue(bar6, %{
        book_keeping_id: bk6,
        name: random_name_revenue(),
        price: random_integer()
      }),
      Services.update_book_keeping_annual_revenue(bar7, %{
        book_keeping_id: bk7,
        name: random_name_revenue(),
        price: random_integer()
      }),
      Services.update_book_keeping_annual_revenue(bar8, %{
        book_keeping_id: bk8,
        name: random_name_revenue(),
        price: random_integer()
      })
    ]
  end

  @spec update_book_keeping_classify_inventory() :: Ecto.Schema.t()
  defp update_book_keeping_classify_inventory do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5)
      }

    book_keeping_classify_inventory_ids =
      Enum.map(Repo.all(BookKeepingClassifyInventory), fn(data) -> data end)

    {bci1, bci2, bci3, bci4, bci5} =
      {
        Enum.at(book_keeping_classify_inventory_ids, 0),
        Enum.at(book_keeping_classify_inventory_ids, 1),
        Enum.at(book_keeping_classify_inventory_ids, 2),
        Enum.at(book_keeping_classify_inventory_ids, 3),
        Enum.at(book_keeping_classify_inventory_ids, 4)
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
      }),
      Services.update_book_keeping_classify_inventory(bci4, %{
        book_keeping_id:                   bk4,
        name: random_name_classify_inventory()
      }),
      Services.update_book_keeping_classify_inventory(bci5, %{
        book_keeping_id:                   bk5,
        name: random_name_classify_inventory()
      })
    ]
  end

  @spec update_book_keeping_industry() :: Ecto.Schema.t()
  defp update_book_keeping_industry do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7, bk8} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6),
        Enum.at(book_keeping_ids, 7),
        Enum.at(book_keeping_ids, 8)
      }

    book_keeping_industry_ids =
      Enum.map(Repo.all(BookKeepingIndustry), fn(data) -> data end)

    {bki1, bki2, bki3, bki4, bki5, bki6, bki7, bki8} =
      {
        Enum.at(book_keeping_industry_ids, 1),
        Enum.at(book_keeping_industry_ids, 2),
        Enum.at(book_keeping_industry_ids, 3),
        Enum.at(book_keeping_industry_ids, 4),
        Enum.at(book_keeping_industry_ids, 5),
        Enum.at(book_keeping_industry_ids, 6),
        Enum.at(book_keeping_industry_ids, 7),
        Enum.at(book_keeping_industry_ids, 8)
      }

    [
      Services.update_book_keeping_industry(bki1, %{
        book_keeping_id:                bk1,
        name: random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki2, %{
        book_keeping_id:                bk2,
        name:  random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki3, %{
        book_keeping_id:                 bk3,
        name:  random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki4, %{
        book_keeping_id:                 bk4,
        name:  random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki5, %{
        book_keeping_id:                 bk5,
        name:  random_name_for_tp_industry()
      }),
      Services.update_book_keeping_industry(bki6, %{
        book_keeping_id:                 bk6,
        name: random_name_for_pro_industry()
      }),
      Services.update_book_keeping_industry(bki7, %{
        book_keeping_id:                 bk7,
        name: random_name_for_pro_industry()
      }),
      Services.update_book_keeping_industry(bki8, %{
        book_keeping_id:                 bk8,
        name: random_name_for_pro_industry()
      })
    ]
  end

  @spec update_book_keeping_number_employee() :: Ecto.Schema.t()
  defp update_book_keeping_number_employee do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7, bk8} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6),
        Enum.at(book_keeping_ids, 7),
        Enum.at(book_keeping_ids, 8)
      }

    book_keeping_number_employee_ids =
      Enum.map(Repo.all(BookKeepingNumberEmployee), fn(data) -> data end)

    {bne1, bne2, bne3, bne4, bne5, bne6, bne7, bne8} =
      {
        Enum.at(book_keeping_number_employee_ids, 1),
        Enum.at(book_keeping_number_employee_ids, 2),
        Enum.at(book_keeping_number_employee_ids, 3),
        Enum.at(book_keeping_number_employee_ids, 4),
        Enum.at(book_keeping_number_employee_ids, 5),
        Enum.at(book_keeping_number_employee_ids, 6),
        Enum.at(book_keeping_number_employee_ids, 7),
        Enum.at(book_keeping_number_employee_ids, 8)
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
        name: random_name_employee()
      }),
      Services.update_book_keeping_number_employee(bne5, %{
        book_keeping_id:         bk5,
        name: random_name_employee()
      }),
      Services.update_book_keeping_number_employee(bne6, %{
        book_keeping_id:         bk6,
        name: random_name_employee(),
        price:      random_integer()
      }),
      Services.update_book_keeping_number_employee(bne7, %{
        book_keeping_id:         bk7,
        name: random_name_employee(),
        price:      random_integer()
      }),
      Services.update_book_keeping_number_employee(bne8, %{
        book_keeping_id:         bk8,
        name: random_name_employee(),
        price:      random_integer()
      })
    ]
  end

  @spec update_book_keeping_transaction_volume() :: Ecto.Schema.t()
  defp update_book_keeping_transaction_volume do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7, bk8} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6),
        Enum.at(book_keeping_ids, 7),
        Enum.at(book_keeping_ids, 8)
      }

    book_keeping_transaction_volume_ids =
      Enum.map(Repo.all(BookKeepingTransactionVolume), fn(data) -> data end)

    {btv1, btv2, btv3, btv4, btv5, btv6, btv7, btv8} =
      {
        Enum.at(book_keeping_transaction_volume_ids, 1),
        Enum.at(book_keeping_transaction_volume_ids, 2),
        Enum.at(book_keeping_transaction_volume_ids, 3),
        Enum.at(book_keeping_transaction_volume_ids, 4),
        Enum.at(book_keeping_transaction_volume_ids, 5),
        Enum.at(book_keeping_transaction_volume_ids, 6),
        Enum.at(book_keeping_transaction_volume_ids, 7),
        Enum.at(book_keeping_transaction_volume_ids, 8)
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
        name: random_name_transaction_volume()
      }),
      Services.update_book_keeping_transaction_volume(btv5, %{
        book_keeping_id:                   bk5,
        name: random_name_transaction_volume()
      }),
      Services.update_book_keeping_transaction_volume(btv6, %{
        book_keeping_id:                   bk6,
        name: random_name_transaction_volume(),
        price:                random_integer()
      }),
      Services.update_book_keeping_transaction_volume(btv7, %{
        book_keeping_id:                   bk7,
        name: random_name_transaction_volume(),
        price:                random_integer()
      }),
      Services.update_book_keeping_transaction_volume(btv8, %{
        book_keeping_id:                   bk8,
        name: random_name_transaction_volume(),
        price:                random_integer()
      })
    ]
  end

  @spec update_book_keeping_type_client() :: Ecto.Schema.t()
  defp update_book_keeping_type_client do
    book_keeping_ids =
      Enum.map(Repo.all(BookKeeping), fn(data) -> data.id end)

    {bk1, bk2, bk3, bk4, bk5, bk6, bk7, bk8} =
      {
        Enum.at(book_keeping_ids, 1),
        Enum.at(book_keeping_ids, 2),
        Enum.at(book_keeping_ids, 3),
        Enum.at(book_keeping_ids, 4),
        Enum.at(book_keeping_ids, 5),
        Enum.at(book_keeping_ids, 6),
        Enum.at(book_keeping_ids, 7),
        Enum.at(book_keeping_ids, 8)
      }

    book_keeping_type_client_ids =
      Enum.map(Repo.all(BookKeepingTypeClient), fn(data) -> data end)

    {bkt1, bkt2, bkt3, bkt4, bkt5, bkt6, bkt7, bkt8} =
      {
        Enum.at(book_keeping_type_client_ids, 1),
        Enum.at(book_keeping_type_client_ids, 2),
        Enum.at(book_keeping_type_client_ids, 3),
        Enum.at(book_keeping_type_client_ids, 4),
        Enum.at(book_keeping_type_client_ids, 5),
        Enum.at(book_keeping_type_client_ids, 6),
        Enum.at(book_keeping_type_client_ids, 7),
        Enum.at(book_keeping_type_client_ids, 8)
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
        name: random_name_type_client()
      }),
      Services.update_book_keeping_type_client(bkt5, %{
        book_keeping_id:            bk5,
        name: random_name_type_client()
      }),
      Services.update_book_keeping_type_client(bkt6, %{
        book_keeping_id:            bk6,
        name: random_name_type_client(),
        price:         random_integer()
      }),
      Services.update_book_keeping_type_client(bkt7, %{
        book_keeping_id:            bk7,
        name: random_name_type_client(),
        price:         random_integer()
      }),
      Services.update_book_keeping_type_client(bkt8, %{
        book_keeping_id:            bk8,
        name: random_name_type_client(),
        price:         random_integer()
      })
    ]
  end

  @spec update_business_tax_return() :: Ecto.Schema.t()
  defp update_business_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, tp4, tp5, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7, btr8} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6),
        Enum.at(business_tax_return_ids, 7),
        Enum.at(business_tax_return_ids, 8)
      }

    {:ok, date} = Date.new(2020, 05,02)

    [
      Services.update_business_tax_return(btr1, %{
        accounting_software:        random_boolean(),
        capital_asset_sale:         random_boolean(),
        church_hospital:            random_boolean(),
        deadline:                               date,
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
        deadline:                               date,
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
        deadline:                               date,
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
        deadline:                               date,
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
        user_id:                                 tp4
      }),
      Services.update_business_tax_return(btr5, %{
        accounting_software:        random_boolean(),
        capital_asset_sale:         random_boolean(),
        church_hospital:            random_boolean(),
        deadline:                               date,
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
        user_id:                                 tp5
      }),
      Services.update_business_tax_return(btr6, %{
        none_expat:     random_boolean(),
        price_state:    random_integer(),
        price_tax_year: random_integer(),
        user_id:                    pro1
      }),
      Services.update_business_tax_return(btr7, %{
        none_expat:     random_boolean(),
        price_state:    random_integer(),
        price_tax_year: random_integer(),
        user_id:                    pro2
      }),
      Services.update_business_tax_return(btr8, %{
        none_expat:     random_boolean(),
        price_state:    random_integer(),
        price_tax_year: random_integer(),
        user_id:                    pro3
      })
    ]
  end

  @spec update_business_entity_type() :: Ecto.Schema.t()
  defp update_business_entity_type do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7, btr8} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6),
        Enum.at(business_tax_return_ids, 7),
        Enum.at(business_tax_return_ids, 8)
      }

    business_entity_type_ids =
      Enum.map(Repo.all(BusinessEntityType), fn(data) -> data end)

    {bet1, bet2, bet3, bet4, bet5, bet6, bet7, bet8} =
      {
        Enum.at(business_entity_type_ids, 1),
        Enum.at(business_entity_type_ids, 2),
        Enum.at(business_entity_type_ids, 3),
        Enum.at(business_entity_type_ids, 4),
        Enum.at(business_entity_type_ids, 5),
        Enum.at(business_entity_type_ids, 6),
        Enum.at(business_entity_type_ids, 7),
        Enum.at(business_entity_type_ids, 8)
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
        name: random_name_entity_type()
      }),
      Services.update_business_entity_type(bet5, %{
        business_tax_return_id:    btr5,
        name: random_name_entity_type()
      }),
      Services.update_business_entity_type(bet6, %{
        business_tax_return_id: btr6,
        name: random_name_entity_type(),
        price:       Enum.random(1..99)
      }),
      Services.update_business_entity_type(bet7, %{
        business_tax_return_id: btr7,
        name: random_name_entity_type(),
        price:       Enum.random(1..99)
      }),
      Services.update_business_entity_type(bet8, %{
        business_tax_return_id: btr8,
        name: random_name_entity_type(),
        price:       Enum.random(1..99)
      })
    ]
  end

  @spec update_business_foreign_account_count() :: Ecto.Schema.t()
  defp update_business_foreign_account_count do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5)
      }

    business_foreign_account_count_ids =
      Enum.map(Repo.all(BusinessForeignAccountCount), fn(data) -> data end)

    {bfa1, bfa2, bfa3, bfa4, bfa5} =
      {
        Enum.at(business_foreign_account_count_ids, 0),
        Enum.at(business_foreign_account_count_ids, 1),
        Enum.at(business_foreign_account_count_ids, 2),
        Enum.at(business_foreign_account_count_ids, 3),
        Enum.at(business_foreign_account_count_ids, 4)
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
      })
    ]
  end

  @spec update_business_foreign_ownership_count() :: Ecto.Schema.t()
  defp update_business_foreign_ownership_count do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5)
      }

    business_foreign_ownership_count_ids =
      Enum.map(Repo.all(BusinessForeignOwnershipCount), fn(data) -> data end)

    {bfo1, bfo2, bfo3, bfo4, bfo5} =
      {
        Enum.at(business_foreign_ownership_count_ids, 0),
        Enum.at(business_foreign_ownership_count_ids, 1),
        Enum.at(business_foreign_ownership_count_ids, 2),
        Enum.at(business_foreign_ownership_count_ids, 3),
        Enum.at(business_foreign_ownership_count_ids, 4)
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
      })
    ]
  end

  @spec update_business_industry() :: Ecto.Schema.t()
  defp update_business_industry do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7, btr8} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6),
        Enum.at(business_tax_return_ids, 7),
        Enum.at(business_tax_return_ids, 8)
      }

    business_industry_ids =
      Enum.map(Repo.all(BusinessIndustry), fn(data) -> data end)

    {bi1, bi2, bi3, bi4, bi5, bi6, bi7, bi8} =
      {
        Enum.at(business_industry_ids, 1),
        Enum.at(business_industry_ids, 2),
        Enum.at(business_industry_ids, 3),
        Enum.at(business_industry_ids, 4),
        Enum.at(business_industry_ids, 5),
        Enum.at(business_industry_ids, 6),
        Enum.at(business_industry_ids, 7),
        Enum.at(business_industry_ids, 8)
      }

    [
      Services.update_business_industry(bi1, %{
        business_tax_return_id:       btr1,
        name: random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi2, %{
        business_tax_return_id:       btr2,
        name: random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi3, %{
        business_tax_return_id:       btr3,
        name: random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi4, %{
        business_tax_return_id:       btr4,
        name: random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi5, %{
        business_tax_return_id:        btr5,
        name: random_name_for_tp_industry()
      }),
      Services.update_business_industry(bi6, %{
        business_tax_return_id:        btr6,
        name: random_name_for_pro_industry()
      }),
      Services.update_business_industry(bi7, %{
        business_tax_return_id:        btr7,
        name: random_name_for_pro_industry()
      }),
      Services.update_business_industry(bi8, %{
        business_tax_return_id:        btr8,
        name: random_name_for_pro_industry()
      })
    ]
  end

  @spec update_business_llc_type() :: Ecto.Schema.t()
  defp update_business_llc_type do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5)
      }

    business_llc_type_ids =
      Enum.map(Repo.all(BusinessLlcType), fn(data) -> data end)

    {blt1, blt2, blt3, blt4, blt5} =
      {
        Enum.at(business_llc_type_ids, 0),
        Enum.at(business_llc_type_ids, 1),
        Enum.at(business_llc_type_ids, 2),
        Enum.at(business_llc_type_ids, 3),
        Enum.at(business_llc_type_ids, 4)
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
      })
    ]
  end

  @spec update_business_number_employee() :: Ecto.Schema.t()
  defp update_business_number_employee do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7, btr8} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6),
        Enum.at(business_tax_return_ids, 7),
        Enum.at(business_tax_return_ids, 8)
      }

    business_number_employee_ids =
      Enum.map(Repo.all(BusinessNumberEmployee), fn(data) -> data end)

    {bne1, bne2, bne3, bne4, bne5, bne6, bne7, bne8} =
      {
        Enum.at(business_number_employee_ids, 1),
        Enum.at(business_number_employee_ids, 2),
        Enum.at(business_number_employee_ids, 3),
        Enum.at(business_number_employee_ids, 4),
        Enum.at(business_number_employee_ids, 5),
        Enum.at(business_number_employee_ids, 6),
        Enum.at(business_number_employee_ids, 7),
        Enum.at(business_number_employee_ids, 8)
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
        name: random_name_employee()
      }),
      Services.update_business_number_employee(bne5, %{
        business_tax_return_id: btr5,
        name: random_name_employee()
      }),
      Services.update_business_number_employee(bne6, %{
        business_tax_return_id: btr6,
        name: random_name_employee(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_number_employee(bne7, %{
        business_tax_return_id: btr7,
        name: random_name_employee(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_number_employee(bne8, %{
        business_tax_return_id: btr8,
        name: random_name_employee(),
        price:    Enum.random(1..99)
      })
    ]
  end

  @spec update_business_total_revenue() :: Ecto.Schema.t()
  defp update_business_total_revenue do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5, btr6, btr7, btr8} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5),
        Enum.at(business_tax_return_ids, 6),
        Enum.at(business_tax_return_ids, 7),
        Enum.at(business_tax_return_ids, 8)
      }

    business_total_revenue_ids =
      Enum.map(Repo.all(BusinessTotalRevenue), fn(data) -> data end)

    {bor1, bor2, bor3, bor4, bor5, bor6, bor7, bor8} =
      {
        Enum.at(business_total_revenue_ids, 1),
        Enum.at(business_total_revenue_ids, 2),
        Enum.at(business_total_revenue_ids, 3),
        Enum.at(business_total_revenue_ids, 4),
        Enum.at(business_total_revenue_ids, 5),
        Enum.at(business_total_revenue_ids, 6),
        Enum.at(business_total_revenue_ids, 7),
        Enum.at(business_total_revenue_ids, 8)
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
        name:  random_name_revenue()
      }),
      Services.update_business_total_revenue(bor5, %{
        business_tax_return_id: btr5,
        name:  random_name_revenue()
      }),
      Services.update_business_total_revenue(bor6, %{
        business_tax_return_id: btr6,
        name:  random_name_revenue(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_total_revenue(bor7, %{
        business_tax_return_id: btr7,
        name:  random_name_revenue(),
        price:    Enum.random(1..99)
      }),
      Services.update_business_total_revenue(bor8, %{
        business_tax_return_id: btr8,
        name:  random_name_revenue(),
        price:    Enum.random(1..99)
      })
    ]
  end

  @spec update_business_transaction_count() :: Ecto.Schema.t()
  defp update_business_transaction_count do
    business_tax_return_ids =
      Enum.map(Repo.all(BusinessTaxReturn), fn(data) -> data.id end)

    {btr1, btr2, btr3, btr4, btr5} =
      {
        Enum.at(business_tax_return_ids, 1),
        Enum.at(business_tax_return_ids, 2),
        Enum.at(business_tax_return_ids, 3),
        Enum.at(business_tax_return_ids, 4),
        Enum.at(business_tax_return_ids, 5)
      }

    business_transaction_count_ids =
      Enum.map(Repo.all(BusinessTransactionCount), fn(data) -> data end)

    {btc1, btc2, btc3, btc4, btc5} =
      {
        Enum.at(business_transaction_count_ids, 0),
        Enum.at(business_transaction_count_ids, 1),
        Enum.at(business_transaction_count_ids, 2),
        Enum.at(business_transaction_count_ids, 3),
        Enum.at(business_transaction_count_ids, 4)
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
      })
    ]
  end

  @spec update_individual_tax_return() :: Ecto.Schema.t()
  defp update_individual_tax_return do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, tp4, tp5, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7, itr8} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6),
        Enum.at(individual_tax_return_ids, 7),
        Enum.at(individual_tax_return_ids, 8)
      }

    {:ok, date} = Date.new(2020, 05,02)

    [
      Services.update_individual_tax_return(itr1, %{
        deadline:                               date,
        financial_situation:        Lorem.sentence(),
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
      Services.update_individual_tax_return(itr2, %{
        deadline:                               date,
        financial_situation:        Lorem.sentence(),
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
      Services.update_individual_tax_return(itr3, %{
        deadline:                               date,
        financial_situation:        Lorem.sentence(),
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
      Services.update_individual_tax_return(itr4, %{
        deadline:                               date,
        financial_situation:        Lorem.sentence(),
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
        user_id:                                 tp4
      }),
      Services.update_individual_tax_return(itr5, %{
        deadline:                               date,
        financial_situation:        Lorem.sentence(),
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
        user_id:                                 tp5
      }),
      Services.update_individual_tax_return(itr6, %{
        foreign_account:                 true,
        home_owner:                      true,
        living_abroad:                   true,
        non_resident_earning:            true,
        none_expat:                      false,
        own_stock_crypto:                true,
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
        rental_property_income:          true,
        stock_divident:                  true,
        user_id:                         pro1
      }),
      Services.update_individual_tax_return(itr7, %{
        foreign_account:                 true,
        home_owner:                      true,
        living_abroad:                   true,
        non_resident_earning:            true,
        none_expat:                      false,
        own_stock_crypto:                true,
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
        rental_property_income:          true,
        stock_divident:                  true,
        user_id:                         pro2
      }),
      Services.update_individual_tax_return(itr8, %{
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
        user_id:                         pro3
      })
    ]
  end

  @spec update_individual_employment_status() :: Ecto.Schema.t()
  defp update_individual_employment_status do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7, itr8} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6),
        Enum.at(individual_tax_return_ids, 7),
        Enum.at(individual_tax_return_ids, 8)
      }

    individual_employment_status_ids =
      Enum.map(Repo.all(IndividualEmploymentStatus), fn(data) -> data end)

    {ies1, ies2, ies3, ies4, ies5, ies6, ies7, ies8} =
      {
        Enum.at(individual_employment_status_ids, 1),
        Enum.at(individual_employment_status_ids, 2),
        Enum.at(individual_employment_status_ids, 3),
        Enum.at(individual_employment_status_ids, 4),
        Enum.at(individual_employment_status_ids, 5),
        Enum.at(individual_employment_status_ids, 6),
        Enum.at(individual_employment_status_ids, 7),
        Enum.at(individual_employment_status_ids, 8)
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
        name: random_name_employment_status()
      }),
      Services.update_individual_employment_status(ies5, %{
        individual_tax_return_id:        itr5,
        name: random_name_employment_status()
      }),
      Services.update_individual_employment_status(ies6, %{
        individual_tax_return_id:        itr6,
        name: random_name_employment_status(),
        price:             Enum.random(1..99)
      }),
      Services.update_individual_employment_status(ies7, %{
        individual_tax_return_id:        itr7,
        name: random_name_employment_status(),
        price:             Enum.random(1..99)
      }),
      Services.update_individual_employment_status(ies8, %{
        individual_tax_return_id:        itr8,
        name: random_name_employment_status(),
        price:             Enum.random(1..99)
      })
    ]
  end

  @spec update_individual_filing_status() :: Ecto.Schema.t()
  defp update_individual_filing_status do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7, itr8} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6),
        Enum.at(individual_tax_return_ids, 7),
        Enum.at(individual_tax_return_ids, 8)
      }

    individual_filing_status_ids =
      Enum.map(Repo.all(IndividualFilingStatus), fn(data) -> data end)

    {ifs1, ifs2, ifs3, ifs4, ifs5, ifs6, ifs7, ifs8} =
      {
        Enum.at(individual_filing_status_ids, 1),
        Enum.at(individual_filing_status_ids, 2),
        Enum.at(individual_filing_status_ids, 3),
        Enum.at(individual_filing_status_ids, 4),
        Enum.at(individual_filing_status_ids, 5),
        Enum.at(individual_filing_status_ids, 6),
        Enum.at(individual_filing_status_ids, 7),
        Enum.at(individual_filing_status_ids, 8)
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
        name: random_name_filling_status()
      }),
      Services.update_individual_filing_status(ifs4, %{
        individual_tax_return_id:     itr4,
        name: random_name_filling_status()
      }),
      Services.update_individual_filing_status(ifs5, %{
        individual_tax_return_id:     itr5,
        name: random_name_filling_status()
      }),
      Services.update_individual_filing_status(ifs6, %{
        individual_tax_return_id:     itr6,
        name: random_name_filling_status(),
        price:          Enum.random(1..99)
      }),
      Services.update_individual_filing_status(ifs7, %{
        individual_tax_return_id:     itr7,
        name: random_name_filling_status(),
        price:          Enum.random(1..99)
      }),
      Services.update_individual_filing_status(ifs8, %{
        individual_tax_return_id:     itr8,
        name: random_name_filling_status(),
        price:          Enum.random(1..99)
      })
    ]
  end

  @spec update_individual_foreign_account_count() :: Ecto.Schema.t()
  defp update_individual_foreign_account_count do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5)
      }

    individual_foreign_account_count_ids =
      Enum.map(Repo.all(IndividualForeignAccountCount), fn(data) -> data end)

    {ifa1, ifa2, ifa3, ifa4, ifa5} =
      {
        Enum.at(individual_foreign_account_count_ids, 0),
        Enum.at(individual_foreign_account_count_ids, 1),
        Enum.at(individual_foreign_account_count_ids, 2),
        Enum.at(individual_foreign_account_count_ids, 3),
        Enum.at(individual_foreign_account_count_ids, 4)
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
      })
    ]
  end

  @spec update_individual_industry() :: Ecto.Schema.t()
  defp update_individual_industry do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7, itr8} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6),
        Enum.at(individual_tax_return_ids, 7),
        Enum.at(individual_tax_return_ids, 8)
      }

    individual_industry_ids =
      Enum.map(Repo.all(IndividualIndustry), fn(data) -> data end)

    {ii1, ii2, ii3, ii4, ii5, ii6, ii7, ii8} =
      {
        Enum.at(individual_industry_ids, 1),
        Enum.at(individual_industry_ids, 2),
        Enum.at(individual_industry_ids, 3),
        Enum.at(individual_industry_ids, 4),
        Enum.at(individual_industry_ids, 5),
        Enum.at(individual_industry_ids, 6),
        Enum.at(individual_industry_ids, 7),
        Enum.at(individual_industry_ids, 8)
      }

    [
      Services.update_individual_industry(ii1, %{
        individual_tax_return_id:      itr1,
        name: random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii2, %{
        individual_tax_return_id:      itr2,
        name: random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii3, %{
        individual_tax_return_id:      itr3,
        name: random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii4, %{
        individual_tax_return_id:      itr4,
        name: random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii5, %{
        individual_tax_return_id:      itr5,
        name: random_name_for_tp_industry()
      }),
      Services.update_individual_industry(ii6, %{
        individual_tax_return_id:       itr6,
        name: random_name_for_pro_industry()
      }),
      Services.update_individual_industry(ii7, %{
        individual_tax_return_id:       itr7,
        name: random_name_for_pro_industry()
      }),
      Services.update_individual_industry(ii8, %{
        individual_tax_return_id:       itr8,
        name: random_name_for_pro_industry()
      })
    ]
  end

  @spec update_individual_itemized_deduction() :: Ecto.Schema.t()
  defp update_individual_itemized_deduction do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5, itr6, itr7, itr8} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5),
        Enum.at(individual_tax_return_ids, 6),
        Enum.at(individual_tax_return_ids, 7),
        Enum.at(individual_tax_return_ids, 8)
      }

    individual_itemized_deduction_ids =
      Enum.map(Repo.all(IndividualItemizedDeduction), fn(data) -> data end)

    {iid1, iid2, iid3, iid4, iid5, iid6, iid7, iid8} =
      {
        Enum.at(individual_itemized_deduction_ids, 1),
        Enum.at(individual_itemized_deduction_ids, 2),
        Enum.at(individual_itemized_deduction_ids, 3),
        Enum.at(individual_itemized_deduction_ids, 4),
        Enum.at(individual_itemized_deduction_ids, 5),
        Enum.at(individual_itemized_deduction_ids, 6),
        Enum.at(individual_itemized_deduction_ids, 7),
        Enum.at(individual_itemized_deduction_ids, 8)
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
        name: random_name_itemized_deduction()
      }),
      Services.update_individual_itemized_deduction(iid5, %{
        individual_tax_return_id:         itr5,
        name: random_name_itemized_deduction()
      }),
      Services.update_individual_itemized_deduction(iid6, %{
        individual_tax_return_id:         itr6,
        name: random_name_itemized_deduction(),
        price:              Enum.random(1..99)
      }),
      Services.update_individual_itemized_deduction(iid7, %{
        individual_tax_return_id:         itr7,
        name: random_name_itemized_deduction(),
        price:              Enum.random(1..99)
      }),
      Services.update_individual_itemized_deduction(iid8, %{
        individual_tax_return_id:         itr8,
        name: random_name_itemized_deduction(),
        price:              Enum.random(1..99)
      })
    ]
  end

  @spec update_individual_stock_transaction_count() :: Ecto.Schema.t()
  defp update_individual_stock_transaction_count do
    individual_tax_return_ids =
      Enum.map(Repo.all(IndividualTaxReturn), fn(data) -> data.id end)

    {itr1, itr2, itr3, itr4, itr5} =
      {
        Enum.at(individual_tax_return_ids, 1),
        Enum.at(individual_tax_return_ids, 2),
        Enum.at(individual_tax_return_ids, 3),
        Enum.at(individual_tax_return_ids, 4),
        Enum.at(individual_tax_return_ids, 5)
      }

    individual_stock_transaction_count_ids =
      Enum.map(Repo.all(IndividualStockTransactionCount), fn(data) -> data end)

    {itc1, itc2, itc3, itc4, itc5} =
      {
        Enum.at(individual_stock_transaction_count_ids, 0),
        Enum.at(individual_stock_transaction_count_ids, 1),
        Enum.at(individual_stock_transaction_count_ids, 2),
        Enum.at(individual_stock_transaction_count_ids, 3),
        Enum.at(individual_stock_transaction_count_ids, 4)
      }

    [
      Services.update_individual_stock_transaction_count(itc1, %{
        individual_tax_return_id:              itr1,
        name: random_name_stock_transaction_count()
      }),
      Services.update_individual_stock_transaction_count(itc2, %{
        individual_tax_return_id:              itr2,
        name: random_name_stock_transaction_count()
      }),
      Services.update_individual_stock_transaction_count(itc3, %{
        individual_tax_return_id:              itr3,
        name: random_name_stock_transaction_count()
      }),
      Services.update_individual_stock_transaction_count(itc4, %{
        individual_tax_return_id:              itr4,
        name: random_name_stock_transaction_count()
      }),
      Services.update_individual_stock_transaction_count(itc5, %{
        individual_tax_return_id:              itr5,
        name: random_name_stock_transaction_count()
      })
    ]
  end

  @spec update_sale_tax() :: Ecto.Schema.t()
  defp update_sale_tax do
    user_ids =
      Enum.map(Repo.all(User), fn(data) -> data.id end)

    {tp1, tp2, tp3, tp4, tp5, pro1, pro2, pro3} = {
      Enum.at(user_ids, 1),
      Enum.at(user_ids, 2),
      Enum.at(user_ids, 3),
      Enum.at(user_ids, 4),
      Enum.at(user_ids, 5),
      Enum.at(user_ids, 6),
      Enum.at(user_ids, 7),
      Enum.at(user_ids, 8)
    }

    sale_tax_ids =
      Enum.map(Repo.all(SaleTax), fn(data) -> data end)

    {st1, st2, st3, st4, st5, st6, st7, st8} =
      {
        Enum.at(sale_tax_ids, 1),
        Enum.at(sale_tax_ids, 2),
        Enum.at(sale_tax_ids, 3),
        Enum.at(sale_tax_ids, 4),
        Enum.at(sale_tax_ids, 5),
        Enum.at(sale_tax_ids, 6),
        Enum.at(sale_tax_ids, 7),
        Enum.at(sale_tax_ids, 8)
      }

    {:ok, date} = Date.new(2020, 05,02)

    [
      Services.update_sale_tax(st1, %{
        deadline:                         date,
        financial_situation:  Lorem.sentence(),
        sale_tax_count:       random_integer(),
        state:                  random_state(),
        user_id:                           tp1
      }),
      Services.update_sale_tax(st2, %{
        deadline:                         date,
        financial_situation:  Lorem.sentence(),
        sale_tax_count:       random_integer(),
        state:                  random_state(),
        user_id:                           tp2
      }),
      Services.update_sale_tax(st3, %{
        deadline:                         date,
        financial_situation:  Lorem.sentence(),
        sale_tax_count:       random_integer(),
        state:                  random_state(),
        user_id:                           tp3
      }),
      Services.update_sale_tax(st4, %{
        deadline:                         date,
        financial_situation:  Lorem.sentence(),
        sale_tax_count:       random_integer(),
        state:                  random_state(),
        user_id:                           tp4
      }),
      Services.update_sale_tax(st5, %{
        deadline:                         date,
        financial_situation:  Lorem.sentence(),
        sale_tax_count:       random_integer(),
        state:                  random_state(),
        user_id:                           tp5
      }),
      Services.update_sale_tax(st6, %{
        price_sale_tax_count: random_integer(),
        user_id:                          pro1
      }),
      Services.update_sale_tax(st7, %{
        price_sale_tax_count: random_integer(),
        user_id:                          pro2
      }),
      Services.update_sale_tax(st8, %{
        price_sale_tax_count: random_integer(),
        user_id:                          pro3
      })
    ]
  end

  @spec update_sale_tax_frequency() :: Ecto.Schema.t()
  defp update_sale_tax_frequency do
    sale_tax_frequency_ids =
      Enum.map(Repo.all(SaleTaxFrequency), fn(data) -> data end)

    {stf1, stf2, stf3, stf4, stf5, stf6, stf7, stf8} =
      {
        Enum.at(sale_tax_frequency_ids, 1),
        Enum.at(sale_tax_frequency_ids, 2),
        Enum.at(sale_tax_frequency_ids, 3),
        Enum.at(sale_tax_frequency_ids, 4),
        Enum.at(sale_tax_frequency_ids, 5),
        Enum.at(sale_tax_frequency_ids, 6),
        Enum.at(sale_tax_frequency_ids, 7),
        Enum.at(sale_tax_frequency_ids, 8)
      }

    [
      Services.update_sale_tax_frequency(stf1, %{
        name: random_name_tax_frequency()
      }),
      Services.update_sale_tax_frequency(stf2, %{
        name: random_name_tax_frequency()
      }),
      Services.update_sale_tax_frequency(stf3, %{
        name: random_name_tax_frequency()
      }),
      Services.update_sale_tax_frequency(stf4, %{
        name: random_name_tax_frequency()
      }),
      Services.update_sale_tax_frequency(stf5, %{
        name: random_name_tax_frequency()
      }),
      Services.update_sale_tax_frequency(stf6, %{
        name: random_name_tax_frequency(),
        price:           random_integer()
      }),
      Services.update_sale_tax_frequency(stf7, %{
        name: random_name_tax_frequency(),
        price:           random_integer()
      }),
      Services.update_sale_tax_frequency(stf8, %{
        name: random_name_tax_frequency(),
        price:           random_integer()
      })
    ]
  end

  @spec update_sale_tax_industry() :: Ecto.Schema.t()
  defp update_sale_tax_industry do
    sale_tax_industry_ids =
      Enum.map(Repo.all(SaleTaxIndustry), fn(data) -> data end)

    {sti1, sti2, sti3, sti4, sti5, sti6, sti7, sti8} =
      {
        Enum.at(sale_tax_industry_ids, 1),
        Enum.at(sale_tax_industry_ids, 2),
        Enum.at(sale_tax_industry_ids, 3),
        Enum.at(sale_tax_industry_ids, 4),
        Enum.at(sale_tax_industry_ids, 5),
        Enum.at(sale_tax_industry_ids, 6),
        Enum.at(sale_tax_industry_ids, 7),
        Enum.at(sale_tax_industry_ids, 8)
      }

    [
      Services.update_sale_tax_industry(sti1, %{
        name: random_name_for_tp_industry()
      }),
      Services.update_sale_tax_industry(sti2, %{
        name: random_name_for_tp_industry()
      }),
      Services.update_sale_tax_industry(sti3, %{
        name: random_name_for_tp_industry()
      }),
      Services.update_sale_tax_industry(sti4, %{
        name: random_name_for_tp_industry()
      }),
      Services.update_sale_tax_industry(sti5, %{
        name: random_name_for_tp_industry()
      }),
      Services.update_sale_tax_industry(sti6, %{
        name: random_name_for_pro_industry()
      }),
      Services.update_sale_tax_industry(sti7, %{
        name: random_name_for_pro_industry()
      }),
      Services.update_sale_tax_industry(sti8, %{
        name: random_name_for_pro_industry()
      })
    ]
  end

  @spec random_integer() :: integer
  defp random_integer(n \\ 99) do
    Enum.random(1..n)
  end

  @spec random_boolean() :: boolean
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_year() :: [String.t()]
  defp random_year do
    years = 2010..2020
    numbers = 1..9
    number = Enum.random(numbers)
    result = for i <- 1..number, i > 0, do: Enum.random(years) |> Integer.to_string
    Enum.uniq(result)
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


  @spec random_name_additional_need() :: String.t()
  defp random_name_additional_need do
    names = [
      "accounts payable",
      "accounts receivable",
      "bank reconciliation",
      "financial report preparation",
      "sales tax"
    ]

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_revenue() :: String.t()
  defp random_name_revenue do
    names = [
      "$100K - $500K",
      "$10M+",
      "$1M - $5M",
      "$500K - $1M",
      "$5M - $10M",
      "Less than $100K"
    ]

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_classify_inventory() :: String.t()
  defp random_name_classify_inventory do
    names = ["Assets", "Expenses"]
    numbers = 1..1
    number = Enum.random(numbers)
    result = for i <- 1..number, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_for_tp_industry() :: String.t()
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

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_for_pro_industry() :: [String.t()]
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
    result = for i <- 1..number, i > 0, do: Enum.random(names)
    Enum.uniq(result)
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

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_transaction_volume() :: String.t()
  defp random_name_transaction_volume do
    names = ["1-25", "200+", "26-75", "76-199"]
    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
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

    result = for i <- 1..1, i > 0, do: Enum.random(names)
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

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_count() :: String.t()
  defp random_name_count do
    names = ["1", "2-5", "5+"]
    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
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

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_transactions_count() :: String.t()
  defp random_name_transactions_count do
    names = ["1-10", "11-25", "26-75", "75+"]
    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_employment_status() :: String.t()
  defp random_name_employment_status do
    names = ["employed", "self-employed", "unemployed"]
    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
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

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_itemized_deduction() :: String.t()
  defp random_name_itemized_deduction do
    names = [
      "Charitable contributions",
      "Health insurance",
      "Medical and dental expenses"
    ]

    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_stock_transaction_count() :: String.t()
  defp random_name_stock_transaction_count do
    names = ["1-5", "100+", "51-100", "6-50"]
    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end

  @spec random_name_tax_frequency() :: String.t()
  defp random_name_tax_frequency do
    names = ["Annually", "Monthly", "Quarterly"]
    result = for i <- 1..1, i > 0, do: Enum.random(names)
    Enum.uniq(result)
  end
end
