defmodule AuthSecureWeb.AdminDashboardController do
  use AuthSecureWeb, :controller

  plug :authenticate_user
  plug :ensure_admin

  def index(conn, _params) do
    render(conn, :index)
  end

  defp authenticate_user(conn, _opts) do
    user = conn.assigns[:current_user]
    if user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  defp ensure_admin(conn,  _opts) do
    user = conn.assigns[:current_user]
    if user.role == "admin" do
      conn
    else
      conn
      |> put_flash(:error, "You do not have access to this page")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
