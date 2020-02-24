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

  def faq_category_factory do
    %FaqCategory{
      title: Lorem.word()
    }
  end

  def faq_factory do
    %Faq{
      content: Lorem.sentence(),
      title: Lorem.word(),
      faq_categories: build(:faq_category)
    }
  end

  def press_article_factory do
    %PressArticle{
      author: Name.name(),
      img_url: Avatar.image_url(),
      preview_text: Lorem.sentence(),
      title: Lorem.word(),
      url: Internet.url()
    }
  end

  def vacancy_factory do
    %Vacancy{
      content: Lorem.sentence(),
      department: En.bs(),
      title: Lorem.word()
    }
  end

  def language_factory do
    %Language{
      abbr: "chi",
      name: "chinese"
    }
  end

  def subscriber_factory do
    %Subscriber{
      email: "lugatex@yahoo.com",
      pro_role: false
    }
  end

  def user_factory do
    %User{
      active: false,
      admin_role: false,
      avatar: "some text",
      bio: "some text",
      birthday: Date.add(Timex.now, 0),
      email: "lugatex@yahoo.com",
      first_name: "some text",
      init_setup: false,
      languages: [build(:language, name: "chinese")],
      last_name: "some text",
      middle_name: "some text",
      phone: "some text",
      password: "qwerty",
      password_confirmation: "qwerty",
      pro_role: false,
      provider: "google",
      sex: "some text",
      ssn: 123456789,
      street: "some text",
      zip: 123456789
    }
  end

  def ptin_factory do
    %Ptin{
      bus_addr_zip: "84116",
      bus_st_code: "UT",
      first_name: "Jason",
      last_name: "Broschinsky",
      profession: "CPA,EA"
    }
  end

  def zipcode_factory do
    %UsZipcode{
      city: "AGUADA",
      state: "PR",
      zipcode: 602
    }
  end

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

  def picture_factory do
    profile = build(:profile)
    %Picture{
      file: profile.logo,
      profile: profile
    }
  end

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
end
