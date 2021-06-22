defmodule Core.Accounts.User do
  @moduledoc """
  Schema for User.
  """

  use Core.Model

  alias Core.{
    Accounts.BanReason,
    Accounts.Platform,
    Accounts.ProRating,
    Accounts.Profile,
    Accounts.User,
    Config,
    Contracts.Addon,
    Contracts.Offer,
    Contracts.PotentialClient,
    Contracts.Project,
    Contracts.ServiceReview,
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
    Talk.Report,
    Talk.Room
  }

  @type t :: %__MODULE__{
    accounting_software: AccountingSoftware.t(),
    active: boolean,
    addons: [Addon.t()],
    admin: boolean,
    avatar: String.t(),
    bio: String.t(),
    birthday: %Date{},
    book_keepings: [BookKeeping.t()],
    bus_addr_zip: String.t(),
    business_tax_returns: [BusinessTaxReturn.t()],
    educations: Education.t(),
    email: String.t(),
    finished_project_count: integer,
    first_name: String.t(),
    individual_tax_returns: [IndividualTaxReturn.t()],
    init_setup: boolean,
    is2fa: boolean,
    languages: [Language.t()],
    last_name: String.t(),
    messages: [Message.t()],
    middle_name: String.t(),
    offers: [Offer.t()],
    on_going_project_count: integer,
    otp_last: :integer,
    otp_secret: String.t(),
    password: String.t(),
    password_confirmation: String.t(),
    password_hash: String.t(),
    phone: String.t(),
    platform: Platform.t(),
    potential_client: PotentialClient.t(),
    pro_ratings: [ProRating.t()],
    profile: Profile.t(),
    projects: [Project.t()],
    provider: String.t(),
    reports: [Report.t()],
    role: boolean,
    rooms: [Room.t()],
    sale_taxes: [SaleTax.t()],
    service_reviews: [ServiceReview.t()],
    sex: String.t(),
    street: String.t(),
    total_earned: integer,
    work_experiences: WorkExperience.t(),
    zip: integer
  }

  @email_regex ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
  @secret :crypto.strong_rand_bytes(32) |> Base.url_encode64 |> binary_part(0, 32)
  @pass_salt Argon2.hash_pwd_salt(@secret)

  @allowed_params ~w(
    active
    admin
    avatar
    bio
    birthday
    bus_addr_zip
    email
    finished_project_count
    first_name
    init_setup
    is2fa
    last_name
    middle_name
    on_going_project_count
    otp_last
    otp_secret
    password
    password_confirmation
    phone
    provider
    role
    sex
    street
    total_earned
    zip
  )a

  @required_params ~w(
    email
    is2fa
    otp_last
    provider
    role
  )a

  schema "users" do
    field :active, :boolean, default: false, null: false
    field :admin, :boolean, default: false, null: false
    field :avatar, :binary, null: true
    field :bio, :string, null: true
    field :birthday, :date, null: true
    field :bus_addr_zip, :string, null: false, default: "00000"
    field :email, :string, null: false
    field :finished_project_count, :integer, virtual: true
    field :first_name, :string, null: true
    field :init_setup, :boolean, null: true
    field :is2fa, :boolean, null: false, default: false
    field :last_name, :string, null: true
    field :middle_name, :string, null: true
    field :on_going_project_count, :integer, virtual: true
    field :otp_last, :integer, null: false, default: 0
    field :otp_secret, :string, null: true
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string, default: @pass_salt, null: false
    field :phone, :string, null: true
    field :profession, :string, null: true
    field :provider, :string, default: "localhost", null: false
    field :role, :boolean, default: false, null: false
    field :sex, :string, null: true
    field :street, :string, null: true
    field :token, :string, virtual: true
    field :total_earned, :decimal, virtual: true
    field :zip, :integer, null: true

    has_one :accounting_software, AccountingSoftware, on_delete: :delete_all
    has_one :platform, Platform, on_delete: :delete_all
    has_one :potential_client, PotentialClient, on_delete: :delete_all
    has_one :profile, Profile, on_delete: :delete_all

    has_many :addons, Addon, on_delete: :delete_all
    has_many :ban_reasons, BanReason, on_delete: :delete_all
    has_many :book_keepings, BookKeeping, on_delete: :delete_all
    has_many :business_tax_returns, BusinessTaxReturn, on_delete: :delete_all
    has_many :educations, Education, on_delete: :delete_all
    has_many :individual_tax_returns, IndividualTaxReturn, on_delete: :delete_all
    has_many :messages, Message, on_delete: :delete_all
    has_many :offers, Offer, on_delete: :delete_all
    has_many :pro_ratings, ProRating, on_delete: :delete_all
    has_many :projects, Project, on_delete: :delete_all
    has_many :reports, Report, on_delete: :delete_all
    has_many :rooms, Room, on_delete: :delete_all
    has_many :sale_taxes, SaleTax, on_delete: :delete_all
    has_many :service_reviews, ServiceReview, on_delete: :delete_all
    has_many :work_experiences, WorkExperience, on_delete: :delete_all

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
    bio_limit = Config.get([:instance, :user_bio_length])
    name_limit = Config.get([:instance, :user_name_length])

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
    |> validate_length(:password, min: 5, max: 20)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_index, message: "The format of the email address isn't correct or email has already been taken!")
    |> validate_email()
    |> validate_length(:bio, max: bio_limit)
    |> validate_length(:first_name, max: name_limit)
    |> validate_length(:last_name, max: name_limit)
    |> validate_length(:middle_name, max: name_limit)
    |> put_password_hash()
  end

  @doc """
  Update changeset for User, registration only requires
  an email, password and password_confirmation are fields.
  """
  @spec update_changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def update_changeset(struct, attrs) do
    #bio_limit = Config.get([:instance, :user_bio_length], 555)
    name_limit = Config.get([:instance, :user_name_length], 25)

    attr =
      attrs
      #|> truncate_if_exists(:bio, bio_limit)
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
    |> validate_length(:password, min: 5, max: 20)
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_email_index, message: "The format of the email address isn't correct or email has already been taken!")
    |> validate_email()
    |> name_zip_validation()
    #|> validate_length(:bio, max: bio_limit)
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

  @spec name_zip_validation(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp name_zip_validation(changeset) do
    bus_addr_zip = get_field(changeset, :bus_addr_zip)
    first_name = get_field(changeset, :first_name)
    last_name = get_field(changeset, :last_name)

    case Repo.get_by(User, [bus_addr_zip: bus_addr_zip, first_name: first_name, last_name: last_name]) do
      nil -> changeset
      _ -> add_error(changeset, :error, "such user already exists")
    end
  end
end
