defmodule GraphicsWeb.Admin.Dashboard.Index do
  use GraphicsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
     <div style="display:flex;min-height:100vh;background:#EDECEA;">
      <Layouts.admin_side_nav current_scope={@current_scope} active={:dashboard} />
      <div style="flex:1;margin-left:240px;display:flex;flex-direction:column;min-height:100vh;margin-top:0;">
        <Layouts.admin_top_navbar page_title="Dashboard Overview" current_scope={@current_scope} />
        <main style="flex:1;padding:2rem;display:flex;flex-direction:column;gap:1.5rem;">
          <%!-- ── STAT CARDS ── --%>
          <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:1rem;">
            <.stat_card label="Total Bookings" value="48"      delta="↑ 12% this month" delta_up={true} />
            <.stat_card label="Revenue"        value="K84,200" delta="↑ 8% this month"  delta_up={true} />
            <.stat_card label="Quote Requests" value="17"      delta="3 pending review"  delta_up={false} />
            <.stat_card label="Active Clients" value="31"      delta="↑ 5 new this month" delta_up={true} />
          </div>
          <%!-- ── MID ROW: bookings + quotes --%>
          <div style="display:grid;grid-template-columns:1.4fr 1fr;gap:1rem;">
            <%!-- Recent Bookings --%>
            <div style="background:#FAF9F7;border:0.5px solid rgba(26,26,24,0.1);border-radius:14px;padding:1.4rem;">
              <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.1rem;">
                <p style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.14em;color:#1a1a18;margin:0;">Recent Bookings</p>
                <.link navigate={~p"/admin/bookings"} style="font-size:0.7rem;color:#E05C3A;text-decoration:none;">View all →</.link>
              </div>
              <.booking_row initials="TM" name="Thandiwe Mwale"  type="Wedding"   date="Jun 14" status="confirmed" />
              <.booking_row initials="BK" name="Bwalya Kapasa"   type="Graduation" date="Jun 18" status="pending" />
              <.booking_row initials="AN" name="Aaron Njobvu"    type="Corporate"  date="Jun 22" status="confirmed" />
              <.booking_row initials="CM" name="Chanda Mutale"   type="Portrait"   date="Jun 25" status="new" />
              <.booking_row initials="LZ" name="Lombe Zulu"      type="Wedding"    date="Jul 2"  status="pending" />
            </div>

            <%!-- Quote Requests --%>
            <div style="background:#FAF9F7;border:0.5px solid rgba(26,26,24,0.1);border-radius:14px;padding:1.4rem;">
              <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.1rem;">
                <p style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.14em;color:#1a1a18;margin:0;">Quote Requests</p>
                <.link navigate={~p"/admin/quotes"} style="font-size:0.7rem;color:#E05C3A;text-decoration:none;">View all →</.link>
              </div>
              <.quote_row service="Wedding Package"  amount="K3,500" />
              <.quote_row service="Drone + Video"    amount="K5,300" />
              <.quote_row service="Portrait Session" amount="K800" />
              <.quote_row service="Corporate Event"  amount="K2,500" />
              <.quote_row service="Elite Package"    amount="K6,500" />
            </div>
          </div>

          <%!-- ── BOTTOM ROW: clients + portfolio --%>
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">

            <%!-- Recent Clients --%>
            <div style="background:#FAF9F7;border:0.5px solid rgba(26,26,24,0.1);border-radius:14px;padding:1.4rem;">
              <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.1rem;">
                <p style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.14em;color:#1a1a18;margin:0;">Recent Clients</p>
                <.link navigate={~p"/admin/clients"} style="font-size:0.7rem;color:#E05C3A;text-decoration:none;">View all →</.link>
              </div>
              <.client_row initials="TM" name="Thandiwe Mwale" email="thandiwe@email.com"  joined="Jun 1" />
              <.client_row initials="AN" name="Aaron Njobvu"   email="aaron@email.com"     joined="May 28" />
              <.client_row initials="BK" name="Bwalya Kapasa"  email="bwalya@email.com"    joined="May 22" />
              <.client_row initials="LZ" name="Lombe Zulu"     email="lombe@email.com"     joined="May 18" />
            </div>

            <%!-- Portfolio Uploads --%>
            <div style="background:#FAF9F7;border:0.5px solid rgba(26,26,24,0.1);border-radius:14px;padding:1.4rem;">
              <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:1.1rem;">
                <p style="font-size:0.7rem;font-weight:700;text-transform:uppercase;letter-spacing:0.14em;color:#1a1a18;margin:0;">Portfolio Uploads</p>
                <.link navigate={~p"/admin/portfolio"} style="font-size:0.7rem;color:#E05C3A;text-decoration:none;">Manage →</.link>
              </div>
              <div style="display:grid;grid-template-columns:repeat(5,1fr);gap:8px;">
                <div style="aspect-ratio:1;border-radius:8px;background:#D8D6D2;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#C8C5BE;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#B8B5AE;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#D0CDC8;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#C0BDB8;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#CBCAC5;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#D4D2CE;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#BFC0BC;"></div>
                <div style="aspect-ratio:1;border-radius:8px;background:#C5C3BE;"></div>
                <.link
                  navigate={~p"/admin/uploads"}
                  style="aspect-ratio:1;border-radius:8px;border:1.5px dashed rgba(26,26,24,0.2);display:flex;align-items:center;justify-content:center;color:#6b6b67;font-size:18px;text-decoration:none;"
                >
                  <i class="ti ti-plus" aria-hidden="true"></i>
                </.link>
              </div>
              <p style="font-size:0.68rem;color:#6b6b67;margin-top:0.75rem;">9 photos · Last upload 2 days ago</p>
            </div>
          </div>

        </main>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Dashboard")}
  end

  # ── Private components ────────────────────────────────────────

  attr :label,    :string, required: true
  attr :value,    :string, required: true
  attr :delta,    :string, required: true
  attr :delta_up, :boolean, default: true

  defp stat_card(assigns) do
    ~H"""
    <div style="background:#FAF9F7;border:0.5px solid rgba(26,26,24,0.1);border-radius:14px;padding:1.2rem 1.4rem;">
      <p style="font-size:0.62rem;font-weight:600;text-transform:uppercase;letter-spacing:0.15em;color:#6b6b67;margin:0 0 6px;">
        <%= @label %>
      </p>
      <p style="font-family:'Bebas Neue',sans-serif;font-size:2.2rem;color:#1a1a18;margin:0;line-height:1;letter-spacing:0.02em;">
        <%= @value %>
      </p>
      <p style={"font-size:0.68rem;margin:6px 0 0;#{if @delta_up, do: "color:#16a34a;", else: "color:#E05C3A;"}"}>
        <%= @delta %>
      </p>
    </div>
    """
  end

  attr :initials, :string, required: true
  attr :name,     :string, required: true
  attr :type,     :string, required: true
  attr :date,     :string, required: true
  attr :status,   :string, required: true

  defp booking_row(assigns) do
    ~H"""
    <div style="display:flex;align-items:center;gap:10px;padding:0.5rem 0;border-bottom:0.5px solid rgba(26,26,24,0.07);">
      <div style="width:30px;height:30px;border-radius:50%;background:#E4E2DF;font-size:10px;font-weight:700;color:#6b6b67;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
        <%= @initials %>
      </div>
      <div style="flex:1;min-width:0;">
        <p style="font-size:0.78rem;font-weight:600;color:#1a1a18;margin:0;"><%= @name %></p>
        <p style="font-size:0.65rem;color:#6b6b67;margin:0;"><%= @type %> · <%= @date %></p>
      </div>
      <span style={
        "font-size:0.58rem;font-weight:700;padding:3px 8px;border-radius:999px;text-transform:uppercase;letter-spacing:0.08em;" <>
        case @status do
          "confirmed" -> "background:#d1fae5;color:#065f46;"
          "pending"   -> "background:#fef3c7;color:#92400e;"
          _           -> "background:#fee2e2;color:#991b1b;"
        end
      }>
        <%= @status %>
      </span>
    </div>
    """
  end

  attr :service, :string, required: true
  attr :amount,  :string, required: true

  defp quote_row(assigns) do
    ~H"""
    <div style="display:flex;justify-content:space-between;align-items:center;padding:0.5rem 0;border-bottom:0.5px solid rgba(26,26,24,0.07);">
      <p style="font-size:0.78rem;color:#1a1a18;margin:0;"><%= @service %></p>
      <span style="font-size:0.78rem;font-weight:700;color:#E05C3A;"><%= @amount %></span>
    </div>
    """
  end

  attr :initials, :string, required: true
  attr :name,     :string, required: true
  attr :email,    :string, required: true
  attr :joined,   :string, required: true

  defp client_row(assigns) do
    ~H"""
    <div style="display:flex;align-items:center;gap:10px;padding:0.5rem 0;border-bottom:0.5px solid rgba(26,26,24,0.07);">
      <div style="width:30px;height:30px;border-radius:50%;background:#E4E2DF;font-size:10px;font-weight:700;color:#6b6b67;display:flex;align-items:center;justify-content:center;flex-shrink:0;">
        <%= @initials %>
      </div>
      <div style="flex:1;min-width:0;">
        <p style="font-size:0.78rem;font-weight:600;color:#1a1a18;margin:0;"><%= @name %></p>
        <p style="font-size:0.65rem;color:#6b6b67;margin:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;"><%= @email %></p>
      </div>
      <span style="font-size:0.65rem;color:#6b6b67;white-space:nowrap;">Joined <%= @joined %></span>
    </div>
    """
  end
end
