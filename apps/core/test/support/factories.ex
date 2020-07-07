defmodule Core.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

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
    Commerce,
    Gov.Us,
    Internet,
    Lorem,
    Name,
    Phone,
    UUID
  }

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

  @spec picture_factory() :: Picture.t()
  def picture_factory do
    %Picture{
      file: build(:file),
      profile: build(:profile)
    }
  end

  @spec file_factory() :: Core.Media.File.t()
  def file_factory do
    File.cp!("test/fixtures/image.jpg", "test/fixtures/image_tmp.jpg")

    file = %Plug.Upload{
      content_type: "image/jpg",
      filename: "image_tmp.jpg",
      path: Path.absname("test/fixtures/image_tmp.jpg")
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

  @spec subscriber_factory() :: Subscriber.t()
  def subscriber_factory do
    %Subscriber{
      email: random_email(),
      pro_role: random_boolean()
    }
  end

  @spec state_factory() :: State.t()
  def state_factory do
    %State{
      abbr: Lorem.word(),
      name: Lorem.word()
    }
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
      birthday: Timex.today,
      email: random_email(),
      first_name: Name.first_name(),
      init_setup: random_boolean(),
      last_name: Name.last_name(),
      middle_name: Name.suffix(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: Phone.Hy.cell_number(),
      provider: random_provider(),
      role: random_boolean(),
      sex: random_gender(),
      ssn: random_ssn(),
      street: Address.street_address(),
      zip: Address.zip_code()
    }
  end

  @spec tp_user_factory() :: User.t()
  def tp_user_factory do
    %User{
      active: random_boolean(),
      avatar: Avatar.image_url(),
      bio: Lorem.sentence(),
      birthday: Timex.today,
      email: "v.kobzan@gmail.com",
      first_name: Name.first_name(),
      init_setup: random_boolean(),
      last_name: Name.last_name(),
      middle_name: Name.suffix(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: Phone.Hy.cell_number(),
      provider: "localhost",
      role: false,
      sex: random_gender(),
      ssn: random_ssn(),
      street: Address.street_address(),
      zip: Address.zip_code()
    }
  end

  @spec pro_user_factory() :: User.t()
  def pro_user_factory do
    %User{
      active: random_boolean(),
      avatar: Avatar.image_url(),
      bio: Lorem.sentence(),
      birthday: Timex.today,
      email: "support@taxgig.com",
      first_name: Name.first_name(),
      init_setup: random_boolean(),
      last_name: Name.last_name(),
      middle_name: Name.suffix(),
      password: "qwerty",
      password_confirmation: "qwerty",
      phone: Phone.Hy.cell_number(),
      provider: "localhost",
      role: true,
      sex: random_gender(),
      ssn: random_ssn(),
      street: Address.street_address(),
      zip: Address.zip_code()
    }
  end

  @spec users_languages_factory() ::  {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def users_languages_factory do
    lang = insert(:language)
    user = insert(:user)
    struct =
      Repo.get(User, user.id)
      |> Repo.preload([:languages])

    user_changeset = Ecto.Changeset.change(struct)
    user_languages_changeset =
      user_changeset
      |> Ecto.Changeset.put_assoc(:languages, [lang])
      |> Repo.update!()

    user_languages_changeset
  end

  @spec vacancy_factory() :: Vacancy.t()
  def vacancy_factory do
    %Vacancy{
      content: Commerce.product_name(),
      department: Commerce.department(),
      title: Lorem.word()
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

  def book_keeping_factory do
    %BookKeeping{
      account_count: random_integer(),
      balance_sheet: random_boolean(),
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

  def pro_book_keeping_factory do
    %BookKeeping{
      payroll: random_boolean(),
      price_payroll: random_integer(),
      user: build(:pro_user)
    }
  end

  def book_keeping_additional_need_factory do
    %BookKeepingAdditionalNeed{
      book_keepings: build(:book_keeping),
      name: random_name_additional_need(),
      price: random_integer()
    }
  end

  def tp_book_keeping_additional_need_factory do
    %BookKeepingAdditionalNeed{
      book_keepings: build(:tp_book_keeping),
      name: random_name_additional_need()
    }
  end

  def pro_book_keeping_additional_need_factory do
    %BookKeepingAdditionalNeed{
      book_keepings: build(:pro_book_keeping),
      name: random_name_additional_need(),
      price: random_integer()
    }
  end

  def book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:book_keeping),
      name: random_name_annual_revenue(),
      price: random_integer()
    }
  end

  def tp_book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:tp_book_keeping),
      name: random_name_annual_revenue()
    }
  end

  def pro_book_keeping_annual_revenue_factory do
    %BookKeepingAnnualRevenue{
      book_keepings: build(:pro_book_keeping),
      name: random_name_annual_revenue(),
      price: random_integer()
    }
  end

  def book_keeping_classify_inventory_factory do
    %BookKeepingClassifyInventory{
      book_keepings: build(:book_keeping),
      name: random_name_classify_inventory()
    }
  end

  def tp_book_keeping_classify_inventory_factory do
    %BookKeepingClassifyInventory{
      book_keepings: build(:tp_book_keeping),
      name: random_name_classify_inventory()
    }
  end

  def book_keeping_industry_factory do
    %BookKeepingIndustry{
      book_keepings: build(:book_keeping),
      name: random_name_industry()
    }
  end

  def tp_book_keeping_industry_factory do
    %BookKeepingIndustry{
      book_keepings: build(:tp_book_keeping),
      name: random_name_for_tp_industry()
    }
  end

  def pro_book_keeping_industry_factory do
    %BookKeepingIndustry{
      book_keepings: build(:pro_book_keeping),
      name: random_name_for_pro_industry()
    }
  end

  def book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:book_keeping),
      name: random_name_number_employee(),
      price: random_integer()
    }
  end

  def tp_book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:tp_book_keeping),
      name: random_name_number_employee()
    }
  end

  def pro_book_keeping_number_employee_factory do
    %BookKeepingNumberEmployee{
      book_keepings: build(:pro_book_keeping),
      name: random_name_number_employee(),
      price: random_integer()
    }
  end

  def book_keeping_transaction_volume_factory do
    %BookKeepingTransactionVolume{
      book_keepings: build(:book_keeping),
      name: random_name_transaction_volume(),
      price: random_integer()
    }
  end

  def tp_book_keeping_transaction_volume_factory do
    %BookKeepingTransactionVolume{
      book_keepings: build(:tp_book_keeping),
      name: random_name_transaction_volume()
    }
  end

  def pro_book_keeping_transaction_volume_factory do
    %BookKeepingTransactionVolume{
      book_keepings: build(:pro_book_keeping),
      name: random_name_transaction_volume(),
      price: random_integer()
    }
  end

  def book_keeping_type_client_factory do
    %BookKeepingTypeClient{
      book_keepings: build(:book_keeping),
      name: random_name_type_client(),
      price: random_integer()
    }
  end

  def tp_book_keeping_type_client_factory do
    %BookKeepingTypeClient{
      book_keepings: build(:tp_book_keeping),
      name: random_name_type_client()
    }
  end

  def pro_book_keeping_type_client_factory do
    %BookKeepingTypeClient{
      book_keepings: build(:pro_book_keeping),
      name: random_name_type_client(),
      price: random_integer()
    }
  end

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

  def pro_business_tax_return_factory do
    %BusinessTaxReturn{
      none_expat: random_boolean(),
      price_state: random_integer(),
      price_tax_year: random_integer(),
      user: build(:pro_user)
    }
  end

  def business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:business_tax_return),
      name: Lorem.word(),
      price: random_integer()
    }
  end

  def tp_business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:tp_business_tax_return),
      name: Lorem.word()
    }
  end

  def pro_business_entity_type_factory do
    %BusinessEntityType{
      business_tax_returns: build(:pro_business_tax_return),
      name: Lorem.word(),
      price: random_integer()
    }
  end

  def business_foreign_account_count_factory do
    %BusinessForeignAccountCount{
      business_tax_returns: build(:business_tax_return),
      name: Lorem.word()
    }
  end

  def tp_business_foreign_account_count_factory do
    %BusinessForeignAccountCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: Lorem.word()
    }
  end

  def pro_business_foreign_account_count_factory do
    %BusinessForeignAccountCount{
      business_tax_returns: build(:pro_business_tax_return),
      name: Lorem.word()
    }
  end

  def business_foreign_ownership_count_factory do
    %BusinessForeignOwnershipCount{
      business_tax_returns: build(:business_tax_return),
      name: Lorem.word()
    }
  end

  def tp_business_foreign_ownership_count_factory do
    %BusinessForeignOwnershipCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: Lorem.word()
    }
  end

  def pro_business_foreign_ownership_count_factory do
    %BusinessForeignOwnershipCount{
      business_tax_returns: build(:pro_business_tax_return),
      name: Lorem.word()
    }
  end

  def business_industry_factory do
    %BusinessIndustry{
      business_tax_returns: build(:business_tax_return),
      name: random_name_for_tp_industry()
    }
  end

  def tp_business_industry_factory do
    %BusinessIndustry{
      business_tax_returns: build(:tp_business_tax_return),
      name: random_name_for_tp_industry()
    }
  end

  def pro_business_industry_factory do
    %BusinessIndustry{
      business_tax_returns: build(:pro_business_tax_return),
      name: random_name_for_pro_industry()
    }
  end

  def business_llc_type_factory do
    %BusinessLlcType{
      business_tax_returns: build(:business_tax_return),
      name: Lorem.word()
    }
  end

  def tp_business_llc_type_factory do
    %BusinessLlcType{
      business_tax_returns: build(:tp_business_tax_return),
      name: Lorem.word()
    }
  end

  def pro_business_llc_type_factory do
    %BusinessLlcType{
      business_tax_returns: build(:pro_business_tax_return),
      name: Lorem.word()
    }
  end

  def business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:business_tax_return),
      name: Lorem.word(),
      price: random_integer()
    }
  end

  def tp_business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:tp_business_tax_return),
      name: Lorem.word()
    }
  end

  def pro_business_number_employee_factory do
    %BusinessNumberEmployee{
      business_tax_returns: build(:pro_business_tax_return),
      name: Lorem.word(),
      price: random_integer()
    }
  end

  def business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:business_tax_return),
      name: Lorem.word(),
      price: random_integer()
    }
  end

  def tp_business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:tp_business_tax_return),
      name: Lorem.word()
    }
  end

  def pro_business_total_revenue_factory do
    %BusinessTotalRevenue{
      business_tax_returns: build(:pro_business_tax_return),
      name: Lorem.word(),
      price: random_integer()
    }
  end

  def business_transaction_count_factory do
    %BusinessTransactionCount{
      business_tax_returns: build(:business_tax_return),
      name: Lorem.word()
    }
  end

  def tp_business_transaction_count_factory do
    %BusinessTransactionCount{
      business_tax_returns: build(:tp_business_tax_return),
      name: Lorem.word()
    }
  end

  def pro_business_transaction_count_factory do
    %BusinessTransactionCount{
      business_tax_returns: build(:pro_business_tax_return),
      name: Lorem.word()
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

  @spec individual_foreign_account_count_factory() :: IndividualForeignAccountCount.t()
  def individual_foreign_account_count_factory do
    %IndividualForeignAccountCount{
      individual_tax_returns: build(:individual_tax_return),
      name: random_name_foreign_account_count()
    }
  end

  @spec tp_individual_foreign_account_count_factory() :: IndividualForeignAccountCount.t()
  def tp_individual_foreign_account_count_factory do
    %IndividualForeignAccountCount{
      individual_tax_returns: build(:tp_individual_tax_return),
      name: random_name_foreign_account_count()
    }
  end

  @spec pro_individual_foreign_account_count_factory() :: IndividualForeignAccountCount.t()
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
      name: random_name_for_tp_industry()
    }
  end

  @spec tp_individual_industry_factory() :: IndividualIndustry.t()
  def tp_individual_industry_factory do
    %IndividualIndustry{
      individual_tax_returns: build(:tp_individual_tax_return),
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
      name: random_name_tax_industry(),
      sale_taxes: build(:sale_tax)
    }
  end

  @spec tp_sale_tax_industry_factory() :: SaleTaxIndustry.t()
  def tp_sale_tax_industry_factory do
    %SaleTaxIndustry{
      name: random_name_for_tp_tax_industry(),
      sale_taxes: build(:tp_sale_tax)
    }
  end

  @spec pro_sale_tax_industry_factory() :: SaleTaxIndustry.t()
  def pro_sale_tax_industry_factory do
    %SaleTaxIndustry{
      name: random_name_for_pro_tax_industry(),
      sale_taxes: build(:pro_sale_tax)
    }
  end

  @spec room_factory() :: Room.t()
  def room_factory do
    %Room{
      name: "defend the police",
      description: "It Can't Get Any More Ridiculous or Frightening.",
      topic: "lionel_nation",
      user: build(:user)
    }
  end

  @spec message_factory() :: Message.t()
  def message_factory do
    %Message{
      body: "My area in Michigan is covered in Trump flags and we have every race there is",
      room: build(:room),
      user: build(:user)
    }
    %Message{
      body: "People like to be Seen a victims. The love to be pitied by others",
      room: build(:room),
      user: build(:user)
    }
    %Message{
      body: "I lived in Chicago. It is and always had been corrupt and lawless.",
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

  @spec random_language() :: {atom, String.t()}
  def random_language do
    data = [
      ara: "arabic",
      ben: "bengali",
      chi: "chinese",
      fra: "french",
      ger: "german",
      gre: "greek",
      heb: "hebrew",
      hin: "hindi",
      ita: "italian",
      jpn: "japanese",
      kor: "korean",
      pol: "polish",
      por: "portuguese",
      rus: "russian",
      spa: "spanish",
      tur: "turkish",
      ukr: "ukraine",
      vie: "vietnamese"
    ]

    value = Enum.random(data)
    abbr = value |> elem(0) |> to_string
    name = value |> elem(1)
    {abbr, name}
  end

  @spec random_boolean() :: boolean()
  def random_boolean do
    data = ~W(true false)a
    Enum.random(data)
  end

  @spec random_gender() :: String.t()
  def random_gender do
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
  def random_email do
    data = [
      "lugatex@yahoo.com",
      "kapranov.lugatex@gmail.com"
    ]

    Enum.random(data)
  end

  @spec random_zipcode() :: {atom(), String.t(), integer()}
  def random_zipcode do
    data = [
      %{city: "AGUADA", state: "PR", zipcode: 631},
      %{city: "BRONX", state: "NY", zipcode: 10459},
      %{city: "CABO ROJO", state: "PR", zipcode: 623},
      %{city: "CHRISTIANSTED", state: "VI", zipcode: 821},
      %{city: "MELROSE", state: "MA", zipcode: 2176},
      %{city: "PIERMONT", state: "NH", zipcode: 3779},
      %{city: "CRANSTON", state: "RI", zipcode: 2920},
      %{city: "MCADOO", state: "PA", zipcode: 18237},
      %{city: "SETH", state: "WV", zipcode: 25181},
      %{city: "SURGOINSVILLE", state: "TN", zipcode: 37873}
    ]

    %{city: city, state: state, zipcode: zipcode} =
      data
      |> Enum.random

    {city, state, zipcode}
  end

  @spec random_provider() :: String.t()
  def random_provider do
    data = ~w(google localhost facebook linkedin twitter)s
    Enum.random(data)
  end

  @spec random_ssn() :: integer()
  def random_ssn do
    Us.ssn()
    |> String.replace(~r/-/, "")
    |> String.trim()
    |> String.to_integer
  end

  @spec random_integer() :: Integer
  def random_integer(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end

  @spec random_state :: list()
  def random_state do
    states =
      ~w(Hawaii Georgia Iowa)s
      |> Enum.random()

    states
  end

  @spec random_year :: list()
  def random_year do
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

  @spec random_name_additional_need :: String.t
  def random_name_additional_need do
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
  def random_name_annual_revenue do
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
  def random_name_classify_inventory do
    names = ["Assets", "Expenses"]
    numbers = 1..1
    number = Enum.random(numbers)
    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end
    Enum.uniq(result)
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
    names = ["1-25", "200+", "26-75", "76-199"]
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

  @spec random_name_foreign_account_count :: String.t()
  defp random_name_foreign_account_count do
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

  @spec random_name_tax_frequency :: String.t
  defp random_name_tax_frequency do
    names = ["Annually", "Monthly", "Quaterly"]
    Enum.random(names)
  end

  @spec random_name_tax_industry :: String.t
  defp random_name_tax_industry do
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

  @spec random_name_for_tp_tax_industry :: String.t
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

    numbers = 0..1
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end

    Enum.uniq(result)
  end

  @spec random_name_for_pro_tax_industry :: String.t
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

    Enum.uniq(result)
  end

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

    Enum.uniq(result)
  end

  defp random_name_university do
    names = [
      "Babcock University",
      "Bluffton College",
      "Banaras Hindu University",
      "Cabrillo College",
      "Cape Coast Polytechnic",
      "Defiance College",
      "Delaware State University",
      "Earlham College",
      "Elon College",
      "Folsom Lake College",
      "Hitit University",
      "Holy Angel University",
      "Illinois Central College",
      "J Sargeant Reynolds Community College",
      "Jones College",
      "Knox College",
      "Lake Forest College",
      "Matn University",
      "Mersin University",
      "Oakland Community College",
      "Pacific University",
      "Parkland College",
      "Radford University",
      "Södertörn University College",
      "Triton College"
      ]

    numbers = 1..1
    number = Enum.random(numbers)

    result =
      for i <- 1..number, i > 0 do
        Enum.random(names)
      end

    result |> Enum.uniq() |> List.to_string
  end
end
