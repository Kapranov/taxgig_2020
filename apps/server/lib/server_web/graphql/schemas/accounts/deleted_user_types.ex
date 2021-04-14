defmodule ServerWeb.GraphQL.Schemas.Accounts.DeletedUserTypes do
  @moduledoc """
  The Deleted User GraphQL interface.
  """

  use Absinthe.Schema.Notation

  alias ServerWeb.GraphQL.Resolvers.Accounts.DeletedUserResolver

  @desc "The deleted user on the site"
  object :deleted_user do
    field :id, non_null(:string)
    field :reason, non_null(list_of(:string))
    field :user_id, non_null(:string)
  end

  @desc "The deleted user update via params"
  input_object :update_deleted_user_params do
    field :reason, list_of(:string)
  end

  object :deleted_user_queries do
    @desc "Get all deleted user"
    field :all_deleted_users, list_of(:deleted_user) do
      resolve(&DeletedUserResolver.list/3)
    end

    @desc "Get a specific deleted user"
    field :show_deleted_user, :deleted_user do
      arg(:id, non_null(:string))
      resolve(&DeletedUserResolver.show/3)
    end
  end

  object :deleted_user_mutations do
    @desc "Create the deleted user"
    field :create_deleted_user, :deleted_user do
      arg :reason, non_null(:string)
      arg :user_id, non_null(:string)
      resolve &DeletedUserResolver.create/3
    end
    @desc "Update a specific deleted user"
    field :update_deleted_user, :deleted_user do
      arg :id, non_null(:string)
      arg :deleted_user, :update_deleted_user_params
      resolve &DeletedUserResolver.update/3
    end

    @desc "Delete a specific deleted user"
    field :delete_deleted_user, :deleted_user do
      arg :id, non_null(:string)
      resolve &DeletedUserResolver.delete/3
    end
  end
end
