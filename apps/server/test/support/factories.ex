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
    Services.IndividualEmploymentStatus,
    Services.IndividualFilingStatus,
    Services.IndividualForeignAccountCount,
    Services.IndividualItemizedDeduction,
    Services.IndividualStockTransactionCount,
    Services.IndividualTaxReturn,
    Services.MatchValueRelate,
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
      phone: EnUs.phone(),
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
    }
  end

  @spec individual_tax_return_factory() :: IndividualTaxReturn.t()
  def individual_tax_return_factory do
    %IndividualTaxReturn{
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

  @spec state_factory() :: State.t()
  def state_factory do
    %State{
      abbr: Lorem.word(),
      name: Lorem.word()
    }
  end

  @spec random_boolean :: boolean()
  defp random_boolean do
    value = ~W(true false)a
    Enum.random(value)
  end

  @spec random_integer() :: integer()
  defp random_integer() do
    Enum.random(111111111..123456789)
  end

  @spec random_integer(integer) :: Integer
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

  @spec random_name_employment_status :: String.t
  defp random_name_employment_status do
    names = [
      "employed",
      "self-employed",
      "unemployed"
    ]

    Enum.random(names)
  end

  @spec random_name_filling_status :: String.t
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

  @spec random_name_foreign_account_count :: String.t
  defp random_name_foreign_account_count do
    names = [
      "1",
      "2-5",
      "5+"
    ]

    Enum.random(names)
  end

  @spec random_name_itemized_deduction :: String.t
  defp random_name_itemized_deduction do
    names = [
      "Charitable contributions",
      "Health insurance",
      "Medical and dental expenses"
    ]

    Enum.random(names)
  end
end
