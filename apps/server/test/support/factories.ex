defmodule Server.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo
  # use ExMachina.Ecto, repo: Ptin.Repo

  alias Core.{
    Accounts.Profile,
    Accounts.Subscriber,
    Accounts.User,
    Landing.Faq,
    Landing.FaqCategory,
    Landing.PressArticle,
    Landing.Vacancy,
    Localization.Language,
    Lookup.State,
    Lookup.UsZipcode,
    Media.Picture,
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
    Skills.AccountingSoftware,
    Skills.Education,
    Skills.University,
    Skills.WorkExperience,
    Talk.Message,
    Talk.Room,
    Upload
  }

  alias Faker.{
    Address,
    App,
    Avatar,
    Company.En,
    Gov.Us,
    Internet,
    Lorem,
    Person,
    Phone,
    UUID
  }

  alias Ptin.Services.Ptin

  @root_dir Path.expand("../../../core/priv/data/", __DIR__)
  @image1_path Path.absname("../core/test/fixtures/image.jpg")
  @image2_path Path.absname("../core/test/fixtures/image_tmp.jpg")
  @universities "#{@root_dir}/university.json"
  @languages "#{@root_dir}/languages.json"
  @usa_states "#{@root_dir}/us_states.json"
  @usa_zipcodes_part1 "#{@root_dir}/us_zip_part1.json"
  @usa_zipcodes_part2 "#{@root_dir}/us_zip_part2.json"
  @usa_zipcodes_part3 "#{@root_dir}/us_zip_part3.json"

  @spec faq_category_factory() :: FaqCategory.t()
  def faq_category_factory do
    %FaqCategory{title: Lorem.word()}
  end

  @spec faq_factory() :: Faq.t()
  def faq_factory do
    %Faq{
      content: Lorem.sentence(),
      faq_categories: build(:faq_category),
      title: Lorem.word()
    }
  end

  @spec language_factory() :: Language.t()
  def language_factory do
    case random_language() do
      {abbr, name} ->
        %Language{
          abbr: abbr,
          name: name
        }
    end
  end

  @spec press_article_factory() :: PressArticle.t()
  def press_article_factory do
    %PressArticle{
      author: App.author(),
      img_url: Avatar.image_url(),
      preview_text: Lorem.sentence(),
      title: Lorem.word(),
      url: Internet.url()
    }
  end

  @spec vacancy_factory() :: Vacancy.t()
  def vacancy_factory do
    %Vacancy{
      content: Lorem.sentence(),
      department: En.bs(),
      title: Lorem.word()
    }
  end

  @spec subscriber_factory() :: Subscriber.t()
  def subscriber_factory do
    %Subscriber{
      email: random_email(),
      pro_role: random_boolean()
    }
  end

  @spec state_factory() :: State.t()
  def state_factory do
    case random_state() do
      {abbr, name} ->
        %State{
          abbr: abbr,
          name: name
        }
    end
  end

  @spec us_zipcode_factory() :: UsZipcode.t()
  def us_zipcode_factory do
    case random_zipcode() do
      {city, state, zipcode} ->
        %UsZipcode{
          city: city,
          state: state,
          zipcode: zipcode
        }
    end
  end

  @spec user_factory() :: User.t()
  def user_factory do
    %User{
      active: random_boolean(),
      avatar: Avatar.image_url(),
      bio: Lorem.sentence(),
      birthday: Date.add(Timex.now, 0),
      email: random_email(),
      first_name: Person.first_name(),
      init_setup: random_boolean(),
      languages: [build(:language)],
      last_name: Person.last_name(),
      middle_name: Person.suffix(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: Phone.Hy.cell_number(),
      provider: random_provider(),
      role: false,
      sex: random_gender(),
      ssn: random_ssn(),
      street: Address.En.street_address(),
      zip: Address.zip_code()
    }
  end

  @spec tp_user_factory() :: User.t()
  def tp_user_factory do
    %User{
      active: random_boolean(),
      avatar: Avatar.image_url(),
      bio: Lorem.sentence(),
      birthday: Date.add(Timex.now, 0),
      email: "v.kobzan@gmail.com",
      first_name: Person.first_name(),
      init_setup: random_boolean(),
      languages: [build(:language)],
      last_name: Person.last_name(),
      middle_name: Person.suffix(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: Phone.Hy.cell_number(),
      provider: "localhost",
      role: false,
      sex: random_gender(),
      ssn: random_ssn(),
      street: Address.En.street_address(),
      zip: Address.zip_code()
    }
  end

  @spec pro_user_factory() :: User.t()
  def pro_user_factory do
    %User{
      active: random_boolean(),
      avatar: Avatar.image_url(),
      bio: Lorem.sentence(),
      birthday: Date.add(Timex.now, 0),
      email: "support@taxgig.com",
      first_name: Person.first_name(),
      init_setup: random_boolean(),
      languages: [build(:language)],
      last_name: Person.last_name(),
      middle_name: Person.suffix(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: Phone.Hy.cell_number(),
      provider: "localhost",
      role: true,
      sex: random_gender(),
      ssn: random_ssn(),
      street: Address.En.street_address(),
      zip: Address.zip_code()
    }
  end

  @spec ptin_factory() :: Ptin.t()
  def ptin_factory do
    %Ptin{
      bus_addr_zip: "84116",
      bus_st_code: "UT",
      first_name: "Jason",
      last_name: "Broschinsky",
      profession: "CPA,EA"
    }
  end

  @spec profile_factory() :: Profile.t()
  def profile_factory do
    %Profile{
      address: Address.street_address(),
      banner: Avatar.image_url(),
      description: Lorem.sentence(),
      logo: build(:file, name: "Logo"),
      us_zipcode: build(:us_zipcode),
      user: build(:user)
    }
  end

  @spec picture_factory() :: Picture.t()
  def picture_factory do
    profile = build(:profile)
    %Picture{
      file: profile.logo,
      profile: profile
    }
  end

  @spec file_factory() :: Core.Media.File.t()
  def file_factory do
    File.cp!(@image1_path, @image2_path)

    file = %Plug.Upload{
      content_type: "image/jpg",
      filename: "image_tmp.jpg",
      path: @image2_path
    }

    {:ok, data} = Upload.store(file)

    %{
      content_type: "image/jpg",
      name: "image_tmp.jpg",
      size: 5024,
      url: url
    } = data

    %Core.Media.File{
      content_type: "image/jpg",
      id: UUID.v4(),
      inserted_at: Timex.shift(Timex.now, days: -2),
      name: "image_tmp.jpg",
      size: 5024,
      updated_at: Timex.shift(Timex.now, days: -1),
      url: url
    }
  end

  @spec match_value_relat_factory() :: MatchValueRelate.t()
  def match_value_relat_factory do
    %MatchValueRelate{
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
  end

  @spec book_keeping_factory() :: BookKeeping.t()
  def book_keeping_factory do
    %BookKeeping{
      account_count: random_integer(),
      balance_sheet: random_boolean(),
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      inventory: random_boolean(),
      inventory_count: random_integer(),
      payroll: random_boolean(),
      price_payroll: random_integer(),
      tax_return_current: random_boolean(),
      tax_year: random_year(),
      user: build(:user)
    }
  end

  @spec tp_book_keeping_factory() :: BookKeeping.t()
  def tp_book_keeping_factory do
    %BookKeeping{
      account_count: random_integer(),
      balance_sheet: random_boolean(),
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      inventory: random_boolean(),
      inventory_count: random_integer(),
      payroll: random_boolean(),
      tax_return_current: random_boolean(),
      tax_year: random_year(),
      user: build(:tp_user)
    }
  end

  @spec pro_book_keeping_factory() :: BookKeeping.t()
  def pro_book_keeping_factory do
    %BookKeeping{
      payroll: random_boolean(),
      price_payroll: random_integer(),
      user: build(:pro_user)
    }
  end

  @spec book_keeping_additional_need_factory() :: BookKeepingAdditionalNeed.t()
  def book_keeping_additional_need_factory do
    %BookKeepingAdditionalNeed{
      book_keepings: build(:book_keeping),
      name: random_name_additional_need(),
      price: random_integer()
    }
  end

  @spec tp_book_keeping_additional_need_factory() :: BookKeepingAdditionalNeed.t()
  def tp_book_keeping_additional_need_factory do
    %BookKeepingAdditionalNeed{
      book_keepings: build(:tp_book_keeping),
      name: random_name_additional_need()
    }
  end

  @spec pro_book_keeping_additional_need_factory() :: BookKeepingAdditionalNeed.t()
  def pro_book_keeping_additional_need_factory do
    %BookKeepingAdditionalNeed{
      book_keepings: build(:pro_book_keeping),
      name: random_name_additional_need(),
      price: random_integer()
    }
  end

  @spec book_keeping_annual_revenue_factory() :: BookKeepingAnnualRevenue.t()
  def book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:book_keeping),
      name: random_name_revenue(),
      price: random_integer()
    }
  end

  @spec tp_book_keeping_annual_revenue_factory() :: BookKeepingAnnualRevenue.t()
  def tp_book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:tp_book_keeping),
      name: random_name_revenue()
    }
  end

  @spec pro_book_keeping_annual_revenue_factory() :: BookKeepingAnnualRevenue.t()
  def pro_book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:pro_book_keeping),
      name: random_name_revenue(),
      price: random_integer()
    }
  end

  @spec book_keeping_classify_inventory_factory() :: BookKeepingClassifyInventory.t()
  def book_keeping_classify_inventory_factory do
    %BookKeepingClassifyInventory{
      book_keepings: build(:book_keeping),
      name: random_name_classify_inventory()
    }
  end

  @spec tp_book_keeping_classify_inventory_factory() :: BookKeepingClassifyInventory.t()
  def tp_book_keeping_classify_inventory_factory do
    %BookKeepingClassifyInventory{
      book_keepings: build(:tp_book_keeping),
      name: random_name_classify_inventory()
    }
  end

  @spec book_keeping_industry_factory() :: BookKeepingIndustry.t()
  def book_keeping_industry_factory do
    %BookKeepingIndustry{
      book_keepings: build(:book_keeping),
      name: random_name_industry()
    }
  end

  @spec tp_book_keeping_industry_factory() :: BookKeepingIndustry.t()
  def tp_book_keeping_industry_factory do
    %BookKeepingIndustry{
      book_keepings: build(:tp_book_keeping),
      name: random_name_for_tp_industry()
    }
  end

  @spec pro_book_keeping_industry_factory() :: BookKeepingIndustry.t()
  def pro_book_keeping_industry_factory do
    %BookKeepingIndustry{
      book_keepings: build(:pro_book_keeping),
      name: random_name_for_pro_industry()
    }
  end

  @spec book_keeping_number_employee_factory() :: BookKeepingNumberEmployee.t()
  def book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:book_keeping),
      name: random_name_employee(),
      price: random_integer()
    }
  end

  @spec tp_book_keeping_number_employee_factory() :: BookKeepingNumberEmployee.t()
  def tp_book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:tp_book_keeping),
      name: random_name_employee()
    }
  end

  @spec pro_book_keeping_number_employee_factory() :: BookKeepingNumberEmployee.t()
  def pro_book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:pro_book_keeping),
      name: random_name_employee(),
      price: random_integer()
    }
  end

  @spec book_keeping_transaction_volume_factory() :: BookKeepingTransactionVolume.t()
  def book_keeping_transaction_volume_factory do
    %BookKeepingTransactionVolume{
      book_keepings: build(:book_keeping),
      name: random_name_transaction_volume(),
      price: random_integer()
    }
  end

  @spec tp_book_keeping_transaction_volume_factory() :: BookKeepingTransactionVolume.t()
  def tp_book_keeping_transaction_volume_factory do
    %BookKeepingTransactionVolume{
      book_keepings: build(:tp_book_keeping),
      name: random_name_transaction_volume()
    }
  end

  @spec pro_book_keeping_transaction_volume_factory() :: BookKeepingTransactionVolume.t()
  def pro_book_keeping_transaction_volume_factory do
    %BookKeepingTransactionVolume{
      book_keepings: build(:pro_book_keeping),
      name: random_name_transaction_volume(),
      price: random_integer()
    }
  end

  @spec book_keeping_type_client_factory() :: BookKeepingTypeClient.t()
  def book_keeping_type_client_factory do
    %BookKeepingTypeClient{
      book_keepings: build(:book_keeping),
      name: random_name_type_client(),
      price: random_integer()
    }
  end

  @spec tp_book_keeping_type_client_factory() :: BookKeepingTypeClient.t()
  def tp_book_keeping_type_client_factory do
    %BookKeepingTypeClient{
      book_keepings: build(:tp_book_keeping),
      name: random_name_type_client()
    }
  end

  @spec pro_book_keeping_type_client_factory() :: BookKeepingTypeClient.t()
  def pro_book_keeping_type_client_factory do
    %BookKeepingTypeClient{
      book_keepings: build(:pro_book_keeping),
      name: random_name_type_client(),
      price: random_integer()
    }
  end

  @spec business_tax_return_factory() :: BusinessTaxReturn.t()
  def business_tax_return_factory do
    %BusinessTaxReturn{
      accounting_software: random_boolean(),
      capital_asset_sale: random_boolean(),
      church_hospital: random_boolean(),
      deadline: Date.utc_today(),
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
      state: random_states(),
      tax_exemption: random_boolean(),
      tax_year: random_year(),
      total_asset_less: random_boolean(),
      total_asset_over: random_boolean(),
      user: build(:user)
    }
  end

  @spec tp_business_tax_return_factory() :: BusinessTaxReturn.t()
  def tp_business_tax_return_factory do
    %BusinessTaxReturn{
      accounting_software: random_boolean(),
      capital_asset_sale: random_boolean(),
      church_hospital: random_boolean(),
      deadline: Date.utc_today(),
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
      property_sale: random_boolean(),
      public_charity: random_boolean(),
      rental_property_count: random_integer(),
      reported_grant: random_boolean(),
      restricted_donation: random_boolean(),
      state: random_states(),
      tax_exemption: random_boolean(),
      tax_year: random_year(),
      total_asset_less: random_boolean(),
      total_asset_over: random_boolean(),
      user: build(:tp_user)
    }
  end

  @spec pro_business_tax_return_factory() :: BusinessTaxReturn.t()
  def pro_business_tax_return_factory do
    %BusinessTaxReturn{
      none_expat: random_boolean(),
      price_state: random_integer(),
      price_tax_year: random_integer(),
      user: build(:pro_user)
    }
  end

  @spec business_entity_type_factory() :: BusinessEntityType.t()
  def business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:business_tax_return),
      name: random_name_entity_type(),
      price: random_integer()
    }
  end

  @spec tp_business_entity_type_factory() :: BusinessEntityType.t()
  def tp_business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_entity_type()
    }
  end

  @spec pro_business_entity_type_factory() :: BusinessEntityType.t()
  def pro_business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:pro_business_tax_return),
      name: random_name_entity_type(),
      price: random_integer()
    }
  end

  @spec business_foreign_account_count_factory() :: BusinessForeignAccountCount.t()
  def business_foreign_account_count_factory do
    %BusinessForeignAccountCount{
      business_tax_returns: build(:business_tax_return),
      name: random_name_count()
    }
  end

  @spec tp_business_foreign_account_count_factory() :: BusinessForeignAccountCount.t()
  def tp_business_foreign_account_count_factory do
    %BusinessForeignAccountCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_count()
    }
  end

  @spec business_foreign_ownership_count_factory() :: BusinessForeignOwnershipCount.t()
  def business_foreign_ownership_count_factory do
    %BusinessForeignOwnershipCount{
      business_tax_returns: build(:business_tax_return),
      name: random_name_count()
    }
  end

  @spec tp_business_foreign_ownership_count_factory() :: BusinessForeignOwnershipCount.t()
  def tp_business_foreign_ownership_count_factory do
    %BusinessForeignOwnershipCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_count()
    }
  end

  @spec business_industry_factory() :: BusinessIndustry.t()
  def business_industry_factory do
    %BusinessIndustry{
      business_tax_returns: build(:business_tax_return),
      name: random_name_industry()
    }
  end

  @spec tp_business_industry_factory() :: BusinessIndustry.t()
  def tp_business_industry_factory do
    %BusinessIndustry{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_for_tp_industry()
    }
  end

  @spec pro_business_industry_factory() :: BusinessIndustry.t()
  def pro_business_industry_factory do
    %BusinessIndustry{
      business_tax_returns: build(:pro_business_tax_return),
      name: random_name_for_pro_industry()
    }
  end

  @spec business_llc_type_factory() :: BusinessLlcType.t()
  def business_llc_type_factory do
    %BusinessLlcType{
      business_tax_returns: build(:business_tax_return),
      name: random_name_llc_type()
    }
  end

  @spec tp_business_llc_type_factory() :: BusinessLlcType.t()
  def tp_business_llc_type_factory do
    %BusinessLlcType{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_llc_type()
    }
  end

  @spec business_number_employee_factory() :: BusinessNumberEmployee.t()
  def business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:business_tax_return),
      name: random_name_employee(),
      price: random_integer()
    }
  end

  @spec tp_business_number_employee_factory() :: BusinessNumberEmployee.t()
  def tp_business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_employee()
    }
  end

  @spec pro_business_number_employee_factory() :: BusinessNumberEmployee.t()
  def pro_business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:pro_business_tax_return),
      name: random_name_employee(),
      price: random_integer()
    }
  end

  @spec business_total_revenue_factory() :: BusinessTotalRevenue.t()
  def business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:business_tax_return),
      name: random_name_revenue(),
      price: random_integer()
    }
  end

  @spec tp_business_total_revenue_factory() :: BusinessTotalRevenue.t()
  def tp_business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_revenue()
    }
  end

  @spec pro_business_total_revenue_factory() :: BusinessTotalRevenue.t()
  def pro_business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:pro_business_tax_return),
      name: random_name_revenue(),
      price: random_integer()
    }
  end

  @spec business_transaction_count_factory() :: BusinessTransactionCount.t()
  def business_transaction_count_factory do
    %BusinessTransactionCount{
      business_tax_returns: build(:business_tax_return),
      name: random_name_transaction_count()
    }
  end

  @spec tp_business_transaction_count_factory() :: BusinessTransactionCount.t()
  def tp_business_transaction_count_factory do
    %BusinessTransactionCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_transaction_count()
    }
  end

  @spec individual_tax_return_factory() :: IndividualTaxReturn.t()
  def individual_tax_return_factory do
    %IndividualTaxReturn{
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      foreign_account: random_boolean(),
      foreign_account_limit: random_boolean(),
      foreign_financial_interest: random_boolean(),
      home_owner: random_boolean(),
      k1_count: random_integer(),
      k1_income: random_boolean(),
      living_abroad: random_boolean(),
      non_resident_earning: random_boolean(),
      none_expat: random_boolean(),
      own_stock_crypto: random_boolean(),
      price_foreign_account: random_integer(),
      price_home_owner: random_integer(),
      price_living_abroad: random_integer(),
      price_non_resident_earning: random_integer(),
      price_own_stock_crypto: random_integer(),
      price_rental_property_income: random_integer(),
      price_sole_proprietorship_count: random_integer(),
      price_state: random_integer(),
      price_stock_divident: random_integer(),
      price_tax_year: random_integer(),
      rental_property_count: random_integer(),
      rental_property_income: random_boolean(),
      sole_proprietorship_count: random_integer(),
      state: random_states(),
      stock_divident: random_boolean(),
      tax_year: random_year(),
      user: build(:user)
    }
  end

  @spec tp_individual_tax_return_factory() :: IndividualTaxReturn.t()
  def tp_individual_tax_return_factory do
    %IndividualTaxReturn{
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      foreign_account: random_boolean(),
      foreign_account_limit: random_boolean(),
      foreign_financial_interest: random_boolean(),
      home_owner: random_boolean(),
      k1_count: random_integer(),
      k1_income: random_boolean(),
      living_abroad: random_boolean(),
      non_resident_earning: random_boolean(),
      none_expat: random_boolean(),
      own_stock_crypto: random_boolean(),
      rental_property_count: random_integer(),
      rental_property_income: random_boolean(),
      sole_proprietorship_count: random_integer(),
      state: random_states(),
      stock_divident: random_boolean(),
      tax_year: random_year(),
      user: build(:tp_user)
    }
  end

  @spec pro_individual_tax_return_factory() :: IndividualTaxReturn.t()
  def pro_individual_tax_return_factory do
    %IndividualTaxReturn{
      foreign_account: random_boolean(),
      home_owner: random_boolean(),
      living_abroad: random_boolean(),
      non_resident_earning: random_boolean(),
      none_expat: random_boolean(),
      own_stock_crypto: random_boolean(),
      price_foreign_account: random_integer(),
      price_home_owner: random_integer(),
      price_living_abroad: random_integer(),
      price_non_resident_earning: random_integer(),
      price_own_stock_crypto: random_integer(),
      price_rental_property_income: random_integer(),
      price_sole_proprietorship_count: random_integer(),
      price_state: random_integer(),
      price_stock_divident: random_integer(),
      price_tax_year: random_integer(),
      rental_property_income: random_boolean(),
      stock_divident: random_boolean(),
      user: build(:pro_user)
    }
  end

  @spec individual_employment_status_factory() :: IndividualEmploymentStatus.t()
  def individual_employment_status_factory do
    %IndividualEmploymentStatus{
      individual_tax_returns: build(:individual_tax_return),
      name: random_name_employment_status(),
      price: Faker.random_between(1, 99)
    }
  end

  @spec tp_individual_employment_status_factory() :: IndividualEmploymentStatus.t()
  def tp_individual_employment_status_factory do
    %IndividualEmploymentStatus{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: random_name_employment_status()
    }
  end

  @spec pro_individual_employment_status_factory() :: IndividualEmploymentStatus.t()
  def pro_individual_employment_status_factory do
    %IndividualEmploymentStatus{
      individual_tax_returns: build(:pro_individual_tax_return),
      name: random_name_employment_status(),
      price: Faker.random_between(1, 99)
    }
  end

  @spec individual_filing_status_factory() :: IndividualFilingStatus.t()
  def individual_filing_status_factory do
    %IndividualFilingStatus{
      individual_tax_returns: build(:individual_tax_return),
      name: random_name_filling_status(),
      price: Faker.random_between(1, 99)
    }
  end

  @spec tp_individual_filing_status_factory() :: IndividualFilingStatus.t()
  def tp_individual_filing_status_factory do
    %IndividualFilingStatus{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: random_name_filling_status()
    }
  end

  @spec pro_individual_filing_status_factory() :: IndividualFilingStatus.t()
  def pro_individual_filing_status_factory do
    %IndividualFilingStatus{
      individual_tax_returns: build(:pro_individual_tax_return),
      name: random_name_filling_status(),
      price: Faker.random_between(1, 99)
    }
  end

  @spec individual_foreign_account_count_factory() :: IndividualForeignAccountCoun.t()
  def individual_foreign_account_count_factory do
    %IndividualForeignAccountCount{
      individual_tax_returns: build(:individual_tax_return),
      name: random_name_count()
    }
  end

  @spec tp_individual_foreign_account_count_factory() :: IndividualForeignAccountCoun.t()
  def tp_individual_foreign_account_count_factory do
    %IndividualForeignAccountCount{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: random_name_count()
    }
  end

  @spec individual_industry_factory() :: IndividualIndustry.t()
  def individual_industry_factory do
    %IndividualIndustry{
      individual_tax_returns: build(:individual_tax_return),
      name: random_name_industry()
    }
  end

  @spec tp_individual_industry_factory() :: IndividualIndustry.t()
  def tp_individual_industry_factory do
    %IndividualIndustry{
      individual_tax_returns: build(:tp_business_tax_return),
      name: random_name_for_tp_industry()
    }
  end

  @spec pro_individual_industry_factory() :: IndividualIndustry.t()
  def pro_individual_industry_factory do
    %IndividualIndustry{
      individual_tax_returns: build(:pro_individual_tax_return),
      name: random_name_for_pro_industry()
    }
  end

  @spec individual_itemized_deduction_factory() :: IndividualItemizedDeduction.t()
  def individual_itemized_deduction_factory do
    %IndividualItemizedDeduction{
      individual_tax_returns: build(:individual_tax_return),
      name: random_name_itemized_deduction(),
      price: Faker.random_between(1, 99)
    }
  end

  @spec tp_individual_itemized_deduction_factory() :: IndividualItemizedDeduction.t()
  def tp_individual_itemized_deduction_factory do
    %IndividualItemizedDeduction{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: random_name_itemized_deduction()
    }
  end

  @spec pro_individual_itemized_deduction_factory() :: IndividualItemizedDeduction.t()
  def pro_individual_itemized_deduction_factory do
    %IndividualItemizedDeduction{
      individual_tax_returns: build(:pro_individual_tax_return),
      name: random_name_itemized_deduction(),
      price: Faker.random_between(1, 99)
    }
  end

  @spec individual_stock_transaction_count_factory() :: IndividualStockTransactionCount.t()
  def individual_stock_transaction_count_factory do
    %IndividualStockTransactionCount{
      individual_tax_returns: build(:individual_tax_return),
      name: random_name_stock_transaction_count()
    }
  end

  @spec tp_individual_stock_transaction_count_factory() :: IndividualStockTransactionCount.t()
  def tp_individual_stock_transaction_count_factory do
    %IndividualStockTransactionCount{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: random_name_stock_transaction_count()
    }
  end

  @spec sale_tax_factory() :: SaleTax.t()
  def sale_tax_factory do
    %SaleTax{
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      price_sale_tax_count: random_integer(),
      sale_tax_count: random_integer(),
      state: random_states(),
      user: build(:user)
    }
  end

  @spec tp_sale_tax_factory() :: SaleTax.t()
  def tp_sale_tax_factory do
    %SaleTax{
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      sale_tax_count: random_integer(),
      state: random_states(),
      user: build(:tp_user)
    }
  end

  @spec pro_sale_tax_factory() :: SaleTax.t()
  def pro_sale_tax_factory do
    %SaleTax{
      price_sale_tax_count: random_integer(),
      user: build(:tp_user)
    }
  end

  @spec sale_tax_frequency_factory() :: SaleTaxFrequency.t()
  def sale_tax_frequency_factory do
    %SaleTaxFrequency{
      name: random_name_tax_frequency(),
      price: random_integer(),
      sale_taxes: build(:sale_tax)
    }
  end

  @spec tp_sale_tax_frequency_factory() :: SaleTaxFrequency.t()
  def tp_sale_tax_frequency_factory do
    %SaleTaxFrequency{
      name: random_name_tax_frequency(),
      sale_taxes: build(:tp_sale_tax)
    }
  end

  @spec pro_sale_tax_frequency_factory() :: SaleTaxFrequency.t()
  def pro_sale_tax_frequency_factory do
    %SaleTaxFrequency{
      name: random_name_tax_frequency(),
      price: random_integer(),
      sale_taxes: build(:pro_sale_tax)
    }
  end

  @spec sale_tax_industry_factory() :: SaleTaxIndustry.t()
  def sale_tax_industry_factory do
    %SaleTaxIndustry{
      name: random_name_industry(),
      sale_taxes: build(:sale_tax)
    }
  end

  @spec tp_sale_tax_industry_factory() :: SaleTaxIndustry.t()
  def tp_sale_tax_industry_factory do
    %SaleTaxIndustry{
      name: random_name_for_tp_industry(),
      sale_taxes: build(:tp_sale_tax)
    }
  end

  @spec pro_sale_tax_industry_factory() :: SaleTaxIndustry.t()
  def pro_sale_tax_industry_factory do
    %SaleTaxIndustry{
      name: random_name_for_pro_industry(),
      sale_taxes: build(:pro_sale_tax)
    }
  end

  @spec room_factory() :: Room.t()
  def room_factory do
    %Room{
      name: Lorem.word(),
      description: Lorem.sentence(),
      topic: Lorem.word(),
      user: build(:user)
    }
  end

  @spec message_factory() :: Message.t()
  def message_factory do
    %Message{
      body: Lorem.sentence(),
      room: build(:room),
      user: build(:user)
    }
    %Message{
      body: Lorem.sentence(),
      room: build(:room),
      user: build(:user)
    }
    %Message{
      body: Lorem.sentence(),
      room: build(:room),
      user: build(:user)
    }
  end

  @spec accounting_software_factory() :: AccountingSoftware.t()
  def accounting_software_factory do
    %AccountingSoftware{
      name: random_name_accounting_software(),
      user: build(:pro_user)
    }
  end

  @spec education_factory() :: Education.t()
  def education_factory do
    %Education{
      course: Lorem.word(),
      graduation: Date.utc_today |> Date.add(-6),
      university: build(:university),
      user: build(:pro_user)
    }
  end

  @spec university_factory() :: University.t()
  def university_factory do
    %University{name: random_name_university()}
  end

  @spec work_experience_factory() :: WorkExperience.t()
  def work_experience_factory do
    %WorkExperience{
      name: Lorem.word(),
      start_date: Date.utc_today |> Date.add(-16),
      end_date: Date.utc_today |> Date.add(-12),
      user: build(:pro_user)
    }
  end

  @spec random_language() :: {String.t()}
  defp random_language do
    names =
      @languages
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"abbr" => abbr, "name" => name} -> %{abbr: abbr, name: name} end)

    numbers = 1..18
    number = Enum.random(numbers)

    data =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    %{abbr: abbr, name: name} = Enum.random(data)
    {abbr, name}
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    data = ~W(true false)a
    Enum.random(data)
  end

  @spec random_gender() :: String.t()
  defp random_gender do
    data = [
      "Decline to Answer",
      "Female/Woman",
      "Genderqueer/Gender nonconforming",
      "Male/Man",
      "Something Else",
      "TransFemail/TransWomen",
      "TransMale/TransMan"
    ]

    Enum.random(data)
  end

  @spec random_email() :: String.t()
  defp random_email do
    data = [
      "lugatex@yahoo.com",
      "kapranov.lugatex@gmail.com"
    ]

    Enum.random(data)
  end

  @spec random_zipcode() :: {String.t(), String.t(), integer()}
  defp random_zipcode do
    decoded_zipcode1 =
      @usa_zipcodes_part1
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end)

    decoded_zipcode2 =
      @usa_zipcodes_part2
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end)

    decoded_zipcode3 =
      @usa_zipcodes_part3
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"Zipcode" => zipcode, "City" => city, "State" => state} ->
        %{zipcode: zipcode, city: city, state: state}
      end)

    data = [decoded_zipcode1 | [decoded_zipcode2 | decoded_zipcode3]]
    %{city: city, state: state, zipcode: zipcode} = Enum.random(data)
    {city, state, zipcode}
  end

  @spec random_provider() :: String.t()
  defp random_provider do
    data = ~w(google localhost facebook linkedin twitter)s
    Enum.random(data)
  end

  @spec random_ssn() :: integer()
  defp random_ssn do
    Us.ssn()
    |> String.replace(~r/-/, "")
    |> String.trim()
    |> String.to_integer
  end

  @spec random_integer() :: integer()
  defp random_integer(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end

  @spec random_state :: {String.t(), String.t()}
  def random_state do
    names =
      @usa_states
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"name" => name, "abbr" => abbr} -> %{name: name, abbr: abbr} end)

    numbers = 1..59
    number = Enum.random(numbers)

    data =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    %{abbr: abbr, name: name} = Enum.random(data)
    {abbr, name}
  end

  @spec random_states :: [String.t()]
  defp random_states do
    names =
      @usa_states
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"name" => name, "abbr" => _} -> name end)

    numbers = 1..59
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_year :: [String.t()]
  defp random_year do
    years = 2000..2020
    numbers = 1..9
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(years)
        |> Integer.to_string
      end
      |> Enum.uniq()

    result
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

  @spec random_name_transaction_count() :: String.t()
  defp random_name_transaction_count do
    names = ["1-10", "11-25", "26-75", "75+"]
    Enum.random(names)
  end

  @spec random_name_stock_transaction_count() :: String.t()
  defp random_name_stock_transaction_count do
    names = ["1-5", "6-50", "51-100", "100+"]
    Enum.random(names)
  end

  @spec random_name_classify_inventory :: String.t()
  defp random_name_classify_inventory do
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

  @spec random_name_industry :: [String.t()]
  defp random_name_industry do
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
      |> Enum.sort()

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
      |> Enum.sort()

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
      |> Enum.sort()

    result
  end

  @spec random_name_employee :: String.t()
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

  @spec random_name_count :: String.t()
  defp random_name_count do
    names = ["1", "2-5", "5+"]
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

  @spec random_name_tax_frequency :: String.t()
  defp random_name_tax_frequency do
    names = ["Annually", "Monthly", "Quarterly"]
    Enum.random(names)
  end

  @spec random_name_accounting_software :: [String.t()]
  defp random_name_accounting_software do
    names = [
      "QuickBooks Desktop Premier",
      "QuickBooks Desktop Pro",
      "QuickBooks Desktop for Mac",
      "QuickBooks Enterprise",
      "QuickBooks Live Bookkeeping",
      "QuickBooks Online Advanced",
      "QuickBooks Online",
      "QuickBooks Self Employed",
      "Xero Cashbook/Ledger",
      "Xero HQ",
      "Xero Practice Manager",
      "Xero Workpapers"
    ]

    numbers = 1..12
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()

    result
  end

  @spec random_name_university :: String.t()
  defp random_name_university do
    names =
      @universities
      |> File.read!()
      |> Jason.decode!()
      |> Enum.map(fn %{"name" => name} -> name end)

    numbers = 1..1
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
      |> Enum.uniq()
      |> List.to_string

    result
  end
end
