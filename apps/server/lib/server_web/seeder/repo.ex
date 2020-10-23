defmodule ServerWeb.Seeder.Repo do
  @moduledoc """
  Seeds for `Stripy.Seeder.Repo` repository.
  """

  alias ServerWeb.Seeder.{
    StripeAccount,
    StripeAccountToken,
    StripeBankAccountToken,
    StripeCard,
    StripeCharge,
    StripeChargeCapture,
    StripeExternalAccountBank,
    StripeExternalAccountCard,
    StripeRefund,
    StripeTransfer,
    StripeTransferReversal,
    Updated
  }


  @spec seed!() :: :ok
  def seed! do
    StripeAccount.seed!()
    StripeAccountToken.seed!()
    StripeBankAccountToken.seed!()
    StripeCard.seed!()
    StripeCharge.seed!()
    StripeChargeCapture.seed!()
    StripeExternalAccountBank.seed!()
    StripeExternalAccountCard.seed!()
    StripeRefund.seed!()
    StripeTransfer.seed!()
    StripeTransferReversal.seed!()
    :ok
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.StripeAccount.start!()
    Updated.StripeAccountToken.start!()
    Updated.StripeBankAccountToken.start!()
    Updated.StripeCard.start!()
    Updated.StripeCharge.start!()
    Updated.StripeChargeCapture.start!()
    Updated.StripeExternalAccountBank.start!()
    Updated.StripeExternalAccountCard.start!()
    Updated.StripeRefund.start!()
    Updated.StripeTransfer.start!()
    Updated.StripeTransferReversal.start!()
    :ok
  end
end
