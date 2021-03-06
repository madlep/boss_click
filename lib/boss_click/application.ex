defmodule BossClick.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  @spec start(Application.start_type(), term()) ::
          {:ok, pid()} | {:ok, pid(), Application.state()} | {:error, reason :: term()}
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BossClickWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BossClick.PubSub},
      {BossClick.Boss, 1000},
      # Start the Endpoint (http/https)
      BossClickWeb.Endpoint
      # Start a worker by calling: BossClick.Worker.start_link(arg)
      # {BossClick.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BossClick.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  @spec config_change(keyword(), keyword(), [atom()]) :: :ok
  def config_change(changed, _new, removed) do
    BossClickWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
