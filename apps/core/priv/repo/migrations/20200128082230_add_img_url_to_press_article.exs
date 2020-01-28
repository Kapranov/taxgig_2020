defmodule Core.Repo.Migrations.AddImgUrlToPressArticle do
  use Ecto.Migration

  def change do
    alter table("press_articles") do
      add :img_url, :string
    end
  end
end
