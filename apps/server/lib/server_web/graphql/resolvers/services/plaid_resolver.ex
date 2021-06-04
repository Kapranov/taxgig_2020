defmodule ServerWeb.GraphQL.Resolvers.Services.PlaidResolver do
  @moduledoc """
  The Plaid GraphQL resolvers.
  """

  alias Core.Accounts.User
  alias Core.Queries
  alias Core.Plaid.PlaidAccount
  alias Core.Plaid.PlaidTransaction
  alias Core.PlaidService.PlaidPlatformAccountService
  alias Core.PlaidService.PlaidPlatformTransactionService
  alias Core.Repo

  alias Core.Plaid, as: CorePlaid

  @type a :: PlaidAccount.t()
  @type t :: PlaidTransaction.t()
  @type reason :: any
  @type success_tuple :: {:ok, a} | {:ok, t}
  @type success_list :: {:ok, [a]} | {:ok, [t]}
  @type error_tuple :: {:error, reason}
  @type result :: success_tuple | error_tuple

  @spec list_account(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list_account(_parent, _args, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
    else
      struct = Queries.by_list(PlaidAccount, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list_account(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list_account(_parent, _args, _resolutions) do
    {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
  end

  @spec list_transaction(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def list_transaction(_parent, _args, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
    else
      struct = Queries.by_list(PlaidTransaction, :user_id, current_user.id)
      {:ok, struct}
    end
  end

  @spec list_transaction(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple
  def list_transaction(_parent, _args, _resolutions) do
    {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
  end

  @spec show_account(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show_account(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
   if current_user.role == true do
      {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
    else
      try do
        struct = CorePlaid.get_plaid_account!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:ok, %{error: "plaid account", error_description: "plaid account #{id} not found!"}}
      end
    end
  end

  @spec show_account(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show_account(_parent, _args, _info) do
    {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
  end

  @spec show_transaction(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def show_transaction(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
    else
      try do
        struct = CorePlaid.get_plaid_transaction!(id)
        {:ok, struct}
      rescue
        Ecto.NoResultsError ->
          {:ok, %{error: "plaid transaction", error_description: "plaid transaction #{id} not found!"}}
      end
    end
  end

  @spec show_transaction(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def show_transaction(_parent, _args, _info) do
    {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
  end

  @spec create(any, %{atom => any}, %{context: %{current_user: User.t()}}) :: result()
  def create(_parent, args, %{context: %{current_user: current_user}}) do
    case current_user.role do
      true ->
        {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
     false ->
        link_token_params = %{
          client_name: "Taxgig",
          country_codes: ["US"],
          products: ["transactions"],
          language: "en",
          webhook: "https://taxgig.com/",
          account_filters: %{
            depository: %{
              account_subtypes: ["checking"]
            }
          },
          user: %{
            client_user_id: current_user.id
          }
        }

        {:ok, _link_token} = Plaid.Link.create_link_token(link_token_params)

        Process.sleep(100)

        public_token_params = %{
        initial_products: ["transactions"],
        institution_id: "ins_3",
        options: %{webhook: "https://www.taxgig.com"},
        public_key: "b30a98d754948d92aee5adfe058cf3"
        }

        {:ok, public_token} = Plaid.Item.create_public_token(public_token_params)

        Process.sleep(100)

        exchange_public_token_params = %{public_token: public_token["public_token"]}

        {:ok, exchange_public_token} = Plaid.Item.exchange_public_token(exchange_public_token_params)

        Process.sleep(100)

        transactions_params = %{
          access_token: exchange_public_token["access_token"],
          start_date: args.start_date,
          end_date: args.end_date,
          options: %{
            count: args.count,
            offset: args.offset
          }
        }

        {:ok, data} = Plaid.Transactions.get(transactions_params)

        Process.sleep(100)

        with :ok <- File.write("/tmp/demo.json", Jason.encode!(data), [:binary]),
             {:ok, struct} <- PlaidPlatformAccountService.create(data, %{projects: args.projects, user_id: current_user.id}),
             Process.sleep(100),
             {:ok, :ok} <- PlaidPlatformTransactionService.create(data)
        do
          {:ok, struct}
        else
          nil -> {:ok, %{error: "400", error_description: "none records"}}
          :enoent -> {:ok, %{error: "typical error reasons", error_description: "a component of the file name does not exist"}}
          :enotdir -> {:ok, %{error: "typical error reasons", error_description: "a component of the file name does not exist"}}
          :enospc -> {:ok, %{error: "typical error reasons", error_description: "a component of the file name does not exist"}}
          :eacces -> {:ok, %{error: "typical error reasons", error_description: "missing permission for writing the file or searching one of the parent directories"}}
          :eisdir -> {:ok, %{error: "typical error reasons", error_description: ""}}
          [] -> {:ok, %{error: "none records", error_description: "plaid transactions are empty"}}
          {:error, %Ecto.Changeset{}} -> {:ok, %{error: "changeset", error_description: "problem with save data"}}
        end

#        case PlaidPlatformAccountService.create(data, %{projects: args.projects, user_id: current_user.id}) do
#          [] -> {:ok, []}
#          {:ok, struct} ->
#            case PlaidPlatformTransactionService.create(data) do
#              {:ok, :ok} ->
#                {:ok, struct}
#              _ ->
#              {:ok, %{error: "500", error_description: "something wrong"}}
#            end
#        end
    end
  end

  @spec create(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def create(_parent, _args, _info) do
    {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
  end

  @spec delete_account(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete_account(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
    else
      try do
        struct = CorePlaid.get_plaid_account!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:ok, %{error: "delete plaid account", error_description: "plaid account #{id} not found!"}}
      end
    end
  end

  @spec delete_account(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete_account(_parent, _args, _info) do
    {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
  end

  @spec delete_transaction(any, %{id: bitstring}, %{context: %{current_user: User.t()}}) :: result()
  def delete_transaction(_parent, %{id: id}, %{context: %{current_user: current_user}}) do
    if current_user.role == true do
      {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
    else
      try do
        struct = CorePlaid.get_plaid_transaction!(id)
        Repo.delete(struct)
      rescue
        Ecto.NoResultsError ->
          {:ok, %{error: "delete plaid transaction ", error_description: "plaid transaction #{id} not found!"}}
      end
    end
  end

  @spec delete_transaction(any, %{atom => any}, Absinthe.Resolution.t()) :: error_tuple()
  def delete_transaction(_parent, _args, _info) do
    {:ok, %{error: "unauthenticated", error_description: "permission denied for current user"}}
  end
end
