defmodule ServerQLApi.Subscription.FaqCategory do
  @moduledoc """
  Subscription adapter module FaqCategory
  """

  @doc false
  def faq_category_created do
    """
    subscription {
      faq_category_created {
        id
        faqs_count
        title
      }
    }
    """
  end
end
