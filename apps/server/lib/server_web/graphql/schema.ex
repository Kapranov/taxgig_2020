defmodule ServerWeb.GraphQL.Schema do
  @moduledoc """
  The GraphQL schema.
  """

  use Absinthe.Schema

  alias Absinthe.{
    Middleware,
    Plugin
  }

  alias ServerWeb.GraphQL.Data

  import_types(Absinthe.Plug.Types)
  import_types(Absinthe.Type.Custom)
  import_types(ServerWeb.GraphQL.Schemas.Accounts.ProfileTypes)
  import_types(ServerWeb.GraphQL.Schemas.Accounts.SubscriberTypes)
  import_types(ServerWeb.GraphQL.Schemas.Accounts.UserTypes)
  import_types(ServerWeb.GraphQL.Schemas.Landing.FaqCategoryTypes)
  import_types(ServerWeb.GraphQL.Schemas.Landing.FaqTypes)
  import_types(ServerWeb.GraphQL.Schemas.Landing.PressArticleTypes)
  import_types(ServerWeb.GraphQL.Schemas.Landing.VacancyTypes)
  import_types(ServerWeb.GraphQL.Schemas.Localization.LanguageTypes)
  import_types(ServerWeb.GraphQL.Schemas.Lookup.UsZipcodeTypes)
  import_types(ServerWeb.GraphQL.Schemas.Media.PictureTypes)
  import_types(ServerWeb.GraphQL.Schemas.Services.BlockscoreTypes)
  import_types(ServerWeb.GraphQL.Schemas.Services.PtinTypes)
  import_types(ServerWeb.GraphQL.Schemas.UuidTypes)

  @desc "The root query type."
  query do
    import_fields(:blockscore_queries)
    import_fields(:faq_category_queries)
    import_fields(:faq_queries)
    import_fields(:language_queries)
    import_fields(:picture_queries)
    import_fields(:press_article_queries)
    import_fields(:profile_queries)
    import_fields(:ptin_queries)
    import_fields(:subscriber_queries)
    import_fields(:us_zipcode_queries)
    import_fields(:user_queries)
    import_fields(:vacancy_queries)
  end

  @desc "The root mutation type."
  mutation do
    import_fields(:faq_category_mutations)
    import_fields(:faq_mutations)
    import_fields(:language_mutations)
    import_fields(:picture_mutations)
    import_fields(:press_article_mutations)
    import_fields(:profile_mutations)
    import_fields(:ptin_mutations)
    import_fields(:subscriber_mutations)
    import_fields(:update_faq_category_params)
    import_fields(:update_faq_params)
    import_fields(:update_language_params)
    import_fields(:update_press_article_params)
    import_fields(:update_profile_params)
    import_fields(:update_subscriber_params)
    import_fields(:update_user_params)
    import_fields(:update_vacancy_params)
    import_fields(:user_mutations)
    import_fields(:vacancy_mutations)
  end

  @desc "The root subscription type."
  subscription do
    import_fields(:blockscore_subscriptions)
    import_fields(:faq_category_subscriptions)
    import_fields(:faq_subscriptions)
    import_fields(:language_subscriptions)
    import_fields(:press_article_subscriptions)
    import_fields(:ptin_subscriptions)
    import_fields(:subscriber_subscriptions)
    import_fields(:user_subscriptions)
    import_fields(:vacancy_subscriptions)
  end

  @spec context(map()) :: map()
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  @spec plugins() :: list()
  def plugins do
    [Middleware.Dataloader] ++ Plugin.defaults()
  end

  @spec middleware(list(), any(), any()) :: list()
  def middleware(middleware, _field, _object) do
    middleware ++ [ServerWeb.GraphQL.Schemas.Middleware.ChangesetErrors]
  end
end
