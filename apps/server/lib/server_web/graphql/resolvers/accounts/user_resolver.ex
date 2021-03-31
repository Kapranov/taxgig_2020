defmodule ServerWeb.GraphQL.Resolvers.Accounts.UserResolver do
  @moduledoc """
  The User GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts.Project,
    Queries,
    Repo
  }

  alias ServerWeb.Provider.{
    OauthFacebook,
    OauthGoogle,
    OauthLinkedIn
  }

  @type d :: DeletedUser.t()
  @type t :: User.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t} | {:ok, d}
  @type success_list :: {:ok, [t]} | {:ok, [d]}
  @type error_tuple :: {:error, reason}
  @type error_map :: {:ok, %{error: any, error_description: any, provider: any}}
  @type result :: success_tuple | error_tuple

  @salt Application.get_env(:server, ServerWeb.Endpoint)[:salt]
  @secret Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_base]

  @keys ~w(provider)a
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
            with val1 <- Queries.by_count_with_status_projects(Project, User, false, "Done", current_user),
                 [val2] <- Queries.by_count_with_status_projects(Project, User, false, "In Progress", "In Transition", current_user),
                 val3 <- Queries.by_count_with_offer_addon_projects(Project, User, false, "Done", current_user)
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
        case id == current_user.id do
          true ->
            struct = Accounts.get_user!(id)
            {:ok, struct}
          false ->
            {:error, "permission denied"}
        end
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
        {:error, extract_error_msg(changeset)}
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

  @spec update_password(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
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

  @spec delete(any, %{id: bitstring, reason: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{user_id: user_id, reason: reason}, %{context: %{current_user: current_user}}) do
    if is_nil(user_id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        case !is_nil(current_user) and user_id == current_user.id do
          true ->
            with struct <- Accounts.get_user!(user_id),
                 {:ok, _struct} <- Accounts.delete_user(struct),
                 {:ok, deleted} <- Accounts.create_deleted_user(%{
                   email:  struct.email,
                   reason:       reason,
                   role:    struct.role,
                   user_id:   struct.id
                 })
            do
              {:ok, deleted}
            else
              nil -> {:error, "permission denied"}
              _ -> {:error, %Ecto.Changeset{}}
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The an User #{user_id} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [
        [field: :user_id, message: "Can't be blank"],
        [field: :current_user,  message: "Unauthenticated"]
      ]
    }
  end

  @spec get_code(any, %{atom => any}, Absinthe.Resolution.t()) :: result() | error_map()
  def get_code(_parent, args, _resolution) do
    case required_keys(@keys, args) do
      true ->
        case args[:provider] do
          "facebook" ->
            case OauthFacebook.generate_url() do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider]), provider: args[:provider]}}
              code ->
                {:ok, %{code: code, provider: args[:provider]}}
            end
          "google" ->
            case OauthGoogle.generate_url() do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider]), provider: args[:provider]}}
              code ->
                {:ok, %{code: code, provider: args[:provider]}}
            end
          "linkedin" ->
            case OauthLinkedIn.generate_url() do
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
                case OauthFacebook.token(args[:code]) do
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
                case OauthGoogle.token(args[:code]) do
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
                case OauthLinkedIn.token(args[:code]) do
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
        case OauthFacebook.token(args[:code]) do
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
                  if is_nil(user) do
                    user_params =
                      %{
                        avatar: profile["picture"]["data"]["url"],
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
        case OauthGoogle.token(args[:code]) do
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
                  if is_nil(user) do
                    user_params =
                      %{
                        avatar:                profile["picture"],
                        email:                   profile["email"],
                        first_name:        profile["family_name"],
                        last_name:          profile["given_name"],
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
        case OauthLinkedIn.token(args[:code]) do
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
                  if is_nil(user) do
                    user_params =
                      %{
                        avatar:                 profile["avatar"],
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
        case OauthFacebook.token(args[:code]) do
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
        case OauthLinkedIn.token(args[:code]) do
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
        case OauthGoogle.token(args[:code]) do
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

  @spec execute_action([action: String.t()]) :: String.t()
  def execute_action([] \\ [action: "generate_secret"]), do: FlakeId.get
end
