defmodule AuthSecureWeb.RegistrationController do
  use AuthSecureWeb, :controller

  alias AuthSecure.Accounts
  alias AuthSecure.Accounts.User

  def new(conn, _params) do
    render(conn, :new, changeset: User.changeset(%User{}))
  end

  def create(conn, %{"user" => user_params}) do
    user_params = Map.put(user_params, "role", "user")
    case Accounts.create_user(user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Registration successful!")
        |> redirect(to: "/login")
      {:error, _} ->
        conn
        |> redirect(to: "/register")
    end
  end
end
