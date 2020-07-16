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
    Talk.Message,
    Talk.Room,
    Upload
  }

  alias Faker.{
    Address,
    Avatar,
    Company.En,
    Internet,
    Lorem,
    Name,
    Phone.EnUs,
    UUID
  }

  alias Ptin.Services.Ptin

  @image1_path Path.absname("../core/test/fixtures/image.jpg")
  @image2_path Path.absname("../core/test/fixtures/image_tmp.jpg")

  @spec faq_category_factory() :: FaqCategory.t()
  def faq_category_factory do
    %FaqCategory{
      title: Lorem.word()
    }
  end

  @spec faq_factory() :: Faq.t()
  def faq_factory do
    %Faq{
      content: Lorem.sentence(),
      title: Lorem.word(),
      faq_categories: build(:faq_category)
    }
  end

  @spec press_article_factory() :: PressArticle.t()
  def press_article_factory do
    %PressArticle{
      author: Name.name(),
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

  @spec language_factory() :: Language.t()
  def language_factory do
    %Language{
      abbr: "chi",
      name: "chinese"
    }
  end

  @spec subscriber_factory() :: Subscriber.t()
  def subscriber_factory do
    %Subscriber{
      email: "lugatex@yahoo.com",
      pro_role: false
    }
  end

  @spec user_factory() :: User.t()
  def user_factory do
    %User{
      active: false,
      avatar: "some text",
      bio: "some text",
      birthday: Date.add(Timex.now, 0),
      email: "lugatex@yahoo.com",
      first_name: "some text",
      init_setup: false,
      languages: [build(:language, name: "chinese")],
      last_name: "some text",
      middle_name: "some text",
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: "some text",
      provider: "google",
      role: false,
      sex: "some text",
      ssn: 123456789,
      street: "some text",
      zip: 123456789
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
      first_name: Name.first_name(),
      init_setup: random_boolean(),
      languages: [build(:language, name: "greek, italian, polish")],
      last_name: Name.last_name(),
      middle_name: Name.name(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: EnUs.phone(),
      provider: "localhost",
      role: false,
      sex: random_gender(),
      ssn: random_integer(),
      street: Address.En.street_address(),
      zip: random_integer()
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
      first_name: Name.first_name(),
      init_setup: random_boolean(),
      languages: [build(:language, name: "spanish, japanese, german, french")],
      last_name: Name.last_name(),
      middle_name: Name.name(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: "555-555-5555",
      provider: "localhost",
      role: true,
      sex: random_gender(),
      ssn: random_integer(),
      street: Address.En.street_address(),
      zip: random_integer()
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

  @spec zipcode_factory() :: UsZipcode.t()
  def zipcode_factory do
    %UsZipcode{
      city: "AGUADA",
      state: "PR",
      zipcode: 602
    }
  end

  @spec profile_factory() :: Profile.t()
  def profile_factory do
    %Profile{
      address: "some text",
      banner: "some text",
      description: "some text",
      logo: build(:file, name: "Logo"),
      us_zipcode: build(:zipcode),
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
      name: random_name_annual_revenue(),
      price: random_integer()
    }
  end

  @spec tp_book_keeping_annual_revenue_factory() :: BookKeepingAnnualRevenue.t()
  def tp_book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:tp_book_keeping),
      name: random_name_annual_revenue()
    }
  end

  @spec pro_book_keeping_annual_revenue_factory() :: BookKeepingAnnualRevenue.t()
  def pro_book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:pro_book_keeping),
      name: random_name_annual_revenue(),
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
      name: random_name_number_employee(),
      price: random_integer()
    }
  end

  @spec tp_book_keeping_number_employee_factory() :: BookKeepingNumberEmployee.t()
  def tp_book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:tp_book_keeping),
      name: random_name_number_employee()
    }
  end

  @spec pro_book_keeping_number_employee_factory() :: BookKeepingNumberEmployee.t()
  def pro_book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:pro_book_keeping),
      name: random_name_number_employee(),
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
      state: [random_state()],
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
      state: [random_state()],
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
      name: "C-Corp / Corporation",
      price: random_integer()
    }
  end

  @spec tp_business_entity_type_factory() :: BusinessEntityType.t()
  def tp_business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:tp_business_tax_return),
      name: "C-Corp / Corporation"
    }
  end

  @spec pro_business_entity_type_factory() :: BusinessEntityType.t()
  def pro_business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:pro_business_tax_return),
      name: "C-Corp / Corporation",
      price: random_integer()
    }
  end

  @spec business_foreign_account_count_factory() :: BusinessForeignAccountCount.t()
  def business_foreign_account_count_factory do
    %BusinessForeignAccountCount{
      business_tax_returns: build(:business_tax_return),
      name: "1"
    }
  end

  @spec tp_business_foreign_account_count_factory() :: BusinessForeignAccountCount.t()
  def tp_business_foreign_account_count_factory do
    %BusinessForeignAccountCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: "1"
    }
  end

  @spec business_foreign_ownership_count_factory() :: BusinessForeignOwnershipCount.t()
  def business_foreign_ownership_count_factory do
    %BusinessForeignOwnershipCount{
      business_tax_returns: build(:business_tax_return),
      name: "1"
    }
  end

  @spec tp_business_foreign_ownership_count_factory() :: BusinessForeignOwnershipCount.t()
  def tp_business_foreign_ownership_count_factory do
    %BusinessForeignOwnershipCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: "1"
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
      name: "C-Corp / Corporation"
    }
  end

  @spec tp_business_llc_type_factory() :: BusinessLlcType.t()
  def tp_business_llc_type_factory do
    %BusinessLlcType{
      business_tax_returns: build(:tp_business_tax_return),
      name: "C-Corp / Corporation"
    }
  end

  @spec business_number_employee_factory() :: BusinessNumberEmployee.t()
  def business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:business_tax_return),
      name: "1 employee",
      price: random_integer()
    }
  end

  @spec tp_business_number_employee_factory() :: BusinessNumberEmployee.t()
  def tp_business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:tp_business_tax_return),
      name: "1 employee"
    }
  end

  @spec pro_business_number_employee_factory() :: BusinessNumberEmployee.t()
  def pro_business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:pro_business_tax_return),
      name: "1 employee",
      price: random_integer()
    }
  end

  @spec business_total_revenue_factory() :: BusinessTotalRevenue.t()
  def business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:business_tax_return),
      name: "$100K - $500K",
      price: random_integer()
    }
  end

  @spec tp_business_total_revenue_factory() :: BusinessTotalRevenue.t()
  def tp_business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:tp_business_tax_return),
      name: "$100K - $500K"
    }
  end

  @spec pro_business_total_revenue_factory() :: BusinessTotalRevenue.t()
  def pro_business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:pro_business_tax_return),
      name: "$100K - $500K",
      price: random_integer()
    }
  end

  @spec business_transaction_count_factory() :: BusinessTransactionCount.t()
  def business_transaction_count_factory do
    %BusinessTransactionCount{
      business_tax_returns: build(:business_tax_return),
      name: "1-10"
    }
  end

  @spec tp_business_transaction_count_factory() :: BusinessTransactionCount.t()
  def tp_business_transaction_count_factory do
    %BusinessTransactionCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: "1-10"
    }
  end

  @spec individual_tax_return_factory() :: IndividualTaxReturn.t()
  def individual_tax_return_factory do
    %IndividualTaxReturn{
      deadline: Date.utc_today(),
      foreign_account: random_boolean(),
      foreign_account_limit: random_boolean(),
      foreign_financial_interest: random_boolean(),
      home_owner: random_boolean(),
      k1_count: random_integer(9),
      k1_income: random_boolean(),
      living_abroad: random_boolean(),
      non_resident_earning: random_boolean(),
      none_expat: random_boolean(),
      own_stock_crypto: random_boolean(),
      price_foreign_account: random_integer(9),
      price_home_owner: random_integer(9),
      price_living_abroad: random_integer(9),
      price_non_resident_earning: random_integer(9),
      price_own_stock_crypto: random_integer(9),
      price_rental_property_income: random_integer(9),
      price_sole_proprietorship_count: random_integer(9),
      price_state: random_integer(9),
      price_stock_divident: random_integer(9),
      price_tax_year: random_integer(9),
      rental_property_count: random_integer(9),
      rental_property_income: random_boolean(),
      sole_proprietorship_count: random_integer(9),
      state: [random_state()],
      stock_divident: random_boolean(),
      tax_year: random_year(),
      user: build(:user)
    }
  end

  @spec tp_individual_tax_return_factory() :: IndividualTaxReturn.t()
  def tp_individual_tax_return_factory do
    %IndividualTaxReturn{
      deadline: Date.utc_today(),
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
      state: [random_state()],
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
      name: random_name_foreign_account_count()
    }
  end

  @spec tp_individual_foreign_account_count_factory() :: IndividualForeignAccountCoun.t()
  def tp_individual_foreign_account_count_factory do
    %IndividualForeignAccountCount{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: random_name_foreign_account_count()
    }
  end

  @spec pro_individual_foreign_account_count_factory() :: IndividualForeignAccountCoun.t()
  def pro_individual_foreign_account_count_factory do
    %IndividualForeignAccountCount{
      individual_tax_returns: build(:pro_individual_tax_return),
      name: random_name_foreign_account_count()
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
      name: Lorem.word()
    }
  end

  @spec tp_individual_stock_transaction_count_factory() :: IndividualStockTransactionCount.t()
  def tp_individual_stock_transaction_count_factory do
    %IndividualStockTransactionCount{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: Lorem.word()
    }
  end

  @spec pro_individual_stock_transaction_count_factory() :: IndividualStockTransactionCount.t()
  def pro_individual_stock_transaction_count_factory do
    %IndividualStockTransactionCount{
      individual_tax_returns: build(:pro_individual_tax_return),
      name: Lorem.word()
    }
  end

  @spec sale_tax_factory() :: SaleTax.t()
  def sale_tax_factory do
    %SaleTax{
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      price_sale_tax_count: random_integer(),
      sale_tax_count: random_integer(),
      state: ["Alabama", "New York"],
      user: build(:user)
    }
  end

  @spec tp_sale_tax_factory() :: SaleTax.t()
  def tp_sale_tax_factory do
    %SaleTax{
      deadline: Date.utc_today(),
      financial_situation: Lorem.sentence(),
      sale_tax_count: random_integer(),
      state: ["Alabama", "New York"],
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

  @spec state_factory() :: State.t()
  def state_factory do
    %State{
      abbr: Lorem.word(),
      name: Lorem.word()
    }
  end

  @spec room_factory() :: Room.t()
  def room_factory do
    %Room{
      name: "Pandemic with Steve Bannon",
      description: "Citizens of the American Republic",
      topic: "war_room",
      user: build(:user)
    }
  end

  @spec message_factory() :: Message.t()
  def message_factory do
    %Message{
      body: "America isn't burning -- Democrat America is burning.",
      room: build(:room),
      user: build(:user)
    }
    %Message{
      body: "Brilliant episode understanding why we are where we are with China",
      room: build(:room),
      user: build(:user)
    }
    %Message{
      body: "love you Steve, enlightening!",
      room: build(:room),
      user: build(:user)
    }
  end

  @spec random_boolean() :: boolean
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_integer() :: integer
  defp random_integer() do
    Enum.random(111111111..123456789)
  end

  @spec random_integer(integer) :: integer
  defp random_integer(n) when is_integer(n) do
    Enum.random(1..n)
  end

  @spec random_gender() :: String.t()
  defp random_gender do
    gender = [
      "Decline to Answer",
      "Female/Woman",
      "Genderqueer/Gender nonconforming",
      "Male/Man",
      "Something Else",
      "TransFemail/TransWomen",
      "TransMale/TransMan"
    ]

    gender
    |> Enum.random
  end

  @spec random_state :: String.t()
  defp random_state do
    states =
      ~w(Hawaii Georgia Iowa)s
      |> Enum.random()

    states
  end

  @spec random_year :: list()
  defp random_year do
    years = 2000..2020
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

  @spec random_name_annual_revenue :: String.t
  defp random_name_annual_revenue do
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

  @spec random_name_classify_inventory :: String.t
  defp random_name_classify_inventory do
    names = [
      "Assets",
      "Expenses"
    ]

    Enum.random(names)
  end

  @spec random_name_industry :: String.t
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

    Enum.uniq(result)
  end

  @spec random_name_for_tp_industry :: String.t
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

    [Enum.random(names)]
  end

  @spec random_name_for_pro_industry :: String.t
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

  @spec random_name_number_employee :: String.t
  defp random_name_number_employee do
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

  @spec random_name_transaction_volume :: String.t
  defp random_name_transaction_volume do
    names = [
      "1-25",
      "200+",
      "26-75",
      "76-199"
    ]

    Enum.random(names)
  end

  @spec random_name_type_client :: String.t
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

  @spec random_name_employment_status :: String.t()
  defp random_name_employment_status do
    names = [
      "employed",
      "self-employed",
      "unemployed"
    ]

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

  @spec random_name_foreign_account_count :: String.t()
  defp random_name_foreign_account_count do
    names = [
      "1",
      "2-5",
      "5+"
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

  @spec random_name_tax_frequency :: String.t
  defp random_name_tax_frequency do
    names = ["Annually", "Monthly", "Quarterly"]
    Enum.random(names)
  end
end
