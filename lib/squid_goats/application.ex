defmodule SquidGoats.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SquidGoatsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SquidGoats.PubSub},
      # Start the Endpoint (http/https)
      SquidGoatsWeb.Endpoint
      # Start a worker by calling: SquidGoats.Worker.start_link(arg)
      # {SquidGoats.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SquidGoats.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SquidGoatsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
