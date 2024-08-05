defmodule AuthSecureWeb.SessionController do
  use AuthSecureWeb, :controller

  alias AuthSecure.Accounts
  alias AuthSecureWeb.Auth.Jwt

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"_csrf_token" => _token, "email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        # Pattern matching to get just token to send as JSON
        {:ok, token, _claim} = Jwt.generate_token(%{"sub" => user.id, "role" => user.role})
        IO.inspect(token)

        conn
        |> put_resp_cookie("auth_token", token, http_only: true, secure: true, max_age: 86400) #sets a cookie named auth_token in Http-response
        |> put_resp_content_type("application/json")
        |> redirect_to_dashboard(user.role)
        # |> send_resp(200, Jason.encode!(%{message: "Login successful"}))

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> send_resp(401, "Invalid credentials")
    end
  end

  defp redirect_to_dashboard(conn, "admin") do
    conn
    |> redirect(to: "/admin/dashboard")
  end

  defp redirect_to_dashboard(conn, _role) do
    conn
    |> redirect(to: "/dashboard")
  end
end
