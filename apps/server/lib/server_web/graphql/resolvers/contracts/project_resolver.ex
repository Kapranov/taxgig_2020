defmodule ServerWeb.GraphQL.Resolvers.Contracts.ProjectResolver do
  @moduledoc """
  The Project GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts,
    Contracts.Project,
    Queries,
    Repo
  }

  alias Reptin.Client

  @type t :: Project.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple
  @current_time :os.system_time(:seconds)
  @seconds  (2 * 24 * 3600)

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct =
        Queries.by_list(Project, :user_id, current_user.id)
        |> Repo.preload([:plaid_accounts, :tp_docs, :pro_docs])
      Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_list: "projects")
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec pro_list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def pro_list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == false do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct =
        Queries.by_list(Project, :assigned_id, current_user.id)
        |> Repo.preload([:tp_docs, :pro_docs])
      {:ok, struct}
    end
  end

  @spec pro_list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def pro_list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      try do
        struct = Contracts.get_project!(id)
        Absinthe.Subscription.publish(ServerWeb.Endpoint, struct, project_show: id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Project #{id} not found!"}
      end
    else
      try do
        struct = Contracts.get_project!(id)
        reptin = Client.search(struct.users.bus_addr_zip, struct.users.first_name, struct.users.last_name) |> List.first
        data = Map.merge(struct.users, %{profession: reptin.profession})
        record = Map.merge(struct, %{users: data})
        Absinthe.Subscription.publish(ServerWeb.Endpoint, record, project_show: id)
        {:ok, record}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Project #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == true do
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
          case Map.has_key?(params, :status) and params[:status] == "In Progress" do
            true ->
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
                    {:ok, struct}
                  {:error, changeset} ->
                    {:error, extract_error_msg(changeset)}
                end
              rescue
                Ecto.NoResultsError ->
                  {:error, "The Project #{id} not found!"}
              end
            false ->
              try do
                Repo.get!(Project, id)
                |> Contracts.update_project(%{})
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
          end
        false ->
          case params[:user_id] == current_user.id do
            true  ->
              case Repo.get_by(Project, %{id: id}).status do
                :Canceled ->
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
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                  end
                :Done ->
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
                        if (DateTime.to_unix(project.updated_at) + @seconds) > @current_time do
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
                            {:ok, struct}
                          {:error, changeset} ->
                            {:error, extract_error_msg(changeset)}
                        end
                      rescue
                        Ecto.NoResultsError ->
                          {:error, "The Project #{id} not found!"}
                      end
                  end
                :New ->
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
end
