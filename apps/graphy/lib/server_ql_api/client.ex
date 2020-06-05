defmodule ServerQLApi.Client do
  use CommonGraphQLClient.Client,
    otp_app: :graphy,
    mod: ServerQLApi

  defp handle(:list, :all_faq_categories) do
    do_post(
      :all_faq_categories,
      ServerQLApi.Schema.FaqCategory,
      ServerQLApi.Query.FaqCategory.list()
    )
  end

  defp handle(:get, :show_faq_category, id), do: handle(:get_by, :show_faq_category, %{id: id})

  defp handle(:get_by, :show_faq_category, variables) do
    do_post(
      :show_faq_category,
      ServerQLApi.Schema.FaqCategory,
      ServerQLApi.Query.FaqCategory.get_by(variables),
      variables
    )
  end

  defp handle_subscribe_to(subscription_name, mod) when subscription_name in [:faq_category_created] do
    do_subscribe(
      mod,
      subscription_name,
      ServerQLApi.Schema.FaqCategory,
      apply(ServerQLApi.Subscription.FaqCategory, subscription_name, [])
    )
  end
end
