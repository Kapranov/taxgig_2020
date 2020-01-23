defmodule Core.Seeder.Landing do
  @moduledoc """
  Seeds for `Core.Landing` context.
  """

  alias Core.Landing.{
    Faq,
    FaqCategory,
    PressArticle,
    Vacancy
  }

  alias Core.Repo

  alias Faker.{
    Company.En,
    Internet,
    Lorem,
    Name
  }

  def reset_database! do
    Repo.delete_all(FaqCategory)
    Repo.delete_all(Faq)
    Repo.delete_all(PressArticle)
    Repo.delete_all(Vacancy)
  end

  def seed! do
    seed_faq_category()
    seed_faq()
    seed_press_article()
    seed_vacancy()
  end

  defp seed_faq_category do
    case Repo.aggregate(FaqCategory, :count, :id) > 0 do
      true -> nil
      false -> insert_faq_category()
    end
  end

  defp seed_faq do
    case Repo.aggregate(Faq, :count, :id) > 0 do
      true -> nil
      false -> insert_faq()
    end
  end

  defp seed_press_article do
    case Repo.aggregate(PressArticle, :count, :id) > 0 do
      true -> nil
      false -> insert_press_article()
    end
  end

  defp seed_vacancy do
    case Repo.aggregate(Vacancy, :count, :id) > 0 do
      true -> nil
      false -> insert_vacancy()
    end
  end

  defp insert_faq_category do
    [
      Repo.insert!(%FaqCategory{
        title: "General"
      }),
      Repo.insert!(%FaqCategory{
        title: "For Pros"
      })
    ]
  end

  defp insert_faq do
    faq_category_ids =
      Enum.map(Repo.all(FaqCategory), fn(data) -> data.id end)

    {ids1, ids2} = {
      Enum.at(faq_category_ids, 0),
      Enum.at(faq_category_ids, 1)
    }

    [
      Repo.insert!(%Faq{
        content: Lorem.sentence(),
        faq_category_id: ids1,
        title: "Article 1"
      }),
      Repo.insert!(%Faq{
        content: Lorem.sentence(),
        faq_category_id: ids2,
        title: "Article 2"
      })
    ]
  end

  defp insert_press_article do
    [
      Repo.insert!(%PressArticle{
        author: Name.name(),
        preview_text: Lorem.sentence(),
        title: Lorem.word(),
        url: Internet.url()
      }),
      Repo.insert!(%PressArticle{
        author: Name.name(),
        preview_text: Lorem.sentence(),
        title: Lorem.word(),
        url: Internet.url()
      })
    ]
  end

  defp insert_vacancy do
    [
      Repo.insert!(%Vacancy{
        content: Lorem.sentence(),
        department: En.bs(),
        title: Lorem.word()
      }),
      Repo.insert!(%Vacancy{
        content: Lorem.sentence(),
        department: En.bs(),
        title: Lorem.word()
      })
    ]
  end
end
