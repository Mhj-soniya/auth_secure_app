defmodule AuthSecure.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :role, :string
    field :email, :string
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :email, :password_hash, :role])
    |> validate_required([:name, :email, :password_hash, :role])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/[a-zA-Z0-9.*+-_]+@[a-zA-Z]+\.[a-zA-Z]{2,}/)
    |> validate_length(:password_hash, min: 6)
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end

end
