defmodule Core.PlaidService.PlaidPlatformTransactionService do
  @moduledoc """
  Work with Plaid Transactions object. Used to perform
  actions on `/transactions/get`, while propagating to
  and from associated Core.Plaid.PlaidTransaction records.

  Transactions data can be useful for many different applications,
  including personal finance management, expense reporting, cash
  flow modeling, risk analysis, and more. Plaid's Transactions
  product allows you to access a user's transaction history via
  the `/transactions/get` endpoint, which provides transaction
  history for `depository` type accounts such as checking and
  savings accounts, `credit` type accounts such as credit cards,
  and student loan accounts. For transaction history from investment
  accounts, use Plaid's Investments product.

  Transactions data includes transaction date, amount, category,
  merchant, location, and more. Transaction data is lightly
  cleaned to populate the name field, and more thoroughly
  processed to populate the merchant_name field.

  By default, up to 500 transactions can be fetched in a single request.

  You can:

   - Create your own `/transactions/get` and transfer transaction's section.

   Plaid API reference: https://plaid.com/docs/transactions/
  """

  def create do
  end
end
