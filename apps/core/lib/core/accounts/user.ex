defmodule Core.Accounts.User do
  @moduledoc """
  Schema for User.
  """

  use Core.Model

  alias Core.{
    Accounts.Profile,
    Accounts.User,
    Config,
    Localization.Language,
    Repo,
    Services.BookKeeping,
    Services.BusinessTaxReturn,
    Services.IndividualTaxReturn,
    Services.SaleTax,
    Skills.AccountingSoftware,
    Skills.Education,
    Skills.WorkExperience,
    Talk.Message,
    Talk.Room
  }

  @type t :: %__MODULE__{
    active: boolean,
    admin: boolean,
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
    role: boolean,
    provider: String.t(),
    sex: String.t(),
    ssn: integer,
    street: String.t(),
    zip: integer,
    accounting_software: [AccountingSoftware.t()],
    book_keepings: [BookKeeping.t()],
    business_tax_returns: [BusinessTaxReturn.t()],
    education: [Education.t()],
    individual_tax_returns: [IndividualTaxReturn.t()],
    messages: [Message.t()],
    rooms: [Room.t()],
    sale_taxes: [SaleTax.t()],
    work_experience: [WorkExperience.t()]
  }

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
  @phone ~r/^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$/
  @secret  Application.get_env(:server, ServerWeb.Endpoint)[:secret_key_base]
  @pass_salt Argon2.hash_pwd_salt(@secret)

  @allowed_params ~w(
    active
    admin
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
    role
    provider
    sex
    ssn
    street
    zip
  )a

  @required_params ~w(
    admin
    email
    password
    password_confirmation
    provider
    role
  )a

  schema "users" do
    field :active, :boolean
    field :admin, :boolean, default: false, null: false
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
    field :provider, :string, default: "localhost", null: false
    field :role, :boolean, default: false, null: false
    field :sex, :string
    field :ssn, :integer
    field :street, :string
    field :token, :string, virtual: true
    field :zip, :integer

    has_one :profile, Profile, on_delete: :delete_all
    has_one :accounting_software, AccountingSoftware, on_delete: :delete_all
    has_one :education, Education, on_delete: :delete_all
    has_one :work_experience, WorkExperience, on_delete: :delete_all

    has_many :book_keepings, BookKeeping
    has_many :business_tax_returns, BusinessTaxReturn
    has_many :individual_tax_returns, IndividualTaxReturn
    has_many :sale_taxes, SaleTax
    has_many :rooms, Room
    has_many :messages, Message

    many_to_many :languages, Language, join_through: "users_languages", on_replace: :delete

    timestamps()
  end

  @doc """
  virtual field via token
  """
  @spec store_token_changeset(User.t(), %{atom => any}) :: Ecto.Changeset.t()
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
    bio_limit = Config.get([:instance, :user_bio_length], 25)
    name_limit = Config.get([:instance, :user_name_length], 25)

    attr =
      attrs
      |> truncate_if_exists(:bio, bio_limit)
      |> truncate_if_exists(:first_name, name_limit)
      |> truncate_if_exists(:last_name, name_limit)
      |> truncate_if_exists(:middle_name, name_limit)
      |> truncate_if_exists(:street, name_limit)

    struct
    |> cast(attr, @allowed_params)
    |> validate_required(@required_params)
    |> changeset_preload(:languages)
    |> put_assoc_nochange(:languages, parse_name(attrs))
    |> validate_format(:email, email_regex())
    |> validate_format(:phone, @phone, message: "must be a valid number")
    |> validate_length(:password, min: 5, max: 20)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:email, name: :users_email_index, message: "Only one an Email Record")
    |> validate_email()
    |> validate_length(:bio, max: bio_limit)
    |> validate_length(:first_name, max: name_limit)
    |> validate_length(:last_name, max: name_limit)
    |> validate_length(:middle_name, max: name_limit)
    |> put_password_hash()
  end

  @doc "Returns status account"
  @spec account_status(User.t()) :: atom()
  def account_status(%User{active: true}), do: :active
  def account_status(%User{}), do: :deactivated

  @spec superuser?(User.t()) :: boolean()
  def superuser?(%User{admin: true}), do: true
  def superuser?(_), do: false

  @spec avatar_url(User.t(), list()) :: String.t()
  def avatar_url(user, options \\ []) do
    base_url = Application.get_env(:core, :base_url)
    case user.avatar do
      %{"url" => [%{"href" => href} | _]} -> href
      _ -> !options[:no_default] && "#{base_url}/images/default.png"
    end
  end

  @doc """
  Dumps Flake Id to SQL-compatible format (16-byte UUID).
  E.g. "9pQtDGXuq4p3VlcJEm" -> <<0, 0, 1, 110, 179, 218, 42, 92, 213, 41, 44, 227, 95, 213, 0, 0>>
  """
  @spec binary_id(String.t()) :: String.t()
  def binary_id(source_id) when is_binary(source_id) do
    with {:ok, dumped_id} <- FlakeId.Ecto.CompatType.dump(source_id) do
      dumped_id
    else
      _ -> source_id
    end
  end

  @spec binary_id([String.t()]) :: String.t()
  def binary_id(source_ids) when is_list(source_ids) do
    Enum.map(source_ids, &binary_id/1)
  end

  @spec binary_id(User.t()) :: String.t()
  def binary_id(%User{} = user), do: binary_id(user.id)

  @spec truncate_if_exists(map(), atom(), integer()) :: map()
  def truncate_if_exists(params, key, max_length) do
    if Map.has_key?(params, key) and is_binary(params[key]) do
      {value, _chopped} = String.split_at(params[key], max_length)
      Map.put(params, key, value)
    else
      params
    end
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

  @spec email_regex() :: Regex.t()
  defp email_regex, do: @email_regex

  @spec validate_email(Ecto.Changeset.t()) :: Ecto.Changeset.t()
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

  @spec put_password_hash(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
