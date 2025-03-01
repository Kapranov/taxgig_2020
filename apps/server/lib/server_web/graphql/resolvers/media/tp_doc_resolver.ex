defmodule ServerWeb.GraphQL.Resolvers.Media.TpDocResolver do
  @moduledoc """
  The Tp Docs GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Media,
    Media.TpDoc,
    Notifications,
    Notifications.Notify,
    Queries,
    Repo
  }

  alias Mailings.Mailer

  @type t :: TpDoc.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Media.list_tp_doc()
      {:ok, struct |> Repo.preload([projects: [:users]])}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Media.get_tp_doc(id)
        {:ok, struct |> Repo.preload([projects: [:users]])}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Tp Docs #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{access_granted: boolean, category: String.t(), file: %{picture: %{file: %Plug.Upload{}}}, project_id: String.t(), signed_by_tp: boolean}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, %{access_granted: access_granted, category: category, file: %{picture: %{file: %Plug.Upload{} = file}}, project_id:  project_id, signed_by_tp: signed_by_tp}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      if category == "Files" do
        try do
          with project <- Contracts.get_project!(project_id),
               {:ok, %{content_type: content_type, name: name, size: size, url: url}} = Core.Upload.store(file),
               params <-
                 Map.new
                 |> Map.put(:content_type, content_type)
                 |> Map.put(:name, name)
                 |> Map.put(:size, size)
                 |> Map.put(:url, url),
               {:ok, tp_doc = %TpDoc{}} <- Media.create_tp_doc(%{
                 "access_granted" => access_granted,
                 "category" => category,
                 "file" => params,
                 "project_id" => project.id,
                 "signed_by_tp" => signed_by_tp
               })
          do
            if project.status == "In Progress" do
              {:ok, notify} = Notifications.create_notify(%{
                is_hidden: false,
                is_read: false,
                project_id: project.id,
                sender_id: current_user.id,
                template: 21,
                user_id: project.assigned_id
              })
              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
              mailing_to(notify.user_id, "uploaded_pro_doc", notify.project_id)
              Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
            else
              :ok
            end
            {:ok, tp_doc |> Repo.preload([projects: [:users]])}
          end
        rescue
          WithClauseError ->
            {:ok, %{error: "uploadTpDoc", error_description: "file format problem's not supported, large a size, content-type"}}
          MatchError ->
            {:ok, %{error: "uploadTpDoc", error_description: "something wrong with format"}}
          Ecto.NoResultsError ->
            {:ok, %{error: "uploadTpDoc", error_description: "Project for currentUser #{current_user.id} not found!"}}
        end
      else
        {:error, [[field: :category, message: "category #{category} incorrect"]]}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring(), tp_doc: map}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, tp_doc: params}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        with struct <- Media.get_tp_doc(id),
             {:ok, tp_doc = %TpDoc{}} <- Media.update_tp_doc(struct, params)
        do
          project = Contracts.get_project!(tp_doc.project_id)
          Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
          {:ok, tp_doc |> Repo.preload([projects: [:users]])}
        else
          nil ->
            {:error, "TpDoc is not owned by authenticated user"}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Tp Docs #{id} not found!"}
      end
    end
  end

  @spec update(any, %{id: bitstring(), file: %{picture: %{file: %Plug.Upload{}}}, tp_doc: map}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, file: %{picture: %{file: %Plug.Upload{} = file}}, tp_doc: params}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        with struct <- Media.get_tp_doc(id),
             {:ok, %{content_type: content_type, name: name, size: size, url: url}} <- Core.Upload.store(file),
             args <-
               %{file: %{content_type: content_type, name: name, size: size, url: url}}
               |> Map.merge(params),
             {:ok, tp_doc = %TpDoc{}} <- Media.update_tp_doc(struct, args)
        do
          project = Contracts.get_project!(tp_doc.project_id)
          Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
          {:ok, tp_doc |> Repo.preload([projects: [:users]])}
        else
          nil ->
            {:error, "TpDoc is not owned by authenticated user"}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Tp Docs #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :tp_doc, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        case Media.get_tp_doc(id)do
          nil ->
            {:error, "The Tp Docs #{id} not found!"}
          struct ->
            Media.delete_tp_doc(struct)
            |> case do
              {:ok, struct} ->
                {:ok, %{id: struct.id}}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Tp Docs #{id} not found!"}
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
