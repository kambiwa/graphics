defmodule Graphics.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Graphics.Repo

  alias Graphics.Accounts.{User, UserToken, UserNotifier}

  ## USERS

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)

    if User.valid_password?(user, password) do
      user
    end
  end

  def get_user!(id), do: Repo.get!(User, id)

  ## REGISTRATION

  def change_user_registration(user, attrs \\ %{}) do
    User.registration_changeset(user, attrs)
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  ## PASSWORD

  def change_user_password(user, attrs \\ %{}, opts \\ []) do
    User.password_changeset(user, attrs, opts)
  end

  def update_user_password(user, attrs) do
    user
    |> User.password_changeset(attrs)
    |> update_user_and_delete_all_tokens()
  end

  ## EMAIL SETTINGS

  def change_user_email(user, attrs \\ %{}, opts \\ []) do
    User.email_changeset(user, attrs, opts)
  end

  ## SESSION

  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)

    Repo.insert!(user_token)

    token
  end

  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)

    Repo.one(query)
  end

  def delete_user_session_token(token) do
    Repo.delete_all(from(UserToken, where: [token: ^token, context: "session"]))

    :ok
  end

  ## HELPERS

  defp update_user_and_delete_all_tokens(changeset) do
    Repo.transact(fn ->
      with {:ok, user} <- Repo.update(changeset) do
        tokens_to_expire =
          Repo.all_by(UserToken, user_id: user.id)

        Repo.delete_all(
          from(t in UserToken,
            where: t.id in ^Enum.map(tokens_to_expire, & &1.id)
          )
        )

        {:ok, {user, tokens_to_expire}}
      end
    end)
  end
end
