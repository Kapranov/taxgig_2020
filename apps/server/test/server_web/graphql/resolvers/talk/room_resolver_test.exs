defmodule ServerWeb.GraphQL.Resolvers.Talk.RoomResolverTest do
  use ServerWeb.ConnCase

  alias ServerWeb.GraphQL.Resolvers.Talk.RoomResolver

  describe "#list" do
    it "returns Rooms" do
      struct = insert(:room)
      {:ok, data} = RoomResolver.list(nil, nil, nil)
      assert length(data) == 1
      assert List.first(data).id          == struct.id
      assert List.first(data).description == struct.description
      assert List.first(data).name        == struct.name
      assert List.first(data).topic       == struct.topic
      assert List.first(data).user_id     == struct.user_id
    end
  end

  describe "#create" do
    it "creates Room" do
      user = insert(:user)
      args = %{
        description: "some description",
        name: "some name",
        topic: "some topic"
      }
      {:ok, created} = RoomResolver.create(nil, args, %{context: %{current_user: user}})
      assert created.description == "some description"
      assert created.name        == "some name"
      assert created.topic       == "some topic"
      assert created.user_id     == user.id
    end

    it "returns error for missing params" do
      user = insert(:user)
      args = %{description: nil, name: nil, topic: nil}
      {:error, error} = RoomResolver.create(nil, args, %{context: %{current_user: user}})
      assert error == "Something went wrong with your room"
    end
  end
end
