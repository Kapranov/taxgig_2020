defmodule ServerQLApi.Query.FaqCategory do
  @moduledoc """
  FaqCategory GraphQL queries
  """

  @doc false
  def list do
    """
    query {
      all_faq_categories {
        id
        faqs_count
        title
        faqs { id content title }
      }
    }
    """
  end

  def get_by(%{id: _}) do
    """
    query get_faq_category($id: String!) {
      show_faq_category(id: $id) {
        id
        faqs_count
        title
        faqs { id content title }
      }
    }
    """
  end
end
