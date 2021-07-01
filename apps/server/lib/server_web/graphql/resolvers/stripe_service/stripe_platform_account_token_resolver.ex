defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountTokenResolver do
  @moduledoc """
  The StripeAccountToken and StripePlatformAccountToken GraphQL resolvers.
  """

  alias Core.{
    Accounts.User,
    Queries
  }

  alias Stripy.{
    Payments.StripeAccount,
    Payments.StripeAccountToken,
    Repo,
    StripeService.StripePlatformAccountService,
    StripeService.StripePlatformAccountTokenService
  }

  @type t :: StripeAccountToken.t()
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:ok, %{error: String.t()}}
  @type result :: success_tuple | error_tuple

  @country "US"
  @mcc 8931
  @requested true
  @settings "manual"
  @type_field "custom"
  @url "https://taxgig.com"

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    querty_account = Queries.by_value(StripeAccount, :user_id, current_user.id)
    querty_account_token = Queries.by_value(StripeAccountToken, :user_id, current_user.id)

    case current_user.role do
      false ->
        {:ok, %{error: "permission denied"}}
      true ->
        case Repo.aggregate(querty_account_token, :count, :id) == 0 do
          false -> {:ok, %{error: "permission denied"}}
          true ->
            case Repo.aggregate(querty_account, :count, :id) == 0 do
              false -> {:ok, %{error: "permission denied"}}
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
                     Process.sleep(10000),
                     {:ok, _account} <- StripePlatformAccountService.create(%{
                       type: @type_field,
                       country: @country,
                       email: current_user.email,
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
                  nil -> {:ok, %{error: "The StripeAccountToken not found!"}}
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
                      } ->
                        query = Queries.by_value(StripeAccountToken, :user_id, current_user.id)
                        {_, _} = Stripy.Repo.delete_all(query)
                        {:ok, %{error: "HTTP Status: #{http_status}, account token invalid request error. #{message}"}}
                      {:error, %Stripe.Error{code: _, extra: %{
                            http_status: http_status,
                            param: _,
                            raw_error: %{
                              "message" => _,
                              "param" => param,
                              "type" => _
                            }},
                          message: message,
                          request_id: _,
                          source: _,
                          user_message: _
                        }
                      } ->
                        query = Queries.by_value(StripeAccountToken, :user_id, current_user.id)
                        {_, _} = Stripy.Repo.delete_all(query)
                        {:ok, %{error: "HTTP Status: #{http_status}, account token invalid request error. #{message} with #{param}"}}
                      {:error, %Stripe.Error{code: _, extra: %{
                            http_status: http_status,
                            raw_error: %{
                              "message" => _,
                              "type" => _
                            }
                          },
                          message: message,
                          request_id: _,
                          source: _,
                          user_message: _
                        }
                      } ->
                        query = Queries.by_value(StripeAccountToken, :user_id, current_user.id)
                        {_, _} = Stripy.Repo.delete_all(query)
                        {:ok, %{error: "HTTP Status: #{http_status}, account token invalid request error. #{message}"}}
                      {:error, %Ecto.Changeset{}} -> {:ok, %{error: "The StripeAccountToken not found!"}}
                    end
                end
            end
        end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    case current_user.admin do
      true ->
        with {:ok, struct} <- StripePlatformAccountTokenService.delete(id_from_stripe) do
          {:ok, struct}
        else
          nil -> {:ok, %{error: "permission denied"}}
          failure ->
            case failure do
              {:error, %Ecto.Changeset{}} -> {:ok, %{error: "The StripeAccountToken #{id_from_stripe} not found!"}}
            end
        end
      false ->
        {:ok, %{error: "permission denied"}}
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info), do: {:ok, %{error: "unauthenticated"}}
end
