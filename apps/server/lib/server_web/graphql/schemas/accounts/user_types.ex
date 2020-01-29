defmodule ServerWeb.GraphQL.Schemas.Accounts.UserTypes do
  @moduledoc """
  The User GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Accounts.UserResolver

  @desc "The accounts user on the site"
  object :user do
    field :id, non_null(:string), description: "language id"
    field :active, :boolean, description: "accounts user active"
    field :admin_role, :boolean, description: "accounts user admin_role"
    field :avatar, :string, description: "accounts user avatar"
    field :bio, :string, description: "accounts user bio"
    field :birthday, :date, description: "accounts user birthday"
    field :email, non_null(:string), description: "accounts user email"
    field :first_name, :string, description: "accounts user first_name"
    field :init_setup, :boolean, description: "accounts user init_setup"
    field :last_name, :string, description: "accounts user last_name"
    field :middle_name, :string, description: "accounts user middle_name"
    field :password, non_null(:string), description: "accounts user password"
    field :password_confirmation, non_null(:string), description: "accounts user password_confirmation"
    field :phone, :string, description: "accounts user phone"
    field :pro_role, :boolean, description: "accounts user pro_role"
    field :provider, non_null(:string), description: "accounts user provider"
    field :sex, :string, description: "accounts user sex"
    field :ssn, :integer, description: "accounts user ssn"
    field :street, :string, description: "accounts user street"
    field :zip, :integer, description: "accounts user zip"
    field :inserted_at, non_null(:datetime)
    field :updated_at, non_null(:datetime)
  end

  @desc "The accounts an user update via params"
  input_object :update_user_params do
    field :active, :boolean
    field :admin_role, :boolean
    field :avatar, :string
    field :bio, :string
    field :birthday
    field :email, :string
    field :first_name, :string
    field :init_setup, :boolean
    field :last_name, :string
    field :middle_name, :string
    field :password, :string
    field :password_confirmation, :string
    field :phone, :string
    field :pro_role, :boolean
    field :provider, :string
    field :sex, :string
    field :ssn, :integer
    field :street, :string
    field :zip, :integer
  end

  object :user_queries do
    @desc "Get all accounts an user"
    field :all_users, list_of(:user) do
      resolve(&UserResolver.list/3)
    end

    @desc "Get a specific accounts an user"
    field :show_user, :user do
      arg(:id, non_null(:string))
      resolve(&UserResolver.show/3)
    end
  end

  object :user_mutations do
    @desc "Create an accounts user"
    field :create_user, :user do
      arg :active, :boolean
      arg :admin_role, :boolean
      arg :avatar, :string
      arg :bio, :string
      arg :birthday
      arg :email, :string
      arg :first_name, :string
      arg :init_setup, :boolean
      arg :last_name, :string
      arg :middle_name, :string
      arg :password, :string
      arg :password_confirmation, :string
      arg :phone, :string
      arg :pro_role, :boolean
      arg :provider, :string
      arg :sex, :string
      arg :ssn, :integer
      arg :street, :string
      arg :zip, :integer
      resolve &UserResolver.create/3
    end

    @desc "Update a specific accounts an user"
    field :update_user, :user do
      arg :id, non_null(:string)
      arg :user, :update_user_params
      resolve &UserResolver.update/3
    end

    @desc "Delete a specific accounts an user"
    field :delete_user, :user do
      arg :id, non_null(:string)
      resolve &UserResolver.delete/3
    end
  end

  object :user_subscriptions do
    @desc "Create an accounts user via Channel"
    field :user_created, :user do
      config(fn _, _ ->
        {:ok, topic: "users"}
      end)

      trigger(:create_user,
        topic: fn _ ->
          "users"
        end
      )
    end
  end
end
