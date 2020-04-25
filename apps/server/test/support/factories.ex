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
    Lookup.UsZipcode,
    Media.Picture,
    Services.MatchValueRelate,
    Upload
  }

  alias Faker.{
    Avatar,
    Company.En,
    Internet,
    Lorem,
    Name,
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
end
