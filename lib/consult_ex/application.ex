defmodule ConsultEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ConsultExWeb.Telemetry,
      ConsultEx.Repo,
      {DNSCluster, query: Application.get_env(:consult_ex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ConsultEx.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ConsultEx.Finch},
      # Start a worker by calling: ConsultEx.Worker.start_link(arg)
      # {ConsultEx.Worker, arg},
      # Start to serve requests, typically the last entry
      ConsultExWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConsultEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ConsultExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
