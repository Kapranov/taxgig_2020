defmodule ServerWeb.GraphQL.Resolvers.Accounts.SubscriberResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Accounts.SubscriberResolver

  describe "#list" do
    it "returns accounts subscriber" do
      struct = insert(:subscriber)
      {:ok, data} = SubscriberResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id       == struct.id
      assert List.first(data).email    == struct.email
      assert List.first(data).pro_role == struct.pro_role
    end
  end

  describe "#show" do
    it "returns specific accounts subscriber by id" do
      struct = insert(:subscriber)
      {:ok, found} = SubscriberResolver.show(nil, %{id: struct.id}, nil)
      assert found.id       == struct.id
      assert found.email    == struct.email
      assert found.pro_role == struct.pro_role
    end

    it "returns not found when accounts subscriber does not exist" do
      id = FlakeId.get()
      {:error, error} = SubscriberResolver.show(nil, %{id: id}, nil)
      assert error == "The Subscriber #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:subscriber)
      args = %{id: nil}
      {:error, error} = SubscriberResolver.show(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#create" do
    it "creates accounts subscriber" do
      args = %{
        email: "lugatex@yahoo.com",
        pro_role: false
      }
      {:ok, created} = SubscriberResolver.create(nil, args, nil)
      assert created.email    == "lugatex@yahoo.com"
      assert created.pro_role == false
    end

    it "returns error for missing params" do
      args = %{email: nil, pro_role: nil}
      {:error, error} = SubscriberResolver.create(nil, args, nil)
      assert error == [[field: :pro_role, message: "Check that an email address or role has been entered"]]
    end
  end

  describe "#update" do
    it "update specific accounts subscriber by id" do
      struct = insert(:subscriber)
      params = %{
        email: "kapranov.lugatex@gmail.com",
        pro_role: true
      }
      args = %{id: struct.id, subscriber: params}
      {:ok, updated} = SubscriberResolver.update(nil, args, nil)
      assert updated.id       == struct.id
      assert updated.email    == "kapranov.lugatex@gmail.com"
      assert updated.pro_role == true
    end

    it "nothing change for missing params" do
      struct = insert(:subscriber)
      params = %{}
      args = %{id: struct.id, subscriber: params}
      {:ok, updated} = SubscriberResolver.update(nil, args, nil)
      assert updated.id       == struct.id
      assert updated.email    == struct.email
      assert updated.pro_role == struct.pro_role
    end

    it "returns error for missing params" do
      insert(:subscriber)
      params = %{email: nil, pro_role: nil}
      args = %{id: nil, subscriber: params}
      {:error, error} = SubscriberResolver.update(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end

  describe "#delete" do
    it "delete specific accounts subscriber by id" do
      struct = insert(:subscriber)
      {:ok, deleted} = SubscriberResolver.delete(nil, %{id: struct.id}, nil)
      assert deleted.id == struct.id
    end

    it "returns not found when accounts subscriber does not exist" do
      id = FlakeId.get()
      {:error, error} = SubscriberResolver.delete(nil, %{id: id}, nil)
      assert error == "The Subscriber #{id} not found!"
    end

    it "returns error for missing params" do
      insert(:subscriber)
      args = %{id: nil}
      {:error, error} = SubscriberResolver.delete(nil, args, nil)
      assert error == [[field: :id, message: "Can't be blank"]]
    end
  end
end
