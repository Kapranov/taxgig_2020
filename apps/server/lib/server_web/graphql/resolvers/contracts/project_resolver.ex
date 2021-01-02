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
          if Accounts.by_role(args[:assigned_id]) == true do
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
              args
              |> Map.merge(%{status: "In Progress"})
              |> Contracts.create_project()
              |> case do
                {:ok, struct} ->
                  {:ok, struct}
                {:error, changeset} ->
                  {:error, extract_error_msg(changeset)}
              end
              # user = Repo.get_by(User, email: "o.puryshev@gmail.com")
              #
              # book_keeping = Repo.get_by(Core.Services.BookKeeping, user_id: user.id)
              # business_tax_return = Repo.get_by(Core.Services.BusinessTaxReturn, user_id: user.id)
              # individual_tax_return = Repo.get_by(Core.Services.IndividualTaxReturn, user_id: user.id)
              # sale_tax = Repo.get_by(Core.Services.SaleTax, user_id: user.id)
              #
              # data = Core.Analyzes.total_match(book_keeping.id) |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
              # data = Core.Analyzes.total_match(business_tax_return.id) |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
              # data = Core.Analyzes.total_match(individual_tax_return.id) |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
              # data = Core.Analyzes.total_match(sale_tax.id) |> Enum.to_list() |> Enum.sort(fn({_, value1}, {_, value2}) -> value2 < value1 end)
              #
              # ttt = data |> List.first |> elem(0)
              #
              # defmodule Recursion do
              #   def double([h|t]) do
              #     ttt = Core.Queries.by_match(Core.Services.IndividualTaxReturn, Core.Accounts.Platform, :id, :user_id, ttt) |> elem(1) == false
              #     if ttt == false, do: [h|double(t)], else: h
              #     [Core.Queries.by_match(Core.Services.IndividualTaxReturn, Core.Accounts.Platform, :id, :user_id, elem(h, 0)) |double(t)]
              #     [id = elem(h, 0)|double(t)]
              #     ttt = Core.Queries.by_match(Core.Services.IndividualTaxReturn, Core.Accounts.Platform, :id, :user_id, id)
              #   end
              #   def double([]), do: []
              # end
              #
              # defmodule Recursion do
              #   def double(list), do: map(list, &(Core.Queries.by_match(Core.Services.IndividualTaxReturn, Core.Accounts.Platform, :id, :user_id, elem(&1, 0))))
              #   def map([h|t], fun), do: [fun.(h)|map(t, fun)] |> List.delete(nil)
              #   def map([], _fun), do: []
              #
              #   def tta(list), do: do_tta(list)
              #
              #   defp do_tta([head | tail]) do
              #     if Core.Queries.by_match(Core.Services.IndividualTaxReturn, Core.Accounts.Platform, :id, :user_id, elem(head, 0)) |> elem(1) == true do
              #       head
              #     else
              #       do_tta(tail)
              #     end
              #   end
              #
              #   defp do_tta([_head | tail]), do: do_tta(tail)
              #   defp do_tta([]), do: []
              # end
              #
              # Settings.mfa_methods()
              # |> Enum.reduce([], fn m, acc ->
              #   if method_enabled?(m, settings) do
              #     acc ++ [m]
              #   else
              #     acc
              #   end
              # end) |> Enum.join(",")
              #
              # defmodule Recursion do
              #   def tta(list), do: do_tta(list)
              #   defp do_tta([head | tail]) do
              #     try do
              #       if Core.Queries.by_match(Core.Services.IndividualTaxReturn, Core.Accounts.Platform, :id, :user_id, elem(head, 0)) |> elem(1) == true do
              #         head
              #       else
              #         do_tta(tail)
              #       end
              #     rescue
              #       ArgumentError -> do_tta(tail)
              #     end
              #   end
              #   defp do_tta([]), do: []
              # end
              #
              # defmodule Recursion do
              #   def double(list), do: map(list, &(Core.Queries.by_match(Core.Services.IndividualTaxReturn, Core.Accounts.Platform, :id, :user_id, elem(&1, 0))))
              #   def map([h|t], fun), do: [fun.(h)|map(t, fun)] |> List.delete(nil)
              #   def map([], _fun), do: []
              # end
              # |> Enum.map(fn x -> if elem(x,1) == true, do: [elem(x, 0)], else: [] end) |> List.flatten |> List.first
              #
              #
              # [offer_price] = Core.Analyzes.total_value(book_keeping.id) |> Map.values
              # [offer_price] = Core.Analyzes.total_value(business_tax_return.id) |> Map.values
              # [offer_price] = Core.Analyzes.total_value(individual_tax_return.id) |> Map.values
              # [offer_price] = Core.Analyzes.total_value(sale_tax.id) |> Map.values
              # Map.merge(%{}, %{offer_price: offer_price})
              #
              # Core.Queries.by_hero_status(Core.Accounts.User, Core.Accounts.Platform, true, :role, :id, :user_id, :hero_status, :email)
              #
              # 1. check out service's book_keeping
              #    [head | tail] = Core.Analyzes.total_all(book_keeping.id)
              #    Core.Analyzes.total_match(book_keeping.id)
              #    tail |> Enum.map(&(&1 |> Map.take([:sum_match])))
              #
              #    Core.Analyzes.total_all(book_keeping.id)
              # 2. take id max row in total list by
              #    %{id: "A2ex7xgtEA5BbGfmj2", sum_match: 60},
              # 3. ttt = Repo.get_by(Core.Services.BookKeeping, %{id: "A2ex7xgtEA5BbGfmj2"}).user_id
              # 4.
              #   if Repo.get_by(Core.Accounts.Platform, %{user_id: ttt}).hero_active == true do
              #     Map.merge(args, %{:assigned_id: ttt})
              #   else
              #     # take  %{id: "A2ex7xczSexnPAqfeC", sum_match: 20}, and do same do it in the end.
              #     # when will be end
              #     # take any user with role true and platform.hero_status == true
              #     # all users send message
              #     # Core.Queries.by_hero_status(Core.Accounts.User, Core.Accounts.Platform, true, :role, :id, :user_id, :hero_status, :email)
              #   end
              # 5.
              #    [value] = head |> Map.get(:sum_value) |> Map.values
              #    [value] = Core.Analyzes.total_value(book_keeping.id) |> Map.values
              #    Map.merge(args, %{offer_price: value})
              #
              # Create action - stripe.charge {amount=project.offer_price, source=project.id_from_stripe_card}
              # Create action - Stripe.charge.capture {amount=project.offer_price * 0.35}, when 2
              #                 hours pass since updated_at and update field captured with
              #                 stripe.charge.capture.amount
            end
          else
            {:error, [[field: :assigned_id, message: "Permission denied for client's role"]]}
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
