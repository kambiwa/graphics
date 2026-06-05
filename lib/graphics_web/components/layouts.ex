defmodule GraphicsWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use GraphicsWeb, :html

  embed_templates "layouts/*"

  @doc """
  Renders the admin sidebar navigation.

  ## Examples

      <Layouts.admin_side_nav current_scope={@current_scope} active={:dashboard} />

  """
  attr :current_scope, :map, default: nil
  attr :active, :atom, default: :dashboard

  def admin_side_nav(assigns) do
    ~H"""
    <aside style="width:240px;background:#1a1a18;display:flex;flex-direction:column;height:100vh;position:fixed;left:0;top:0;z-index:50;border-right:0.5px solid rgba(255,255,255,0.06);">
      <%!-- Logo --%>
      <div style="padding:1.5rem 1.4rem 1.2rem;border-bottom:0.5px solid rgba(255,255,255,0.07);">
        <a href={~p"/admin/dashboard"} style="text-decoration:none;">
          <span style="font-family:'Bebas Neue',sans-serif;font-size:1.4rem;letter-spacing:0.15em;color:#FAF9F7;">JAGUAR</span>
          <span style="display:block;font-size:0.58rem;font-weight:600;letter-spacing:0.22em;text-transform:uppercase;color:#E05C3A;margin-top:1px;">Admin Panel</span>
        </a>
      </div>

      <%!-- Nav --%>
      <nav style="flex:1;padding:1rem 0;overflow-y:auto;">
        <p style="font-size:0.58rem;font-weight:600;letter-spacing:0.22em;text-transform:uppercase;color:rgba(255,255,255,0.2);padding:0.8rem 1.4rem 0.3rem;">Main</p>

        <.admin_nav_item icon="ti-layout-dashboard" label="Dashboard" href={~p"/admin/dashboard"} active={@active == :dashboard} />
        <.admin_nav_item icon="ti-calendar" label="Bookings" href={~p"/admin/bookings"} active={@active == :bookings} />
        <.admin_nav_item icon="ti-users" label="Clients" href={~p"/admin/clients"} active={@active == :clients} />
        <.admin_nav_item icon="ti-file-text" label="Quotes" href={~p"/admin/quotes"} active={@active == :quotes} />

        <p style="font-size:0.58rem;font-weight:600;letter-spacing:0.22em;text-transform:uppercase;color:rgba(255,255,255,0.2);padding:1.2rem 1.4rem 0.3rem;">Content</p>

        <.admin_nav_item icon="ti-photo" label="Portfolio" href={~p"/admin/portfolio"} active={@active == :portfolio} />
        <.admin_nav_item icon="ti-upload" label="Uploads" href={~p"/admin/uploads"} active={@active == :uploads} />

        <p style="font-size:0.58rem;font-weight:600;letter-spacing:0.22em;text-transform:uppercase;color:rgba(255,255,255,0.2);padding:1.2rem 1.4rem 0.3rem;">System</p>

        <.admin_nav_item icon="ti-settings" label="Settings" href={~p"/admin/users/settings"} active={@active == :settings} />
      </nav>

      <%!-- User footer --%>
      <div style="padding:1rem 1.4rem;border-top:0.5px solid rgba(255,255,255,0.07);display:flex;align-items:center;gap:10px;">
        <div style="width:32px;height:32px;border-radius:50%;background:#E05C3A;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#FAF9F7;flex-shrink:0;">
          <%= if @current_scope && @current_scope.user do %>
            <%= @current_scope.user.email |> String.upcase() |> String.slice(0, 2) %>
          <% else %>
            JG
          <% end %>
        </div>
        <div style="flex:1;min-width:0;">
          <p style="font-size:0.72rem;font-weight:600;color:#FAF9F7;margin:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
            <%= if @current_scope && @current_scope.user, do: @current_scope.user.email, else: "Admin" %>
          </p>
          <span style="font-size:0.6rem;color:rgba(255,255,255,0.3);">Administrator</span>
        </div>
        <.link
          href={~p"/users/log-out"}
          method="delete"
          title="Log out"
          style="color:rgba(255,255,255,0.25);font-size:15px;flex-shrink:0;"
        >
          <i class="ti ti-logout" aria-label="Log out"></i>
        </.link>
      </div>
    </aside>
    """
  end

  attr :icon, :string, required: true
  attr :label, :string, required: true
  attr :href, :string, required: true
  attr :active, :boolean, default: false

  defp admin_nav_item(assigns) do
    ~H"""
    <.link
      navigate={@href}
      style={
        "display:flex;align-items:center;gap:10px;padding:0.55rem 1.4rem;" <>
        "font-size:0.78rem;text-decoration:none;border-left:2px solid transparent;transition:all 0.15s;" <>
        if(@active,
          do: "color:#FAF9F7;border-left-color:#E05C3A;background:rgba(224,92,58,0.09);",
          else: "color:rgba(255,255,255,0.4);"
        )
      }
    >
      <i class={"ti #{@icon}"} aria-hidden="true" style="font-size:16px;"></i>
      <%= @label %>
    </.link>
    """
  end

  @doc """
  Renders the admin top bar.

  ## Examples

      <Layouts.admin_top_bar page_title="Dashboard Overview" current_scope={@current_scope} />

  """
  attr :page_title, :string, default: "Dashboard"
  attr :current_scope, :map, default: nil


     def admin_top_navbar(assigns) do
      ~H"""
      <header style="height:64px;display:flex;align-items:center;justify-content:space-between;padding:0 2rem;background:#FAF9F7;border-bottom:0.5px solid rgba(26,26,24,0.1);position:sticky;top:0;z-index:40;margin:0;">
      <div class="flex items-center">
        <h1 style="font-family:'Bebas Neue',sans-serif;font-size:1.4rem;letter-spacing:0.12em;color:#1a1a18;margin:0;">
          {@page_title}
        </h1>
      </div>

      <div style="display:flex;align-items:center;gap:1.5rem;">
        <%!-- Notifications --%>
        <.live_component
          module={GraphicsWeb.NotificationBellComponent}
          id="admin-notification-bell"
          current_scope={@current_scope}
          role={:admin}
        />

        <%!-- Profile dropdown --%>
        <div style="position:relative;" id="admin-menu-container">
          <button
            type="button"
            phx-click={toggle_user_dropdown("#admin-dropdown-menu")}
            style="display:flex;align-items:center;gap:10px;padding:6px 14px;border-radius:8px;background:rgba(26,26,24,0.05);border:0.5px solid rgba(26,26,24,0.12);cursor:pointer;"
          >
            <div style="width:34px;height:34px;border-radius:50%;background:#E05C3A;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#FAF9F7;flex-shrink:0;">
              <%= @current_scope.user.email |> String.upcase() |> String.slice(0, 2) %>
            </div>
            <div style="text-align:left;">
              <p style="font-size:0.78rem;font-weight:600;color:#1a1a18;margin:0;white-space:nowrap;">
                <%= @current_scope.user.email |> String.split("@") |> List.first() |> String.capitalize() %>
              </p>
              <p style="font-size:0.62rem;color:#6b6b67;margin:0;white-space:nowrap;">
                <%= @current_scope.user.email %>
              </p>
            </div>
            <i class="ti ti-chevron-down" aria-hidden="true" style="font-size:14px;color:#6b6b67;"></i>
          </button>

          <%!-- Dropdown --%>
          <div
            id="admin-dropdown-menu"
            class="hidden"
            style="position:absolute;right:0;top:calc(100% + 6px);width:220px;background:#FAF9F7;border:0.5px solid rgba(26,26,24,0.12);border-radius:10px;box-shadow:0 8px 24px rgba(0,0,0,0.08);z-index:50;overflow:hidden;"
          >
            <div style="padding:0.75rem 1rem;border-bottom:0.5px solid rgba(26,26,24,0.08);">
              <p style="font-size:0.72rem;font-weight:600;color:#1a1a18;margin:0;">
                <%= @current_scope.user.email |> String.split("@") |> List.first() |> String.capitalize() %>
              </p>
              <p style="font-size:0.62rem;color:#6b6b67;margin:2px 0 0;">
                <%= @current_scope.user.email %>
              </p>
            </div>

            <.link
              navigate={~p"/admin/users/settings"}
              style="display:flex;align-items:center;gap:8px;padding:0.6rem 1rem;font-size:0.78rem;color:#1a1a18;text-decoration:none;"
            >
              <i class="ti ti-settings" aria-hidden="true" style="font-size:15px;color:#6b6b67;"></i>
              Account Settings
            </.link>

            <div style="height:0.5px;background:rgba(26,26,24,0.08);margin:0.25rem 0;"></div>

            <.link
              href={~p"/users/log-out"}
              method="delete"
              style="display:flex;align-items:center;gap:8px;padding:0.6rem 1rem;font-size:0.78rem;color:#E05C3A;text-decoration:none;"
            >
              <i class="ti ti-logout" aria-hidden="true" style="font-size:15px;"></i>
              Log out
            </.link>
          </div>
        </div>
      </div>
    </header>
    """
  end

  attr :current_scope, :map, default: nil
  def public_nav(assigns) do
    ~H"""
    <nav id="navbar" style="position:fixed;top:0;left:0;right:0;z-index:100;background:rgba(237,236,234,0.88);backdrop-filter:blur(14px);border-bottom:0.5px solid rgba(26,26,24,0.12);display:flex;align-items:center;justify-content:space-between;padding:0 4rem;height:64px;">
      <a href={"/"} style="font-family:'Bebas Neue',sans-serif;font-size:1.6rem;letter-spacing:0.15em;color:#1a1a18;text-decoration:none box-shadow: 0 1px 20px rgba(26,26,24,0.08), 0 1px 4px rgba(26,26,24,0.06);;">
        JAGUAR
      </a>
      <div style="display:flex;gap:2.5rem;" class="hidden md:flex">
        <a href="#about" class="nav-link" style="font-size:0.82rem;font-weight:500;letter-spacing:0.05em;text-transform:uppercase;color:#6b6b67;text-decoration:none;">About</a>
        <a href="#services" class="nav-link" style="font-size:0.82rem;font-weight:500;letter-spacing:0.05em;text-transform:uppercase;color:#6b6b67;text-decoration:none;">Services</a>
        <a href="#portfolio" class="nav-link" style="font-size:0.82rem;font-weight:500;letter-spacing:0.05em;text-transform:uppercase;color:#6b6b67;text-decoration:none;">Portfolio</a>
        <a href="#pricing" class="nav-link" style="font-size:0.82rem;font-weight:500;letter-spacing:0.05em;text-transform:uppercase;color:#6b6b67;text-decoration:none;">Pricing</a>
        <a href="#booking" class="nav-cta">Book Now</a>
        <%= if @current_scope do %>
          <a href={~p"/users/settings"} class="nav-link" style="...">Settings</a>
          <a href={~p"/users/log-out"} method="delete" class="nav-link" style="...">Log out</a>
        <% else %>
          <a href="/users/log-in" class="nav-link" style="font-size:0.82rem;font-weight:500;letter-spacing:0.05em;text-transform:uppercase;color:#6b6b67;text-decoration:none;">Login</a>
        <% end %>
      </div>
      <button id="mobile-menu-btn" class="md:hidden" style="color:#1a1a18;" aria-label="Open menu">
        <i data-lucide="menu" class="w-7 h-7"></i>
      </button>
    </nav>
    """
  end

  @doc """
  Renders the public-facing footer for the landing page.

  ## Examples

      <Layouts.public_footer />

  """
  def public_footer(assigns) do
    ~H"""
    <footer>
      <p style="font-family:'Bebas Neue',sans-serif;font-size:1.2rem;letter-spacing:0.1em;">
        JAGUAR PHOTOGRAPHY
      </p>
      <p>© 2026 Jaguar Photography · Lusaka, Zambia</p>
      <div class="footer-links">
        <a href="#">facebook</a>
        <a href="#">WhatsApp</a>
        <a href="#">Twitter</a>
        <a href="#">Instagram</a>
      </div>
    </footer>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_scope, :map, default: nil, doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"
  slot :inner_block, required: true



  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end


end
