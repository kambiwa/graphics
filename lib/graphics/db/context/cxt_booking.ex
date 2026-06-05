defmodule Graphics.Context.CxtBooking do

  alias Graphics.Booking
  import Ecto.Query, warn: false
  alias Graphics.Repo



    def list_bookings(filters \\ %{}) do
      Booking
      |> filter_by_status(filters[:status])
      |> filter_by_service(filters[:service])
      |> filter_by_search(filters[:search])
      |> order_by([b], desc: b.inserted_at)
      |> Repo.all()
    end

    defp filter_by_status(query, status) when status in [nil, ""], do: query
    defp filter_by_status(query, status), do: where(query, [b], b.status == ^status)

    defp filter_by_service(query, service) when service in [nil, ""], do: query
    defp filter_by_service(query, service), do: where(query, [b], b.service_type == ^service)

    defp filter_by_search(query, search) when search in [nil, ""], do: query
    defp filter_by_search(query, search) do
      term = "%#{search}%"
      where(query, [b], ilike(b.client_name, ^term) or ilike(b.email, ^term) or ilike(b.location, ^term))
    end

    def delete_booking(%Booking{} = booking), do: Repo.delete(booking)

  def get_booking!(id), do: Repo.get!(Booking, id)

  def create_booking(attrs \\ %{}) do
    %Booking{}
    |> Booking.changeset(attrs)
    |> Repo.insert()
  end

  def update_booking(%Booking{} = booking, attrs) do
    booking
    |> Booking.changeset(attrs)
    |> Repo.update()
  end

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end

  def change_booking(%Booking{} = booking, attrs \\ %{}) do
    Booking.changeset(booking, attrs)
  end
end
