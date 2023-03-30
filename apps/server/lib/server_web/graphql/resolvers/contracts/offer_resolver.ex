defmodule ServerWeb.GraphQL.Resolvers.Contracts.OfferResolver do
  @moduledoc """
  The an Offer GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.Offer,
    Notifications,
    Notifications.Notify,
    Queries,
    Repo
  }

  alias Mailings.Mailer

  @type t :: Offer.t()
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
      struct = Queries.by_list(Offer, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Contracts.get_offer!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The an Offer #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
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
          if Enum.count(Repo.all(Queries.by_offer(Offer, :user_id, :project_id, :status, "Declined", args[:user_id], args[:project_id]))) == 0 do
            args
            |> Map.merge(%{status: "Sent"})
            |> Contracts.create_offer()
            |> case do
              {:ok, struct} ->
                {:ok, notify} = Notifications.create_notify(%{
                  is_hidden: false,
                  is_read: false,
                  project_id: struct.project_id,
                  sender_id: struct.user_id,
                  template: 4,
                  user_id: Repo.preload(struct, :projects).user_id
                })
                mailing_to(notify.user_id, "new_offer", notify.project_id)
                project = Contracts.get_project!(struct.project_id)
                notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          else
            {:error, [[field: :status, message: "You have some a record's of status is Sent."]]}
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, offer: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, offer: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case params[:user_id] == current_user.id do
        true  ->
          if Repo.get_by(Offer, %{id: id}).status == :Declined || Repo.get_by(Offer, %{id: id}).status == :Accepted do
            {:error, [[field: :status, message: "You have some a record's of status is Declined or Accepted."]]}
          else
            try do
              Repo.get!(Offer, id)
              |> Contracts.update_offer(Map.delete(params, :user_id))
              |> case do
                {:ok, struct} ->
                  case struct.status do
                    "Accepted" ->
                      {:ok, notify} = Notifications.create_notify(%{
                        is_hidden: false,
                        is_read: false,
                        project_id: struct.project_id,
                        template: 16,
                        user_id: struct.user_id
                      })
                      mailing_to(notify.user_id, "offer_accepted", notify.project_id)
                      project = Contracts.get_project!(struct.project_id)
                      notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                      Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                      Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
                      {:ok, struct}
                    "Declined" ->
                      {:ok, notify} = Notifications.create_notify(%{
                        is_hidden: false,
                        is_read: false,
                        project_id: struct.project_id,
                        template: 17,
                        user_id: struct.user_id
                      })
                      mailing_to(notify.user_id, "offer_declined", notify.project_id)
                      project = Contracts.get_project!(struct.project_id)
                      notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                      Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                      Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
                      {:ok, struct}
                    _ ->
                      {:ok, struct}
                  end
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
            rescue
              Ecto.NoResultsError ->
                {:error, "The an Offer #{id} not found!"}
            end
          end
        false -> {:error, "permission denied"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :offer, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Contracts.get_offer!(id)
            Repo.delete(struct)
          rescue
            Ecto.NoResultsError ->
              {:error, "The an Offer #{id} not found!"}
          end
        false -> {:error, "permission denied"}
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

  @spec mailing_to(String.t(), String.t(), String.t()) :: map
  defp mailing_to(user_id, template, project_id) do
    email_and_name = Accounts.by_email(user_id)
    Task.async(fn ->
      Mailer.send_by_notification(email_and_name.email, template, email_and_name.first_name, project_id)
    end)
  end
end
