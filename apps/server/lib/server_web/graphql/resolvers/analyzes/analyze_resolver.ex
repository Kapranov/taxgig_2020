defmodule ServerWeb.GraphQL.Resolvers.Analyzes.AnalyzeResolver do
  @moduledoc """
  An analyze GraphQL resolvers.
  """

  alias Core.{Accounts.User, Analyzes}

  @type t :: map
  @type reason :: any
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec show(any, %{service_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show(_parent, %{page: num, service_id: id}, %{context: %{current_user: current_user}}) do
    if is_nil(id) || is_nil(current_user) do
      {:error, [[field: :service_id, message: "Can't be blank or Permission denied for current_user to perform action Show"]]}
    else
      case Analyzes.total_all(id, num) do
        {:error, [field: :user_id, message: "UserId Not Found in SaleTax"]} ->
          {:error, "The ServiceId #{id} not found!"}
        data ->
          {:ok, data}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :current_user,  message: "Unauthenticated"], [field: :id, message: "Can't be blank"]]}
  end

  @spec max_price(any, %{customer_id: bitstring, service_id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def max_price(_parent, %{service_id: id, customer_id: customer_id}, %{context: %{current_user: _current_user}}) do
    case Analyzes.total_max_price(id, customer_id) do
      {:error, _} ->
        {:error, "The ServiceId #{id} or CustomerId #{customer_id} not found!"}
      data ->
        {:ok, data}
    end
  end
end
