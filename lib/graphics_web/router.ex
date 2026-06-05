defmodule GraphicsWeb.Router do
  use GraphicsWeb, :router

  import GraphicsWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GraphicsWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # ── Public landing ───────────────────────────────────────────
  scope "/", GraphicsWeb do
    pipe_through :browser

    live "/", Landing.Index, :index
    get "/quotations/:id/pdf", QuotationPdfController, :download
  end

  # ── Dev tools ────────────────────────────────────────────────
  if Application.compile_env(:graphics, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GraphicsWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # ── Auth routes (guest only) ──────────────────────────────────
  # Registration, login, password reset — accessible when logged out.
  # current_scope is still mounted so the templates can read it.
  scope "/", GraphicsWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{GraphicsWeb.UserAuth, :mount_current_scope}] do
      live "/users/register",        UserLive.Registration,    :new
      live "/users/log-in",          UserLive.Login,           :new
      live "/users/reset-password",  UserLive.ResetPassword,   :new
    end

    # Session controller handles the actual form POST + cookie logic
    post "/users/log-in",   UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  # ── Authenticated routes ──────────────────────────────────────
    scope "/admin", GraphicsWeb do
      pipe_through [:browser, :require_authenticated_user]

      live_session :require_authenticated_user,
        on_mount: [{GraphicsWeb.UserAuth, :require_authenticated}] do
        live "/dashboard",  Admin.Dashboard.Index, :index
        live "/bookings",   Admin.Bookings.Index,  :index
        live "/bookings/new", Admin.Bookings.New,  :new
        live "/clients",    Admin.Clients.Index,   :index
        live "/quotes",     Admin.Quotes.Index,    :index
        live "/portfolio",  Admin.Portfolio.Index, :index
        live "/uploads",    Admin.Uploads.Index,   :index
        live "/users/settings", UserLive.Settings, :edit
      end

      post "/users/update-password", UserSessionController, :update_password
    end
end
