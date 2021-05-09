defmodule ServerWeb.GraphQL.Resolvers.Accounts.UserResolver do
  @moduledoc """
  The User GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts.Project,
    Repo
  }

  alias Mailings.Mailer
  alias Server.Token

  alias ServerWeb.Provider.{
    OauthFacebook,
    OauthGoogle,
    OauthLinkedIn
  }

  alias Stripy.{
    Payments,
    Payments.StripeAccount,
    Payments.StripeBankAccountToken,
    Payments.StripeCardToken,
    Payments.StripeCustomer,
    Payments.StripeExternalAccountBank,
    Payments.StripeExternalAccountCard,
    Queries,
    StripeService.StripePlatformAccountService,
    StripeService.StripePlatformCustomerService
  }

  alias Core.Queries, as: CoreQueries
  alias Stripy.Queries, as: StripyQueries

  @type d :: DeletedUser.t()
  @type t :: User.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t} | {:ok, d}
  @type success_list :: {:ok, [t]} | {:ok, [d]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type error_map :: {:ok, %{error: any, error_description: any, provider: any}}
  @type result :: success_tuple | success_list | error_tuple

  @salt Application.get_env(:server, ServerWeb.Endpoint)[:salt]
  @secret Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_base]
  @secret_email Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_email]
  @email_age Application.get_env(:server, ServerWeb.Endpoint)[:email_age]
  @ts DateTime.utc_now |> DateTime.to_unix

  @keys ~w(provider)a
  @code_keys ~w(provider redirect)a
  @error_code "invalid code"
  @error_des "invalid url by"
  @error_pro "invalid provider"
  @error_pro_des "invalid url by provider"
  @error_email "invalid an email"
  @error_email_des "an email is empty or doesn't correct"
  @error_password "invalid password"
  @error_password_des "password is empty or doesn't correct"
  @error_token "invalid token"
  @error_token_des "token is empty or doesn't correct"
  @error_request "invalid grant"
  @error_request_des "Bad Request"

  def default_avatars(_parent, _args, _resolutions) do
    image_url = "http://robohash.org/set_set1/bgset_bg1"
    {:ok, [
        "#{image_url}/RbY701OjHTBuUfgP8SM",
        "#{image_url}/8Q",
        "#{image_url}/3kmxQaPHLKJm",
        "#{image_url}/PlCHlAkrc",
        "#{image_url}/JvBkyiCDIsje",
        "#{image_url}/2f80"
      ]
    }
  end

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: success_list() | error_tuple()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :user_id, message: "An User not found! or Unauthenticated"]]}
    else
      case Accounts.all(User, [desc: :id], [id: current_user.id], [
        :accounting_software,
        :book_keepings,
        :business_tax_returns,
        :educations,
        :individual_tax_returns,
        :languages,
        :platform,
        :sale_taxes,
        :work_experiences
      ]) do
        nil -> {:error, "Not found"}
        struct ->
          if current_user.role == true do
            with val1 <- CoreQueries.by_count_with_status_projects(Project, User, false, "Done", current_user),
                 [val2] <- CoreQueries.by_count_with_status_projects(Project, User, false, "In Progress", "In Transition", current_user),
                 val3 <- CoreQueries.by_count_with_offer_addon_projects(Project, User, false, "Done", current_user)
            do
              new_val1 = if val1 == [], do: 0, else: List.last(val1)
              new_val3 =
                if val3 == [] do
                  Decimal.new("0.0")
                else
                  val3
                  |> Enum.map(fn n ->
                    if is_nil(elem(n, 1)) do
                      data = { n |> elem(0) |> Decimal.to_string |> String.to_float, 0 }
                      ((elem(data, 0) + (elem(data, 1) * 0.01)) * 0.8) |> Float.round(2)

                    else
                      data = { n |> elem(0) |> Decimal.to_string |> String.to_float, n |> elem(1) }
                      ((elem(data, 0) + (elem(data, 1) * 0.01)) * 0.8) |> Float.round(2)
                    end
                  end)
                  |> Enum.sum
                  |> Decimal.from_float
                  |> Decimal.round(2)
                end

              {:ok,
                struct
                |> List.last
                |> Map.update!(:finished_project_count, fn _ -> new_val1 end)
                |> Map.update!(:on_going_project_count, fn _ -> val2 end)
                |> Map.update!(:total_earned, fn _ -> new_val3 end)
              }
            end
          else
            {:ok, struct}
          end
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      try do
        struct = Accounts.get_user!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec search(any, %{email: bitstring}, any) :: result()
  def search(_parent, %{email: term}, _resolutions) do
    data = Accounts.search_email(term)
    if is_nil(data) do
      {:ok, %{error: "email not found"}}
    else
      case Token.create(data.email, @secret_email, date_time: timestamp_one_day()) do
        {:ok, code} ->
          Task.async(fn ->
            Mailer.send_forgot_password_html(code, data.email, data.first_name)
          end)
          {:ok, %{email: data.email}}
        {:error, :invalid_token} ->
          {:ok, %{error: "invalid token"}}
      end
    end
  end

  @spec search(any, any, any) :: error_tuple()
  def search(_parent, _args, _resolutions) do
    {:ok, %{error: "field is empty"}}
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, %{} = args, _info) do
    args
    |> Accounts.create_user()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    %User{}
    |> User.changeset(%{})
    |> Repo.insert
    |> case do
      {:error, changeset} ->
        {:error, error_details(changeset)}
    end
  end

  @spec update(any, %{id: bitstring, user: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_root, %{id: id, user: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      try do
        case id == current_user.id do
          true ->
            Repo.get!(User, id)
            |> User.changeset(params)
            |> Repo.update
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_root, _args, _info) do
    {:error, [
        [field: :id, message: "Can't be blank"],
        [field: :user, message: "Can't be blank"],
        [field: :current_user,  message: "Unauthenticated"]
      ]
    }
  end

  @spec update_password(any, %{id: bitstring, user: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update_password(_root, %{id: id, user: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Unauthenticated"]]}
    else
      try do
        case id == current_user.id do
          true ->
            case Argon2.check_pass(current_user, params[:old_password]) do
              {:error, _} ->
                {:ok, %{error: "old password is not correct"}}
              {:ok, user} ->
                user
                |> User.changeset(params)
                |> Repo.update
                |> case do
                  {:ok, struct} ->
                    {:ok, struct}
                  {:error, changeset} ->
                    {:error, extract_error_msg(changeset)}
                end
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec update_password(any, any, any) :: error_tuple()
  def update_password(_root, _args, _info) do
    {:error, [
        [field: :id, message: "Can't be blank"],
        [field: :user, message: "Can't be blank"],
        [field: :password, message: "Can't be blank"],
        [field: :password_confirmation, message: "Can't be blank"],
        [field: :current_user,  message: "Unauthenticated"]
      ]
    }
  end

  @spec password_reset(any, %{code: String.t(), email: String.t(), password: String.t(), password_confirmation: String.t()}, any) :: result()
  def password_reset(_root, %{code: code, password: password, password_confirmation: password_confirmation}, _info) do
    if is_nil(code) do
      {:error, "invalid authorization code"}
    else
      try do
        case Token.verify(code, @secret_email, @ts) do
          {:ok, email} ->
            Repo.get_by!(User, %{email: email})
            |> User.changeset(%{password: password, password_confirmation: password_confirmation})
            |> Repo.update
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          {:error, :invalid_token} ->
            {:ok, %{error: "invalid_token"}}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "An User not found"}
      end
    end
  end

  @spec password_reset(any, any, any) :: error_tuple()
  def password_reset(_root, _args, _info) do
    {:ok, %{error: "invalid authorization code"}}
  end

  @spec delete(any, %{reason: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{reason: reason}, %{context: %{current_user: current_user}}) do
    case Accounts.by_role(current_user.id) do
      true ->
        querty = Queries.by_count(StripeAccount, :user_id, current_user.id)

        case Repo.aggregate(querty, :count, :id) == 1 do
          true ->
            with struct <- Accounts.get_user!(current_user.id),
                 [account] = StripyQueries.by_list(StripeAccount, :user_id, struct.id),
                 {:ok, stripe} <- StripePlatformAccountService.delete(account.id_from_stripe),
                 ex_cards <- StripyQueries.by_list(StripeExternalAccountCard, :user_id, stripe.user_id),
                 ex_banks <- StripyQueries.by_list(StripeExternalAccountBank, :user_id, stripe.user_id),
                 cards <- StripyQueries.by_list(StripeCardToken, :user_id, stripe.user_id),
                 bank_account_tokens <- StripyQueries.by_list(StripeBankAccountToken, :user_id, stripe.user_id),
                 {:ok, deleted} <- Accounts.delete_user(struct, reason)
            do
              Enum.reduce(ex_cards, [], fn(x, acc) ->
                [Payments.delete_stripe_external_account_card(x) | acc]
              end)
              Enum.reduce(ex_banks, [], fn(x, acc) ->
                [Payments.delete_stripe_external_account_bank(x) | acc]
              end)
              Enum.reduce(cards, [], fn(x, acc) ->
                [Payments.delete_stripe_card_token(x) | acc]
              end)
              Enum.reduce(bank_account_tokens, [], fn(x, acc) ->
                [Payments.delete_stripe_bank_account_token(x) | acc]
              end)
              {:ok, deleted}
            else
              nil -> {:error, "permission denied"}
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
              } -> {:ok, %{error: "HTTP Status: #{http_status}, invalid request error. #{message}"}}
              {:error, changeset} -> {:error, extract_error_msg(changeset)}
            end
          false ->
            with struct <- Accounts.get_user!(current_user.id),
                 {:ok, deleted} <- Accounts.delete_user(struct, reason)
            do
              {:ok, deleted}
            else
              nil -> {:error, "permission denied"}
              {:error, changeset} -> {:error, extract_error_msg(changeset)}
            end
        end
      false ->
        querty = Queries.by_count(StripeCustomer, :user_id, current_user.id)

        case Repo.aggregate(querty, :count, :id) == 1 do
          true ->
            with struct <- Accounts.get_user!(current_user.id),
                 [customer] <- StripyQueries.by_list(StripeCustomer, :user_id, struct.id),
                 {:ok, stripe} <- StripePlatformCustomerService.delete(customer.id_from_stripe),
                 cards <- StripyQueries.by_list(StripeCardToken, :user_id, stripe.user_id),
                 {:ok, deleted} <- Accounts.delete_user(struct, reason)
            do
              Enum.reduce(cards, [], fn(x, acc) ->
                [Payments.delete_stripe_card_token(x) | acc]
              end)
              {:ok, deleted}
            else
              nil -> {:error, "permission denied"}
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
              } -> {:ok, %{error: "HTTP Status: #{http_status}, invalid request error. #{message}"}}
              {:error, changeset} -> {:error, extract_error_msg(changeset)}
            end
          false ->
            with struct <- Accounts.get_user!(current_user.id),
                 {:ok, deleted} <- Accounts.delete_user(struct, reason)
            do
              {:ok, deleted}
            else
              nil -> {:error, "permission denied"}
              {:error, changeset} -> {:error, extract_error_msg(changeset)}
            end
        end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [
        [field: :current_user,  message: "Unauthenticated"],
        [field: :id, message: "Can't be blank"],
        [field: :reason, message: "Can't be blank"]
      ]
    }
  end

  @spec get_code(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def get_code(_parent, args, _resolution) do
    case required_keys(@code_keys, args) do
      true ->
        case args[:provider] do
          "facebook" ->
            case OauthFacebook.generate_url(args[:redirect]) do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider]), provider: args[:provider]}}
              code ->
                {:ok, %{code: code, provider: args[:provider]}}
            end
          "google" ->
            case OauthGoogle.generate_url(args[:redirect]) do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider]), provider: args[:provider]}}
              code ->
                {:ok, %{code: code, provider: args[:provider]}}
            end
          "linkedin" ->
            case OauthLinkedIn.generate_url(args[:redirect]) do
              {:ok, data} ->
                {:ok, %{code: data["url"], provider: args[:provider]}}
            end
          "twitter" ->
            {:ok, %{code: :ok, provider: args[:provider]}}
          _ ->
            {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
        end
      false ->
        {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
    end
  end

  @spec get_token(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def get_token(_parent, args, _resolution) do
    case required_keys(@keys, args) do
      true ->
        case args[:code] do
          nil ->
            if(args[:provider] == "localhost" && is_bitstring(args[:email])) do
              case User.find_by(email: String.downcase(args[:email])) do
                nil ->
                  {:ok, %{error: @error_email, error_description: @error_email_des, provider: args[:provider]}}
                user ->
                  case Argon2.check_pass(user, args[:password]) do
                    {:error, _} ->
                      {:ok, %{error: @error_password, error_description: @error_password_des, provider: args[:provider]}}
                    {:ok, user} ->
                      with data <- generate_token(user) do
                        {:ok, %{access_token: data, provider: args[:provider]}}
                      end
                  end
              end
            else
              if(args[:provider] == "twitter") do
                {:ok, %{access_token: :ok, provider: args[:provider]}}
              else
                {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
              end
            end
          _ ->
            case args[:provider] do
              "facebook" ->
                case OauthFacebook.token(args[:code], args[:redirect]) do
                  {:ok, data} ->
                    if is_nil(data["error"]) do
                      {:ok, %{
                          access_token: data["access_token"],
                          expires_in: data["expires_in"],
                          provider: args[:provider]
                        }}
                    else
                      if is_map(data["error"]) do
                        {:ok, %{
                            error: "#{data["error"]["type"]}, #{data["error"]["code"]}",
                            error_description: data["error"]["message"],
                            provider: args[:provider]
                          }}
                      else
                        {:ok, %{
                            error: data["error"],
                            error_description: data["error_description"],
                            provider: args[:provider]
                          }}
                      end
                    end
                end
              "google" ->
                case OauthGoogle.token(args[:code], args[:redirect]) do
                  {:error, data} ->
                    %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
                    {:ok, %{error: @error_code, error_description: msg, provider: args[:provider]}}
                  {:ok, data} ->
                    {:ok,
                      %{
                        access_token:           data["access_token"],
                        error:                         data["error"],
                        error_description: data["error_description"],
                        expires_in:               data["expires_in"],
                        id_token:                   data["id_token"],
                        provider:                    args[:provider],
                        refresh_token:         data["refresh_token"],
                        scope:                         data["scope"],
                        token_type:               data["token_type"]
                      }
                    }
                end
              "linkedin" ->
                case OauthLinkedIn.token(args[:code], args[:redirect]) do
                  nil ->
                    {:ok, %{error: @error_email, error_description: @error_email_des, provider: args[:provider]}}
                  {:ok, data} ->
                    {:ok, %{
                        access_token: data["access_token"],
                        error: data["error"],
                        error_description: data["error_description"],
                        expires_in: data["expires_in"],
                        provider: args[:provider]
                      }}
                end
              _ ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
            end
        end
      false ->
        {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
    end
  end

  @spec get_refresh_token_code(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def get_refresh_token_code(_parent, args, _resolution) do
    case required_keys(@keys, args) do
      true ->
        case args[:provider] do
          "facebook" ->
            case OauthFacebook.generate_refresh_token_url(args[:token]) do
              {:ok, data} ->
                if is_nil(data["error"]) do
                  {:ok, %{
                      code: data["code"],
                      provider: args[:provider]
                    }}
                else
                  if is_map(data["error"]) do
                    {:ok, %{
                        error: "#{data["error"]["type"]}, #{data["error"]["code"]}",
                        error_description: data["error"]["message"],
                        provider: args[:provider]
                      }}
                  else
                    {:ok, %{
                        error: data["error"],
                        error_description: data["error_description"],
                        provider: args[:provider]
                      }}
                  end
                end
            end
          "google" ->
            case OauthGoogle.generate_refresh_token_url() do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider]), provider: args[:provider]}}
              code ->
                {:ok, %{code: code, provider: args[:provider]}}
            end
          "linkedin" ->
            case OauthLinkedIn.generate_refresh_token_url(args[:token]) do
              {:ok, data} ->
                {:ok, %{
                    code: data["code"],
                    provider: args[:provider]
                  }}
            end
          "twitter" -> {:ok, %{code: :ok, provider: args[:provider]}}
          _ ->
            {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
        end
      false ->
        {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
    end
  end

  @spec get_refresh_token(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def get_refresh_token(_parent, args, _resolution) do
    if required_keys(@keys, args) do
      if (args[:provider] == "google" || args[:provider] == "linkedin" || args[:provider] == "facebook") do
        case args[:provider] do
          nil ->
            {:ok, %{error: @error_token, error_description: @error_token_des, provider: args[:provider]}}
          "google" ->
            case OauthGoogle.refresh_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
              {:error, data} ->
                %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
                {:ok, %{error: @error_token, error_description: msg, provider: args[:provider]}}
              {:ok, data} ->
                {:ok,
                  %{
                    access_token:           data["access_token"],
                    error:                         data["error"],
                    error_description: data["error_description"],
                    expires_in:               data["expires_in"],
                    id_token:                   data["id_token"],
                    provider:                    args[:provider],
                    refresh_token:         data["refresh_token"],
                    scope:                         data["scope"],
                    token_type:               data["token_type"]
                  }
                }
            end
          "linkedin" ->
            case OauthLinkedIn.refresh_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_token, error_description: error_des(args[:provider]), provider: args[:provider]}}
              {:error, data} ->
                %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
                {:ok, %{error: @error_token, error_description: msg, provider: args[:provider]}}
              {:ok, data} ->
                {:ok,
                  %{
                    access_token:           data["access_token"],
                    error:                         data["error"],
                    error_description: data["error_description"],
                    expires_in:               data["expires_in"],
                    id_token:                   data["id_token"],
                    provider:                    args[:provider],
                    refresh_token:         data["refresh_token"],
                    scope:                         data["scope"],
                    token_type:               data["token_type"]
                  }
                }
            end
          "facebook" ->
            case OauthFacebook.refresh_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_token, error_description: error_des(args[:provider]), provider: args[:provider]}}
              {:ok, data} ->
                if is_nil(data["error"]) do
                  {:ok,
                    %{
                      access_token:           data["access_token"],
                      error:                         data["error"],
                      error_description: data["error_description"],
                      expires_in:               data["expires_in"],
                      id_token:                   data["id_token"],
                      provider:                    args[:provider],
                      refresh_token:         data["refresh_token"],
                      scope:                         data["scope"],
                      token_type:               data["token_type"]
                    }
                  }
                else
                  if is_map(data["error"]) do
                    {:ok, %{
                        error: "#{data["error"]["type"]}, #{data["error"]["code"]}",
                        error_description: data["error"]["message"],
                        provider: args[:provider]
                      }}
                  else
                    {:ok, %{
                        error: data["error"],
                        error_description: data["error_description"],
                        provider: args[:provider]
                      }}
                  end
                end
            end
        end
      else
        if (args[:provider] == "twitter") do
          {:ok, %{access_token: :ok, provider: args[:provider]}}
        else
          {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
        end
      end
    else
      {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
    end
  end

  @spec verify_token(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def verify_token(_parent, args, _resolution) do
    if required_keys(@keys, args) do
      if (args[:provider] == "google" || args[:provider] == "linkedin" || args[:provider] == "facebook") do
        case args[:provider] do
          "google" ->
            case OauthGoogle.verify_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
              {:ok, data} ->
                {:ok,
                  %{
                    access_type:             data["access_type"],
                    aud:                             data["aud"],
                    azp:                             data["azp"],
                    error:                         data["error"],
                    error_description: data["error_description"],
                    exp:                             data["exp"],
                    expires_in:               data["expires_in"],
                    provider:                           "google",
                    scope:                         data["scope"],
                    sub:                             data["sub"]
                  }
                }
              {:error, data} ->
                %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
                {:ok, %{error: @error_token, error_description: msg, provider: args[:provider]}}
            end
          "linkedin" ->
            case OauthLinkedIn.verify_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
              {:ok, data} ->
                if is_nil(data["error"]) do
                  {:ok, %{
                      email: data["email"],
                      provider: args[:provider]
                    }}
                else
                  {:ok, %{
                      error: data["error"],
                      error_description: data["error_description"]
                    }}
                end
            end
          "facebook" ->
            case OauthFacebook.verify_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
              {:ok, data} ->
                if is_nil(data["error"]) do
                  {:ok, %{
                      access_token: data["access_token"],
                      expires_in:     data["expires_in"],
                      provider:          args[:provider]
                    }}
                else
                  if is_map(data["error"]) do
                    {:ok, %{
                        error: "#{data["error"]["type"]}, #{data["error"]["code"]}",
                        error_description: data["error"]["message"],
                        provider: args[:provider]
                      }}
                  else
                    {:ok, %{
                        error: data["error"],
                        error_description: data["error_description"],
                        provider: args[:provider]
                      }}
                  end
                end
            end
        end
      else
        if (args[:provider] == "twitter") do
          {:ok, %{access_token: :ok, provider: args[:provider]}}
        else
          {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
        end
      end
    else
      {:ok, %{error: @error_pro, error_description: @error_pro_des, provider: args[:provider]}}
    end
  end

  @spec signup(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def signup(_parent, args, _resolution) do
    case args[:provider] do
      nil ->
        {:ok, %{
            error: @error_pro,
            error_description: @error_pro_des,
            provider: args[:provider]
          }}
      "facebook" ->
        case OauthFacebook.token(args[:code], args[:redirect]) do
          {:ok, data} ->
            if is_nil(data["error"]) do
              with {:ok, profile} <- OauthFacebook.user_profile(data["access_token"]) do
                if is_nil(profile["email"]) do
                  {:ok, %{
                      error: @error_email,
                      error_description: "Email dosn't exist in Facebook profile",
                      provider: args[:provider]
                    }}
                else
                  user = User.find_by(email: profile["email"])
                  pict = profile["picture"]["data"]["url"]
                  avatar = if is_nil(pict), do: Gravity.image(profile["email"]), else: pict
                  if is_nil(user) do
                    user_params =
                      %{
                        avatar:                            avatar,
                        email:                   profile["email"],
                        first_name:         profile["first_name"],
                        last_name:           profile["last_name"],
                        middle_name:       profile["middle_name"],
                        provider:                 args[:provider]
                      }
                    case Accounts.create_user(user_params) do
                      {:ok, created} ->
                        with data <- generate_token(created) do
                          {:ok, %{
                              access_token: data,
                              provider: args[:provider],
                              user_id: created.id
                            }}
                        end
                      {:error, %Ecto.Changeset{}} ->
                        {:error, %Ecto.Changeset{}}
                    end
                  else
                    if is_map(data["error"]) do
                      {:ok, %{
                          error: "#{data["error"]["type"]}, #{data["error"]["code"]}",
                          error_description: data["error"]["message"],
                          provider: args[:provider]
                        }}
                    else
                      {:ok, %{
                          error: @error_email,
                          error_description: "Has already been taken",
                          provider: args[:provider]
                        }}
                    end
                  end
                end
              end
            else
              if is_map(data["error"]) do
                {:ok, %{
                    error: "#{data["error"]["type"]}, #{data["error"]["code"]}",
                    error_description: data["error"]["message"],
                    provider: args[:provider]
                  }}
              else
                {:ok, %{
                    error: data["error"],
                    error_description: data["error_description"],
                    provider: args[:provider]
                  }}
              end
            end
        end
      "google" ->
        case OauthGoogle.token(args[:code], args[:redirect]) do
          {:error, data} ->
            %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
            {:ok, %{
                error: @error_code,
                error_description: msg,
                provider: args[:provider]
              }}
          {:ok, data} ->
            if is_nil(data["error"]) do
              with {:ok, profile} <- OauthGoogle.user_profile(data["access_token"]) do
                if is_nil(profile["email"]) do
                  {:ok, %{
                      error: @error_email,
                      error_description: "Email dosn't exist in Google profile",
                      provider: args[:provider]
                    }}
                else
                  user = User.find_by(email: profile["email"])
                  pict = profile["picture"]
                  avatar = if is_nil(pict), do: Gravity.image(profile["email"]), else: pict
                  if is_nil(user) do
                    user_params =
                      %{
                        avatar:                            avatar,
                        email:                   profile["email"],
                        first_name:         profile["given_name"],
                        last_name:         profile["family_name"],
                        provider:                        "google"
                      }

                    case Accounts.create_user(user_params) do
                      {:ok, created} ->
                        with data <- generate_token(created) do
                          {:ok, %{
                              access_token: data,
                              provider: args[:provider],
                              user_id: created.id
                            }}
                        end
                      {:error, %Ecto.Changeset{}} ->
                        {:error, %Ecto.Changeset{}}
                    end
                  else
                    {:ok, %{
                        error: @error_email,
                        error_description: "An email has already been taken",
                        provider: args[:provider]
                      }}
                  end
                end
              end
            else
              {:ok, %{
                  error: @error_request,
                  error_description: @error_request_des,
                  provider: args[:provider]
                }}
            end
        end
      "linkedin" ->
        case OauthLinkedIn.token(args[:code], args[:redirect]) do
          {:error, data} ->
            %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
            {:ok, %{
                error: @error_code,
                error_description: msg,
                provider: args[:provider]
              }}
          {:ok, data} ->
            if is_nil(data["error"]) do
              with {:ok, info} <- OauthLinkedIn.user_email(data["access_token"]),
                   {:ok, profile} <- OauthLinkedIn.user_profile(data["access_token"]) do
                if is_nil(info["email"]) do
                  {:ok, %{
                      error: @error_email,
                      error_description: "Email dosn't exist in Linkedin profile",
                      provider: args[:provider]
                    }}
                else
                  user = User.find_by(email: info["email"])
                  pict = profile["avatar"]
                  avatar = if is_nil(pict), do: Gravity.image(info["email"]), else: pict
                  if is_nil(user) do
                    user_params =
                      %{
                        avatar:                            avatar,
                        email:                      info["email"],
                        first_name:         profile["first_name"],
                        last_name:           profile["last_name"],
                        provider:                 args[:provider]
                      }
                    case Accounts.create_user(user_params) do
                      {:ok, created} ->
                        with data <- generate_token(created) do
                          {:ok, %{
                              access_token: data,
                              provider: args[:provider],
                              user_id: created.id
                            }}
                        end
                      {:error, %Ecto.Changeset{}} ->
                        {:error, %Ecto.Changeset{}}
                    end
                  else
                    {:ok, %{
                        error: @error_email,
                        error_description: "Has already been taken",
                        provider: args[:provider]
                      }}
                  end
                end
              end
            else
              {:ok, %{
                  error: data["error"],
                  error_description: data["error_description"],
                  provider: args[:provider]
                }}
            end
        end
      "localhost" ->
        args
        |> Map.merge(%{avatar: Gravity.image(args[:email])})
        |> Accounts.create_user()
        |> case do
          {:ok, user} ->
            with data <- generate_token(user) do
              {:ok, %{
                  access_token: data,
                  provider: args[:provider],
                  user_id: user.id,
                }}
            end
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      "twitter" ->
        {:ok, %{
            error: @error_pro,
            error_description: @error_pro_des,
            provider: args[:provider]
          }}
      _ ->
        {:ok, %{
            error: @error_pro,
            error_description: @error_pro_des,
            provider: args[:provider]
          }}
    end
  end

  @spec signin(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def signin(_parent, args, _resolution) do
    case args[:provider] do
      nil ->
        {:ok, %{
            error: @error_pro,
            error_description: @error_pro_des,
            provider: args[:provider]
          }}
      "facebook" ->
        case OauthFacebook.token(args[:code], args[:redirect]) do
          {:error, data} ->
            %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
            {:ok, %{
                error: @error_code,
                error_description: msg,
                provider: args[:provider]
              }}
          {:ok, data} ->
            if is_nil(data["error"]) do
              {:ok, profile} = OauthFacebook.user_profile(data["access_token"])
              user = User.find_by(email: profile["email"])
              if is_nil(user) do
                {:ok, %{
                    error: @error_email,
                    error_description: @error_email_des,
                    provider: args[:provider]
                  }}
              else
                {:ok, verifed} = OauthFacebook.verify_token(data["access_token"])
                case verifed["expires_in"] > 0 do
                  true ->
                    with token <- generate_token(user) do
                      {:ok, %{
                          access_token: token,
                          provider: args[:provider],
                          user_id: user.id
                        }}
                    end
                  false ->
                    {:ok, %{
                        error: @error_request,
                        error_description: @error_request_des,
                        provider: args[:provider]
                      }}
                end
              end
            else
              if is_map(data["error"]) do
                {:ok, %{
                    error: "#{data["error"]["type"]}, #{data["error"]["code"]}",
                    error_description: data["error"]["message"],
                    provider: args[:provider]
                  }}
              else
                {:ok, %{
                    error: @error_code,
                    error_description: "code doesn't correct",
                    provider: args[:provider]
                  }}
              end
            end
        end
      "linkedin" ->
        case OauthLinkedIn.token(args[:code], args[:redirect]) do
          {:error, data} ->
            %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
            {:ok, %{
                error: @error_code,
                error_description: msg,
                provider: args[:provider]
              }}
          {:ok, data} ->
            if is_nil(data["error"]) do
              {:ok, info} = OauthLinkedIn.user_email(data["access_token"])
              user = User.find_by(email: info["email"])
              if is_nil(user) do
                {:ok, %{
                    error: info["error"],
                    error_description: info["error_description"],
                    provider: args[:provider]
                  }}
              else
                {:ok, verifed} = OauthLinkedIn.verify_token(data["access_token"])
                case verifed["email"] == user.email do
                  true ->
                    with token <- generate_token(user) do
                      {:ok, %{
                          access_token: token,
                          provider: args[:provider],
                          user_id: user.id
                        }}
                    end
                  false ->
                    {:ok, %{
                        error: verifed["error"],
                        error_description: verifed["error_description"],
                        provider: args[:provider]
                      }}
                end
              end
            else
              {:ok, %{
                  error: data["error"],
                  error_description: data["error_description"],
                  provider: args[:provider]
                }}
            end
        end
      "google" ->
        case OauthGoogle.token(args[:code], args[:redirect]) do
          {:error, data} ->
            %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
            {:ok, %{
                error: @error_code,
                error_description: msg,
                provider: args[:provider]
              }}
          {:ok, data} ->
            if is_nil(data["error"]) do
              {:ok, profile} = OauthGoogle.user_profile(data["access_token"])
              user = User.find_by(email: profile["email"])
              if is_nil(user) do
                {:ok, %{
                    error: @error_email,
                    error_description: @error_email_des,
                    provider: args[:provider]
                  }}
              else
                {:ok, verifed} = OauthGoogle.verify_token(data["access_token"])
                case verifed["access_type"] == "online" || verifed["email_verified"] == "true" do
                  true ->
                    with token <- generate_token(user) do
                      {:ok, %{
                          access_token: token,
                          provider: args[:provider],
                          user_id: user.id
                        }}
                    end
                  false ->
                    {:ok, %{
                        error: @error_request,
                        error_description: @error_request_des,
                        provider: args[:provider]
                      }}
                  _ ->
                    {:ok, %{
                        error: @error_request,
                        error_description: @error_request_des,
                        provider: args[:provider]
                      }}
                end
              end
            else
              {:ok, %{
                  error: @error_request,
                  error_description: @error_request_des,
                  provider: args[:provider]
                }}
            end
        end
      "localhost" ->
        case args[:email] do
          nil ->
            {:ok, %{
                error: @error_email,
                error_description: @error_email_des,
                provider: args[:provider]
              }}
          "" ->
            {:ok, %{
                error: @error_email,
                error_description: @error_email_des,
                provider: args[:provider]
              }}
          _ ->
            if is_bitstring(args[:email]) do
              case User.find_by(email: String.downcase(args[:email])) do
                nil ->
                  {:ok, %{
                      error: @error_email,
                      error_description: @error_email_des,
                      provider: args[:provider]
                    }}
                user ->
                  case Argon2.check_pass(user, args[:password]) do
                    {:error, data} ->
                      {:ok, %{
                          error: @error_password,
                          error_description: data,
                          provider: args[:provider]
                        }}
                    {:ok, user} ->
                      if {:ok, user} == Argon2.check_pass(user, args[:password_confirmation]) do
                        with token <- generate_token(user) do
                          {:ok, %{
                              access_token: token,
                              provider: args[:provider],
                              user_id: user.id
                            }}
                        end
                      else
                        {:ok, %{
                            error: @error_password,
                            error_description: "Your password is not correct!",
                            provider: args[:provider]
                          }}
                      end
                  end

              end
            else
              {:ok, %{
                  error: @error_email,
                  error_description: @error_email_des,
                  provider: args[:provider]
                }}
            end
        end
      "twitter" ->
        {:ok, %{
            error: @error_pro,
            error_description: @error_pro_des,
            provider: args[:provider]
          }}
      _ ->
        {:ok, %{
            error: @error_pro,
            error_description: @error_pro_des,
            provider: args[:provider]
          }}
    end
  end

  @spec required_keys([atom()], map()) :: boolean()
  defp required_keys(keys, args) do
    keys
    |> Enum.all?(&(Map.has_key?(args, &1)))
  end

  @spec error_des(String.t()) :: String.t()
  defp error_des(provider) do
    @error_des <> " " <>  provider
  end

  @spec generate_token(User.t()) :: tuple()
  defp generate_token(user) do
    with token <- Phoenix.Token.sign(@secret, @salt, user.id) do
      token
    end
  end

  @spec extract_error_msg(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end

  @doc """
  Traverses the changeset errors and returns a map of error messages.
  For example:

  %{start_date: ["can't be blank"], end_date: ["can't be blank"]}
  """
  def error_details(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  @spec execute_action([action: String.t()]) :: String.t()
  def execute_action([] \\ [action: "generate_secret"]), do: FlakeId.get

  @spec timestamp_one_day() :: {{integer, integer, integer}, {integer, integer, integer}}
  defp timestamp_one_day() do
    :calendar.universal_time()
    |> :calendar.datetime_to_gregorian_seconds()
    |> (fn now_in_seconds -> now_in_seconds - @email_age end).()
    |> :calendar.gregorian_seconds_to_datetime()
  end
end
