defmodule GraphicsWeb.UserLive.Login do
  use GraphicsWeb, :live_view

  alias Graphics.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.public_nav flash={@flash} current_scope={@current_scope} />

    <main style="min-height:100vh;background:var(--bg);display:flex;align-items:center;justify-content:center;padding:5rem 1.5rem;">
      <div style="width:100%;max-width:900px;display:grid;grid-template-columns:1fr 1fr;border-radius:24px;overflow:hidden;border:0.5px solid var(--border);">

        <%!-- LEFT: atmospheric photo panel --%>
        <div style="background:#1a1a18;position:relative;min-height:560px;display:flex;flex-direction:column;justify-content:space-between;padding:2.5rem;">

          <%!-- Background image - swap src once you have a real photo --%>
          <img
            src="/images/hero-photographer.jpg"
            alt=""
            aria-hidden="true"
            style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:0.45;"
          />

          <%!-- Dark overlay --%>
          <div style="position:absolute;inset:0;background:linear-gradient(160deg,rgba(26,26,24,0.5) 0%,rgba(10,10,10,0.85) 100%);"></div>

          <%!-- Top copy --%>
          <div style="position:relative;z-index:2;">
            <p style="font-size:0.65rem;font-weight:600;letter-spacing:0.28em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">
              Click for your shoot
            </p>
            <h2 style="font-family:'DM Serif Display',serif;font-size:2.4rem;font-style:italic;color:var(--white);line-height:1.1;">
              Photography.
            </h2>
          </div>

          <%!-- Centre lens decoration --%>
          <div style="position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);z-index:2;pointer-events:none;">
            <div style="width:180px;height:180px;border-radius:50%;border:1px solid rgba(224,92,58,0.25);display:flex;align-items:center;justify-content:center;">
              <div style="width:124px;height:124px;border-radius:50%;border:1px solid rgba(224,92,58,0.2);display:flex;align-items:center;justify-content:center;">
                <div style="width:76px;height:76px;border-radius:50%;background:rgba(224,92,58,0.1);border:1.5px solid rgba(224,92,58,0.45);display:flex;align-items:center;justify-content:center;">
                  <div style="width:34px;height:34px;border-radius:50%;background:var(--accent);opacity:0.6;"></div>
                </div>
              </div>
            </div>
          </div>

          <%!-- Bottom copy --%>
          <div style="position:relative;z-index:2;">
            <p style="font-size:0.6rem;font-weight:600;letter-spacing:0.35em;text-transform:uppercase;color:rgba(255,255,255,0.25);">
              Journey Everywhere
            </p>
          </div>

        </div>

        <%!-- RIGHT: form panel --%>
        <div style="background:var(--bg);padding:3rem 2.5rem;display:flex;flex-direction:column;justify-content:center;">

          <%!-- Heading --%>
          <p style="font-size:0.68rem;font-weight:600;letter-spacing:0.25em;text-transform:uppercase;color:var(--accent);margin-bottom:0.6rem;">
            Welcome Back
          </p>
          <h1 style="font-family:'Bebas Neue',sans-serif;font-size:1.6rem;letter-spacing:0.15em;color:#1a1a18;text-decoration:none;">
            <%= if @current_scope, do: "Reauthenticate", else: "LogIn" %>
          </h1>
          <p style="font-size:0.82rem;color:var(--muted);margin-bottom:2rem;">
            <%= if @current_scope do %>
              Confirm your credentials to continue.
            <% else %>  
              No account yet?
              <.link navigate={~p"/users/register"} style="color:var(--accent);font-weight:600;text-decoration:none;">
                Sign up here
              </.link>
            <% end %>
          </p>

          <%!-- Form --%>
          <.form
            :let={f}
            for={@form}
            id="login_form_password"
            action={~p"/users/log-in"}
            phx-submit="submit_password"
            phx-trigger-action={@trigger_submit}
          >
            <%!-- Email --%>
            <div style="margin-bottom:1.1rem;">
              <label style="display:block;font-size:0.65rem;font-weight:600;text-transform:uppercase;letter-spacing:0.15em;color:var(--muted);margin-bottom:0.35rem;">
                Email
              </label>
              <.input
                readonly={!!@current_scope}
                field={f[:email]}
                type="email"
                autocomplete="username"
                spellcheck="false"
                required
                phx-mounted={JS.focus()}
                class="w-full"
                style="background:var(--white);border:0.5px solid var(--border);color:var(--text);padding:0.85rem 1rem;border-radius:10px;font-size:0.88rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color 0.2s;width:100%;"
              />
            </div>

            <%!-- Password --%>
            <div style="margin-bottom:0.5rem;">
              <label style="display:block;font-size:0.65rem;font-weight:600;text-transform:uppercase;letter-spacing:0.15em;color:var(--muted);margin-bottom:0.35rem;">
                Password
              </label>
              <.input
                field={@form[:password]}
                type="password"
                autocomplete="current-password"
                spellcheck="false"
                style="background:var(--white);border:0.5px solid var(--border);color:var(--text);padding:0.85rem 1rem;border-radius:10px;font-size:0.88rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color 0.2s;width:100%;"
              />
            </div>

            <%!-- Forgot --%>
            <div style="text-align:right;margin-bottom:1.8rem;">
              <.link
                navigate={~p"/users/reset-password"}
                style="font-size:0.75rem;color:var(--muted);text-decoration:none;"
              >
                Forgot your password?
              </.link>
            </div>

            <%!-- Primary CTA --%>
            <button
              type="submit"
              name={@form[:remember_me].name}
              value="true"
              style="width:100%;background:var(--text);color:var(--white);padding:0.9rem 1.5rem;border-radius:10px;font-size:0.8rem;font-weight:600;text-transform:uppercase;letter-spacing:0.1em;border:none;cursor:pointer;margin-bottom:0.75rem;transition:background 0.2s;"
            >
              Log In &amp; Stay Logged In →
            </button>

            <%!-- Secondary CTA --%>
            <button
              type="submit"
              style="width:100%;background:transparent;color:var(--text);padding:0.88rem 1.5rem;border-radius:10px;font-size:0.8rem;font-weight:600;text-transform:uppercase;letter-spacing:0.1em;border:1.5px solid var(--border);cursor:pointer;transition:all 0.2s;"
            >
              This Session Only
            </button>
          </.form>

          <%!-- Flash messages --%>
          <div :if={Phoenix.Flash.get(@flash, :info)} style="margin-top:1.25rem;background:rgba(224,92,58,0.07);border:0.5px solid rgba(224,92,58,0.3);border-radius:10px;padding:0.85rem 1rem;">
            <p style="font-size:0.82rem;color:var(--accent);">{Phoenix.Flash.get(@flash, :info)}</p>
          </div>
          <div :if={Phoenix.Flash.get(@flash, :error)} style="margin-top:1.25rem;background:rgba(224,92,58,0.07);border:0.5px solid rgba(224,92,58,0.3);border-radius:10px;padding:0.85rem 1rem;">
            <p style="font-size:0.82rem;color:var(--accent);">{Phoenix.Flash.get(@flash, :error)}</p>
          </div>

        </div>
      </div>
    </main>

    <Layouts.public_footer />
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end
end
