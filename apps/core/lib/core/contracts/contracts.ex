defmodule Core.Contracts do
  @moduledoc """
  The Contract context.
  """

  use Core.Context

  alias Core.{
    Accounts,
    Accounts.User,
    Analyzes,
    Contracts,
    Contracts.Addon,
    Contracts.Offer,
    Contracts.PotentialClient,
    Contracts.Project,
    Contracts.ServiceReview,
    Queries,
    Services.BookKeeping,
    Services.BusinessTaxReturn,
    Services.IndividualTaxReturn,
    Services.SaleTax
  }

  @type word() :: String.t()
  @type message() :: atom()

  @doc """
  Returns the list of Addon.

  ## Examples

      iex> list_addon()
      [%Addon{}, ...]
  """
  @spec list_addon() :: [Addon.t()]
  def list_addon, do: Repo.all(Addon)

  @doc """
  Gets a single an Addon.

  Raises `Ecto.NoResultsError` if an Addon does not exist.

  ## Examples

      iex> get_addon!(123)
      %Faq{}

      iex> get_addon!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_addon!(String.t()) :: Addon.t() | error_tuple()
  def get_addon!(id), do: Repo.get!(Addon, id)

  @doc """
  Creates an Addon.

  ## Examples

      iex> create_addon(%{field: value})
      {:ok, %Addon{}}

      iex> create_addon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_addon(%{atom => any}) :: result() | error_tuple()
  def create_addon(attrs \\ %{}) do
    %Addon{}
    |> Addon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an Addon.

  ## Examples

      iex> update_addon(struct, %{field: new_value})
      {:ok, %Addon{}}

      iex> update_addon(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_addon(Addon.t(), %{atom => any}) :: result() | error_tuple()
  def update_addon(%Addon{} = struct, attrs) do
    struct
    |> Addon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an Addon.

  ## Examples

      iex> delete_addon(struct)
      {:ok, %Addon{}}

      iex> delete_addon(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_addon(Addon.t()) :: result()
  def delete_addon(%Addon{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking an Addon Changes.

  ## Examples

      iex> change_addon(struct)
      %Ecto.Changeset{source: %Addon{}}

  """
  @spec change_addon(Addon.t()) :: Ecto.Changeset.t()
  def change_addon(%Addon{} = struct) do
    Addon.changeset(struct, %{})
  end

  @doc """
  Returns the list of Offer.

  ## Examples

      iex> list_offer()
      [%Offer{}, ...]
  """
  @spec list_offer() :: [Offer.t()]
  def list_offer, do: Repo.all(Offer)

  @doc """
  Gets a single an Offer.

  Raises `Ecto.NoResultsError` if an Offer does not exist.

  ## Examples

      iex> get_offer!(123)
      %Faq{}

      iex> get_offer!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_offer!(String.t()) :: Offer.t() | error_tuple()
  def get_offer!(id), do: Repo.get!(Offer, id)

  @doc """
  Creates an Offer.

  ## Examples

      iex> create_offer(%{field: value})
      {:ok, %Offer{}}

      iex> create_offer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_offer(%{atom => any}) :: result() | error_tuple()
  def create_offer(attrs \\ %{}) do
    %Offer{}
    |> Offer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an Offer.

  ## Examples

      iex> update_offer(struct, %{field: new_value})
      {:ok, %Offer{}}

      iex> update_offer(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_offer(Offer.t(), %{atom => any}) :: result() | error_tuple()
  def update_offer(%Offer{} = struct, attrs) do
    struct
    |> Offer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an Offer.

  ## Examples

      iex> delete_offer(struct)
      {:ok, %Offer{}}

      iex> delete_offer(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_offer(Offer.t()) :: result()
  def delete_offer(%Offer{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking an Offer Changes.

  ## Examples

      iex> change_offer(struct)
      %Ecto.Changeset{source: %Offer{}}

  """
  @spec change_offer(Offer.t()) :: Ecto.Changeset.t()
  def change_offer(%Offer{} = struct) do
    Offer.changeset(struct, %{})
  end

  @doc """
  Returns the list of PotentialClient.

  ## Examples

      iex> list_potential_client()
      [%PotentialClient{}, ...]
  """
  @spec list_potential_client() :: [PotentialClient.t()]
  def list_potential_client, do: Repo.all(PotentialClient)

  @doc """
  Gets a single PotentialClient.

  Raises `Ecto.NoResultsError` if PotentialClient does not exist.

  ## Examples

      iex> get_potential_client!(123)
      %PotentialClient{}

      iex> get_potential_client!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_potential_client!(String.t()) :: PotentialClient.t() | error_tuple()
  def get_potential_client!(id), do: Repo.get!(PotentialClient, id)

  @doc """
  Creates PotentialClient.

  ## Examples

      iex> create_potential_client(%{field: value})
      {:ok, %PotentialClient{}}

      iex> create_potential_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_potential_client(%{atom => any}) :: result() | error_tuple()
  def create_potential_client(attrs \\ %{}) do
    %PotentialClient{}
    |> PotentialClient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates PotentialClient.

  ## Examples

      iex> update_potential_client(struct, %{field: new_value})
      {:ok, %PotentialClient{}}

      iex> update_potential_client(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_potential_client(PotentialClient.t(), %{atom => any}) :: result() | error_tuple()
  def update_potential_client(%PotentialClient{} = struct, attrs) do
    struct
    |> PotentialClient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes PotentialClient.

  ## Examples

      iex> delete_potential_client(struct)
      {:ok, %PotentialClient{}}

      iex> delete_potential_client(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_potential_client(PotentialClient.t()) :: result()
  def delete_potential_client(%PotentialClient{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking PotentialClient Changes.

  ## Examples

      iex> change_potential_client(struct)
      %Ecto.Changeset{source: %PotentialClient{}}

  """
  @spec change_potential_client(PotentialClient.t()) :: Ecto.Changeset.t()
  def change_potential_client(%PotentialClient{} = struct) do
    PotentialClient.changeset(struct, %{})
  end

  @doc """
  Returns the list the Projects.

  ## Examples

      iex> list_project()
      [%Project{}, ...]
  """
  @spec list_project() :: [Project.t()]
  def list_project do
    Repo.all(Project)
    |> Repo.preload([:service_review])
  end

  @doc """
  Gets a single the Project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_project!(String.t()) :: Project.t() | error_tuple()
  def get_project!(id) do
    Repo.get!(Project, id)
  end

  @doc """
  Creates the Project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_project(%{atom => any}) :: result() | error_tuple()
  def create_project(attrs \\ %{}) do
    case Accounts.by_role(attrs.user_id) do
      false ->
        %Project{}
        |> Project.changeset(filtered(attrs))
        |> Repo.insert()
      true -> {:error, %Changeset{}}
    end
  end

  @doc """
  Creates Extention the Project.

  ## Examples

      iex> extention_project(%{field: value})
      {:ok, %Project{}}

      iex> extention_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec extention_project(%{atom => any}) :: result() | error_tuple()
  def extention_project(attrs \\ %{}) do
    case Accounts.by_role(attrs.user_id) do
      false ->
        %Project{}
        |> Project.changeset(extention_filtered(attrs))
        |> Repo.insert()
      true -> {:error, %Changeset{}}
    end
  end

  @doc """
  Updates the Project.

  ## Examples

      iex> update_project(struct, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_project(Project.t(), %{atom => any}) :: result() | error_tuple()
  def update_project(%Project{} = struct, attrs) do
    struct
    |> Project.changeset(filtered(attrs))
    |> Repo.update()
  end

  @doc """
  Updates Extention the Project.

  ## Examples

      iex> update_extention_project(struct, %{field: new_value})
      {:ok, %Project{}}

      iex> update_extention_project(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_extention_project(Project.t(), %{atom => any}) :: result() | error_tuple()
  def update_extention_project(%Project{} = struct, attrs) do
    case Contracts.by_role(struct.id) do
      false ->
        struct
        |> Project.changeset(extention_filtered(attrs))
        |> Repo.update()
      true -> {:error, %Changeset{}}
    end
  end

  @doc """
  Deletes the Project.

  ## Examples

      iex> delete_project(struct)
      {:ok, %Project{}}

      iex> delete_project(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_project(Project.t()) :: result()
  def delete_project(%Project{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking the Project Changes.

  ## Examples

      iex> change_project(struct)
      %Ecto.Changeset{source: %Project{}}

  """
  @spec change_project(Project.t()) :: Ecto.Changeset.t()
  def change_project(%Project{} = struct) do
    Project.changeset(struct, %{})
  end

  @doc """
  Returns the list of ServiceReview.

  ## Examples

      iex> list_service_review()
      [%ServiceReview{}, ...]
  """
  @spec list_service_review() :: [ServiceReview.t()]
  def list_service_review, do: Repo.all(ServiceReview)

  @doc """
  Gets a single the ServiceReview.

  Raises `Ecto.NoResultsError` if the ServiceReview does not exist.

  ## Examples

      iex> get_service_review!(123)
      %ServiceReview{}

      iex> get_service_review!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_service_review!(String.t()) :: ServiceReview.t() | error_tuple()
  def get_service_review!(id), do: Repo.get!(ServiceReview, id)

  @doc """
  Creates the ServiceReview.

  ## Examples

      iex> create_service_review(%{field: value})
      {:ok, %ServiceReview{}}

      iex> create_service_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_service_review(%{atom => any}) :: result() | error_tuple()
  def create_service_review(attrs \\ %{}) do
    %ServiceReview{}
    |> ServiceReview.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates the ServiceReview.

  ## Examples

      iex> update_service_review(struct, %{field: new_value})
      {:ok, %ServiceReview{}}

      iex> update_service_review(struct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_service_review(ServiceReview.t(), %{atom => any}) :: result() | error_tuple()
  def update_service_review(%ServiceReview{} = struct, attrs) do
    struct
    |> ServiceReview.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes the ServiceReview.

  ## Examples

      iex> delete_service_review(struct)
      {:ok, %ServiceReview{}}

      iex> delete_addon(struct)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_service_review(ServiceReview.t()) :: result()
  def delete_service_review(%ServiceReview{} = struct) do
    Repo.delete(struct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking the ServiceReview Changes.

  ## Examples

      iex> change_service_review(struct)
      %Ecto.Changeset{source: %ServiceReview{}}

  """
  @spec change_service_review(ServiceReview.t()) :: Ecto.Changeset.t()
  def change_service_review(%ServiceReview{} = struct) do
    ServiceReview.changeset(struct, %{})
  end

  @doc """
  Share user's role.
  """
  @spec by_role(word) :: boolean | {:error, nonempty_list(message)}
  def by_role(id) when not is_nil(id) do
    struct =
      try do
        Contracts.get_project!(id)
      rescue
        Ecto.NoResultsError -> :error
      end

    case struct do
      :error ->
        {:error, [field: :user_id, message: "Project Not Found"]}
      %Project{user_id: user_id} ->
        with %User{role: role} <- by_user(user_id), do: role
    end
  end

  @spec by_role(nil) :: {:error, nonempty_list(message)}
  def by_role(id) when is_nil(id) do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_role :: {:error, nonempty_list(message)}
  def by_role do
    {:error, [field: :user_id, message: "Can't be blank"]}
  end

  @spec by_user(word) :: Ecto.Schema.t() | nil
  defp by_user(user_id) do
    try do
      Repo.one(from c in User, where: c.id == ^user_id)
    rescue
      Ecto.Query.CastError -> nil
    end
  end

  @spec filtered(map) :: map
  def filtered(attrs) do
    case Map.has_key?(attrs, :book_keeping_id) do
      true ->
        case is_nil(attrs.book_keeping_id) do
          true ->
            case Map.has_key?(attrs, :business_tax_return_id) do
              true ->
                case is_nil(attrs.business_tax_return_id) do
                  true ->
                    case Map.has_key?(attrs, :individual_tax_return_id) do
                      true ->
                         case is_nil(attrs.individual_tax_return_id) do
                           true ->
                             case Map.has_key?(attrs, :sale_tax_id) do
                               true ->
                                 case is_nil(attrs.sale_tax_id) do
                                   true ->
                                     attrs
                                     |> Map.delete(:book_keeping_id)
                                     |> Map.delete(:business_tax_return_id)
                                     |> Map.delete(:individual_tax_return_id)
                                     |> Map.delete(:sale_tax_id)
                                   false ->
                                     attrs
                                     |> Map.delete(:book_keeping_id)
                                     |> Map.delete(:business_tax_return_id)
                                     |> Map.delete(:individual_tax_return_id)
                                 end
                               false ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                                 |> Map.delete(:business_tax_return_id)
                                 |> Map.delete(:book_keeping_id)
                             end
                           false ->
                             attrs
                             |> Map.delete(:book_keeping_id)
                             |> Map.delete(:business_tax_return_id)
                             |> Map.delete(:sale_tax_id)
                         end
                      false ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                            case is_nil(attrs.sale_tax_id) do
                              true ->
                                attrs
                                |> Map.delete(:book_keeping_id)
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:sale_tax_id)
                              false ->
                                attrs
                                |> Map.delete(:book_keeping_id)
                                |> Map.delete(:business_tax_return_id)
                            end
                          false ->
                            attrs
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                        end
                    end
                  false ->
                    attrs
                    |> Map.delete(:book_keeping_id)
                    |> Map.delete(:individual_tax_return_id)
                    |> Map.delete(:sale_tax_id)
                end
              false ->
                case Map.has_key?(attrs, :individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.individual_tax_return_id) do
                      true ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                             case is_nil(attrs.sale_tax_id) do
                               true ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                                 |> Map.delete(:sale_tax_id)
                               false ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                             end
                          false ->
                            attrs
                            |> Map.delete(:individual_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:sale_tax_id)
                    end
                  false ->
                    case Map.has_key?(attrs, :sale_tax_id) do
                      true ->
                        case is_nil(attrs.sale_tax_id) do
                          true ->
                            attrs
                            |> Map.delete(:sale_tax_id)
                          false -> attrs
                        end
                      false -> attrs
                    end
                end
            end
          false ->
            attrs
            |> Map.delete(:business_tax_return_id)
            |> Map.delete(:individual_tax_return_id)
            |> Map.delete(:sale_tax_id)
        end
      false ->
        case Map.has_key?(attrs, :business_tax_return_id) do
          true ->
            case is_nil(attrs.business_tax_return_id) do
              true ->
                case Map.has_key?(attrs, :individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.individual_tax_return_id) do
                      true ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                            case is_nil(attrs.sale_tax_id) do
                              true ->
                                attrs
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:individual_tax_return_id)
                                |> Map.delete(:sale_tax_id)
                              false ->
                                attrs
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:individual_tax_return_id)
                            end
                          false ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:individual_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:business_tax_return_id)
                        |> Map.delete(:sale_tax_id)
                    end
                  false ->
                    case Map.has_key?(attrs, :sale_tax_id) do
                      true ->
                        case is_nil(attrs.sale_tax_id) do
                          true ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:sale_tax_id)
                          false ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:business_tax_return_id)
                    end
                end
              false ->
                attrs
                |> Map.delete(:individual_tax_return_id)
                |> Map.delete(:sale_tax_id)
            end
          false ->
            case Map.has_key?(attrs, :individual_tax_return_id) do
              true ->
                case is_nil(attrs.individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.sale_tax_id) do
                      true ->
                        attrs
                        |> Map.delete(:individual_tax_return_id)
                        |> Map.delete(:sale_tax_id)
                      false ->
                        attrs
                        |> Map.delete(:individual_tax_return_id)
                    end
                  false ->
                    attrs
                    |> Map.delete(:sale_tax_id)
                end
              false ->
                case Map.has_key?(attrs, :sale_tax_id) do
                  true ->
                    case is_nil(attrs.sale_tax_id) do
                      true ->
                        attrs
                        |> Map.delete(:sale_tax_id)
                      false -> attrs
                    end
                  false -> attrs
                end
            end
        end
    end
  end

  @spec extention_filtered(map) :: map
  def extention_filtered(attrs) do
    case Map.has_key?(attrs, :book_keeping_id) do
      true ->
        case is_nil(attrs.book_keeping_id) do
          true ->
            case Map.has_key?(attrs, :business_tax_return_id) do
              true ->
                case is_nil(attrs.business_tax_return_id) do
                  true ->
                    case Map.has_key?(attrs, :individual_tax_return_id) do
                      true ->
                         case is_nil(attrs.individual_tax_return_id) do
                           true ->
                             case Map.has_key?(attrs, :sale_tax_id) do
                               true ->
                                 case is_nil(attrs.sale_tax_id) do
                                   true ->
                                     attrs
                                     |> Map.delete(:book_keeping_id)
                                     |> Map.delete(:business_tax_return_id)
                                     |> Map.delete(:individual_tax_return_id)
                                     |> Map.delete(:sale_tax_id)
                                   false ->
                                     attrs
                                     |> Map.delete(:book_keeping_id)
                                     |> Map.delete(:business_tax_return_id)
                                     |> Map.delete(:individual_tax_return_id)
                                     |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                                 end
                               false ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                                 |> Map.delete(:business_tax_return_id)
                                 |> Map.delete(:book_keeping_id)
                             end
                           false ->
                             attrs
                             |> Map.delete(:book_keeping_id)
                             |> Map.delete(:business_tax_return_id)
                             |> Map.delete(:sale_tax_id)
                             |> Map.merge(transfers(IndividualTaxReturn, attrs[:individual_tax_return_id]))
                         end
                      false ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                            case is_nil(attrs.sale_tax_id) do
                              true ->
                                attrs
                                |> Map.delete(:book_keeping_id)
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:sale_tax_id)
                              false ->
                                attrs
                                |> Map.delete(:book_keeping_id)
                                |> Map.delete(:business_tax_return_id)
                                |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                            end
                          false ->
                            attrs
                            |> Map.delete(:book_keeping_id)
                            |> Map.delete(:business_tax_return_id)
                        end
                    end
                  false ->
                    attrs
                    |> Map.delete(:book_keeping_id)
                    |> Map.delete(:individual_tax_return_id)
                    |> Map.delete(:sale_tax_id)
                    |> Map.merge(transfers(BusinessTaxReturn, attrs[:business_tax_return_id]))
                end
              false ->
                case Map.has_key?(attrs, :individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.individual_tax_return_id) do
                      true ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                             case is_nil(attrs.sale_tax_id) do
                               true ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                                 |> Map.delete(:sale_tax_id)
                               false ->
                                 attrs
                                 |> Map.delete(:individual_tax_return_id)
                                 |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                             end
                          false ->
                            attrs
                            |> Map.delete(:individual_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:sale_tax_id)
                        |> Map.merge(transfers(IndividualTaxReturn, attrs[:individual_tax_return_id]))
                    end
                  false ->
                    case Map.has_key?(attrs, :sale_tax_id) do
                      true ->
                        case is_nil(attrs.sale_tax_id) do
                          true ->
                            attrs
                            |> Map.delete(:sale_tax_id)
                          false ->
                            attrs
                            |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                        end
                      false -> attrs
                    end
                end
            end
          false ->
            attrs
            |> Map.delete(:business_tax_return_id)
            |> Map.delete(:individual_tax_return_id)
            |> Map.delete(:sale_tax_id)
            |> Map.merge(transfers(BookKeeping, attrs[:book_keeping_id]))
        end
      false ->
        case Map.has_key?(attrs, :business_tax_return_id) do
          true ->
            case is_nil(attrs.business_tax_return_id) do
              true ->
                case Map.has_key?(attrs, :individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.individual_tax_return_id) do
                      true ->
                        case Map.has_key?(attrs, :sale_tax_id) do
                          true ->
                            case is_nil(attrs.sale_tax_id) do
                              true ->
                                attrs
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:individual_tax_return_id)
                                |> Map.delete(:sale_tax_id)
                              false ->
                                attrs
                                |> Map.delete(:business_tax_return_id)
                                |> Map.delete(:individual_tax_return_id)
                                |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                            end
                          false ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:individual_tax_return_id)
                        end
                      false ->
                        attrs
                        |> Map.delete(:business_tax_return_id)
                        |> Map.delete(:sale_tax_id)
                        |> Map.merge(transfers(IndividualTaxReturn, attrs[:individual_tax_return_id]))
                    end
                  false ->
                    case Map.has_key?(attrs, :sale_tax_id) do
                      true ->
                        case is_nil(attrs.sale_tax_id) do
                          true ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                            |> Map.delete(:sale_tax_id)
                          false ->
                            attrs
                            |> Map.delete(:business_tax_return_id)
                            |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                        end
                      false ->
                        attrs
                        |> Map.delete(:business_tax_return_id)
                    end
                end
              false ->
                attrs
                |> Map.delete(:individual_tax_return_id)
                |> Map.delete(:sale_tax_id)
                |> Map.merge(transfers(BusinessTaxReturn, attrs[:business_tax_return_id]))
            end
          false ->
            case Map.has_key?(attrs, :individual_tax_return_id) do
              true ->
                case is_nil(attrs.individual_tax_return_id) do
                  true ->
                    case is_nil(attrs.sale_tax_id) do
                      true ->
                        attrs
                        |> Map.delete(:individual_tax_return_id)
                        |> Map.delete(:sale_tax_id)
                      false ->
                        attrs
                        |> Map.delete(:individual_tax_return_id)
                        |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                    end
                  false ->
                    attrs
                    |> Map.delete(:sale_tax_id)
                    |> Map.merge(transfers(IndividualTaxReturn, attrs[:individual_tax_return_id]))
                end
              false ->
                case Map.has_key?(attrs, :sale_tax_id) do
                  true ->
                    case is_nil(attrs.sale_tax_id) do
                      true ->
                        attrs
                        |> Map.delete(:sale_tax_id)
                      false ->
                        attrs
                        |> Map.merge(transfers(SaleTax, attrs[:sale_tax_id]))
                    end
                  false -> attrs
                end
            end
        end
    end
  end

  @spec transfers(atom, String.t()) ::
          %{assigned_id: String.t(), offer_price: integer}
          | %{user_id: String.t()}
          | [{String.t(), String.t()}]
  def transfers(struct, id) do
    with offer_price <- by_offer_price(id),
         match <- by_match(id),
         single <- Queries.get_hero_active(struct, match),
         counter <- by_counter(match)
    do
      if counter <= 1 do
        data = Queries.max_match(struct, match)
        if is_list(data), do: %{}, else: %{assigned_id: data[:user_id], offer_price: offer_price}
      else
        try do
          if Enum.count(match) == 1 do
            %{assigned_id: List.first(single), offer_price: offer_price}
          else
            {user_id, _offer_price} = Queries.max_pro_rating(single) |> Enum.max_by(&(elem(&1, 1)))
            %{assigned_id: user_id, offer_price: offer_price}
          end
        rescue
          Enum.EmptyError -> %{}
        end
      end
    end
  end

  @spec by_counter([{String.t(), integer}]) :: integer
  defp by_counter(data) do
    data
    |> Enum.filter(&(elem(&1, 1) == List.first(Enum.take(data, 1))
    |> elem(1) ))
    |> Enum.count
  end

  @spec by_offer_price(String.t()) :: integer | nil
  defp by_offer_price(id) do
    case by_value(id) do
      [] -> nil
      [data] -> data
    end
  end

  @spec by_match(String.t()) :: [{String.t(), integer}] | []
  defp by_match(id), do: Queries.transform_match(id)

  @spec by_value(String.t()) :: [integer] | []
  defp by_value(id) do
    case Analyzes.total_value(id) do
      [field: :user_id, message: _] -> []
      data -> Map.values(data)
    end
  end
end
