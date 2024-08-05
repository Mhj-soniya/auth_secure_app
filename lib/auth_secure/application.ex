defmodule AuthSecure.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuthSecureWeb.Telemetry,
      AuthSecure.Repo,
      {DNSCluster, query: Application.get_env(:auth_secure, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AuthSecure.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AuthSecure.Finch},
      # Start a worker by calling: AuthSecure.Worker.start_link(arg)
      # {AuthSecure.Worker, arg},
      # Start to serve requests, typically the last entry
      AuthSecureWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthSecure.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuthSecureWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
