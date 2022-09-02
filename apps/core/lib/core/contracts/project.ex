defmodule Core.Contracts.Project do
  @moduledoc """
  Schema for the Project.
  """

  use Core.Model

  alias Core.{
    Accounts.ProRating,
    Accounts.User,
    Contracts.Addon,
    Contracts.Helpers.ProjectEnum,
    Contracts.Offer,
    Contracts.ServiceReview,
    Media.ProDoc,
    Media.TpDoc,
    Plaid.PlaidAccount,
    Services.BookKeeping,
    Services.BusinessTaxReturn,
    Services.IndividualTaxReturn,
    Services.SaleTax
  }

  @type t :: %__MODULE__{
    addon_price: integer,
    addons: Addon.t(),
    assigned_id: User.t(),
    book_keeping_id: BookKeeping.t(),
    business_tax_return_id: BusinessTaxReturn.t(),
    by_pro_status: boolean,
    end_time: DateTime.t(),
    id_from_stripe_card: String.t(),
    id_from_stripe_transfer: String.t(),
    individual_tax_return_id: IndividualTaxReturn.t(),
    instant_matched: boolean,
    mailers: [%{email: String.t(), user_id: String.t()}],
    offer_price: integer,
    offers: Offer.t(),
    plaid_accounts: [PlaidAccount.t()],
    pro_docs: [ProDoc.t()],
    pro_ratings: [ProRating.t()],
    room_id: FlakeId.Ecto.CompatType.t(),
    sale_tax_id: SaleTax.t(),
    service_review_id: ServiceReview.t(),
    status: String.t(),
    tp_docs: [TpDoc.t()],
    user_id: User.t()
  }

  @allowed_params ~w(
    addon_price
    assigned_id
    book_keeping_id
    business_tax_return_id
    by_pro_status
    end_time
    id_from_stripe_card
    id_from_stripe_transfer
    individual_tax_return_id
    instant_matched
    mailers
    offer_price
    room_id
    sale_tax_id
    service_review_id
    status
    user_id
  )a

  @required_params ~w(
    instant_matched
    status
    user_id
  )a

  schema "projects" do
    field :addon_price, :integer
    field :by_pro_status, :boolean, default: false
    field :end_time, :date
    field :id_from_stripe_card, :string
    field :id_from_stripe_transfer, :string
    field :instant_matched, :boolean
    field :mailers, {:array, :map}, virtual: true
    field :offer_price, :decimal
    field :room_id, FlakeId.Ecto.CompatType
    field :status, ProjectEnum

    belongs_to :assigned, User,
      foreign_key: :assigned_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :book_keeping, BookKeeping,
      foreign_key: :book_keeping_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :business_tax_return, BusinessTaxReturn,
      foreign_key: :business_tax_return_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :individual_tax_return, IndividualTaxReturn,
      foreign_key: :individual_tax_return_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :sale_tax, SaleTax,
      foreign_key: :sale_tax_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    belongs_to :service_review, ServiceReview,
      foreign_key: :service_review_id, type: FlakeId.Ecto.CompatType, references: :id

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    has_many :addons, Addon, on_delete: :delete_all
    has_many :offers, Offer, on_delete: :delete_all
    has_many :pro_docs, ProDoc, on_delete: :delete_all
    has_many :tp_docs, TpDoc, on_delete: :delete_all

    many_to_many :pro_ratings, ProRating, join_through: "pro_ratings_projects", on_replace: :delete
    many_to_many :plaid_accounts, PlaidAccount, join_through: "plaid_accounts_projects", on_replace: :delete

    timestamps()
  end

  @doc """
  Create changeset for the Project.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:assigned_id, message: "Select an User's role Pro")
    |> foreign_key_constraint(:book_keeping_id, message: "Select a Service BookKeeping")
    |> foreign_key_constraint(:business_tax_return_id, message: "Select a Service BusinessTaxReturn")
    |> foreign_key_constraint(:id_from_stripe_card, message: "Select the StripeCard")
    |> foreign_key_constraint(:id_from_stripe_transfer, message: "Select the StripeTransfer")
    |> foreign_key_constraint(:individual_tax_return_id, message: "Select a Service IndividualTaxReturn")
    |> foreign_key_constraint(:sale_tax_id, message: "Select a Service SaleTax")
    |> foreign_key_constraint(:user_id, message: "Select an User")
    |> unique_constraint(:book_keeping_id, name: :book_keeping_id_unique_index)
    |> unique_constraint(:business_tax_return_id, name: :business_tax_return_id_unique_index)
    |> unique_constraint(:individual_tax_return_id, name: :individual_tax_return_id_unique_index)
    |> unique_constraint(:sale_tax_id, name: :sale_tax_id_unique_index)
  end
end
