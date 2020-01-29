defmodule Core.Accounts.Subscriber do
  @moduledoc """
  Schema for Subscriber.
  """

  use Core.Model

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
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_format(:email, email_regex())
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_email()
  end

  defp email_regex, do: @email_regex

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

  defp validate_email(changeset), do: changeset
end
