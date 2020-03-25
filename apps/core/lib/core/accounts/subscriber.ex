defmodule Core.Accounts.Subscriber do
  @moduledoc """
  Schema for Subscriber.
  """

  use Core.Model

  @type t :: %__MODULE__{
    email: String.t(),
    pro_role: boolean
  }

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

  @allowed_params ~w(
    email
    pro_role
  )a

  @required_params ~w(
    email
    pro_role
  )a

  schema "subscribers" do
    field :email, :string
    field :pro_role, :boolean

    timestamps()
  end

  @doc """
  Create changeset for Subscriber.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_format(:email, email_regex())
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_email()
  end

  @spec email_regex() :: Regex.t()
  defp email_regex, do: @email_regex

  @spec validate_email(Ecto.Changeset.t()) :: %Ecto.Changeset{}
  defp validate_email(%{changes: %{email: email}} = changeset) do
    case Regex.match?(@email_regex, email) do
      true ->
        case Burnex.is_burner?(email) do
          true ->
            add_error(changeset, :email, "forbidden_provider")
          false ->
            changeset
        end
      false ->
        add_error(changeset, :email, "invalid_format")
    end
  end

  @spec validate_email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_email(changeset), do: changeset
end
