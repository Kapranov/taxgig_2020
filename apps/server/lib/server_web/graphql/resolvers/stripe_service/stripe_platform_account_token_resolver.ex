defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountTokenResolver do
  @moduledoc """
  The StripeAccountToken and StripePlatformAccountToken GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeAccountToken,
    StripeService.StripePlatformAccountService,
    StripeService.StripePlatformAccountTokenService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @type t :: StripeAccountToken.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @country "US"
  @mcc 8931
  @requested true
  @settings "manual"
  @type_field "custom"
  @url "https://taxgig.com"

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:business_type]) ||
       is_nil(args[:city]) ||
       is_nil(args[:country]) ||
       is_nil(args[:day]) ||
       is_nil(args[:email]) ||
       is_nil(args[:first_name]) ||
       is_nil(args[:last_name]) ||
       is_nil(args[:line1]) ||
       is_nil(args[:month]) ||
       is_nil(args[:phone]) ||
       is_nil(args[:postal_code]) ||
       is_nil(args[:ssn_last4]) ||
       is_nil(args[:state]) ||
       is_nil(args[:tos_shown_and_accepted]) ||
       is_nil(args[:year])
    do
      {:error, [[field: :account_token, message: "Can't be blank"]]}
    else
      querty_account_token =
        try do
          Queries.by_value(StripeAccountToken, :user_id, current_user.id)
        rescue
          ArgumentError -> :error
        end
      querty_account =
        try do
          Queries.by_value(StripeAccount, :user_id, current_user.id)
        rescue
          ArgumentError -> :error
        end

      case Accounts.by_role(current_user.id) do
        false ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
        true ->
          case StripyRepo.aggregate(querty_account_token, :count, :id) < 1 do
            false -> {:error, %Ecto.Changeset{}}
            true ->
              case StripyRepo.aggregate(querty_account, :count, :id) < 1 do
                false -> {:error, %Ecto.Changeset{}}
                true ->
                  with {:ok, struct} <- StripePlatformAccountTokenService.create(%{
                    business_type: args[:business_type],
                    individual: %{
                      first_name: args[:first_name],
                      last_name: args[:last_name],
                      maiden_name: args[:maiden_name],
                      email: args[:email],
                      phone: args[:phone],
                      address: %{
                        city: args[:city],
                        country: args[:country],
                        line1: args[:line1],
                        postal_code: args[:postal_code],
                        state: args[:state]
                      },
                      dob: %{
                        day: args[:day],
                        month: args[:month],
                        year: args[:year] },
                        ssn_last_4: args[:ssn_last4]
                      },
                      tos_shown_and_accepted: args[:tos_shown_and_accepted]
                    }, %{"user_id" => current_user.id}),
                       user <- CoreRepo.get_by(User, id: current_user.id),
                       Process.sleep(10000),
                       {:ok, _account} <- StripePlatformAccountService.create(%{
                         type: @type_field,
                         country: @country,
                         email: user.email,
                         account_token: struct.id_from_stripe,
                         business_profile: %{
                           mcc: @mcc,
                           url: @url
                         },
                         capabilities: %{
                           card_payments: %{
                             requested: @requested
                           },
                           transfers: %{
                             requested: @requested
                           }
                         },
                         settings: %{
                           payouts: %{
                             schedule: %{
                               interval: @settings
                             }
                           }
                         }
                       }, %{"user_id" => current_user.id})
                  do
                    {:ok, struct}
                  else
                    nil -> {:error, :not_found}
                    failure ->
                      case failure do
                        {:error, %Stripe.Error{code: _, extra: %{
                              card_code: _,
                              http_status: http_status,
                              raw_error: _
                            },
                            message: message,
                            request_id: _,
                            source: _,
                            user_message: _
                          }
                        } -> {:ok, %{error: "HTTP Status: #{http_status}, account token invalid request error. #{message}"}}
                        {:error, %Ecto.Changeset{}} -> {:ok, %{error: "account token not found!"}}
                      end
                  end
              end
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) do
          true ->
            with {:ok, struct} <- StripePlatformAccountTokenService.delete(id_from_stripe) do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure ->
                case failure do
                  {:error, %Stripe.Error{code: _, extra: %{
                        card_code: _,
                        http_status: http_status,
                        raw_error: _
                      },
                      message: message,
                      request_id: _,
                      source: _,
                      user_message: _
                    }
                  } -> {:ok, %{error: "HTTP Status: #{http_status}, account token invalid request error. #{message}"}}
                  {:error, %Ecto.Changeset{}} -> {:ok, %{error: "account token not found!"}}
                end
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeAccountToken #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end
end
