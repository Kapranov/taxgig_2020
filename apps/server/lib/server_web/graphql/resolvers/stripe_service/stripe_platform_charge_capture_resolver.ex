defmodule ServerWeb.GraphQL.Resolvers.StripeService.StripePlatformChargeCaptureResolver do
  @moduledoc """
  The StripeChargeCapture GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.User,
    Contracts.Project
  }

  alias Stripy.{
    Payments.StripeCharge,
    StripeService.StripePlatformChargeCaptureService
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

  @current_time DateTime.to_unix(DateTime.utc_now)
  @seconds  (2 * 3600)

  @spec update(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                 {:ok, struct} <- StripePlatformChargeCaptureService.create(charge.id_from_stripe, %{amount: charge.amount})
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

  @spec update_by_created(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_created(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                 project <- CoreRepo.get_by(Project, %{id: charge.description}),
                 {:ok, struct} <- captured(charge, project)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update_by_created(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_created(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

  @spec update_by_in_progress(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_in_progress(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                 project <- CoreRepo.get_by(Project, %{id: charge.description}),
                 {:ok, struct} <- captured(charge, project)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update_by_in_progress(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_in_progress(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

  @spec update_by_canceled(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_canceled(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                 {:ok, struct} <- captured_by_canceled(charge)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update_by_canceled(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_canceled(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

  @spec update_by_canceled_doc(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_canceled_doc(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                 project <- CoreRepo.get_by(Project, %{id: charge.description}),
                 {:ok, struct} <- captured_by_canceled_doc(charge, project)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update_by_canceled_doc(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_canceled_doc(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

  @spec update_by_in_transion(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_in_transion(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                 project <- CoreRepo.get_by(Project, %{id: charge.description}),
                 {:ok, struct} <- captured_by_in_transition(charge, project)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update_by_in_transition(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_in_transition(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

  @spec update_by_done(any, %{id_from_stripe: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def update_by_done(_root, %{id_from_stripe: id_from_stripe}, %{context: %{current_user: current_user}}) do
    if is_nil(id_from_stripe) do
      {:error, [[field: :id_from_stripe, message: "Can't be blank"]]}
    else
      try do
        case Accounts.by_role(current_user.id) do
          true -> {:error, :not_found}
          false ->
            with charge <- StripyRepo.get_by(StripeCharge, %{id_from_stripe: id_from_stripe}),
                 project <- CoreRepo.get_by(Project, %{id: charge.description}),
                 {:ok, struct} <- captured(charge, project)
            do
              {:ok, struct}
            else
              nil -> {:error, :not_found}
              failure -> failure
            end
        end
      rescue
        Ecto.NoResultsError ->
          {:error, "The StripeCharge #{id_from_stripe} not found!"}
      end
    end
  end

  @spec update_by_done(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update_by_done(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"], [field: :id_from_stripe, message: "Can't be blank"]]}
  end

  @spec captured(StripeCharge.t(), Project.t()) :: {:ok, StripeCharge.t()}
  defp captured(charge, project) do
    if (DateTime.to_unix(charge.updated_at) + @seconds) > @current_time or project.status == "In Progress" or project.status == "In Transition" do
      StripePlatformChargeCaptureService.create(charge.id_from_stripe, %{amount: amounted(charge)})
    else
      {:ok, charge}
    end
  end

  @spec captured_by_canceled(StripeCharge.t()) :: {:ok, StripeCharge.t()}
  defp captured_by_canceled(charge) do
    if (DateTime.to_unix(charge.updated_at) + @seconds) > @current_time do
      StripePlatformChargeCaptureService.create(charge.id_from_stripe, %{amount: 0})
    else
      {:ok, charge}
    end
  end

  @spec captured_by_canceled_doc(StripeCharge.t(), Project.t()) :: {:ok, StripeCharge.t()}
  defp captured_by_canceled_doc(charge, project) do
    if (DateTime.to_unix(charge.updated_at) + @seconds) > @current_time do
      StripePlatformChargeCaptureService.create(charge.id_from_stripe, %{amount: amounted_doc(project)})
    else
      {:ok, charge}
    end
  end

  @spec captured_by_in_transition(StripeCharge.t(), Project.t()) :: {:ok, StripeCharge.t()}
  defp captured_by_in_transition(charge, project) do
    if project.status == "In Transition" do
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

  @spec amounted_doc(StripeCharge.t()) :: integer
  defp amounted_doc(project) do
    offer_price =
      (Decimal.to_float(project.offer_price) * 100)
      |> Float.round(2)
      |> Float.ceil(0)
      |> Float.ratio
      |> elem(0)


    ((offer_price + project.addon_price) * 0.7)
    |> Float.round(0)
    |> Float.ceil(0)
    |> Float.ratio
    |> elem(0)
  end
end
