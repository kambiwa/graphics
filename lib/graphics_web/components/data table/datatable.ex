defmodule GraphicsWeb.Datatable.Table do
  use Phoenix.Component
  # alias Phoenix.LiveView.JS

  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns = assign(assigns, :has_actions?, not Enum.empty?(assigns.action))

    ~H"""
    <div class="overflow-y-auto px-4 sm:px-0" id="table-container">
      <table class="min-w-full divide-y divide-gray-200 table rounded-t-lg overflow-hidden">
        <thead class="bg-gradient-to-r from-[#1e2a4a] to-[#2d3c61]">
          <tr class="table-row">
            <th
              :for={col <- @col}
              class="px-3 py-3 text-left text-xs font-medium text-white uppercase tracking-wider whitespace-nowrap"
            >
              {col[:label]}
            </th>

            <%= if @has_actions? do %>
              <th class="px-3 py-3 text-center text-xs font-medium text-white uppercase tracking-wider whitespace-nowrap">
                Actions
              </th>
            <% end %>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="table-row">
            <td
              :for={{col, _i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["px-3 py-3 whitespace-nowrap", @row_click && "hover:cursor-pointer"]}
            >
              {render_slot(col, @row_item.(row))}
            </td>

            <%= if @has_actions? do %>
              <td class="px-3 py-3 whitespace-nowrap text-center">
                <div class="relative">
                  {render_slot(@action, @row_item.(row))}
                </div>
              </td>
            <% end %>
            <%!-- <%= if @has_actions? do %>
              <td class="px-3 py-3 whitespace-nowrap">
                <div class="relative">
                  <!-- Options Button -->
                  <button
                    id={"dropdown-trigger-#{(@row_id && @row_id.(row)) || row.id}"}
                    type="button"
                    phx-click={
                      JS.dispatch("toggle-dropdown",
                        detail: %{id: (@row_id && @row_id.(row)) || row.id}
                      )
                    }
                    class="bg-[#0f172a] hover:bg-amber-500 text-white px-2 py-1 rounded-md text-sm font-medium transition duration-150 ease-in-out"
                  >
                    <i class="fa-solid fa-ellipsis-h"></i>
                  </button>

    <!-- Floating Dropdown -->
                  <div
                    id={"dropdown-menu-#{@row_id && @row_id.(row) || row.id}"}
                    class="hidden absolute z-40 mt-2 w-48 bg-white rounded-md shadow-lg"
                    style="top: 100%; left: 50%; transform: translateX(-50%);"
                  >
                    <!-- Arrow -->
                    <div class="absolute -top-1 left-1/2 transform -translate-x-1/2 w-3 h-3 bg-white rotate-45">
                    </div>

    <!-- Dropdown Content -->
                    <div class="p-2">
                      {render_slot(@action, @row_item.(row))}
                    </div>
                  </div>
                </div>
              </td>
            <% end %> --%>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
