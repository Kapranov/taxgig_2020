defmodule ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver do
  @moduledoc """
  The Project GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.Project,
    Notifications,
    Notifications.Notify,
    Queries,
    Repo
  }

  alias Mailings.Mailer
  alias Stripy.Repo, as: StripyRepo
  alias Stripy.{
    Payments.StripeCharge,
    StripeService.StripePlatformChargeCaptureService
  }

  @type t :: Project.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple
  @current_time :os.system_time(:seconds)
  @two_days  (2 * 24 * 3600)
  #@current_time DateTime.to_unix(DateTime.utc_now)
  @seconds  (2 * 3600)

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, %{filter: args}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      case args do
        %{status: status, page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list(Project, :user_id, current_user.id, :status, status)
              |> Repo.preload([:plaid_accounts, :tp_docs, :pro_docs])
              |> Enum.take(page)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          else
            struct =
              Queries.by_list(Project, :user_id, current_user.id, :status, status)
              |> Repo.preload([:plaid_accounts, :tp_docs, :pro_docs])
              |> Enum.take(counter)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          end
        %{page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list(Project, :user_id, current_user.id)
              |> Repo.preload([:plaid_accounts, :tp_docs, :pro_docs])
              |> Enum.take(page)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          else
            struct =
              Queries.by_list(Project, :user_id, current_user.id)
              |> Repo.preload([:plaid_accounts, :tp_docs, :pro_docs])
              |> Enum.take(counter)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          end
        _ -> {:ok, []}
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec list_for_admin(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list_for_admin(_parent, %{user_id: id, filter: args}, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      case args do
        %{status: status, page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list(Project, :user_id, id, :status, status)
              |> Enum.take(page)

            {:ok, struct}
          else
            struct =
              Queries.by_list(Project, :user_id, id, :status, status)
              |> Enum.take(counter)

            {:ok, struct}
          end
        %{page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list(Project, :user_id, id)
              |> Enum.take(page)

            {:ok, struct}
          else
            struct =
              Queries.by_list(Project, :user_id, id)
              |> Enum.take(counter)

            {:ok, struct}
          end
        _ -> {:ok, []}
      end
    else
      {:error, "Unauthenticated"}
    end
  end

  @spec list_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list_for_admin(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec pro_list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def pro_list(_parent, %{filter: args}, %{context: %{current_user: current_user}}) do
    if current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      case args do
        %{status: status, page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list(Project, :assigned_id, current_user.id, :status, status)
              |> Repo.preload([:tp_docs, :pro_docs])
              |> Enum.take(page)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          else
            struct =
              Queries.by_list(Project, :assigned_id, current_user.id, :status, status)
              |> Repo.preload([:tp_docs, :pro_docs])
              |> Enum.take(counter)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          end
        %{page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list(Project, :assigned_id, current_user.id)
              |> Repo.preload([:tp_docs, :pro_docs])
              |> Enum.take(page)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          else
            struct =
              Queries.by_list(Project, :assigned_id, current_user.id)
              |> Repo.preload([:tp_docs, :pro_docs])
              |> Enum.take(counter)

            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
            {:ok, struct}
          end
        _ -> {:ok, []}
      end
    end
  end

  @spec pro_list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def pro_list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec pro_list_for_admin(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def pro_list_for_admin(_parent, %{user_id: user_id, filter: args}, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      case args do
        %{status: status, page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list(User, Project, :assigned_id, user_id, :status, status, true)
              |> Enum.take(page)

            {:ok, struct}
          else
            struct =
              Queries.by_list(User, Project, :assigned_id, user_id, :status, status, true)
              |> Enum.take(counter)

            {:ok, struct}
          end
        %{page: page, limit_counter: counter} ->
          if page < counter do
            struct =
              Queries.by_list_admin(User, Project, :assigned_id, user_id, true)
              |> Enum.take(page)

            {:ok, struct}
          else
            struct =
              Queries.by_list_admin(User, Project, :assigned_id, user_id, true)
              |> Enum.take(counter)

            {:ok, struct}
          end
        _ -> {:ok, []}
      end
    else
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    end
  end

  @spec pro_list_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def pro_list_for_admin(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: _current_user}}) do
    try do
      struct = Contracts.get_project!(id)
      Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
      {:ok, struct}
    rescue
      Ecto.NoResultsError ->
        {:error, "The Project #{id} not found!"}
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for current_user to perform action Create"]]}
    else
      case Accounts.by_role(current_user.id) do
        false ->
          if args[:instant_matched] == false do
            params =
              args
              |> Map.delete(:assigned_id)

            params
            |> Map.merge(%{status: "New"})
            |> Contracts.create_project()
            |> case do
              {:ok, struct} ->
                {:ok, struct}
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          else
            # ACTION - ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver.list/3
            # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver.create/3
            # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver.update_by_created/3
            #
            # Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card, description: ""}
            # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35},
            #                 take project.updated_at + 7200 = xxx if xxx and status == "In Progres" > now, do: stripe_captur, else: :nothing
            #                 and do stripe_capture hours pass since updated_at and status="In Progress" and update field captured with
            #                 stripe.charge.capture.amount
            args
            |> Map.merge(%{status: "In Progress"})
            |> Contracts.extention_project()
            |> case do
              {:ok, struct} ->
                if is_nil(struct.assigned_id) do
                  if is_nil(struct.mailers) do
                    {:ok, struct}
                  else
                    Task.Supervisor.async_nolink(Server.TaskSupervisor, fn ->
                      Process.sleep(60000)
                      Mailings.Mailer.send_total_match(struct.mailers)
                    end)
                    {:ok, struct}
                  end
                else
                  {:ok, Map.delete(struct, :mailers)}
                end
              {:error, changeset} ->
                {:error, extract_error_msg(changeset)}
            end
          end
        true ->
          {:error, [[field: :user_id, message: "Can't be blank or Permission denied for current_user"]]}
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec update(any, %{id: bitstring, project: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update(_parent, %{id: id, project: params}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
      case Accounts.by_role(current_user.id) do
        true ->
          case Map.has_key?(params, :status) and params[:status] == "Canceled" do
            true ->
              case Repo.get_by(Project, %{id: id}).status do
                :"In Progress" ->
                  case params[:status] do
                    "Canceled" ->
                      try do
                        struct = Repo.get!(Project, id)
                        if struct.assigned_id == current_user.id do
                          struct
                          |> Contracts.update_project(
                            Map.delete(params, :user_id)
                            |> Map.delete(:addon_price)
                            |> Map.delete(:assigned_id)
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:end_time)
                            |> Map.delete(:id_from_stripe_card)
                            |> Map.delete(:id_from_stripe_transfer)
                            |> Map.delete(:individual_tax_return_id)
                            |> Map.delete(:instant_matched)
                            |> Map.delete(:mailers)
                            |> Map.delete(:offer_price)
                            |> Map.delete(:room_id)
                            |> Map.delete(:sale_tax_id)
                            |> Map.delete(:service_review_id)
                            |> Map.delete(:user_id)
                          )
                          |> case do
                            {:ok, struct} ->
                              {:ok, notify} = Notifications.create_notify(%{
                                is_hidden: false,
                                is_read: false,
                                project_id: struct.id,
                                template: 7,
                                user_id: struct.assigned_id
                              })
                              mailing_to(notify.user_id, "canceled_project_by_client", notify.project_id)
                              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                              {:ok, struct}
                            {:error, changeset} ->
                              {:error, extract_error_msg(changeset)}
                          end
                        else
                          {:error, "permission denied"}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    _ -> {:error, "permission denied"}
                  end
                _ ->
                  try do
                    Repo.get!(Project, id)
                    |> Contracts.update_project(
                      Map.delete(params, :user_id)
                      |> Map.delete(:addon_price)
                      |> Map.delete(:assigned_id)
                      |> Map.delete(:book_keeping_id)
                      |> Map.delete(:business_tax_return_id)
                      |> Map.delete(:end_time)
                      |> Map.delete(:id_from_stripe_card)
                      |> Map.delete(:id_from_stripe_transfer)
                      |> Map.delete(:individual_tax_return_id)
                      |> Map.delete(:instant_matched)
                      |> Map.delete(:offer_price)
                      |> Map.delete(:sale_tax_id)
                      |> Map.delete(:service_review_id)
                      |> Map.merge(%{by_pro_status: true})
                    )
                    |> case do
                      {:ok, struct} ->
                        Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                        {:ok, struct}
                      {:error, changeset} ->
                        {:error, extract_error_msg(changeset)}
                    end
                  rescue
                    Ecto.NoResultsError ->
                      {:error, "The Project #{id} not found!"}
                  end
              end
            false ->
              try do
                Repo.get!(Project, id)
                |> Contracts.update_project(%{})
                |> case do
                  {:ok, struct} ->
                    Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                    {:ok, struct}
                  {:error, changeset} ->
                    {:error, extract_error_msg(changeset)}
                end
              rescue
                Ecto.NoResultsError ->
                  {:error, "The Project #{id} not found!"}
              end
          end
        false ->
          case params[:user_id] == current_user.id do
            true  ->
              case Repo.get_by(Project, %{id: id}).status do
                :"Canceled" ->
                  case params[:status] do
                    "Canceled" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                          |> Map.delete(:status)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "Done" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "In Progress" ->
                      if !is_nil(params[:id_from_stripe_card]) and is_nil(params[:offer_price]) and is_nil(params[:assigned_id]) and params[:instant_matched] == true do
                        try do
                          Repo.get!(Project, id)
                          |> Contracts.update_extention_project(
                            Map.delete(params, :user_id)
                            |> Map.delete(:addon_price)
                            |> Map.delete(:end_time)
                            |> Map.delete(:id_from_stripe_transfer)
                            |> Map.delete(:service_review_id)
                            |> Map.merge(%{addon_price: nil, by_pro_status: false})
                          )
                          |> case do
                            {:ok, struct} ->
                              {:ok, notify} = Notifications.create_notify(%{
                                is_hidden: false,
                                is_read: false,
                                project_id: struct.id,
                                template: 5,
                                user_id: struct.user_id
                              })
                              mailing_to(notify.user_id, "canceled_project_by_client")
                              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                              {:ok, struct}
                            {:error, changeset} ->
                              {:error, extract_error_msg(changeset)}
                          end
                        rescue
                          Ecto.NoResultsError ->
                            {:error, "The Project #{id} not found!"}
                        end
                      else
                        {:error, "There are field's :id_from_stripe_card, :offer_price, :assigned_id, :instant_matched can't blank"}
                      end
                      # ACTION - ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver.list/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver.create/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver.update_by_in_progress/3
                      #
                      # Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card, description: ""}
                      # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35},
                      #                 take project.updated_at + 7200 = xxx if xxx and status == "In Progres" > now, do: stripe_captur, else: :nothing
                      #                 and do stripe_capture hours pass since updated_at and status="In Progress" and update field captured with
                      #                 stripe.charge.capture.amount
                    "In Transition" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "New" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:service_review_id)
                          |> Map.merge(%{assigned_id: nil, offer_price: nil, instant_matched: false, addon_price: nil, by_pro_status: false})
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                  end
                :"Done" ->
                  case params[:status] do
                    "Canceled" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "Done" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "In Progress" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "In Transition" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "New" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                  end
                :"In Progress" ->
                  case params[:status] do
                    "Canceled" ->
                      try do
                        struct = Repo.get!(Project, id)
                        if struct.by_pro_status == false do
                          struct
                          |> Contracts.update_project(
                            Map.delete(params, :user_id)
                            |> Map.delete(:addon_price)
                            |> Map.delete(:assigned_id)
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:end_time)
                            |> Map.delete(:id_from_stripe_card)
                            |> Map.delete(:id_from_stripe_transfer)
                            |> Map.delete(:individual_tax_return_id)
                            |> Map.delete(:instant_matched)
                            |> Map.delete(:offer_price)
                            |> Map.delete(:sale_tax_id)
                            |> Map.delete(:service_review_id)
                          )
                          |> case do
                            {:ok, struct} ->
                              {:ok, notify} = Notifications.create_notify(%{
                                is_hidden: false,
                                is_read: false,
                                project_id: struct.id,
                                template: 7,
                                user_id: struct.assigned_id
                              })
                              mailing_to(notify.user_id, "canceled_project_by_client", notify.project_id)
                              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                              {:ok, struct}
                            {:error, changeset} ->
                              {:error, extract_error_msg(changeset)}
                          end
                        else
                          struct
                          |> Contracts.update_project(
                            Map.delete(params, :user_id)
                            |> Map.delete(:addon_price)
                            |> Map.delete(:assigned_id)
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:end_time)
                            |> Map.delete(:id_from_stripe_card)
                            |> Map.delete(:id_from_stripe_transfer)
                            |> Map.delete(:individual_tax_return_id)
                            |> Map.delete(:instant_matched)
                            |> Map.delete(:offer_price)
                            |> Map.delete(:sale_tax_id)
                          )
                          |> case do
                            {:ok, struct} ->
                              {:ok, notify} = Notifications.create_notify(%{
                                is_hidden: false,
                                is_read: false,
                                project_id: struct.id,
                                template: 6,
                                user_id: struct.user_id
                              })
                              mailing_to(notify.user_id, "canceled_project_by_pro", notify.project_id)
                              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                              {:ok, struct}
                            {:error, changeset} ->
                              {:error, extract_error_msg(changeset)}
                          end
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                      # ACTION - ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver.pro_list/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver.show/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.Media.ProDocResolver.list/3
                      # ACTION - ProDocs category: "Final Document" for struct.by_pro_status == false,
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver.update_by_canceled_with_doc/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformRefundResolver.create_by_canceled/3
                      #
                      # 8.1
                      # If canceled by role=false
                      # create action list_charge(description: id_from_project)
                      # Create action - Stripe.charge.capture {amount=0, id_from_stripe: ch_}, If less than 2 hours passed since
                      # charge.updated_at, insert into amount=0 and ProDocs.category == "Final Document" and if absent
                      # 8.2
                      # If canceled by role=true (Pro)
                      # create allProProject(assign_id: for_role_true)
                      # create updateProject(status:)
                      # create action list_charge(description: id_from_project)
                      # Create action - Stripe.charge.capture {amount=0}, If less than 2 hours passed since
                      # charge.updated_at
                      # Or
                      # create updateProject(status:, by_pro_status: boolean)
                      # Allow project.user_id to create service_review
                      # If Stripe.charge(captured: true)
                      # Create action - Stripe.refund{amount=project.offer_price * 0.35})
                    "Done" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "In Progress" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "In Transition" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            {:ok, notify} = Notifications.create_notify(%{
                              is_hidden: false,
                              is_read: false,
                              project_id: struct.id,
                              template: 8,
                              user_id: struct.user_id
                            })
                            mailing_to(notify.user_id, "project_in_transition", notify.project_id)
                            notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                      # ACTION - ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver.list/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver.create_by_in_transition/3
                      #
                      # Create action - stripe.charge 2 {amount=(vol1+vol3)-vol2, source=project.id_from_stripe_card}
                      # Logic:
                      # (
                      #   (Decimal.to_float(project.offer_price) * 100
                      #   |> Float.round(2)
                      #   |> Float.ceil(0)
                      #   |> Float.ratio
                      #   |> elem(0))
                      # + project.addon_price) - ((Decimal.to_float(project.offer_price) * 100 |> Float.round(2) |> Float.ceil(0) |> Float.ratio |> elem(0)) * 0.35) |> Float.ratio |> elem(0)
                      #
                      # vol1 = project.offer_price (status=“In Progress”)
                      # vol2 = vol1 * 0.35
                      # if is_nil(project.addon_price), do: 0, else: project.addon_price
                      # vol3 = project.addon_price = sum of all addons with addon_project.status="Accepted"
                      # and their relative fields addon_project.addon_id.addon_price
                      # (project.offer_price + (project.addon_price))-(project.offer_price * 0.35)
                      #
                      # ((Decimal.to_float(project.offer_price) * 100 |> Float.round(2) |> Float.ceil(0) |> Float.ratio |> elem(0)) + 0) - ((Decimal.to_float(project.offer_price) * 100 |> Float.round(2) |> Float.ceil(0) |> Float.ratio |> elem(0)) * 0.35) |> Float.ratio |> elem(0)
                    "New" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                  end
                :"In Transition" ->
                  case params[:status] do
                    "Canceled" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "Done" ->
                      try do
                        project = Repo.get!(Project, id)
                        if (DateTime.to_unix(project.updated_at) + @two_days) > @current_time do
                          project
                          |> Contracts.update_project(
                            Map.delete(params, :user_id)
                            |> Map.delete(:addon_price)
                            |> Map.delete(:assigned_id)
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:end_time)
                            |> Map.delete(:id_from_stripe_card)
                            |> Map.delete(:id_from_stripe_transfer)
                            |> Map.delete(:individual_tax_return_id)
                            |> Map.delete(:instant_matched)
                            |> Map.delete(:offer_price)
                            |> Map.delete(:sale_tax_id)
                          )
                          |> case do
                            {:ok, struct} ->
                              {:ok, notify} = Notifications.create_notify(%{
                                is_hidden: false,
                                is_read: false,
                                project_id: struct.id,
                                template: 10,
                                user_id: struct.user_id
                              })
                              mailing_to(notify.user_id, "project_done_automatically", notify.project_id)
                              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                              {:ok, struct}
                            {:error, changeset} ->
                              {:error, extract_error_msg(changeset)}
                          end
                        else
                          project
                          |> Contracts.update_project(
                            Map.delete(params, :user_id)
                            |> Map.delete(:addon_price)
                            |> Map.delete(:assigned_id)
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:end_time)
                            |> Map.delete(:id_from_stripe_card)
                            |> Map.delete(:id_from_stripe_transfer)
                            |> Map.delete(:individual_tax_return_id)
                            |> Map.delete(:instant_matched)
                            |> Map.delete(:offer_price)
                            |> Map.delete(:sale_tax_id)
                            |> Map.delete(:service_review_id)
                          )
                          |> case do
                            {:ok, struct} ->
                              {:ok, notify} = Notifications.create_notify(%{
                                is_hidden: false,
                                is_read: false,
                                project_id: struct.id,
                                template: 9,
                                user_id: struct.assigned_id
                              })
                              mailing_to(notify.user_id, "project_done", notify.project_id)
                              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                              {:ok, struct}
                            {:error, changeset} ->
                              {:error, extract_error_msg(changeset)}
                          end
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                      # ACTION - ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver.list/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver.show/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver.update_by_done/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformAccountTokenResolver.create/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformTransferResolver.create/3
                      #
                      # Allow update project.status to "Done",
                      # if action 1 successful, create action 2 - stripe.transfer {amount=(vol1+vol3) * 0.8,
                      # destination=project.assigned_pro.stripe_account.id_from_stripe= “acc_xxx”} and
                      # save result to project.id_from_stripe
                    "In Progress" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "In Transition" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "New" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                  end
                :"New" ->
                  case params[:status] do
                    "Canceled" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "Done" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "In Progress" ->
                      if !is_nil(params[:id_from_stripe_card]) and !is_nil(params[:offer_price]) and is_nil(params[:instant_matched]) do
                        try do
                          Repo.get!(Project, id)
                          |> Contracts.update_project(
                            Map.delete(params, :user_id)
                            |> Map.delete(:addon_price)
                            |> Map.delete(:end_time)
                            |> Map.delete(:id_from_stripe_transfer)
                            |> Map.delete(:instant_matched)
                            |> Map.delete(:service_review_id)
                          )
                          |> case do
                            {:ok, struct} ->
                              {:ok, notify} = Notifications.create_notify(%{
                                is_hidden: false,
                                is_read: false,
                                project_id: struct.id,
                                template: 5,
                                user_id: struct.user_id
                              })
                              mailing_to(notify.user_id, "project_in_progress", notify.project_id)
                              notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                              Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                              Task.async(fn -> create_captured(struct, params) end)
                              {:ok, struct}
                            {:error, changeset} ->
                              {:error, extract_error_msg(changeset)}
                          end
                        rescue
                          Ecto.NoResultsError ->
                            {:error, "The Project #{id} not found!"}
                        end
                      else
                        if !is_nil(params[:id_from_stripe_card]) and is_nil(params[:offer_price]) and params[:instant_matched] == true do
                          try do
                            Repo.get!(Project, id)
                            |> Contracts.update_extention_project(
                              Map.delete(params, :user_id)
                              |> Map.delete(:addon_price)
                              |> Map.delete(:end_time)
                              |> Map.delete(:id_from_stripe_transfer)
                              |> Map.delete(:service_review_id)
                            )
                            |> case do
                              {:ok, struct} ->
                                {:ok, notify} = Notifications.create_notify(%{
                                  is_hidden: false,
                                  is_read: false,
                                  project_id: struct.id,
                                  template: 5,
                                  user_id: struct.user_id
                                })
                                mailing_to(notify.user_id, "project_in_progress")
                                notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                                Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                                Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                                {:ok, struct}
                              {:error, changeset} ->
                                {:error, extract_error_msg(changeset)}
                            end
                          rescue
                            Ecto.NoResultsError ->
                              {:error, "The Project #{id} not found!"}
                          end
                        else
                          if !is_nil(params[:id_from_stripe_card]) and !is_nil(params[:offer_price]) do
                            try do
                              Repo.get!(Project, id)
                              |> Contracts.update_project(
                                Map.delete(params, :user_id)
                                |> Map.delete(:addon_price)
                                |> Map.delete(:end_time)
                                |> Map.delete(:id_from_stripe_transfer)
                                |> Map.delete(:instant_matched)
                                |> Map.delete(:service_review_id)
                              )
                              |> case do
                                {:ok, struct} ->
                                  {:ok, notify} = Notifications.create_notify(%{
                                    is_hidden: false,
                                    is_read: false,
                                    project_id: struct.id,
                                    template: 5,
                                    user_id: struct.user_id
                                  })
                                  mailing_to(notify.user_id, "project_in_progress")
                                  notifies = Queries.by_list(Notify, :user_id, notify.user_id)
                                  Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
                                  Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                                  {:ok, struct}
                                {:error, changeset} ->
                                  {:error, extract_error_msg(changeset)}
                              end
                            rescue
                              Ecto.NoResultsError ->
                                {:error, "The Project #{id} not found!"}
                            end
                          else
                            {:error, "field's id_from_stripe_card must filled"}
                          end
                        end
                      end
                      # ACTION - ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver.list/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver.create/3
                      # ACTION - ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver.update_by_in_progress/3
                      #
                      # Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card, description: ""}
                      # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35},
                      #                 take project.updated_at + 7200 = xxx if xxx and status == "In Progres" > now, do: stripe_captur, else: :nothing
                      #                 and do stripe_capture hours pass since updated_at and status="In Progress" and update field captured with
                      #                 stripe.charge.capture.amount
                    "In Transition" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_card)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:status)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                    "New" ->
                      try do
                        Repo.get!(Project, id)
                        |> Contracts.update_project(
                          Map.delete(params, :user_id)
                          |> Map.delete(:addon_price)
                          |> Map.delete(:assigned_id)
                          |> Map.delete(:book_keeping_id)
                          |> Map.delete(:business_tax_return_id)
                          |> Map.delete(:end_time)
                          |> Map.delete(:id_from_stripe_transfer)
                          |> Map.delete(:individual_tax_return_id)
                          |> Map.delete(:instant_matched)
                          |> Map.delete(:offer_price)
                          |> Map.delete(:sale_tax_id)
                          |> Map.delete(:service_review_id)
                          |> Map.delete(:status)
                        )
                        |> case do
                          {:ok, struct} ->
                            Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                  end
              end
            false -> {:error, "permission denied"}
          end
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :project, message: "Can't be blank"]]}
  end

  @spec update_for_admin(any, %{id: bitstring, project: map()}, %{context: %{current_user: User.t()}}) :: result()
  def update_for_admin(_parent, %{id: id, project: params}, %{context: %{current_user: current_user}}) do
    if current_user.admin do
      try do
        Repo.get!(Project, id)
        |> Contracts.update_project(params)
        |> case do
          {:ok, struct} ->
            {:ok, struct}
          {:error, changeset} ->
            {:error, extract_error_msg(changeset)}
          end
      rescue
        Ecto.NoResultsError ->
          {:error, "The Project #{id} not found!"}
      end
    else
      {:error, "permission denied for current user"}
    end
  end

  @spec update_for_admin(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_for_admin(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :project, message: "Can't be blank"]]}
  end

  @spec delete(any, %{id: bitstring, user_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id: id, user_id: user_id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Delete"]]}
    else
      case user_id == current_user.id do
        true  ->
          try do
            struct = Contracts.get_project!(id)
            Repo.delete(struct)
          rescue
            Ecto.NoResultsError ->
              {:error, "The Project #{id} not found!"}
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

  @spec mailing_to(String.t(), String.t()) :: map
  defp mailing_to(user_id, template) do
    email_and_name = Accounts.by_email(user_id)
    Task.async(fn ->
      #:timer.sleep(5_000)
      Mailer.send_by_notification(email_and_name.email, template, email_and_name.first_name)
      Process.sleep 75_000
    end)
    |> Task.await(:infinity)
  end

  @spec mailing_to(String.t(), String.t(), String.t()) :: map
  defp mailing_to(user_id, template, project_id) do
    email_and_name = Accounts.by_email(user_id)
    Task.async(fn ->
      #:timer.sleep(5_000)
      Mailer.send_by_notification(email_and_name.email, template, email_and_name.first_name, project_id)
      Process.sleep 75_000
    end)
    |> Task.await(:infinity)
  end

  @spec create_captured(Project.t(), map) :: :ok | :error
  defp create_captured(struct, params) do
    with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: params["id_from_stripe_charge"]}),
         {:ok, _struct} <- captured(charge, struct)
    do
      :ok
    else
      nil -> :error
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
            #{:ok, notify} = Notifications.create_notify(%{
            #  is_hidden: false,
            #  is_read: false,
            #  project_id: struct.id,
            #  template: 5,
            #  user_id: struct.user_id
            #})
            # notifies = Queries.by_list(Notify, :user_id, notify.user_id)
            # Absinthe.Subscription.publish(ServerWeb.Endpoint, notifies, notify_list: "notifies")
            {:ok, %{error: "HTTP Status: #{http_status}, charge capture invalid, invalid request error. #{message}"}}
          {:error, %Ecto.Changeset{}} -> :error
        end
    end
  end

  @spec captured(StripeCharge.t(), Project.t()) :: {:ok, StripeCharge.t()}
  defp captured(charge, project) do
    if (DateTime.to_unix(charge.updated_at) + @seconds) > @current_time or project.status == "In Progress" or project.status == "In Transition" do
      StripePlatformChargeCaptureService.create(charge.id_from_stripe, %{amount: amounted(charge)})
    else
      {:ok, charge}
    end
  end

  @spec amounted(StripeCharge.t()) :: integer
  defp amounted(charge) do
    (charge.amount * 0.35)
    |> Float.round(2)
    |> Float.ceil(0)
    |> Float.ratio
    |> elem(0)
  end
end
