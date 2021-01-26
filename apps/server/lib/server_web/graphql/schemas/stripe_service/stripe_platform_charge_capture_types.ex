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
    field :failure_code, :string
    field :failure_message, :string
    #field :fraud_details,  list_of(:string)
    #field :outcome,  list_of(:string)
    field :receipt_url, non_null(:string)
    field :status, non_null(:string)
    field :user_id, non_null(:string)
  end

  object :stripe_platform_charge_capture_mutations do
    @desc "Update a specific StripePlatformChargeCapture"
    field :update_stripe_platform_charge_capture, :stripe_platform_charge_capture do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformChargeCaptureResolver.update/3
    end

    @desc "Update a specific StripePlatformChargeCapture by an action's create"
    field :update_by_created_stripe_platform_charge_capture, :stripe_platform_charge_capture do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformChargeCaptureResolver.update_by_created/3
    end

    @desc "Update a specific StripePlatformChargeCapture by field's in progress"
    field :update_by_in_progress_stripe_platform_charge_capture, :stripe_platform_charge_capture do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformChargeCaptureResolver.update_by_in_progress/3
    end

    @desc "Update a specific StripePlatformChargeCapture by field's canceled"
    field :update_by_canceled_stripe_platform_charge_capture, :stripe_platform_charge_capture do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformChargeCaptureResolver.update_by_canceled/3
    end

    @desc "Update a specific StripePlatformChargeCapture by field's in transition"
    field :update_by_in_transition_stripe_platform_charge_capture, :stripe_platform_charge_capture do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformChargeCaptureResolver.update_by_in_transition/3
    end

    @desc "Update a specific StripePlatformChargeCapture by field's done"
    field :update_by_done_stripe_platform_charge_capture, :stripe_platform_charge_capture do
      arg :id_from_stripe, non_null(:string)
      resolve &StripePlatformChargeCaptureResolver.update_by_done/3
    end
  end
end
