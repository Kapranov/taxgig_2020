defmodule Plaid.Factory do
  @moduledoc false

  def http_response_body(:error) do
    %{
      "error_type" => "INVALID_REQUEST",
      "error_code" => "MISSING_FIELDS",
      "error_message" => "Something went bad wrong.",
      "display_message" => "lol wut",
      "request_id" => "h12lD"
    }
  end

  def http_response_body(:create_link_token) do
    %{
      "link_token" => "link-sandbox-cc8a09fe-e6a1-49ee-a533-074d12027cf4",
      "expiration" => "2021-03-26T22:10:29Z",
      "request_id" => "3IEVhOxceZKRBlK"
    }
  end

  def http_response_body(:create_public_token) do
    %{
      "public_token" => "public-sandbox-ae89b269-724d-48fe-af9a-cb31c2d1708a",
      "expiration" => "2021-03-12T21:24:42Z",
      "request_id" => "zxKj9"
    }
  end

  def http_response_body(:exchange_public_token) do
    %{
      "access_token" => "access-sandbox-e9317406-8413",
      "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
      "request_id" => "qpCtl"
    }
  end

  def http_response_body(:accounts) do
    %{
      "accounts" => [
        %{
          "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
          "balances" => %{
            "available" => 100,
            "current" => 110,
            "limit" => nil,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => nil
          },
          "mask" => "0000",
          "name" => "Plaid Checking",
          "official_name" => "Plaid Gold Checking",
          "subtype" => "checking",
          "type" => "depository"
        },
        %{
          "account_id" => "6Myq63K1KDSe3lBwp7K1fnEbNGLV4nSxalVdW",
          "balances" => %{
            "available" => nil,
            "current" => 410,
            "limit" => 2000,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => nil
          },
          "mask" => "3333",
          "name" => "Plaid Credit Card",
          "official_name" => "Plaid Diamond Credit Card",
          "subtype" => "credit card",
          "type" => "credit"
        }
      ],
      "item" => %{
        "available_products" => ["balance", "auth"],
        "billed_products" => ["identity", "transactions"],
        "error" => nil,
        "institution_id" => "ins_109508",
        "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
        "webhook" => "https://plaid.com/example/hook"
      },
      "request_id" => "45QSn"
    }
  end

  def http_response_body(:transactions) do
    %{
      "accounts" => [
        %{
          "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
          "balances" => %{
            "available" => 100,
            "current" => 110,
            "limit" => nil,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => "USD"
          },
          "mask" => "0000",
          "name" => "Plaid Checking",
          "official_name" => "Plaid Gold Checking",
          "subtype" => "checking",
          "type" => "depository"
        },
        %{
          "account_id" => "6Myq63K1KDSe3lBwp7K1fnEbNGLV4nSxalVdW",
          "balances" => %{
            "available" => nil,
            "current" => 410,
            "limit" => 2000,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => "USD"
          },
          "mask" => "3333",
          "name" => "Plaid Credit Card",
          "official_name" => "Plaid Diamond Credit Card",
          "subtype" => "credit card",
          "type" => "credit"
        }
      ],
      "transactions" => [
        %{
          "account_id" => "vokyE5Rn6vHKqDLRXEn5fne7LwbKPLIXGK98d",
          "amount" => 2307.01,
          "iso_currency_code" => "USD",
          "unofficial_currency_code" => "USD",
          "category" => [
            "Shops",
            "Computers and Electronics"
          ],
          "category_id" => "19013000",
          "date" => "2021-01-29",
          "authorized_date" => "2021-01-27",
          "location" => %{
            "address" => "300 Post St",
            "city" => "San Francisco",
            "region" => "CA",
            "postal_code" => "94108",
            "country" => "US",
            "lat" => nil,
            "lon" => nil,
            "store_number" => "1235"
          },
          "merchant_name" => "Apple",
          "name" => "Apple Store",
          "payment_meta" => %{
            "by_order_of" => nil,
            "payee" => nil,
            "payer" => nil,
            "payment_method" => nil,
            "payment_processor" => nil,
            "ppd_id" => nil,
            "reason" => nil,
            "reference_number" => nil
          },
          "payment_channel" => "in store",
          "pending" => false,
          "pending_transaction_id" => nil,
          "account_owner" => nil,
          "transaction_id" => "lPNjeW1nR6CDn5okmGQ6hEpMo4lLNoSrzqDje",
          "transaction_code" => nil,
        },
        %{
          "account_id" => "XA96y1wW3xS7wKyEdbRzFkpZov6x1ohxMXwep",
          "amount" => 78.5,
          "iso_currency_code" => "USD",
          "unofficial_currency_code" => "USD",
          "category" => [
            "Food and Drink",
            "Restaurants"
          ],
          "category_id" => "13005000",
          "date" => "2017-01-29",
          "authorized_date" => "2017-01-28",
          "location" => %{
            "address" => "262 W 15th St",
            "city" => "New York",
            "region" => "NY",
            "postal_code" => "10011",
            "country" => "US",
            "lat" => 40.740352,
            "lon" => -74.001761,
            "store_number" => "455"
          },
          "merchant_name" => "Golden Crepes",
          "name" => "Golden Crepes",
          "payment_meta" => %{
            "by_order_of" => nil,
            "payee" => nil,
            "payer" => nil,
            "payment_method" => nil,
            "payment_processor" => nil,
            "ppd_id" => nil,
            "reason" => nil,
            "reference_number" => nil
          },
          "payment_channel" => "in store",
          "pending" => false,
          "pending_transaction_id" => nil,
          "account_owner" => nil,
          "transaction_id" => "4WPD9vV5A1cogJwyQ5kVFB3vPEmpXPS3qvjXQ",
          "transaction_code" => nil,
          "transaction_type" => "place"
        }
      ],
      "item" => %{
        "available_products" => ["balance", "auth"],
        "billed_products" => ["identity", "transactions"],
        "error" => nil,
        "institution_id" => "ins_109508",
        "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
        "webhook" => "https://plaid.com/example/hook"
      },
      "request_id" => "45QSn"
    }
  end
end
