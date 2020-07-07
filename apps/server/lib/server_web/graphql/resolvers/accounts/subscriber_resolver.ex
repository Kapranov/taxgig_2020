defmodule ServerWeb.GraphQL.Resolvers.Accounts.SubscriberResolver do
  @moduledoc """
  The Subscriber GraphQL resolvers.
  """

  alias Core.{
    Accounts,
    Accounts.Subscriber,
    Repo
  }

  alias Mailings.Mailer

  @type t :: Subscriber.t()
  @type reason :: any
  @type ok :: {:ok}
  @type success_tuple :: {:ok, t}
  @type success_list :: {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list(any, %{atom => any}, Absinthe.Resolution.t()) :: success_list()
  def list(_parent, _args, _info) do
    struct = Accounts.list_subscriber()
    {:ok, struct}
  end

  @spec show(any, %{id: bitstring}, Absinthe.Resolution.t()) :: result()
  def show(_parent, %{id: id}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        struct = Accounts.get_subscriber!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:error, "The Subscriber #{id} not found!"}
      end
    end
  end

  @spec show(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show(_parent, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"]]}
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: result()
  def create(_parent, args, _info) do
    if is_nil(args[:email]) || is_nil(args[:pro_role]) do
      {:error, [[field: :email, message: "email and pro_role can't be blank"]]}
    else
      with {:ok, struct} <- Accounts.create_subscriber(args) do
        :ok = Task.await(mailgun(args.email, args.pro_role), 3000)
        {:ok, struct}
      else
        :error ->
          {:error, [[field: :pro_role, message: "Check that an email address or role has been entered"]]}
        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    end
  end

  @spec update(any, %{id: bitstring, subscriber: map()}, Absinthe.Resolution.t()) :: result()
  def update(_root, %{id: id, subscriber: params}, _info) do
    if is_nil(id) do
      {:error, [[field: :id, message: "Can't be blank"]]}
    else
      try do
        Repo.get!(Subscriber, id)
        |> Subscriber.changeset(params)
        |> Repo.update
      rescue
        Ecto.NoResultsError ->
          {:error, "The Subscriber #{id} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def update(_root, _args, _info) do
    {:error, [[field: :id, message: "Can't be blank"], [field: :subscriber, message: "Can't be blank"]]}
  end

  @spec delete(any, %{email: bitstring}, Absinthe.Resolution.t()) :: result()
  def delete(_parent, %{email: email}, _info) do
    if is_nil(email) do
      {:error, [[field: :email, message: "Can't be blank"]]}
    else
      try do
        struct = Subscriber.find_by(email: email)
        Repo.delete(struct)
      rescue
        _ ->
          {:error, "The Subscriber #{email} not found!"}
      end
    end
  end

  @spec update(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete(_root, _args, _info) do
    {:error, [[field: :email, message: "can't be blank"]]}
  end

  @spec mailgun(bitstring, boolean()) :: ok() | error_tuple()
  defp mailgun(email, role) when is_bitstring(email) and is_boolean(role) do
    case role do
      true ->
        Task.async(fn ->
          Mailer.send_pro_html(email)
        end)
      false ->
        Task.async(fn ->
          Mailer.send_tp_html(email)
        end)
    end
  end

  @spec mailgun(any, any) :: error_tuple()
  defp mailgun(_, _) do
    Task.async(fn ->
      try do
        raise "Oops"
      catch _, _ ->
        :error
      end
    end)
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
