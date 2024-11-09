defmodule TypesenseWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TypesenseWebWeb.Telemetry,
      TypesenseWeb.Repo,
      {DNSCluster, query: Application.get_env(:typesense_web, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TypesenseWeb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TypesenseWeb.Finch},
      # Start a worker by calling: TypesenseWeb.Worker.start_link(arg)
      # {TypesenseWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      TypesenseWebWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TypesenseWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TypesenseWebWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
