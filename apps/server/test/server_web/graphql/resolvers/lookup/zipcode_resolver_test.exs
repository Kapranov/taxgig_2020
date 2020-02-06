defmodule ServerWeb.GraphQL.Resolvers.Lookup.ZipcodeResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Lookup.ZipcodeResolver

  describe "#show" do
    it "returns specific UsZipcode by id" do
      struct = insert(:zipcode)
      {:ok, found} = ZipcodeResolver.show(nil, %{id: struct.id}, nil)
      assert found.id      == struct.id
      assert found.city    == struct.city
      assert found.state   == struct.state
      assert found.zipcode == struct.zipcode
    end

    it "returns not found when UsZipcode does not exist" do
      id = Ecto.UUID.generate
      {:error, error} = ZipcodeResolver.show(nil, %{id: id}, nil)
      assert error == "The UsZipcode #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:zipcode)
      args = %{id: nil}
      {:error, error} = ZipcodeResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#search" do
    it "returns search specific UsZipcode by number" do
      struct = insert(:zipcode)
      {:ok, found} = ZipcodeResolver.search(nil, %{zipcode: struct.zipcode}, nil)
      assert found.id      == struct.id
      assert found.city    == struct.city
      assert found.state   == struct.state
      assert found.zipcode == struct.zipcode
    end

    it "returns not found when UsZipcode does not exist" do
      zipcode = 600
      {:ok, data} = ZipcodeResolver.search(nil, %{zipcode: zipcode}, nil)
      assert data == nil
    end

    it "returns error for missing params" do
      insert(:zipcode)
      args = %{zipcode: nil}
      {:error, error} = ZipcodeResolver.search(nil, args, nil)
      assert error == [[field: :zipcode, message: "Can't be blank"]]
    end
  end
end
