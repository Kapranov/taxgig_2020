defmodule ServerWeb.GraphQL.Schemas.Accounts.UserTypes do
  @moduledoc """
  The User GraphQL interface.
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias ServerWeb.GraphQL.{
    Data,
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
    field :first_name, :string, description: "accounts user first_name"
    field :id, non_null(:string), description: "account user's id"
    field :individual_tax_returns, list_of(:individual_tax_return), description: "list user's business tax returns"
    field :init_setup, :boolean, description: "accounts user init_setup"
    field :is2fa, non_null(:boolean), description: "two factory authorization"
    field :languages, list_of(:language), description: "languages list for user"
    field :last_name, :string, description: "accounts user last_name"
    field :middle_name, :string, description: "accounts user middle_name"
    field :on_going_project_count, :integer, description: "virtual field with calculates all projects In Progress and in Transition"
    field :otp_last, non_null(:integer), description: "2factor last code"
    field :otp_secret, non_null(:string), description: "2factor token"
    field :phone, :string, description: "accounts user phone"
    field :platform, list_of(:platform), resolve: dataloader(Data), description: "list user's platform"
    field :profession, :string, description: "credentials received from searchProfession"
    field :profile, list_of(:profile), resolve: dataloader(Data), description: "user's profile"
    field :provider, non_null(:string), description: "accounts user provider"
    field :role, non_null(:boolean), description: "accounts user role"
    field :rooms, list_of(:room), resolve: dataloader(Data), description: "list user's room"
    field :pro_ratings, list_of(:pro_rating), resolve: dataloader(Data)
    field :sale_taxes, list_of(:sale_tax), description: "list user's sale_taxes"
    field :sex, :string, description: "accounts user sex"
    field :street, :string, description: "accounts user street"
    field :total_earned, :decimal, description: "sum of offerPrice and addonPrice from projects Done"
    field :work_experiences, list_of(:work_experience), description: "list user's work_experiences"
    field :zip, :integer, description: "accounts user zip"
  end

  @desc "The accounts has been destroy via model's deletedUser"
  object :user_deleted do
    field :email, :string
    field :error, :string
    field :id, :string
    field :role, :boolean
  end

  @desc "Provider's code"
  object :provider do
    field :code, :string
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
    field :is2fa, :boolean, description: "usage two factory authorization"
    field :provider, :string, description: "Choose provider service"
    field :user_id, :string, description: "A userId is a unique identifier"
  end

  @desc "Updated is2fa when successful google authentificator"
  object :updated2fa do
    field :error, :string, description: "A short sentence with error"
    field :error_description, :string, description: "Full details of the error"
    field :is2fa, :boolean, description: "usage two factory authorization"
    field :user_id, :string, description: "A userId is a unique identifier"
  end

  @desc "Get email"
  object :info_email do
    field :email, :string, description: "accounts user email"
    field :error, :string, description: "a short sentence with error"
  end

  @desc "Get 2fa"
  object :two_factory do
    field :qcode, :string, description: "2fa barcode"
    field :is2fa, :boolean, description: "on or off two factory"
    field :key, :string, description: "your secret key for otp"
    field :error, :string, description: "a short sentence with error"
  end

  @desc "Statistica totalCount"
  object :total_count do
    field :total_client, list_of(:integer), description: "total user client"
    field :total_client_difference, list_of(:integer), description: "total user client timestamp"
    field :total_deleted, list_of(:integer), description: "total deleted user"
    field :total_deleted_difference, list_of(:integer), description: "total deleted user timestamp"
    field :total_pro, list_of(:integer), description: "total user pro"
    field :total_pro_difference, list_of(:integer), description: "total user pro timestamp"
    field :total_user, list_of(:integer), description: "total all users"
    field :total_user_difference, list_of(:integer), description: "total user timestamp"
    field :error,  :string
    field :error_description, :string
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

  input_object :update_password_reset_params do
    field :code, non_null(:string)
    field :password, non_null(:string)
    field :password_confirmation, non_null(:string)
  end

  @desc "The user filter via params"
  input_object :filter_user_params, description: "filter user" do
    field :start_date, non_null(:date)
    field :end_date, non_null(:date)
  end

  @desc "The pro user filter via params"
  input_object :filter_pro_users_params, description: "filter pro role by an user" do
    field :hero_status, :boolean
    field :limit_counter, non_null(:integer)
    field :page, non_null(:integer)
    field :profession, :string
  end

  @desc "The users filter via params"
  input_object :filter_users_params, description: "filter users" do
    field :page, :integer
    field :limit_counter, :integer
  end

  @desc "The stuck users filter via params"
  input_object :filter_stuck_users_params, description: "filter stuck users" do
    field :limit_counter, non_null(:integer)
    field :page, non_null(:integer)
    field :role, :boolean
    field :stuck_stage, :string
  end

  @desc "The banned users filter via params"
  input_object :filter_banned_users_params, description: "filter banned users" do
    field :limit_counter, non_null(:integer)
    field :page, non_null(:integer)
    field :reasons, :string
    field :role, :boolean
  end

  object :user_queries do
    @desc "Get default avatars"
    field :default_avatars, list_of(:string) do
      resolve(&UserResolver.default_avatars/3)
    end

    @desc "Get all accounts an user"
    field :all_users, list_of(:user) do
      resolve(&UserResolver.list/3)
    end

    @desc "Get all stuck accounts an user for admin"
    field :all_stuck_users_by_admin, list_of(:user) do
      arg :filter, non_null(:filter_stuck_users_params)
      resolve(&UserResolver.list_stuck_users/3)
    end

    @desc "Get all banned accounts an user for admin"
    field :all_banned_users_by_admin, list_of(:user) do
      arg :filter, non_null(:filter_banned_users_params)
      resolve(&UserResolver.list_banned_users/3)
    end

    @desc "Get all pro accounts an user for admin"
    field :all_pro_users_by_admin, list_of(:user) do
      arg :filter, non_null(:filter_pro_users_params)
      resolve(&UserResolver.list_pro_users/3)
    end

    @desc "Get all tp accounts an user for admin"
    field :all_tp_users_by_admin, list_of(:user) do
      arg :filter, non_null(:filter_users_params)
      resolve(&UserResolver.list_tp_users/3)
    end

    @desc "Get all accounts ian user for admin"
    field :all_users_by_admin, list_of(:user) do
      arg :filter, non_null(:filter_users_params)
      resolve(&UserResolver.list_users/3)
    end

    @desc "Get a specific accounts an user"
    field :show_user, :user do
      arg(:id, non_null(:string))
      resolve(&UserResolver.show/3)
    end

    @desc "Get a specific accounts an user for admin"
    field :show_user_by_admin, :user do
      arg(:user_id, non_null(:string))
      resolve(&UserResolver.show_for_admin/3)
    end

    @desc "Get email"
    field :get_email, :info_email do
      arg(:email, non_null(:string))
      resolve(&UserResolver.search/3)
    end

    @desc "Get code by Providers"
    field :get_code, :provider do
      arg(:provider, non_null(:string))
      arg(:redirect, non_null(:string))
      resolve(&UserResolver.get_code/3)
    end

    @desc "Get token by Providers"
    field :get_token, :social_provider do
      arg(:code, :string)
      arg(:email, :string)
      arg(:password, :string)
      arg(:provider, non_null(:string))
      arg(:redirect, non_null(:string))
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
      arg(:redirect, non_null(:string), description: "Redirect URI by Social's network Dashboard")
      resolve(&UserResolver.signin/3)
    end

    @desc "SignIn via localhost"
    field :sign_in_local, :session do
      arg(:email, non_null(:string), description: "A field type for email addresses")
      arg(:password, non_null(:string), description: "Input created a secure passphrase")
      arg(:password_confirmation, non_null(:string), description: "Input a secure passphrase match")
      arg(:provider, non_null(:string), description: "Choose provider service")
      resolve(&UserResolver.signin/3)
    end

    @desc "Two factory authorization"
    field :create2fa, :two_factory do
      resolve(&UserResolver.create_2fa/3)
    end

    @desc "SignIn via 2FA"
    field :sign_in2fa, :session do
      arg(:pin, non_null(:string), description: "code number via 2fa")
      arg(:user_id, non_null(:string), description: "A field type for email addresses")
      resolve(&UserResolver.signin2fa/3)
    end

    @desc "Statistica total Users"
    field :total_user_count_by_admin, :total_count do
      arg :filter, non_null(:filter_user_params)
      resolve(&UserResolver.total_user_count/3)
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
      arg(:redirect, non_null(:string), description: "Redirect URI by Social's network Dashboard")
      resolve(&UserResolver.signup/3)
    end

    @desc "Sign up via localhost"
    field :sign_up_local, :session do
      arg(:email, non_null(:string), description: "A field type for email addresses")
      arg(:password, non_null(:string), description: "Input a secure passphrase")
      arg(:password_confirmation, non_null(:string), description: "Input a secure passphrase match")
      arg(:phone, non_null(:string), description: "Input only allow US phone number format")
      arg(:provider, non_null(:string), description: "Choose provider service")
      arg(:role, non_null(:boolean), description: "Type is-User Role")
      arg(:zip, :string, description: "Zip only USA authorize")
      resolve(&UserResolver.signup/3)
    end

    @desc "Update a specific accounts an user fo admin"
    field :update_user_by_admin, :user do
      arg :id, non_null(:string)
      arg :user, :update_user_params
      resolve &UserResolver.update_for_admin/3
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

    @desc "Update only password a specific accounts an user via code"
    field :update_password_reset, :user do
      arg :code, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)
      resolve &UserResolver.password_reset/3
    end

    @desc "Change is2fa via 2FA"
    field :verify2fa, :updated2fa do
      arg :pin, non_null(:string), description: "code number via 2fa"
      resolve &UserResolver.verify2fa/3
    end

    @desc "Delete a specific accounts an user"
    field :delete_user, :user_deleted do
      arg :reason, non_null(:string)
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
