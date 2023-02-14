defmodule Blockscore do
  @moduledoc """
  Blockscore service `&Blockscore.get_status/14`
  fields are `document_type: "ssn"` and `document_value: "0000"`
  return `{:ok, "valid"}` if value is `"0000"` or return
  `{:ok, "invalid"}` if value is any but except `"0000"`.
  """
  @url Application.compile_env(:blockscore, :url)
  @header Application.compile_env(:blockscore, :header)
  @headers [accept: "#{@header}"]
  @adapter Application.compile_env(:blockscore, :adapter)

  @type b :: bitstring()
  @type i :: integer()
  @type success_tuple() :: {:ok, String.t()}
  @type result() :: success_tuple()

  @spec get_status(b,b,b,b,b,b,i,i,i,b,b,b,b,b) :: result()
  def get_status(
      address_city, address_country_code, address_postal_code,
      address_street1, address_street2, address_subdivision,
      birth_day, birth_month, birth_year, document_type,
      document_value, name_first, name_last, name_middle
    ) do
      body = ""
      params = %{
        "address_city" => address_city,
        "address_country_code" => address_country_code,
        "address_postal_code" => address_postal_code,
        "address_street1" => address_street1,
        "address_street2" => address_street2,
        "address_subdivision" => address_subdivision,
        "birth_day" => birth_day,
        "birth_month" => birth_month,
        "birth_year" => birth_year,
        "document_type" => document_type,
        "document_value" => document_value,
        "name_first" => name_first,
        "name_last" => name_last,
        "name_middle" => name_middle
      }

      {:ok,
        %HTTPoison.Response{
          body: result
        }
      } = @adapter.post(@url, body, @headers, params: params)

      status =
        result
        |> Jason.decode!
        |> Map.get("status")

      {:ok, status}
  end
end
