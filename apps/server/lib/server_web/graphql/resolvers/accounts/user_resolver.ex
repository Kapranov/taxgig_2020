defmodule ServerWeb.GraphQL.Resolvers.Accounts.UserResolver do
  @moduledoc """
  The User GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Repo
  }

  alias ServerWeb.Provider.{
    OauthGoogle,
    OauthLinkedIn
  }

  @type t :: User.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
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

  @spec list(map(), map(), map()) :: success_list | error_tuple
  def list(_parent, _args, _info) do
    struct = Accounts.list_user()
    {:ok, struct}
  end

  @spec show(map(), %{id: bitstring}, map()) :: result
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
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

  @spec create(map(), map(), map()) :: result
  def create(_parent, args, _info) do
    args
    |> Accounts.create_user()
    |> case do
      {:ok, struct} ->
        {:ok, struct}
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  @spec update(map(), %{id: bitstring, user: map()}, map()) :: result
  def update(_root, %{id: id, user: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(User, id)
        |> User.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  @spec delete(map(), %{id: bitstring}, map()) :: result
  def delete(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_user!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "An User #{id} not found!"}
      end
    end
  end

  def get_code(_parent, args, _resolution) do
    case required_keys(@keys, args) do
      true ->
        case args[:provider] do
          "facebook" ->
            {:ok, %{code: :ok}}
          "google" ->
            case OauthGoogle.generate_url() do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider])}}
              code ->
                {:ok, %{code: code}}
            end
          "linkedin" ->
            case OauthLinkedIn.generate_url() do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider])}}
              code ->
                {:ok, %{code: code}}
            end
          "twitter" ->
            {:ok, %{code: :ok}}
          _ ->
            {:ok, %{error: @error_pro, error_description: @error_pro_des}}
        end
      false ->
        {:ok, %{error: @error_pro, error_description: @error_pro_des}}
    end
  end

  def get_token(_parent, args, _resolution) do
    case required_keys(@keys, args) do
      true ->
        case args[:code] do
          nil ->
            if(args[:provider] == "localhost" && is_bitstring(args[:email])) do
              case User.find_by(email: String.downcase(args[:email])) do
                nil ->
                  {:ok, %{error: @error_email, error_description: @error_email_des}}
                user ->
                  case Argon2.check_pass(user, args[:password]) do
                    {:error, _} ->
                      {:ok, %{error: @error_password, error_description: @error_password_des}}
                    {:ok, user} ->
                      with data <- generate_token(user) do
                        {:ok, %{access_token: data, provider: args[:provider]}}
                      end
                  end
              end
            else
              if(args[:provider] == "facebook" || args[:provider] == "twitter") do
                {:ok, %{access_token: :ok}}
              else
                {:ok, %{error: @error_pro, error_description: @error_pro_des}}
              end
            end
          _ ->
            case args[:provider] do
              "google" ->
                case OauthGoogle.token(args[:code]) do
                  {:error, data} ->
                    %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
                    {:ok, %{error: @error_code, error_description: msg}}
                  {:ok, data} ->
                    {:ok,
                      %{
                        access_token:           data["access_token"],
                        error:                         data["error"],
                        error_description: data["error_description"],
                        expires_in:               data["expires_in"],
                        id_token:                   data["id_token"],
                        provider:                           "google",
                        refresh_token:         data["refresh_token"],
                        scope:                         data["scope"],
                        token_type:               data["token_type"]
                      }
                    }
                end
              "linkedin" ->
                case OauthLinkedIn.token(args[:code]) do
                  nil ->
                    {:ok, %{error: @error_email, error_description: @error_email_des}}
                  {:ok, data} ->
                    {:ok,
                      %{
                        access_token:           data["access_token"],
                        error:                         data["error"],
                        error_description: data["error_description"],
                        expires_in:               data["expires_in"],
                        provider:                         "linkedin"
                      }
                    }
                end
              _ ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des}}
            end
        end
      false ->
        {:ok, %{error: @error_pro, error_description: @error_pro_des}}
    end
  end

  def get_refresh_token_code(_parent, args, _resolution) do
    case required_keys(@keys, args) do
      true ->
        case args[:provider] do
          "facebook" ->
            {:ok, %{code: :ok}}
          "google" ->
            case OauthGoogle.generate_refresh_token_url() do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider])}}
              code ->
                {:ok, %{code: code}}
            end
          "linkedin" ->
            case OauthLinkedIn.generate_refresh_token_url(args[:token]) do
              nil ->
                {:ok, %{error: @error_code, error_description: error_des(args[:provider])}}
              code ->
                {:ok, %{code: code}}
            end
          "twitter" -> {:ok, %{code: :ok}}
          _ ->
            {:ok, %{error: @error_pro, error_description: @error_pro_des}}
        end
      false ->
        {:ok, %{error: @error_pro, error_description: @error_pro_des}}
    end
  end

  def get_refresh_token(_parent, args, _resolution) do
    if required_keys(@keys, args) do
      if (args[:provider] == "google" || args[:provider] == "linkedin") do
        case args[:provider] do
          nil ->
            {:ok, %{error: @error_token, error_description: @error_token_des}}
          "google" ->
            case OauthGoogle.refresh_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des}}
              {:error, data} ->
                %{field: _, message: msg} = for {n, m} <- data, into: %{}, do: {n, m}
                {:ok, %{error: @error_token, error_description: msg}}
              {:ok, data} ->
                {:ok,
                  %{
                    access_token:           data["access_token"],
                    error:                         data["error"],
                    error_description: data["error_description"],
                    expires_in:               data["expires_in"],
                    id_token:                   data["id_token"],
                    provider:                           "google",
                    refresh_token:         data["refresh_token"],
                    scope:                         data["scope"],
                    token_type:               data["token_type"]
                  }
                }
            end
          "linkedin" ->
            case OauthLinkedIn.refresh_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_token, error_description: error_des(args[:provider])}}
              {:ok, %{"error" => msg1, "error_description" => msg2}} ->
                {:ok, %{error: msg1, error_description: msg2}}
              {:ok, code} -> {:ok, code}
            end
        end
      else
        if (args[:provider] == "facebook" || args[:provider] == "twitter") do
          {:ok, %{access_token: :ok}}
        else
          {:ok, %{error: @error_pro, error_description: @error_pro_des}}
        end
      end
    else
      {:ok, %{error: @error_pro, error_description: @error_pro_des}}
    end
  end

  def verify_token(_parent, args, _resolution) do
    if required_keys(@keys, args) do
      if (args[:provider] == "google" || args[:provider] == "linkedin") do
        case args[:provider] do
          "google" ->
            case OauthGoogle.verify_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des}}
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
                {:ok, %{error: @error_token, error_description: msg}}
            end
          "linkedin" ->
            case OauthLinkedIn.verify_token(args[:token]) do
              nil ->
                {:ok, %{error: @error_pro, error_description: @error_pro_des}}
              data ->
                {:ok, %{email: data, provider: args[:provider]}}
            end
        end
      else
        if (args[:provider] == "facebook" || args[:provider] == "twitter") do
          {:ok, %{access_token: :ok}}
        else
          {:ok, %{error: @error_pro, error_description: @error_pro_des}}
        end
      end
    else
      {:ok, %{error: @error_pro, error_description: @error_pro_des}}
    end
  end

  def signin(_parent, _args, _resolution) do
  end

  def signup(_parent, _args, _resolution) do
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

  @spec generate_token(User.t) :: tuple()
  defp generate_token(user) do
    with token <- Phoenix.Token.sign(@secret, @salt, user.id) do
      token
    end
  end

  @spec extract_error_msg(%Ecto.Changeset{}) :: %Ecto.Changeset{}
  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
