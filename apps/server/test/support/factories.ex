defmodule Server.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.{
    Accounts.Subscriber,
    Landing.Faq,
    Landing.FaqCategory,
    Landing.PressArticle,
    Landing.Vacancy,
    Localization.Language
  }

  alias Faker.{
    Avatar,
    Company.En,
    Internet,
    Lorem,
    Name
  }

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
      abbr: Lorem.word(),
      name: Lorem.word()
    }
  end

  def subscriber_factory do
    %Subscriber{
      email: "lugatex@yahoo.com",
      pro_role: false
    }
  end
end
