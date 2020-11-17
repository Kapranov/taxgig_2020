defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformChargeCaptureTypes do
  @moduledoc """
  The StripeChargeCapture GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver

  @desc "The StripeChargeCapture"
  object :stripe_platform_charge_capture do
    field :id, non_null(:string)
    field :id_from_card, non_null(:string)
    field :id_from_customer, non_null(:string)
    field :id_from_stripe, non_null(:string)
    field :amount, non_null(:integer)
    field :amount_refunded, non_null(:integer)
    field :captured, non_null(:boolean)
    field :created, non_null(:integer)
    field :currency, non_null(:string)
    field :description, non_null(:string)
    field :failure_code, non_null(:string)
    field :failure_message, non_null(:string)
    field :fraud_details,  list_of(:string)
    field :outcome,  list_of(:string)
    field :receipt_url, non_null(:string)
    field :status, non_null(:string)
    field :user_id, non_null(:string)
  end

  @desc "The StripePlatformChargeCapture update via params"
  input_object :update_stripe_platform_charge_capture_params, description: "update stripe platform charge" do
    field :amount, non_null(:integer), description: "An amount is integer for StripeCharge"
  end

  object :stripe_platform_charge_capture_mutations do
    @desc "Update a specific StripePlatformChargeCapture"
    field :update_stripe_platform_charge_capture, :stripe_platform_charge_capture do
      arg :id_from_stripe, non_null(:string)
      arg :stripe_platform_charge_capture, :update_stripe_platform_charge_capture_params
      resolve &StripePlatformChargeCaptureResolver.update/3
    end
  end
end
