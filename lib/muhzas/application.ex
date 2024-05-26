defmodule Muhzas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MuhzasWeb.Telemetry,
      Muhzas.Repo,
      {DNSCluster, query: Application.get_env(:muhzas, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Muhzas.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Muhzas.Finch},
      # Start a worker by calling: Muhzas.Worker.start_link(arg)
      # {Muhzas.Worker, arg},
      # Start to serve requests, typically the last entry
      MuhzasWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Muhzas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MuhzasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
