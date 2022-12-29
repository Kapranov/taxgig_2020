defmodule TalkJob.Contracts.Project do
  @moduledoc """
  Schema for the Project.
  """

  use TalkJob.Model

  @type t :: %__MODULE__{
    addon_price: integer,
    assigned_id: FlakeId.Ecto.CompatType.t(),
    book_keeping_id: FlakeId.Ecto.CompatType.t(),
    business_tax_return_id: FlakeId.Ecto.CompatType.t(),
    by_pro_status: boolean,
    end_time: DateTime.t(),
    id_from_stripe_card: String.t(),
    id_from_stripe_transfer: String.t(),
    individual_tax_return_id: FlakeId.Ecto.CompatType.t(),
    instant_matched: boolean,
    mailers: [%{email: String.t(), user_id: String.t()}],
    offer_price: integer,
    room_id: FlakeId.Ecto.CompatType.t(),
    sale_tax_id: FlakeId.Ecto.CompatType.t(),
    service_review_id: FlakeId.Ecto.CompatType.t(),
    status: String.t(),
    user_id: FlakeId.Ecto.CompatType.t()
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
    field :status, :string
    field :assigned_id, FlakeId.Ecto.CompatType
    field :book_keeping_id, FlakeId.Ecto.CompatType
    field :business_tax_return_id, FlakeId.Ecto.CompatType
    field :individual_tax_return_id, FlakeId.Ecto.CompatType
    field :sale_tax_id, FlakeId.Ecto.CompatType
    field :service_review_id, FlakeId.Ecto.CompatType
    field :user_id, FlakeId.Ecto.CompatType

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
