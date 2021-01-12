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

  @type t :: Project.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) || current_user.role == true do
      {:error, [[field: :current_user, message: "Permission denied for user current_user to perform action List"]]}
    else
      struct = Queries.by_list(Project, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      try do
        struct = Contracts.get_project!(id)
        {:ok, struct}
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
            # Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card}
            # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35}, when 2
            #                 hours pass since updated_at and update field captured with
            #                 stripe.charge.capture.amount
            args
            |> Map.merge(%{status: "In Progress"})
            |> Contracts.extention_project()
            |> case do
              {:ok, struct} ->
                {:ok, struct}
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
    if is_nil(id) || is_nil(current_user) || current_user.role == true do
      {:error, [[field: :id, message: "Can't be blank or Permission denied for current_user to perform action Update"]]}
    else
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
                  if !is_nil(params[:id_from_stripe_card]) and !is_nil(params[:offer_price]) and !is_nil(params[:assigned_id]) and params[:instant_matched] == true do
                    try do
                      Repo.get!(Project, id)
                      |> Contracts.update_project(
                        Map.delete(params, :user_id)
                        |> Map.delete(:addon_price)
                        |> Map.delete(:end_time)
                        |> Map.delete(:id_from_stripe_transfer)
                        |> Map.delete(:service_review_id)
                        |> Map.merge(%{addon_price: nil})
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
                  # Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card}
                  # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35}, when 2
                  #                 hours pass since updated_at and update field captured with
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
                  # 8.1
                  # If canceled by role=false
                  # Create action - Stripe.charge.capture {amount=o}, If less than 2 hours passed since
                  # updated_at, then
                  # Or
                  # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35}, when 2
                  # hours pass since updated_at and update field captured with
                  # stripe.charge.capture.amount
                  # Or
                  # Create action - Stripe.charge {amount=((vol1+vol3)-vol2) * 0.75} and perform
                  # stripe.charge.capture {amount=((vol1+vol3)-vol2) * 0.75}
                  # 8.2
                  # If canceled by role=true (Pro)
                  # Create action - Stripe.charge.capture {amount=o}, If less than 2 hours passed since
                  # updated_at, then
                  # Or
                  # Create action - Stripe.refund{amount=project.offer_price * 0.35}, when 2 hours
                  # passed since updated at
                  # Allow project.user_id to create service_review
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
                  # Create action - stripe.charge 2 {amount=(vol1+vol3)-vol2, source=project.id_from_stripe_card}
                  # Logic:
                  # vol1 = project.offer_price (status=“In Progress”)
                  # vol2 = vol1 * 0.35
                  # vol3 = project.addon_price = sum of all addons with addon_project.status="Accepted"
                  # and their relative fields addon_project.addon_id.addon_price
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
                  # 6.0
                  # if project.status="In Transition" has not changed in 48 hours since updated_at
                  # or if project.service_review_id is NOT nil,
                  # create action 1 - stripe.charge.capture{amount=(vol1+vol3)-vol2}
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
                  if !is_nil(params[:id_from_stripe_card]) and !is_nil(params[:offer_price]) do
                    try do
                      Repo.get!(Project, id)
                      |> Contracts.update_project(
                        Map.delete(params, :user_id)
                        |> Map.delete(:addon_price)
                        |> Map.delete(:book_keeping_id)
                        |> Map.delete(:business_tax_return_id)
                        |> Map.delete(:end_time)
                        |> Map.delete(:id_from_stripe_transfer)
                        |> Map.delete(:individual_tax_return_id)
                        |> Map.delete(:instant_matched)
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
                    # Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card}
                    # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35}, when 2
                    #                 hours pass since updated_at and update field captured with
                    #                 stripe.charge.capture.amount
                  else
                    {:error, "field's id_from_stripe_card must filled"}
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
