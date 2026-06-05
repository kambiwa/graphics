defmodule Graphics.Quotation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotations" do
    field :quotation_number, :string
    field :event_date, :date
    field :service_type, :string
    field :hours, :integer, default: 1
    field :drone_coverage, :boolean, default: false
    field :videography, :boolean, default: false
    field :amount, :decimal
    field :status, :string, default: "draft"

    belongs_to :booking, Graphics.Booking
    belongs_to :generated_by, Graphics.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(quotation, attrs) do
    quotation
    |> cast(attrs, [:quotation_number, :event_date, :service_type, :hours, :drone_coverage, :videography, :amount, :status, :booking_id, :generated_by_id])
    |> validate_required([:quotation_number, :service_type, :hours, :amount]) 
    |> validate_inclusion(:service_type, ~w(wedding graduation portrait corporate event))
    |> validate_number(:hours, greater_than: 0)
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_inclusion(:status, ~w(draft sent accepted rejected))
    |> unique_constraint(:quotation_number)
  end
end
