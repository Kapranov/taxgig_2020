defmodule ServerWeb.GraphQL.Resolvers.Services.BlockscoreResolver do
  @moduledoc """
  The Blockscore GraphQL resolvers.
  """

  @type t :: %{status: bitstring}
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @doc """
  Get the status by Blockscore service
  """
  @spec get_status(any, %{atom => any}, Absinthe.Resolution.t()) :: result
  def get_status(_root, %{address_city: address_city,
                          address_country_code: address_country_code,
                          address_postal_code: address_postal_code,
                          address_street1: address_street1,
                          address_street2: address_street2,
                          address_subdivision: address_subdivision,
                          birth_day: birth_day,
                          birth_month: birth_month,
                          birth_year: birth_year,
                          document_type: document_type,
                          document_value: document_value,
                          name_first: name_first,
                          name_last: name_last,
                          name_middle: name_middle
                        }, _info) do
        with {:ok, status} <-
          Blockscore.get_status(
            address_city,
            address_country_code,
            address_postal_code,
            address_street1,
            address_street2,
            address_subdivision,
            birth_day,
            birth_month,
            birth_year,
            document_type,
            document_value,
            name_first,
            name_last,
            name_middle
          ) do
          {:ok, %{status: status}}
        else
          _ ->
          {:error, "Something wrong with args or don't respond service"}
        end
  end
end
