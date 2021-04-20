defmodule ServerWeb.GraphQL.Schemas.StripeService.StripePlatformBankAccountTokenTypes do
  @moduledoc """
  The StripeBankAccountToken GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformBankAccountTokenResolver

  @desc "The StripeBankAccountToken"
  object :stripe_platform_bank_account_token do
    field :id, :string
    field :id_from_stripe, :string
    field :account_holder_name, :string
    field :account_holder_type, :string
    field :bank_name, :string
    field :client_ip, :string
    field :country, :string
    field :created, :integer
    field :currency, :string
    field :error, :string
    field :fingerprint, :string
    field :id_from_bank_account, :string
    field :last4, :string
    field :routing_number, :string
    field :status, :string
    field :used, :boolean
    field :user_id, :string
  end

  object :stripe_platform_bank_account_token_mutations do
    @desc "Create the StripePlatformBankAccountToken"
    field :create_stripe_platform_bank_account_token, :stripe_platform_bank_account_token, description: "Create a new stripe platform bank account token" do
      arg :account_holder_name, non_null(:string)
      arg :account_holder_type, non_null(:string)
      arg :account_number, non_null(:string)
      arg :country, non_null(:string)
      arg :currency, non_null(:string)
      arg :routing_number, non_null(:string)
      resolve &StripePlatformBankAccountTokenResolver.create/3
    end
  end
end
