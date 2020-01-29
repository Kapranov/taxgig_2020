defmodule Core.Accounts.User do
  @moduledoc """
  Schema for User.
  """

  use Core.Model

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
  @pass_salt "$argon2id$v=19$m=131072,t=8,p=4$bzlQ77WsnZVTotjmea95iw$s1uYbt2mqfmE9upwEq5vSm3V5GwAmVZn/4QOmchvtoo"

  @allowed_params ~w(
    active
    admin_role
    avatar
    bio
    birthday
    email
    first_name
    init_setup
    last_name
    middle_name
    password
    password_confirmation
    phone
    pro_role
    provider
    sex
    ssn
    street
    zip
  )a

  @required_params ~w(
    email
    password
    password_confirmation
  )a

  schema "users" do
    field :active, :boolean
    field :admin_role, :boolean
    field :avatar, :string
    field :bio, :string
    field :birthday, :date
    field :email, :string
    field :first_name, :string
    field :init_setup, :boolean
    field :last_name, :string
    field :middle_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string, default: @pass_salt
    field :phone, :string
    field :pro_role, :boolean
    field :provider, :string
    field :sex, :string
    field :ssn, :integer
    field :street, :string
    field :zip, :integer

    timestamps()
  end

  @doc """
  Create changeset for User.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> validate_format(:email, email_regex())
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_email()
    |> put_password_hash()
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

  @spec put_password_hash(%Ecto.Changeset{}) :: %Ecto.Changeset{}
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
