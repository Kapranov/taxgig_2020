defmodule ServerWeb.GraphQL.Resolvers.Contracts.AddonResolver do
  @moduledoc """
  The an Addon GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.Addon,
    Notifications,
    Notifications.Notify,
    Queries,
    Repo
  }

  alias Mailings.Mailer

  @type t :: Addon.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Queries.by_list(Addon, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{project_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{project_id: project_id}, %{context: %{current_user: current_user}}) do
    if is_nil(project_id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :project_id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Queries.by_list(Addon, :project_id, project_id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The an Addon #{project_id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :project_id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      case Accounts.by_role(current_user.id) do
        false ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
        true ->
          if Enum.count(Repo.all(Queries.by_offer(Addon, :user_id, :project_id, :status, "Sent", args[:user_id], args[:project_id]))) > 0 do
            {:error, [[field: :status, message: "You have some a record's of status is Sent."]]}
          else
            args
            |> Contracts.create_addon()
            |> case do
              {:ok, struct} ->
                {:ok, notify} = Notifications.create_notify(%{
                  is_hidden: false,
                  is_read: false,
                  project_id: struct.project_id,
                  sender_id: struct.user_id,
                  template: 25,
                  user_id: Repo.preload(struct, :projects).user_id
                })
                mailing_to(notify.user_id, "add-ons_for_your_approval_client")
                notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                project = Contracts.get_project!(struct.project_id)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, addon: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, addon: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        struct = Repo.get!(Addon, id)
        struct
        |> Contracts.update_addon(Map.delete(params, :user_id))
        |> case do
          {:ok, struct} ->
            case struct.status do
              "Accepted" ->
                {:ok, notify} = Notifications.create_notify(%{
                  is_hidden: false,
                  is_read: false,
                  project_id: struct.project_id,
                  template: 26,
                  user_id: struct.user_id
                })
                mailing_to(notify.user_id, "client_accepted_addons_pro")
                notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
              "Declined" ->
                {:ok, notify} = Notifications.create_notify(%{
                  is_hidden: false,
                  is_read: false,
                  project_id: struct.project_id,
                  sender_id: struct.user_id,
                  template: 4,
                  user_id: struct.user_id
                })
                mailing_to(notify.user_id, "client_declined_addons_pro")
                notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
              _ -> :ok
            end
            project = Contracts.get_project!(struct.project_id)
            Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The an Addon #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :project_id, message: "Can't be blank"], [field: :addon, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Contracts.get_addon!(id)
            Repo.delete(struct)
          rescue
            Ecto.NoResultsError ->
              {:error, "The an Addon #{id} not found!"}
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :project_id, message: "Can't be blank"]]}
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
