defmodule AuthSecureWeb.UserDashboardController do
  use AuthSecureWeb, :controller

  plug :authenticate_user

  def index(conn, _params) do
    render(conn, :index)
  end

  defp authenticate_user(conn, _opts) do
    user = conn.assigns[:current_user]
    IO.inspect(user)
    if user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page")
      |> redirect(to: "/login")
      |> halt()
    end
  end

end
