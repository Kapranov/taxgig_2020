defmodule ServerWeb.GraphQL.Resolvers.Services.BlockscoreResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Services.BlockscoreResolver

  @opts [
    address_city: "Cupertino",
    address_country_code: "US",
    address_postal_code: "95014",
    address_street1: "1 Infinite Loop",
    address_street2: "Apt 6",
    address_subdivision: "CA",
    birth_day: 23,
    birth_month: 8,
    birth_year: 1993,
    document_type: "ssn",
    document_value: "0000",
    name_first: "John",
    name_last: "Doe",
    name_middle: "Pearce"
  ]

  describe "#get_status" do
    it "returns correct status" do
      {:ok, found} =
        BlockscoreResolver.get_status(
          nil,
          %{
            address_city: Keyword.get(@opts, :address_city),
            address_country_code: Keyword.get(@opts, :address_country_code),
            address_postal_code: Keyword.get(@opts, :address_postal_code),
            address_street1: Keyword.get(@opts, :address_street1),
            address_street2: Keyword.get(@opts, :address_street2),
            address_subdivision: Keyword.get(@opts, :address_subdivision),
            birth_day: Keyword.get(@opts, :birth_day),
            birth_month: Keyword.get(@opts, :birth_month),
            birth_year: Keyword.get(@opts, :birth_year),
            document_type: Keyword.get(@opts, :document_type),
            document_value: Keyword.get(@opts, :document_value),
            name_first: Keyword.get(@opts, :name_first),
            name_last: Keyword.get(@opts, :name_last),
            name_middle: Keyword.get(@opts, :name_middle)
          },
          nil
        )

      assert found.status == "valid"
    end

    it "returns incorrect status" do
      {:ok, found} =
        BlockscoreResolver.get_status(
          nil,
          %{
            address_city: Keyword.get(@opts, :address_city),
            address_country_code: Keyword.get(@opts, :address_country_code),
            address_postal_code: Keyword.get(@opts, :address_postal_code),
            address_street1: Keyword.get(@opts, :address_street1),
            address_street2: Keyword.get(@opts, :address_street2),
            address_subdivision: Keyword.get(@opts, :address_subdivision),
            birth_day: Keyword.get(@opts, :birth_day),
            birth_month: Keyword.get(@opts, :birth_month),
            birth_year: Keyword.get(@opts, :birth_year),
            document_type: Keyword.get(@opts, :document_type),
            document_value: "1111",
            name_first: Keyword.get(@opts, :name_first),
            name_last: Keyword.get(@opts, :name_last),
            name_middle: Keyword.get(@opts, :name_middle)
          },
          nil
        )

      assert found.status == "invalid"
    end

    it "returns null status" do
      {:ok, found} =
        BlockscoreResolver.get_status(
          nil,
          %{
            address_city: Keyword.get(@opts, :address_city),
            address_country_code: Keyword.get(@opts, :address_country_code),
            address_postal_code: Keyword.get(@opts, :address_postal_code),
            address_street1: Keyword.get(@opts, :address_street1),
            address_street2: Keyword.get(@opts, :address_street2),
            address_subdivision: Keyword.get(@opts, :address_subdivision),
            birth_day: Keyword.get(@opts, :birth_day),
            birth_month: Keyword.get(@opts, :birth_month),
            birth_year: Keyword.get(@opts, :birth_year),
            document_type: "XXXX",
            document_value: "0000",
            name_first: Keyword.get(@opts, :name_first),
            name_last: Keyword.get(@opts, :name_last),
            name_middle: Keyword.get(@opts, :name_middle)
          },
          nil
        )

      assert found.status == nil
      refute found.status, "valid"
      refute found.status, "invalid"
    end
  end
end
