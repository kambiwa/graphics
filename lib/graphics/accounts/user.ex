defmodule Graphics.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field :email, :string

    # Virtual password field
    field :password, :string, virtual: true, redact: true

    # Stored hashed password
    field :hashed_password, :string, redact: true

    # Optional account confirmation
    field :confirmed_at, :utc_datetime

    # Used for sudo mode/session re-authentication
    field :authenticated_at, :utc_datetime, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc """
  Registration changeset.
  Used during account creation.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  @doc """
  Email update changeset.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_format(
      :email,
      ~r/^[^@,;\s]+@[^@,;\s]+$/,
      message: "must have the @ sign and no spaces"
    )
    |> validate_length(:email, max: 160)
    |> maybe_validate_unique_email(opts)
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_unique, true) do
      changeset
      |> unsafe_validate_unique(:email, Graphics.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  @doc """
  Password update changeset.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(
      :password,
      message: "does not match password"
    )
    |> validate_password(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    # Optional stronger password rules:
    # |> validate_format(:password, ~r/[a-z]/,
    #      message: "must contain a lowercase letter")
    # |> validate_format(:password, ~r/[A-Z]/,
    #      message: "must contain an uppercase letter")
    # |> validate_format(:password, ~r/[0-9]/,
    #      message: "must contain a number")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)

    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(
        :hashed_password,
        Bcrypt.hash_pwd_salt(password)
      )
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  Marks account as confirmed.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now(:second)

    change(user, confirmed_at: now)
  end

  @doc """
  Verifies password securely.
  """
  def valid_password?(
        %Graphics.Accounts.User{
          hashed_password: hashed_password
        },
        password
      )
      when is_binary(hashed_password) and
             byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end
end
