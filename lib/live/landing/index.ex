defmodule GraphicsWeb.Landing.Index do
  use GraphicsWeb, :live_view

  alias Graphics.Context.CxtBooking
  alias Graphics.Context.CxtQuotation
  alias Graphics.Booking
  alias Graphics.Quotation

  # ── Mount ────────────────────────────────────────────────────

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Jaguar Photography")
     |> assign(:submitted_booking, false)
     |> assign(:booking_name, nil)
     |> assign(:saved_quotation_id, nil)
     |> assign(:saved_quotation_number, nil)
     |> assign_booking_form(CxtBooking.change_booking(%Booking{}))
     |> assign_quote_defaults()}
  end

  # ── Quote events ─────────────────────────────────────────────

  @impl true
  def handle_event("calculate_quote", params, socket) do
    service_type   = Map.get(params, "service_type", "")
    hours          = Map.get(params, "hours", "1") |> parse_hours()
    drone_coverage = Map.get(params, "drone_coverage") == "true"
    videography    = Map.get(params, "videography") == "true"

    amount =
      if service_type == "" do
        Decimal.new("0")
      else
        CxtQuotation.calculate_amount(service_type, hours, drone_coverage, videography)
      end

    {:noreply,
     socket
     |> assign(:quote_service_type, service_type)
     |> assign(:quote_hours, hours)
     |> assign(:quote_drone, drone_coverage)
     |> assign(:quote_video, videography)
     |> assign(:quote_total, amount)}
  end

    @impl true
  def handle_event("save_quotation", _params, socket) do
    attrs = %{
      "service_type"   => socket.assigns.quote_service_type,
      "hours"          => socket.assigns.quote_hours,
      "drone_coverage" => socket.assigns.quote_drone,
      "videography"    => socket.assigns.quote_video,
      "amount"         => socket.assigns.quote_total,
      "status"         => "draft"
    }

    case CxtQuotation.create_quotation(attrs) do
      {:ok, quotation} ->
        {:noreply,
        socket
        |> assign(:saved_quotation_id, quotation.id)
        |> assign(:saved_quotation_number, quotation.quotation_number)
        |> push_event("download_pdf", %{url: "/quotations/#{quotation.id}/pdf"})}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not save quote. Please try again.")}
    end
  end

  # ── Booking events ────────────────────────────────────────────

  @impl true
  def handle_event("validate_booking", %{"booking" => attrs}, socket) do
    changeset =
      %Booking{}
      |> CxtBooking.change_booking(attrs)
      |> Map.put(:action, :validate)

    {:noreply, assign_booking_form(socket, changeset)}
  end

  @impl true
  def handle_event("submit_booking", %{"booking" => attrs}, socket) do
    case CxtBooking.create_booking(attrs) do
      {:ok, booking} ->
        {:noreply,
         socket
         |> assign(:submitted_booking, true)
         |> assign(:booking_name, booking.client_name)
         |> assign_booking_form(CxtBooking.change_booking(%Booking{}))}

      {:error, changeset} ->
        {:noreply, assign_booking_form(socket, changeset)}
    end
  end

  @impl true
  def handle_event("reset_booking", _params, socket) do
    {:noreply,
     socket
     |> assign(:submitted_booking, false)
     |> assign(:booking_name, nil)
     |> assign_booking_form(CxtBooking.change_booking(%Booking{}))}
  end

  # ── Private helpers ───────────────────────────────────────────

  defp assign_booking_form(socket, changeset) do
    assign(socket, :booking_form, to_form(changeset, as: :booking))
  end

  defp assign_quote_defaults(socket) do
    socket
    |> assign(:quote_service_type, "")
    |> assign(:quote_hours, 1)
    |> assign(:quote_drone, false)
    |> assign(:quote_video, false)
    |> assign(:quote_total, Decimal.new("0"))
  end

  defp parse_hours(val) when is_binary(val) do
    case Integer.parse(val) do
      {n, _} when n > 0 -> n
      _                 -> 1
    end
  end
  defp parse_hours(val) when is_integer(val) and val > 0, do: val
  defp parse_hours(_), do: 1
end
