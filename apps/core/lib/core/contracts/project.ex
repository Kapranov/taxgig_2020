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
    Contracts.ProjectDoc,
    Services.BookKeeping,
    Services.BusinessTaxReturn,
    Services.IndividualTaxReturn,
    Services.SaleTax,
    Talk.Message
  }

  @type t :: %__MODULE__{
    addon_price: integer,
    addons: Addon.t(),
    assigned_pro: FlakeId.Ecto.Type,
    book_keeping_id: BookKeeping.t(),
    business_tax_return_id: BusinessTaxReturn.t(),
    end_time: DateTime.t(),
    id_from_stripe_card: String.t(),
    id_from_stripe_transfer: String.t(),
    individual_tax_return_id: IndividualTaxReturn.t(),
    instant_matched: boolean,
    messages: [Message.t()],
    offer_price: integer,
    offers: Offer.t(),
    pro_ratings: [ProRating.t()],
    project_docs: [ProjectDoc.t()],
    sale_tax_id: SaleTax.t(),
    status: String.t(),
    user_id: User.t()
  }

  @allowed_params ~w(
    addon_price
    assigned_pro
    book_keeping_id
    business_tax_return_id
    end_time
    id_from_stripe_card
    id_from_stripe_transfer
    individual_tax_return_id
    instant_matched
    offer_price
    sale_tax_id
    status
    user_id
  )a

  @required_params ~w(
    addon_price
    instant_matched
    status
    user_id
  )a

  schema "projects" do
    field :addon_price, :integer, null: false
    field :assigned_pro, FlakeId.Ecto.Type, null: true
    field :end_time, :date, null: true
    field :id_from_stripe_card, :string, null: true
    field :id_from_stripe_transfer, :string, null: true
    field :instant_matched, :boolean, null: false
    field :offer_price, :integer, null: true
    field :status, ProjectEnum, null: false

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

    belongs_to :users, User,
      foreign_key: :user_id,
      type: FlakeId.Ecto.CompatType,
      references: :id

    has_many :addons, Addon, on_delete: :delete_all
    has_many :messages, Message, on_delete: :delete_all
    has_many :offers, Offer, on_delete: :delete_all
    has_many :project_docs, ProjectDoc, on_delete: :delete_all

    many_to_many :pro_ratings, ProRating, join_through: "pro_ratings_projects", on_replace: :delete

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
