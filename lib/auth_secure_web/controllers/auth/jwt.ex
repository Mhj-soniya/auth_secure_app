defmodule AuthSecureWeb.Auth.Jwt do
  use Joken.Config, default_signer: :pem_rs256
  alias Joken

  @signer Joken.Signer.create("HS256", "secret")

  @impl Joken.Config
  def token_config do #token config is needed during validation
      %{}
      |> Map.put("sub", %Joken.Claim{
        generate: fn -> nil end,
        validate: fn val, _claims, _context -> val != nil end
      })
      |> Map.put("role", %Joken.Claim{
        generate: fn -> nil end,
        validate: fn val, _claims, _context -> val in ["admin", "user"] end
      })
      |> Map.put("exp", %Joken.Claim{
        generate: fn -> DateTime.utc_now() |> DateTime.add(3600, :second) |> DateTime.to_unix() end,
        validate: fn val, _claims, _context -> val > DateTime.to_unix(DateTime.utc_now()) end
      })
      |> Map.put("iat", %Joken.Claim{
        generate: fn -> DateTime.utc_now() |> DateTime.to_unix() end
      })
  end

  def generate_token(payload) do
      claims = %{
        "exp" => DateTime.utc_now() |> DateTime.add(3600, :second) |> DateTime.to_unix(),
        "iat" => DateTime.utc_now() |> DateTime.to_unix(),
        "role" => payload["role"],
        "sub" => payload["sub"]
      }

      Joken.encode_and_sign(claims, @signer)
  end

  def verify_token(token) do
    case Joken.verify_and_validate(token_config(), token, @signer) do
      {:ok, claims} -> {:ok, claims}
      {:error, reason} -> {:error, reason}
    end
  end
end
