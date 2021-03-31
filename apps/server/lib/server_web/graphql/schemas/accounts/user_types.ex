defmodule ServerWeb.GraphQL.Schemas.Accounts.UserTypes do
  @moduledoc """
  The User GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
    Resolvers.Accounts.DeletedUserResolver,
    Resolvers.Accounts.UserResolver,
    Schemas.Middleware
  }

  @desc "The accounts user on the site"
  object :user do
    field :accounting_software, list_of(:accounting_software), description: "list user's accounting_software"
    field :active, non_null(:boolean), description: "accounts user active"
    field :avatar, :string, description: "accounts user avatar"
    field :bio, :string, description: "accounts user bio"
    field :birthday, :date, description: "accounts user birthday"
    field :book_keepings, list_of(:book_keeping), description: "list user's book keepings"
    field :bus_addr_zip, :string, description: "zip customer by ptin"
    field :business_tax_returns, list_of(:business_tax_return), description: "list user's business tax returns"
    field :educations, list_of(:education), description: "list user's educations"
    field :email, non_null(:string), description: "accounts user email"
    field :error, :string, description: "user error"
    field :finished_project_count, :integer, description: "virtual field with calculates all projects with status Done"
    field :first_name, non_null(:string), description: "accounts user first_name"
    field :id, non_null(:string), description: "account user's id"
    field :individual_tax_returns, list_of(:individual_tax_return), description: "list user's business tax returns"
    field :init_setup, :boolean, description: "accounts user init_setup"
    field :is2fa, non_null(:boolean), description: "two factory authorization"
    field :languages, list_of(:language), description: "languages list for user"
    field :last_name, non_null(:string), description: "accounts user last_name"
    field :middle_name, :string, description: "accounts user middle_name"
    field :on_going_project_count, :integer, description: "virtual field with calculates all projects In Progress and in Transition"
    field :otp_last, non_null(:integer), description: "2factor last code"
    field :otp_secret, :string, description: "2factor token"
    field :phone, :string, description: "accounts user phone"
    field :platform, list_of(:platform), description: "list user's platform"
    field :profession, :string, description: "credentials received from searchProfession"
    field :provider, non_null(:string), description: "accounts user provider"
    field :role, non_null(:boolean), description: "accounts user role"
    field :rooms, list_of(:room), resolve: dataloader(Data), description: "list user's room"
    field :sale_taxes, list_of(:sale_tax), description: "list user's sale_taxes"
    field :sex, :string, description: "accounts user sex"
    field :street, :string, description: "accounts user street"
    field :total_earned, :decimal, description: "sum of offerPrice and addonPrice from projects Done"
    field :work_experiences, list_of(:work_experience), description: "list user's work_experiences"
    field :zip, :integer, description: "accounts user zip"
  end

  @desc "The accounts has been destroy via model's deletedUser"
  object :user_deleted do
    field :id, :string
    field :email, :string
    field :reason, :string
    field :role, :boolean
    field :user_id, :string
  end

  @desc "Provider's code"
  object :provider do
    field :code, non_null(:string)
    field :provider, non_null(:string)
  end

  @desc "Provider's verify tokens"
  object :verify_token do
    field :access_type, :string
    field :aud, :string
    field :azp, :string
    field :email, :string
    field :error, :string
    field :error_description, :string
    field :exp, :string
    field :expires_in, :string
    field :provider, :string
    field :scope, :string
    field :sub, :string
  end

  @desc "Provider's access by Facebook, Google, LinkedIn, Twitter"
  object :social_provider do
    field :access_token, :string
    field :error, :string
    field :error_description, :string
    field :expires_in, :string
    field :id_token, :string
    field :provider, non_null(:string)
    field :refresh_token, :string
    field :scope, :string
    field :token_type, :string
  end

  @desc "Get token for an authentication of user"
  object :session do
    field :access_token, :string, description: "Generate JWT access token"
    field :error, :string, description: "A short sentence with error"
    field :error_description, :string, description: "Full details of the error"
    field :provider, non_null(:string), description: "Choose provider service"
    field :user_id, :string, description: "A userId is a unique identifier"
  end

  @desc "The accounts an user update via params"
  input_object :update_user_params do
    field :active, :boolean
    field :avatar, :string
    field :bio, :string
    field :birthday, :date
    field :bus_addr_zip, :string
    field :email, :string
    field :error, :string
    field :first_name, :string
    field :init_setup, :boolean
    field :is2fa, :boolean
    field :languages, :string
    field :last_name, :string
    field :middle_name, :string
    field :phone, :string
    field :profession, :string
    field :provider, :string
    field :role, :boolean
    field :sex, :string
    field :street, :string
    field :zip, :integer
  end

  input_object :update_password_params do
    field :old_password, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
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

    @desc "Get code by Providers"
    field :get_code, :provider do
      arg(:provider, non_null(:string))
      resolve(&UserResolver.get_code/3)
    end

    @desc "Get token by Providers"
    field :get_token, :social_provider do
      arg(:code, :string)
      arg(:provider, non_null(:string))
      arg(:email, :string)
      arg(:password, :string)
      resolve(&UserResolver.get_token/3)
    end

    @desc "Get refresh token code by Providers"
    field :get_refresh_token_code, :provider do
      arg(:provider, non_null(:string))
      arg(:token, non_null(:string))
      resolve(&UserResolver.get_refresh_token_code/3)
    end

    @desc "Get refresh token by Providers"
    field :get_refresh_token, :social_provider do
      arg(:token, non_null(:string))
      arg(:provider, non_null(:string))
      resolve(&UserResolver.get_refresh_token/3)
    end

    @desc "Get verify by Providers"
    field :get_verify, :verify_token do
      arg(:token, non_null(:string))
      arg(:provider, non_null(:string))
      resolve(&UserResolver.verify_token/3)
    end

    @desc "SignIn via social networks"
    field :sign_in_social, :session do
      arg(:code, non_null(:string), description: "Generated the boiler-plate code through social networks, except for localhost")
      arg(:provider, non_null(:string), description: "Choose provider service")
      resolve(&UserResolver.signin/3)
    end

    @desc "SignIn via localhost"
    field :sign_in_local, :session do
      arg(:email, non_null(:string), description: "A field type for email addresses")
      arg(:is2fa, non_null(:boolean), description: "2FA two-factor authentication")
      arg(:password, non_null(:string), description: "Input created a secure passphrase")
      arg(:password_confirmation, non_null(:string), description: "Input a secure passphrase match")
      arg(:provider, non_null(:string), description: "Choose provider service")
      resolve(&UserResolver.signin/3)
    end
  end

  object :user_mutations do
    @desc "Create an accounts user"
    field :create_user, :user do
      arg :active, :boolean
      arg :avatar, :string
      arg :bio, :string
      arg :birthday, :date
      arg :email, :string
      arg :first_name, :string
      arg :init_setup, :boolean
      arg :is2fa, :boolean
      arg :languages, :string
      arg :last_name, :string
      arg :middle_name, :string
      arg :password, :string
      arg :password_confirmation, :string
      arg :phone, :string
      arg :provider, :string
      arg :role, :boolean
      arg :sex, :string
      arg :street, :string
      arg :zip, :integer
      resolve &UserResolver.create/3
      middleware Middleware.ChangesetErrors
    end

    @desc "Sign up via social networks"
    field :sign_up_social, :session do
      arg(:code, non_null(:string), description: "Generated the boiler-plate code through social networks, except for localhost")
      arg(:provider, non_null(:string), description: "Choose provider service")
      resolve(&UserResolver.signup/3)
    end

    @desc "Sign up via localhost"
    field :sign_up_local, :session do
      arg(:email, non_null(:string), description: "A field type for email addresses")
      arg(:first_name, non_null(:string), description: "Input for first name")
      arg(:last_name, non_null(:string), description: "Input for last name")
      arg(:middle_name, :string, description: "Input for middle name")
      arg(:password, non_null(:string), description: "Input a secure passphrase")
      arg(:password_confirmation, non_null(:string), description: "Input a secure passphrase match")
      arg(:phone, non_null(:string), description: "Input only allow US phone number format")
      arg(:provider, non_null(:string), description: "Choose provider service")
      arg(:role, non_null(:boolean), description: "Type is-User Role")
      resolve(&UserResolver.signup/3)
    end

    @desc "Update a specific accounts an user"
    field :update_user, :user do
      arg :id, non_null(:string)
      arg :user, :update_user_params
      resolve &UserResolver.update/3
    end

    @desc "Update only password a specific accounts an user"
    field :update_password, :user do
      arg :id, non_null(:string)
      arg :user, :update_password_params
      resolve &UserResolver.update_password/3
    end

    @desc "Delete a specific accounts an user"
    field :delete_user, :user_deleted do
      arg :reason, non_null(:string)
      arg :user_id, non_null(:string)
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
