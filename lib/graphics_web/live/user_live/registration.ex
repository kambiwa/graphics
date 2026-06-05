defmodule GraphicsWeb.UserLive.Registration do
  use GraphicsWeb, :live_view

  alias Graphics.Accounts
  alias Graphics.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.public_nav flash={@flash} current_scope={@current_scope} />

    <main style="min-height:100vh;background:var(--bg);display:flex;align-items:center;justify-content:center;padding:5rem 1.5rem;">
      <div style="width:100%;max-width:900px;display:grid;grid-template-columns:1fr 1fr;border-radius:24px;overflow:hidden;border:0.5px solid var(--border);">

        <%!-- LEFT: photo panel --%>
        <div style="background:#1a1a18;position:relative;min-height:560px;display:flex;flex-direction:column;justify-content:space-between;padding:2.5rem;">

          <img
            src="/images/hero-photographer.jpg"
            alt=""
            aria-hidden="true"
            style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:0.45;"
          />

          <div style="position:absolute;inset:0;background:linear-gradient(160deg,rgba(26,26,24,0.5) 0%,rgba(10,10,10,0.85) 100%);"></div>

          <%!-- Top copy --%>
          <div style="position:relative;z-index:2;">
            <p style="font-size:0.65rem;font-weight:600;letter-spacing:0.28em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">
              Start your journey
            </p>
            <h2 style="font-family:'DM Serif Display',serif;font-size:2.4rem;font-style:italic;color:var(--white);line-height:1.1;">
              Photography.
            </h2>
          </div>

          <%!-- Lens decoration --%>
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

        <%!-- RIGHT: registration form panel --%>
        <div style="background:var(--bg);padding:3rem 2.5rem;display:flex;flex-direction:column;justify-content:center;">

          <%!-- Heading --%>
          <p style="font-size:0.68rem;font-weight:600;letter-spacing:0.25em;text-transform:uppercase;color:var(--accent);margin-bottom:0.6rem;">
            Create Account
          </p>
          <h1 style="font-family:'DM Serif Display',serif;font-size:2.6rem;font-style:italic;color:var(--text);line-height:1.1;margin-bottom:0.5rem;">
            Registration
          </h1>
          <p style="font-size:0.82rem;color:var(--muted);margin-bottom:2rem;">
            Already have an account?
            <.link
              navigate={~p"/users/log-in"}
              style="color:var(--accent);font-weight:600;text-decoration:none;"
            >
              Log in here
            </.link>
          </p>

          <%!-- Form --%>
          <.form
             for={@form}
             id="registration_form"
             phx-submit="save"
             phx-change="validate" >
            <%!-- Email --%>
            <div style="margin-bottom:1.25rem;">
              <label style="display:block;font-size:0.65rem;font-weight:600;text-transform:uppercase;letter-spacing:0.15em;color:var(--muted);margin-bottom:0.35rem;">
                Email
              </label>
              <.input
                field={@form[:email]}
                type="email"
                autocomplete="username"
                spellcheck="false"
                required
                phx-mounted={JS.focus()}
                style="background:var(--white);border:0.5px solid var(--border);color:var(--text);padding:0.85rem 1rem;border-radius:10px;font-size:0.88rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color 0.2s;width:100%;"
              />
            </div>

            <%!-- Password --%>
            <div style="margin-bottom:1.25rem;">
              <label style="display:block;font-size:0.65rem;font-weight:600;text-transform:uppercase;letter-spacing:0.15em;color:var(--muted);margin-bottom:0.35rem;">
                Password
              </label>
              <.input
                field={@form[:password]}
                type="password"
                autocomplete="new-password"
                required
                style="background:var(--white);border:0.5px solid var(--border);color:var(--text);padding:0.85rem 1rem;border-radius:10px;font-size:0.88rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color 0.2s;width:100%;"
              />
            </div>

            <%!-- Password confirmation --%>
            <div style="margin-bottom:1.75rem;">
              <label style="display:block;font-size:0.65rem;font-weight:600;text-transform:uppercase;letter-spacing:0.15em;color:var(--muted);margin-bottom:0.35rem;">
                Confirm Password
              </label>
              <.input
                field={@form[:password_confirmation]}
                type="password"
                autocomplete="new-password"
                required
                style="background:var(--white);border:0.5px solid var(--border);color:var(--text);padding:0.85rem 1rem;border-radius:10px;font-size:0.88rem;font-family:'DM Sans',sans-serif;outline:none;transition:border-color 0.2s;width:100%;"
              />
            </div>

            <%!-- Submit --%>
            <button
              type="submit"
              phx-disable-with="Creating account..."
              style="width:100%;background:var(--text);color:var(--white);padding:0.9rem 1.5rem;border-radius:10px;font-size:0.8rem;font-weight:600;text-transform:uppercase;letter-spacing:0.1em;border:none;cursor:pointer;transition:background 0.2s;"
            >
              Create Account →
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
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: GraphicsWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{}, %{})
    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    IO.inspect(user_params, label: "==============Received registration params")
    case Accounts.register_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully.")
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      Accounts.change_user_registration(%User{}, user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

    @impl true
    def handle_event("create", params, socket) do
      handle_event("save", params, socket)
    end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, form: to_form(changeset, as: "user"))
  end
end
