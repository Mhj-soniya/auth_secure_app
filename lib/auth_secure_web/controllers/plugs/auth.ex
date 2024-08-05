defmodule AuthSecureWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias AuthSecureWeb.Auth.Jwt
  alias AuthSecure.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    case fetch_cookies(conn) do
      %{cookies: %{"auth_token" => token}} ->
        IO.inspect(token)
        IO.inspect(Jwt.verify_token(token))

        case Jwt.verify_token(token) do
          {:ok, claims} ->
            user = Accounts.get_user!(claims["sub"])
            assign(conn, :current_user, user)

          {:error, _reason} ->
            conn
            # |> put_status(:unauthorized)
            |> put_flash(:error, "You must login first")
            |> redirect(to: "/login")
            |> halt()
        end

      _ ->
        conn
        # |> put_status(:unauthorized)
        |> put_flash(:error, "You must login first")
        |> redirect(to: "/login")
        |> halt()
    end
  end
end
