defmodule Server.SubscriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ServerWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: ServerWeb.GraphQL.Schema
      use ExSpec
      import Server.Factory

      setup do
        Core.Seeder.Repo.seed!()

        {:ok, socket} =
          Phoenix.ChannelTest.connect(ServerWeb.UserSocket, params)
        {:ok, socket} =
          Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end
    end
  end
end
