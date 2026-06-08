defmodule GraphicsWeb.Admin.Bookings.Index do
  use GraphicsWeb, :live_view

  alias Graphics.Context.CxtBooking
  alias Graphics.Booking
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Bookings")
     |> assign(:bookings, [])
     |> assign(:filter_expanded, false)
     |> assign(:status_filter, "")
     |> assign(:search_filter, "")
     |> assign(:service_filter, "")
     |> fetch_bookings()}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Booking")
    |> assign(:booking, %Booking{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Booking")
    |> assign(:booking, CxtBooking.get_booking!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Bookings")
    |> assign(:booking, nil)
  end

  @impl true
  def handle_event("toggle-filter", _, socket) do
    {:noreply, assign(socket, :filter_expanded, !socket.assigns.filter_expanded)}
  end

  @impl true
  def handle_event("filter", %{"filter" => filters}, socket) do
    {:noreply,
     socket
     |> assign(:status_filter, filters["status_filter"] || "")
     |> assign(:search_filter, filters["search_filter"] || "")
     |> assign(:service_filter, filters["service_filter"] || "")
     |> fetch_bookings()}
  end

  @impl true
  def handle_event("delete_booking", %{"id" => id}, socket) do
    booking = CxtBooking.get_booking!(id)
    {:ok, _} = CxtBooking.delete_booking(booking)
    {:noreply, fetch_bookings(socket)}
  end

  @impl true
  def handle_info({GraphicsWeb.Admin.Bookings.FormComponent, {:saved, _booking}}, socket) do
    {:noreply, fetch_bookings(socket)}
  end

  defp fetch_bookings(socket) do
    filters = %{
      status:  socket.assigns.status_filter,
      search:  socket.assigns.search_filter,
      service: socket.assigns.service_filter
    }

    assign(socket, :bookings, CxtBooking.list_bookings(filters))
  end

  defp status_class("pending"),   do: "bg-yellow-100 text-yellow-800"
  defp status_class("confirmed"), do: "bg-green-100  text-green-800"
  defp status_class("cancelled"), do: "bg-red-100    text-red-800"
  defp status_class(_),           do: "bg-gray-100   text-gray-800"

  @impl true
@impl true
def render(assigns) do
  ~H"""
  <Layouts.admin_side_nav current_scope={@current_scope} active={:bookings} />
  <Layouts.admin_top_navbar page_title="Bookings" current_scope={@current_scope} />

  <main class="ml-[180px] pt-16 min-h-screen bg-gray-100 p-6">

    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between mb-6 gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900">Bookings</h1>
        <p class="text-sm text-gray-500 mt-1">{length(@bookings)} total bookings</p>
      </div>
      <div class="flex items-center gap-3">
        <button
          phx-click="toggle-filter"
          class="inline-flex items-center px-4 py-2 text-sm font-semibold text-white bg-gradient-to-r from-[#1e2a4a] to-[#2d3c61] rounded-lg hover:opacity-90 transition-all"
        >
          <i class="fa-solid fa-filter mr-2"></i> Filter
        </button>
        <.link
          patch={~p"/admin/bookings/new"}
          class="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-[#E05C3A] rounded-lg hover:bg-[#c94e2e] transition-colors"
        >
          <i class="fas fa-plus mr-2"></i> New Booking
        </.link>
      </div>
    </div>

    <!-- Filter Panel -->
    <div class={[
      "overflow-hidden transition-all duration-500 ease-in-out mb-6",
      @filter_expanded && "max-h-96 opacity-100",
      !@filter_expanded && "max-h-0 opacity-0"
    ]}>
      <div class="bg-white shadow rounded-lg p-6 relative">
        <div class="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-[#E05C3A] to-[#c94e2e] rounded-t-lg"></div>
        <.form for={%{}} as={:filter} phx-change="filter" class="space-y-4">
          <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Search</label>
              <.input name="filter[search_filter]" placeholder="Name, email, location…" value={@search_filter} />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
              <.input
                type="select"
                name="filter[status_filter]"
                prompt="-- All --"
                options={[{"Pending", "pending"}, {"Confirmed", "confirmed"}, {"Cancelled", "cancelled"}]}
                value={@status_filter}
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-1">Service Type</label>
              <.input
                type="select"
                name="filter[service_filter]"
                prompt="-- All --"
                options={[{"Wedding", "wedding"}, {"Graduation", "graduation"}, {"Portrait", "portrait"}, {"Corporate", "corporate"}, {"Event", "event"}]}
                value={@service_filter}
              />
            </div>
          </div>
        </.form>
      </div>
    </div>

    <!-- Table -->
    <div class="bg-white shadow rounded-lg overflow-hidden">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Client</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Service</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Event Date</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Location</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Booked</th>
            <th class="relative px-6 py-3"><span class="sr-only">Actions</span></th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <%= if Enum.empty?(@bookings) do %>
            <tr>
              <td colspan="7" class="px-6 py-12 text-center text-gray-400">
                <i class="fa-solid fa-calendar-xmark text-3xl mb-2 block"></i>
                No bookings found
              </td>
            </tr>
          <% else %>
            <%= for booking <- @bookings do %>
              <tr class="hover:bg-gray-50 transition-colors">
                <td class="px-6 py-4">
                  <div class="font-medium text-gray-900">{booking.client_name}</div>
                  <div class="text-sm text-gray-500">{booking.email}</div>
                  <div class="text-sm text-gray-500">{booking.phone_number}</div>
                </td>
                <td class="px-6 py-4 text-sm text-gray-700 capitalize">{booking.service_type}</td>
                <td class="px-6 py-4 text-sm text-gray-700">
                  {Calendar.strftime(booking.event_date, "%d %b %Y")}
                </td>
                <td class="px-6 py-4 text-sm text-gray-700">{booking.location}</td>
                <td class="px-6 py-4">
                  <span class={"inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{status_class(booking.status)}"}>
                    {String.capitalize(booking.status)}
                  </span>
                </td>
                <td class="px-6 py-4 text-sm text-gray-500">
                  {Calendar.strftime(booking.inserted_at, "%d %b %Y")}
                </td>
                <td class="px-6 py-4 text-right text-sm font-medium space-x-2 whitespace-nowrap">
                  <.link
                    patch={~p"/admin/bookings/#{booking.id}/edit"}
                    class="inline-flex items-center px-3 py-1.5 text-xs font-medium rounded-md text-amber-700 bg-amber-100 hover:bg-amber-200"
                  >
                    <i class="fa-solid fa-pen w-3 h-3 mr-1"></i> Edit
                  </.link>
                  <button
                    phx-click="delete_booking"
                    phx-value-id={booking.id}
                    data-confirm="Delete this booking?"
                    class="inline-flex items-center px-3 py-1.5 text-xs font-medium rounded-md text-red-700 bg-red-100 hover:bg-red-200"
                  >
                    <i class="fa-solid fa-trash w-3 h-3 mr-1"></i> Delete
                  </button>
                </td>
              </tr>
            <% end %>
          <% end %>
        </tbody>
      </table>
    </div>

    <!-- Modal: New / Edit -->
    <%= if @live_action in [:new, :edit] do %>
      <.modal id="booking-modal" show on_cancel={JS.patch(~p"/admin/bookings")}>
        <.live_component
          module={GraphicsWeb.Admin.Bookings.FormComponent}
          id={@booking.id || :new}
          title={@page_title}
          action={@live_action}
          booking={@booking}
          patch={~p"/admin/bookings"}
        />
      </.modal>
    <% end %>

  </main>
  """
end
end

