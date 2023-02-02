defmodule ServerWeb.GraphQL.Resolvers.Media.ProDocResolver do
  @moduledoc """
  The Pro Docs GraphQL resolvers.
  """

  alias Core.{
    Accounts.User,
    Contracts,
    Media,
    Media.ProDoc,
    Notifications,
    Notifications.Notify,
    Queries
  }

  @type t :: ProDoc.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:ok, %{error: String.t(), error_description: String.t()}} | {:ok, nil}
  @type result :: success_tuple | success_list | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    struct = Queries.by_list(ProDoc, :user_id, current_user.id)
    {:ok, struct}
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
    else
      struct = Media.get_pro_doc(id)
      {:ok, struct}
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create(any, %{category: String.t(), file: %{picture: %{file: %Plug.Upload{}}}, project_id: String.t(), signature: boolean, signed_by_pro: boolean}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, %{category: category, file: %{picture: %{file: %Plug.Upload{} = file}}, project_id:  project_id, signature: signature, signed_by_pro: signed_by_pro}, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      if category == "Final Document" do
        try do
          with project <- Contracts.get_project!(project_id),
               {:ok, %{content_type: content_type, name: name, size: size, url: url}} = Core.Upload.store(file),
               params <-
                 Map.new
                 |> Map.put(:content_type, content_type)
                 |> Map.put(:name, name)
                 |> Map.put(:size, size)
                 |> Map.put(:url, url),
               {:ok, pro_doc = %ProDoc{}} <- Media.create_pro_doc(%{
                 "category" => category,
                 "file" => params,
                 "project_id" => project.id,
                 "signature" => signature,
                 "signed_by_pro" => signed_by_pro,
                 "user_id" => current_user.id
               })
          do
            {:ok, notify} = Notifications.create_notify(%{
              is_hidden: false,
              is_read: false,
              project_id: project.id,
              template: 11,
              user_id: project.user_id
            })
            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
            case pro_doc.signature do
              true ->
                {:ok, notify} = Notifications.create_notify(%{
                  is_hidden: false,
                  is_read: false,
                  project_id: project.id,
                  template: 20,
                  user_id: project.user_id
                })
                notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
              _ -> :ok
            end
            Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
            {:ok, pro_doc}
          else
            nil ->
              {:ok, %{error: "project_id", error_description: "project_id is not owned by authenticated user"}}
            {:error, changeset} ->
              {:ok, %{error: "pro_docs schema", error_description: extract_error_msg(changeset)}}
          end
        rescue
          Ecto.NoResultsError ->
            {:ok, %{error: "project_id", error_description: "project for currentUser #{current_user.id} not found"}}
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

#  @spec update(any, %{id: bitstring(), file: %{picture: %{file: %Plug.Upload{}}}, pro_doc: map}, %{context: %{current_user: User.t()}}) :: result()
#  def update(_parent, %{id: id, file: %{picture: %{file: %Plug.Upload{} = file}}, pro_doc: params}, %{context: %{current_user: current_user}}) do
#    if current_user.role == false do
#      {:ok, nil}
#    else
#      try do
#        with struct <- Media.get_pro_doc(id),
#             {:ok, %{content_type: content_type, name: name, size: size, url: url}} <- Core.Upload.store(file),
#             args <-
#               %{file: %{content_type: content_type, name: name, size: size, url: url}}
#               |> Map.merge(params),
#             {:ok, pro_doc = %ProDoc{}} <- Media.update_pro_doc(struct, args)
#        do
#          {:ok, pro_doc}
#        else
#          nil ->
#            {:ok, %{error: "pro_doc", error_description: "id is not owned by authenticated user"}}
#          {:error, changeset} ->
#            {:ok, %{error: "pro_docs schema", error_description: extract_error_msg(changeset)}}
#        end
#      rescue
#        Ecto.NoResultsError ->
#          {:error, "The Tp Docs #{id} not found!"}
#      end
#    end
#  end

  @spec update(any, %{id: bitstring(), pro_doc: map}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, pro_doc: params}, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      try do
        with struct <- Media.get_pro_doc(id),
             {:ok, pro_doc = %ProDoc{}} <- Media.update_pro_doc(struct, params)
        do
          project = Contracts.get_project!(pro_doc.project_id)
          Absinthe.Subscription.publish(ServerWeb.Endpoint, project, project_show: project.id)
          {:ok, pro_doc}
        else
          nil ->
            {:ok, %{error: "pro_doc", error_description: "id is not owned by authenticated user"}}
          {:error, changeset} ->
            {:ok, %{error: "pro_docs schema", error_description: extract_error_msg(changeset)}}
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
    if current_user.role == false do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      try do
        case Media.get_pro_doc(id)do
          nil ->
            {:ok, %{error: "pro_doc", error_description: "the pro docs #{id} not found"}}
          struct ->
            Media.delete_pro_doc(struct)
            |> case do
              {:ok, struct} ->
                {:ok, %{id: struct.id}}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:ok, %{error: "pro_doc", error_description: "pro docs for currentUser #{current_user.id} not found"}}
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
end
