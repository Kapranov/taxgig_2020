defmodule Core.Accounts.User do
  @moduledoc """
  Schema for User.
  """

  use Core.Model

  alias Core.{
    Accounts.Profile,
    Accounts.User,
    Localization.Language,
    Repo
  }

  @type t :: %__MODULE__{
    active: boolean,
    admin_role: boolean,
    avatar: String.t(),
    bio: String.t(),
    birthday: %Date{},
    email: String.t(),
    first_name: String.t(),
    init_setup: boolean,
    languages: [Language.t()],
    last_name: String.t(),
    middle_name: String.t(),
    password: String.t(),
    password_confirmation: String.t(),
    password_hash: String.t(),
    phone: String.t(),
    pro_role: boolean,
    provider: String.t(),
    sex: String.t(),
    ssn: integer,
    street: String.t(),
    zip: integer
  }

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
  @secret  Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_base]
  @pass_salt Argon2.hash_pwd_salt(@secret)

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
    field :token, :string, virtual: true
    field :zip, :integer

    has_one :profile, Profile,
      on_delete: :delete_all

    many_to_many :languages, Language,
      join_through: "users_languages",
      on_replace: :delete

    timestamps()
  end

  @doc """
  virtual field via token
  """
  @spec store_token_changeset(%User{}, %{atom => any}) :: Ecto.Changeset.t()
  def store_token_changeset(struct, attrs) do
    struct
    |> cast(attrs, [:token])
  end

  @doc """
  Create changeset for User, registration only requires
  an email, password and password_confirmation are fields.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> changeset_preload(:languages)
    |> put_assoc_nochange(:languages, parse_name(attrs))
    |> validate_format(:email, email_regex())
    |> validate_length(:password, min: 5, max: 20)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_index, message: "Only one an Email Record")
    |> validate_email()
    |> put_password_hash()
  end

  @spec changeset_preload(map, Keyword.t()) :: Ecto.Changeset.t()
  defp changeset_preload(ch, field),
    do: update_in(ch.data, &Repo.preload(&1, field))

  @spec put_assoc_nochange(map, Keyword.t(), map) :: Ecto.Changeset.t()
  defp put_assoc_nochange(ch, field, new_change) do
    case get_change(ch, field) do
      nil -> put_assoc(ch, field, new_change)
      _ -> ch
    end
  end

  @spec parse_name(%{atom => any}) :: map()
  defp parse_name(params)  do
    (params[:languages] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_lang/1)
  end

  @spec get_or_insert_lang(String.t()) :: map()
  defp get_or_insert_lang(name) do
    Repo.get_by(Language, name: name) || maybe_insert_lang(name)
  end

  @spec maybe_insert_lang(String.t()) :: map()
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

  @spec email_regex() :: %Regex{}
  defp email_regex, do: @email_regex

  @spec validate_email(%Ecto.Changeset{}) :: %Ecto.Changeset{}
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
