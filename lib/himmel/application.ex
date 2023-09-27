defmodule Himmel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HimmelWeb.Telemetry,
      # Start the Ecto repository
      Himmel.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Himmel.PubSub},
      # Start Finch
      {Finch, name: Himmel.Finch},
      # Start the Endpoint (http/https)
      HimmelWeb.Endpoint,
      # Start a worker by calling: Himmel.Worker.start_link(arg)
      # {Himmel.Worker, arg}
      {Himmel.Weather.Service, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Himmel.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HimmelWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
