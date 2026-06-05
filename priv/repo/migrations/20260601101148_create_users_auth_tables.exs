defmodule Graphics.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    #
    # USERS
    #
    create table(:users) do
      add :first_name, :string
      add :last_name, :string

      add :email, :citext, null: false
      add :phone_number, :string

      add :hashed_password, :string
      add :confirmed_at, :utc_datetime

      add :status, :string, default: "active"

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])

    #
    # ROLES
    #
    create table(:roles) do
      add :name, :string, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:roles, [:name])

    #
    # PERMISSIONS
    #
    create table(:permissions) do
      add :name, :string, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:permissions, [:name])

    #
    # USER ROLES
    #
    create table(:user_roles) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user_roles, [:user_id, :role_id])

    #
    # ROLE PERMISSIONS
    #
    create table(:role_permissions) do
      add :role_id, references(:roles, on_delete: :delete_all), null: false

      add :permission_id,
          references(:permissions, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(
      :role_permissions,
      [:role_id, :permission_id]
    )

    #
    # BOOKINGS
    #
    create table(:bookings) do
      add :client_name, :string, null: false
      add :email, :string
      add :phone_number, :string

      add :service_type, :string
      add :event_date, :date
      add :location, :string

      add :notes, :text

      add :status, :string, default: "pending"

      add :assigned_photographer_id,
          references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:bookings, [:status])
    create index(:bookings, [:assigned_photographer_id])

    #
    # QUOTATIONS
    #
    create table(:quotations) do
      add :booking_id, references(:bookings, on_delete: :delete_all)

      add :quotation_number, :string, null: false
      add :event_date, :date
      add :service_type, :string

      add :hours, :integer, default: 1

      add :drone_coverage, :boolean, default: false
      add :videography, :boolean, default: false

      add :amount,
          :decimal,
          precision: 12,
          scale: 2

      add :status, :string, default: "draft"

      add :generated_by_id,
          references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:quotations, [:quotation_number])
    create index(:quotations, [:status])

    #
    # USER TOKENS
    #
    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :token, :binary, null: false
      add :context, :string, null: false

      add :sent_to, :string
      add :authenticated_at, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:users_tokens, [:user_id])

    create unique_index(
      :users_tokens,
      [:context, :token]
    )

    #
    # NOTIFICATIONS
    #
    create_if_not_exists table(:tbl_notifications) do
      add :status, :string
      add :type, :string
      add :message, :string
      add :read, :boolean, default: false

      add :action_url, :string
      add :sender_name, :string

      add :document_name, :string
      add :document_id, :string

      add :comments, :string

      add :user_id,
          references(:users, on_delete: :delete_all),
          null: false

      add :sender_id,
          references(:users, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tbl_notifications, [:user_id])
    create index(:tbl_notifications, [:sender_id])
    create index(:tbl_notifications, [:read])
    create index(:tbl_notifications, [:status])
  end
end
