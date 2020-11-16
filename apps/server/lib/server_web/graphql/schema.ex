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
  import_types(ServerWeb.GraphQL.Schemas.Lookup.StateTypes)
  import_types(ServerWeb.GraphQL.Schemas.Lookup.UsZipcodeTypes)
  import_types(ServerWeb.GraphQL.Schemas.Media.PictureTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingAdditionalNeedTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingAnnualRevenueTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingClassifyInventoryTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingIndustryTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingNumberEmployeeTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingTransactionVolumeTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingTypeClientTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BookKeepingTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessEntityTypeTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessForeignAccountCountTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessForeignOwnershipCountTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessIndustryTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessLlcTypeTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessNumberEmployeeTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessTaxReturnTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessTotalRevenueTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.BusinessTransactionCountTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.IndividualEmploymentStatusTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.IndividualFilingStatusTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.IndividualForeignAccountCountTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.IndividualIndustryTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.IndividualItemizedDeductionTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.IndividualStockTransactionCountTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.IndividualTaxReturnTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.MatchValueRelateTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.SaleTaxFrequencyTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.SaleTaxIndustryTypes)
  import_types(ServerWeb.GraphQL.Schemas.Products.SaleTaxTypes)
  import_types(ServerWeb.GraphQL.Schemas.Services.BlockscoreTypes)
  import_types(ServerWeb.GraphQL.Schemas.Services.PtinTypes)
  import_types(ServerWeb.GraphQL.Schemas.Skills.AccountingSoftwareTypes)
  import_types(ServerWeb.GraphQL.Schemas.Skills.EducationTypes)
  import_types(ServerWeb.GraphQL.Schemas.Skills.UniversityTypes)
  import_types(ServerWeb.GraphQL.Schemas.Skills.WorkExperienceTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformAccountTokenTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformAccountTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformBankAccountTokenTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformCardTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformChargeCaptureTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformChargeTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformCustomerTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformExternalAccountBankTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformExternalAccountCardTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformPayoutTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformRefundTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformTransferReversalTypes)
  import_types(ServerWeb.GraphQL.Schemas.StripeService.StripePlatformTransferTypes)
  import_types(ServerWeb.GraphQL.Schemas.Talk.RoomTypes)
  import_types(ServerWeb.GraphQL.Schemas.UuidTypes)

  @desc "The root query type."
  query do
    import_fields(:accounting_software_queries)
    import_fields(:blockscore_queries)
    import_fields(:book_keeping_additional_need_queries)
    import_fields(:book_keeping_annual_revenue_queries)
    import_fields(:book_keeping_classify_inventory_queries)
    import_fields(:book_keeping_industry_queries)
    import_fields(:book_keeping_number_employee_queries)
    import_fields(:book_keeping_queries)
    import_fields(:book_keeping_transaction_volume_queries)
    import_fields(:book_keeping_type_client_queries)
    import_fields(:business_entity_type_queries)
    import_fields(:business_foreign_account_count_queries)
    import_fields(:business_foreign_ownership_count_queries)
    import_fields(:business_industry_queries)
    import_fields(:business_llc_type_queries)
    import_fields(:business_number_employee_queries)
    import_fields(:business_tax_return_queries)
    import_fields(:business_total_revenue_queries)
    import_fields(:business_transaction_count_queries)
    import_fields(:education_queries)
    import_fields(:faq_category_queries)
    import_fields(:faq_queries)
    import_fields(:individual_employment_status_queries)
    import_fields(:individual_filing_status_queries)
    import_fields(:individual_foreign_account_count_queries)
    import_fields(:individual_industry_queries)
    import_fields(:individual_itemized_deduction_queries)
    import_fields(:individual_stock_transaction_count_queries)
    import_fields(:individual_tax_return_queries)
    import_fields(:language_queries)
    import_fields(:match_value_relate_queries)
    import_fields(:picture_queries)
    import_fields(:press_article_queries)
    import_fields(:profile_queries)
    import_fields(:ptin_queries)
    import_fields(:room_queries)
    import_fields(:sale_tax_frequency_queries)
    import_fields(:sale_tax_industry_queries)
    import_fields(:sale_tax_queries)
    import_fields(:state_queries)
#    import_fields(:stripe_platform_bank_account_token_queries)
    import_fields(:stripe_platform_card_queries)
#    import_fields(:stripe_platform_external_account_bank_queries)
#    import_fields(:stripe_platform_external_account_card_queries)
#    import_fields(:stripe_platform_payout_queries)
#    import_fields(:stripe_platform_transfer_queries)
#    import_fields(:stripe_platform_transfer_reversal_queries)
    import_fields(:subscriber_queries)
    import_fields(:university_queries)
    import_fields(:us_zipcode_queries)
    import_fields(:user_queries)
    import_fields(:vacancy_queries)
    import_fields(:work_experience_queries)
  end

  @desc "The root mutation type."
  mutation do
    import_fields(:accounting_software_mutations)
    import_fields(:book_keeping_additional_need_mutations)
    import_fields(:book_keeping_annual_revenue_mutations)
    import_fields(:book_keeping_classify_inventory_mutations)
    import_fields(:book_keeping_industry_mutations)
    import_fields(:book_keeping_mutations)
    import_fields(:book_keeping_number_employee_mutations)
    import_fields(:book_keeping_transaction_volume_mutations)
    import_fields(:book_keeping_type_client_mutations)
    import_fields(:business_entity_type_mutations)
    import_fields(:business_foreign_account_count_mutations)
    import_fields(:business_foreign_ownership_count_mutations)
    import_fields(:business_industry_mutations)
    import_fields(:business_llc_type_mutations)
    import_fields(:business_number_employee_mutations)
    import_fields(:business_tax_return_mutations)
    import_fields(:business_total_revenue_mutations)
    import_fields(:business_transaction_count_mutations)
    import_fields(:education_mutations)
    import_fields(:faq_category_mutations)
    import_fields(:faq_mutations)
    import_fields(:individual_employment_status_mutations)
    import_fields(:individual_filing_status_mutations)
    import_fields(:individual_foreign_account_count_mutations)
    import_fields(:individual_industry_mutations)
    import_fields(:individual_itemized_deduction_mutations)
    import_fields(:individual_stock_transaction_count_mutations)
    import_fields(:individual_tax_return_mutations)
    import_fields(:language_mutations)
    import_fields(:match_value_relate_mutations)
    import_fields(:picture_mutations)
    import_fields(:press_article_mutations)
    import_fields(:profile_mutations)
    import_fields(:ptin_mutations)
    import_fields(:room_mutations)
    import_fields(:sale_tax_frequency_mutations)
    import_fields(:sale_tax_industry_mutations)
    import_fields(:sale_tax_mutations)
    import_fields(:stripe_platform_account_mutations)
    import_fields(:stripe_platform_account_token_mutations)
