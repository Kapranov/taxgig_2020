defmodule ServerWeb.GraphQL.Resolvers.Accounts.PlatformResolver do
  @moduledoc """
  The Platform GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Platform,
    Accounts.User,
    Notifications,
    Notifications.Notify,
    Queries,
    Repo,
    Talk,
    Talk.Room
  }

  alias Mailings.Mailer

  @type t :: Platform.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      # struct = Accounts.list_platform()
      # {:ok, struct}
      struct = Queries.by_list(Platform, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Accounts.get_platform!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Platform #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      params =
        if is_nil(args[:stuck_stage]) do
          Map.put(args, :is_stuck, false)
        else
          Map.put(args, :is_stuck, true)
        end

      attrs = Map.merge(args, params)

      case Accounts.by_role(current_user.id) do
        false ->
          attrs
          |> Map.delete(:hero_active)
          |> Map.delete(:hero_status)
          |> Accounts.create_platform()
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
          end
        true ->
          attrs
          |> Accounts.create_platform()
          |> case do
            {:ok, struct} ->
              {:ok, struct}
            {:error, changeset} ->
              {:error, extract_error_msg(changeset)}
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, platform: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, platform: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          is_stuck_stage =
            if is_nil(params[:stuck_stage]) do
              Map.put(params, :is_stuck, false)
            else
              Map.put(params, :is_stuck, true)
            end

          attrs =
            params
            |> Map.merge(is_stuck_stage)
            |> Map.delete(:user_id)

          rooms = Queries.by_list(Room, :user_id, params[:user_id])

          try do
            struct = Repo.get!(Platform, id)
            case Accounts.by_role(current_user.id) do
              true ->
                if params[:payment_active] ==  true do
                  if struct.hero_status == true and struct.client_limit_reach == false and params[:hero_active] == true do
                    struct
                    |> Accounts.update_platform(attrs)
                    |> case do
                      {:ok, updated} ->
                        Enum.reduce(rooms, [], fn(x, acc) ->
                          [{:ok, _} = Talk.update_room(x, %{active: true}) | acc]
                        end)
                        case updated.is_banned do
                          true ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 13,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_banned_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                          false ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 15,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_restored_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        end
                        {:ok, updated}
                      {:error, changeset} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  else
                    struct
                    |> Accounts.update_platform(Map.put(attrs, :hero_active, false))
                    |> case do
                      {:ok, updated} ->
                        Enum.reduce(rooms, [], fn(x, acc) ->
                          [{:ok, _} = Talk.update_room(x, %{active: true}) | acc]
                        end)
                        case updated.is_banned do
                          true ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 13,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_banned_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                          false ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 15,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_restored_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        end
                        case updated.hero_status do
                          true -> :ok
                          false ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 18,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "hero_status_lost")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        end
                        {:ok, updated}
                      {:error, changeset} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  end
                else
                  if struct.hero_status == true and struct.client_limit_reach == false and params[:hero_active] == true do
                    struct
                    |> Accounts.update_platform(attrs)
                    |> case do
                      {:ok, updated} ->
                        Enum.reduce(rooms, [], fn(x, acc) ->
                          [{:ok, _} = Talk.update_room(x, %{active: false}) | acc]
                        end)
                        case updated.is_banned do
                          true ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 13,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_banned_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                          false ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 15,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_restored_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        end
                        {:ok, updated}
                      {:error, changeset} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  else
                    struct
                    |> Accounts.update_platform(Map.put(attrs, :hero_active, false))
                    |> case do
                      {:ok, updated} ->
                        Enum.reduce(rooms, [], fn(x, acc) ->
                          [{:ok, _} = Talk.update_room(x, %{active: false}) | acc]
                        end)
                        case updated.is_banned do
                          true ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 13,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_banned_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                          false ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 15,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "user_restored_pro")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        end
                        case updated.hero_status do
                          true -> :ok
                          false ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              template: 18,
                              user_id: updated.user_id
                            })
                            mailing_to(notify.user_id, "hero_status_lost")
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        end
                        {:ok, updated}
                      {:error, changeset} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  end
                end
              false ->
                deleted =
                  attrs
                  |> Map.delete(:hero_active)
                  |> Map.delete(:hero_status)

                if params[:payment_active] ==  true do
                  struct
                  |> Accounts.update_platform(deleted)
                  |> case do
                    {:ok, updated} ->
                      Enum.reduce(rooms, [], fn(x, acc) ->
                        [{:ok, _} = Talk.update_room(x, %{active: true}) | acc]
                      end)
                      case updated.is_banned do
                        true ->
                          {:ok, notify} = Notifications.create_notify(%{
                            is_hidden: false,
                            is_read: false,
                            template: 12,
                            user_id: updated.user_id
                          })
                          notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        false ->
                          {:ok, notify} = Notifications.create_notify(%{
                            is_hidden: false,
                            is_read: false,
                            template: 14,
                            user_id: updated.user_id
                          })
                          mailing_to(notify.user_id, "user_restored_client")
                          notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                      end
                      {:ok, updated}
                    {:error, changeset} ->
                      {:error, extract_error_msg(changeset)}
                  end
                else
                  struct
                  |> Accounts.update_platform(deleted)
                  |> case do
                    {:ok, updated} ->
                      Enum.reduce(rooms, [], fn(x, acc) ->
                        [{:ok, _} = Talk.update_room(x, %{active: false}) | acc]
                      end)
                      case updated.is_banned do
                        true ->
                          {:ok, notify} = Notifications.create_notify(%{
                            is_hidden: false,
                            is_read: false,
                            template: 12,
                            user_id: updated.user_id
                          })
                          notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                        false ->
                          {:ok, notify} = Notifications.create_notify(%{
                            is_hidden: false,
                            is_read: false,
                            template: 14,
                            user_id: updated.user_id
                          })
                          notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                          Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                      end
                      {:ok, updated}
                    {:error, changeset} ->
                      {:error, extract_error_msg(changeset)}
                  end
                end
            end
          rescue
            Ecto.NoResultsError ->
              {:error, "The Platform #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :platform, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        struct = Accounts.get_platform!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:error, "The Platform #{id} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
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

  @spec mailing_to(String.t(), String.t()) :: map
  defp mailing_to(user_id, template) do
    email_and_name = Accounts.by_email(user_id)
    Task.async(fn ->
      Mailer.send_by_notification(email_and_name.email, template, email_and_name.first_name)
    end)
  end
end
