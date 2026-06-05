defmodule Graphics.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :client_name, :string
    field :email, :string
    field :phone_number, :string
    field :service_type, :string
    field :event_date, :date
    field :location, :string
    field :notes, :string
    field :status, :string, default: "pending"
    field :assigned_photographer_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:client_name, :email, :phone_number, :service_type, :event_date, :location, :notes, :assigned_photographer_id])
    |> validate_required([:client_name, :phone_number, :service_type, :event_date, :location])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_length(:client_name, min: 2, max: 100)
  end
end