#    import_fields(:stripe_platform_bank_account_token_mutations)
    import_fields(:stripe_platform_card_mutations)
    import_fields(:stripe_platform_charge_capture_mutations)
    import_fields(:stripe_platform_customer_mutations)
#    import_fields(:stripe_platform_external_account_bank_mutations)
#    import_fields(:stripe_platform_external_account_card_mutations)
#    import_fields(:stripe_platform_payout_mutations)
    import_fields(:stripe_platform_refund_mutations)
#    import_fields(:stripe_platform_transfer_mutations)
#    import_fields(:stripe_platform_transfer_reversal_mutations)
    import_fields(:subscriber_mutations)
    import_fields(:university_mutations)
    import_fields(:user_mutations)
    import_fields(:vacancy_mutations)
    import_fields(:work_experience_mutations)
    import_fields(:update_book_keeping_additional_need_params)
    import_fields(:update_book_keeping_annual_revenue_params)
    import_fields(:update_book_keeping_classify_inventory_params)
    import_fields(:update_book_keeping_industry_params)
    import_fields(:update_book_keeping_number_employee_params)
    import_fields(:update_book_keeping_params)
    import_fields(:update_book_keeping_transaction_volume_params)
    import_fields(:update_book_keeping_type_client_params)
    import_fields(:update_business_entity_type_params)
    import_fields(:update_business_foreign_account_count_params)
    import_fields(:update_business_foreign_ownership_count_params)
    import_fields(:update_business_industry_params)
    import_fields(:update_business_llc_type_params)
    import_fields(:update_business_number_employee_params)
    import_fields(:update_business_tax_return_params)
    import_fields(:update_business_total_revenue_params)
    import_fields(:update_business_transaction_count_params)
    import_fields(:update_faq_category_params)
    import_fields(:update_faq_params)
    import_fields(:update_individual_employment_status_params)
    import_fields(:update_individual_filing_status_params)
    import_fields(:update_individual_foreign_account_count_params)
    import_fields(:update_individual_industry_params)
    import_fields(:update_individual_itemized_deduction_params)
    import_fields(:update_individual_stock_transaction_count_params)
    import_fields(:update_individual_tax_return_params)
    import_fields(:update_language_params)
    import_fields(:update_match_value_relate_params)
    import_fields(:update_press_article_params)
    import_fields(:update_profile_params)
    import_fields(:update_sale_tax_frequency_params)
    import_fields(:update_sale_tax_industry_params)
    import_fields(:update_sale_tax_params)
    import_fields(:update_stripe_platform_charge_capture_params)
    import_fields(:update_stripe_platform_customer_params)
    import_fields(:update_subscriber_params)
    import_fields(:update_university_params)
    import_fields(:update_user_params)
    import_fields(:update_vacancy_params)
    import_fields(:update_work_experience_params)
  end

  @desc "The root subscription type."
  subscription do
    import_fields(:accounting_software_subscriptions)
    import_fields(:blockscore_subscriptions)
    import_fields(:book_keeping_subscriptions)
    import_fields(:business_tax_return_subscriptions)
    import_fields(:education_subscriptions)
    import_fields(:faq_category_subscriptions)
    import_fields(:faq_subscriptions)
    import_fields(:individual_tax_return_subscriptions)
    import_fields(:language_subscriptions)
    import_fields(:match_value_relate_subscriptions)
    import_fields(:press_article_subscriptions)
    import_fields(:ptin_subscriptions)
    import_fields(:sale_tax_subscriptions)
    import_fields(:subscriber_subscriptions)
    import_fields(:university_subscriptions)
    import_fields(:user_subscriptions)
    import_fields(:vacancy_subscriptions)
    import_fields(:work_experience_subscriptions)
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
  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:get_string, field, object)
    |> apply(:debug, field, object)
  end

  @spec apply(list(), atom(), any(), map()) :: list()
  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++
      [ServerWeb.GraphQL.Schemas.Middleware.ChangesetErrors] ++
        [ServerWeb.GraphQL.Helpers.ErrorHelper]
  end

  defp apply(middleware, :get_string, field, %{identifier: :name} = object) do
    new_middleware = {Absinthe.Middleware.MapGet, to_string(field.identifier)}

    middleware
    |> Absinthe.Schema.replace_default(new_middleware, field, object)
  end

  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end

  defp apply(middleware, _, _, _) do
    middleware ++
      [ServerWeb.GraphQL.Schemas.Middleware.ChangesetErrors] ++
        [ServerWeb.GraphQL.Helpers.ErrorHelper]
  end
end
