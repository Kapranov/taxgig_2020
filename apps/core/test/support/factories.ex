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
    Lookup.UsZipcode,
    Media.Picture,
    Repo,
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
      admin_role: random_boolean(),
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
      pro_role: random_boolean(),
      provider: random_provider(),
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

  @spec random_language() :: {atom, String.t()}
  defp random_language do
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
end
