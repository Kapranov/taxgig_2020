defmodule ServerQLApi do
  @moduledoc """
  Documentation for ServerQLApi.

  ServerQLApi.list(:all_faq_categories)
  ServerQLApi.get(:show_faq_category, "9vjdYNxPo303XRpD0K")
  ServerQLApi.get_by(:show_faq_category, %{id: "9vjdYNxPo303XRpD0K"})

  ServerQLApi.list!(:all_faq_categories)
  ServerQLApi.get!(:show_faq_category, "9vjdYNxPo303XRpD0K")
  ServerQLApi.get_by!(:show_faq_category, %{id: "9vjdYNxPo303XRpD0K"})

  faq_category = ServerQLApi.get!(:show_faq_category, "9vjdYNxPo303XRpD0K")
  faq_category = Landing.get_faq_category!("9vjdYNvztJrjT3A4nI")
  Absinthe.Subscription.publish(ServerWeb.Endpoint, faq_category, faq_category_created: "faq_categories")
  """

  use CommonGraphQLClient.Context, otp_app: :graphy

  def subscribe do
    client().subscribe_to(:faq_category_created, __MODULE__)

    list!(:all_faq_categories)
    |> sync_faq_categories()
  end

  def receive(subscription_name, %{id: id, title: title}) when subscription_name in [:faq_category_created] do
    import Ecto.Query, warn: false
    alias Core.{Landing.FaqCategory, Repo}

    query = from t in FaqCategory, where: t.title == ^title and not is_nil(t.id)

    Repo.all(query)
    |> Enum.each(fn(faq_category) ->
      faq_category
      |> Ecto.Changeset.change(id: id)
      |> Repo.update!()
    end)
  end

  def sync_faq_categories(faq_categories) do
    IO.puts "Beginning Re-connection Sync"

    faq_categories
    |> Enum.each(fn(faq_category) -> receive(:faq_category_created, faq_category) end)

    IO.puts "Completed Re-connection Sync"
  end
end
