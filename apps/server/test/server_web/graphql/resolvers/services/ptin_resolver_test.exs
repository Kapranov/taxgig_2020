defmodule ServerWeb.GraphQL.Resolvers.Services.PtinResolverTest do
  use ServerWeb.ConnCase

#  alias ServerWeb.GraphQL.Resolvers.Services.PtinResolver

  describe "#create" do
    it "creates valid the ptin" do
#      struct = insert(:ptin)
#
#      _args = %{
#        expired: "Updated August 30, 2019",
#        url: "https://www.irs.gov/pub/irs-utl/foia_utah_extract.zip"
#      }
#
#      assert struct.bus_addr_zip == "84116"
#      assert struct.bus_st_code  == "UT"
#      assert struct.first_name   == "Jason"
#      assert struct.last_name    == "Broschinsky"
#      assert struct.profession   == "CPA,EA"
    end

    it "returns error for missing params" do
#      args = %{expired: nil, url: nil}
#      {:ok, %{error: error}} = PtinResolver.create(nil, args, nil)
#      assert error == [message: "Oops something went wrong!"]
    end
  end

  describe "#search" do
    it "search specific ptin" do
#      insert(:ptin)
#      args = %{
#        bus_addr_zip: "84116",
#        bus_st_code: "UT",
#        first_name: "Jason",
#        last_name: "Broschinsky"
#      }
#
#      assert {:ok, %{profession: data}} = PtinResolver.search(nil, args, nil)
#      assert data == "CPA,EA"
    end

    it "returns nil when invalid attrs" do
#      insert(:ptin)
#      args = %{
#        bus_addr_zip: "xxx",
#        bus_st_code: "xxx",
#        first_name: "xxx",
#        last_name: "xxx"
#      }
#
#      assert {:ok, %{profession: data}} = PtinResolver.search(nil, args, nil)
#      assert data == nil
    end
  end

  describe "#delete" do
    it "delete all the ptins" do
#      insert(:ptin)
#      assert {:ok, %{ptin: data}} = PtinResolver.delete(nil, nil, nil)
#      assert data == "it has been deleted 1 records"
    end

    it "returns not found when the ptins does not exist" do
#      assert {:ok, %{ptin: data}} = PtinResolver.delete(nil, nil, nil)
#      assert data == "none records"
    end
  end

  describe "#delete_dir" do
    it "delete directory with timestamp by ptins" do
    end

    it "returns null found when the ptins does not exist" do
#      time = Timex.today |> to_string
#      args = %{date: time}
#      assert {:ok, %{error: data}} = PtinResolver.delete_dir(nil, args, nil)
#      assert data == [message: "Directory apps/ptin/priv/data/#{time} doesn't exist!"]
    end
  end
end
