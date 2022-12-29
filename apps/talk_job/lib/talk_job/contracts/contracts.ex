defmodule TalkJob.Contracts do
  @moduledoc """
  The Contract context.
  """

  use TalkJob.Context

  alias TalkJob.Contracts.Project

  @type word() :: String.t()

  @doc """
  Returns the list the Projects.

  ## Examples

      iex> list_project()
      [%Project{}, ...]
  """
  @spec list_project() :: [Project.t()]
  def list_project do
    Repo.all(Project)
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
  def get_project!(id), do: Repo.get!(Project, id)

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

  @spec filtered(map) :: map
  defp filtered(attrs) do
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
end
