defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeResolver do
  @moduledoc """
  The StripeCharge GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts.Project
  }

  alias Stripy.{
    Payments.StripeCharge,
    Payments.StripeCustomer,
    Queries,
    StripeService.StripePlatformChargeService
  }

  alias Core.Repo, as: CoreRepo
  alias Stripy.Repo, as: StripyRepo

  @type t :: StripeCharge.t()
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason} |
                       {:error, Ecto.Changeset.t} |
                       {:error, Stripe.Error.t()}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: success_list() | error_tuple()
  def list(_parent, _args, %{context: %{current_user: current_user}}) do
    if is_nil(current_user) do
      {:error, [[field: :user_id, message: "An User not found! or Unauthenticated"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}),
               {:ok, struct} <- StripePlatformChargeService.list(customer.id_from_stripe)
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
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
                } -> {:ok, %{error: "HTTP Status: #{http_status}, invalid request error. #{message}"}}
                {:error, %Ecto.Changeset{}} -> {:ok, %{error: "Customer token not found!"}}
              end
          end
      end
    end
  end

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  @spec show(any, %{description: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{description: id_from_project}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_project) || is_nil(current_user) do
      {:error, [[field: :id_from_project, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      case Queries.by_list(StripeCharge, :description, id_from_project) do
        [] -> {:ok, Map.new()}
        [struct] -> {:ok, struct}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end


  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:amount]) ||
       is_nil(args[:capture]) ||
       is_nil(args[:currency]) ||
       is_nil(args[:description]) ||
       is_nil(args[:id_from_card])
    do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}),
                {:ok, struct} <- StripePlatformChargeService.create(%{
                  amount: elem(Float.ratio(Decimal.to_float(args[:amount]) * 100), 0),
                  capture: args[:capture],
                  currency: args[:currency],
                  customer: customer.id_from_stripe,
                  source: args[:id_from_card],
                  description: args[:description],
                },
                %{"user_id" => current_user.id, "id_from_card" => args[:id_from_card]}
               )
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
      end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create_by_fee(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create_by_fee(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:amount]) ||
       is_nil(args[:capture]) ||
       is_nil(args[:currency]) ||
       is_nil(args[:description]) ||
       is_nil(args[:id_from_card])
    do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}),
                {:ok, struct} <- StripePlatformChargeService.create(%{
                  amount: args[:amount],
                  capture: args[:capture],
                  currency: args[:currency],
                  customer: customer.id_from_stripe,
                  source: args[:id_from_card],
                  description: args[:description],
                },
                %{"user_id" => current_user.id, "id_from_card" => args[:id_from_card]}
               )
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
      end
    end
  end

  @spec create_by_fee(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_by_fee(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create_by_in_transition(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create_by_in_transition(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:capture]) ||
       is_nil(args[:currency]) ||
       is_nil(args[:description]) ||
       is_nil(args[:id_from_card])
    do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}),
                project <- CoreRepo.get_by(Project, %{id: args[:description]}),
                {:ok, struct} <- StripePlatformChargeService.create(%{
                  amount: amounted(project),
                  capture: args[:capture],
                  currency: args[:currency],
                  customer: customer.id_from_stripe,
                  description: args[:description],
                  source: args[:id_from_card]
                },
                %{"user_id" => current_user.id, "id_from_card" => args[:id_from_card]}
               )
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
      end
    end
  end

  @spec create_by_in_transition(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_by_in_transition(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec create_by_canceled_doc(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create_by_canceled_doc(_parent, args, %{context: %{current_user: current_user}}) do
    if is_nil(args[:capture]) ||
       is_nil(args[:currency]) ||
       is_nil(args[:description]) ||
       is_nil(args[:id_from_card])
    do
      {:error, [[field: :stripe_charge, message: "Can't be blank"]]}
    else
      case Accounts.by_role(current_user.id) do
        true -> {:error, :not_found}
        false ->
          with customer <- StripyRepo.get_by(StripeCustomer, %{user_id: current_user.id}),
                project <- CoreRepo.get_by(Project, %{id: args[:description]}),
                {:ok, struct} <- StripePlatformChargeService.create(%{
                  amount: amounted_by_canceled_doc(project),
                  capture: args[:capture],
                  currency: args[:currency],
                  customer: customer.id_from_stripe,
                  description: args[:description],
                  source: args[:id_from_card]
                },
                %{"user_id" => current_user.id, "id_from_card" => args[:id_from_card]}
               )
          do
            {:ok, struct}
          else
            nil -> {:error, :not_found}
            failure -> failure
          end
      end
    end
  end

  @spec create_by_canceled_doc(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create_by_canceled_doc(_parent, _args, _info) do
    {:error, "Unauthenticated"}
  end

  @spec delete(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete(_parent, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case !is_nil(current_user) do
          true ->
            with {:ok, struct} <- StripePlatformChargeService.delete(id_from_stripe) do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
          false ->
            {:error, "permission denied"}
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec delete(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec amounted(Project.t()) :: integer
  defp amounted(project) do
    val1 =
      if is_nil(project.offer_price) do
        0
      else
        (Decimal.to_float(project.offer_price) * 100)
        |> Float.round(2)
        |> Float.ceil(0)
        |> Float.ratio
        |> elem(0)
      end

    val2 =
      (val1 * 0.35)
      |> Float.ratio
      |> elem(0)

    val3 = if is_nil(project.addon_price), do: 0, else: project.addon_price

    (val1 + val3) - val2
  end

  # amount = (((project.offer_price + project.addon_price) - (project.offer_price  0.35))  0.7)

  @spec amounted_by_canceled_doc(Project.t()) :: integer
  defp amounted_by_canceled_doc(project) do
    val1 =
      if is_nil(project.offer_price) do
        0
      else
        (Decimal.to_float(project.offer_price) * 100)
        |> Float.round(2)
        |> Float.ceil(0)
        |> Float.ratio
        |> elem(0)
      end

    val3 = if is_nil(project.addon_price), do: 0, else: project.addon_price

    (((val1 + val3) - (val1 * 0.35)) * 0.7)
    |> Float.round(0)
    |> Float.ceil(0)
    |> Float.ratio
    |> elem(0)
  end
end
