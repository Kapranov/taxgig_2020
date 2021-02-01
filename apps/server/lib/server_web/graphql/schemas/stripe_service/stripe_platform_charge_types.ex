defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformChargeTypes do
  @moduledoc """
  The StripeCharge GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver

  @desc "The StripeCharge"
  object :stripe_platform_charge do
    field :id, non_null(:string)
    field :amount, non_null(:integer)
    field :amount_refunded, non_null(:integer)
    field :captured, non_null(:boolean)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :description, non_null(:string)
    field :failure_code, :string
    field :failure_message, :string
    #field :fraud_details,  list_of(:string)
    field :id_from_card, non_null(:string)
    field :id_from_customer, non_null(:string)
    field :id_from_stripe, non_null(:string)
    #field :outcome,  list_of(:string)
    field :receipt_url, non_null(:string)
    field :status, non_null(:string)
    field :user_id, non_null(:string)
  end

  object :get_stripe_platform_charge do
    field :amount, :integer
    field :amount_refunded, :integer
    field :captured, :boolean
    field :created, :integer
    field :id_from_stripe, :string
  end

  object :stripe_platform_charge_queries do
    @desc "Get a specific StripePlatformCharge"
    field :show_stripe_platform_charge, :get_stripe_platform_charge do
      arg(:description, non_null(:string))
      resolve(&StripePlatformChargeResolver.show/3)
    end
  end

  object :stripe_platform_charge_mutations do
    @desc "Create the StripePlatformCharge"
    field :create_stripe_platform_charge, :stripe_platform_charge, description: "Create a new stripe platform charge" do
      arg :amount, non_null(:decimal)
      arg :capture, non_null(:boolean)
      arg :currency, non_null(:string)
      arg :description, non_null(:string)
      arg :id_from_card, non_null(:string)
      resolve &StripePlatformChargeResolver.create/3
    end

    @desc "Create the StripePlatformCharge by InTransition"
    field :create_by_in_transition_stripe_platform_charge, :stripe_platform_charge, description: "Create a new stripe platform charge" do
      arg :capture, non_null(:boolean)
      arg :currency, non_null(:string)
      arg :description, non_null(:string)
      arg :id_from_card, non_null(:string)
      resolve &StripePlatformChargeResolver.create_by_in_transition/3
    end

    @desc "Create the StripePlatformCharge by CanceledDoc"
    field :create_by_canceld_doc_stripe_platform_charge, :stripe_platform_charge, description: "Create a new stripe platform charge" do
      arg :capture, non_null(:boolean)
      arg :currency, non_null(:string)
      arg :description, non_null(:string)
      arg :id_from_card, non_null(:string)
      resolve &StripePlatformChargeResolver.create_by_canceled_doc/3
    end

    @desc "Delete a specific the StripePlatformCharge"
    field :delete_stripe_platform_charge, :stripe_platform_charge do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformChargeResolver.delete/3
    end
  end
end
