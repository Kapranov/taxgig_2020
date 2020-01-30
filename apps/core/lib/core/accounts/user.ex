defmodule Core.Accounts.User do
  @moduledoc """
  Schema for User.
  """

  use Core.Model

  alias Core.Localization.Language
  alias Core.Repo

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
    field :email, :string, null: false
    field :first_name, :string
    field :init_setup, :boolean
    field :last_name, :string
    field :middle_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string, default: @pass_salt, null: false
    field :phone, :string
    field :pro_role, :boolean
    field :provider, :string, default: "localhost", null: false
    field :sex, :string
    field :ssn, :integer
    field :street, :string
    field :zip, :integer

    many_to_many :languages, Language, join_through: "users_languages", on_replace: :delete

    timestamps()
  end

  @doc """
  Create changeset for User.
  """
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> put_assoc(:languages, parse_name(attrs))
    |> validate_format(:email, email_regex())
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_index, message: "Only one an Email Record")
    |> validate_email()
    |> put_password_hash()
  end

  defp parse_name(params)  do
    (params[:languages] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_lang/1)
  end

  defp get_or_insert_lang(name) do
    Repo.get_by(Language, name: name) || maybe_insert_lang(name)
  end

  defp maybe_insert_lang(name) do
    %Language{}
    |> Ecto.Changeset.change(name: name)
    |> Ecto.Changeset.unique_constraint(:name)
    |> Repo.insert!(on_conflict: [set: [name: name]], conflict_target: :name)
    |> case do
      {:ok, lang} -> lang
      {:error, _} -> Repo.get_by!(Language, name: name)
    end
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
