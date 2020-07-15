defmodule BossClick.Boss do
  @moduledoc false

  alias BossClick.Boss.BossServer
  alias BossClick.Boss.BossState

  @type state() :: BossState.t()

  @spec start_link(max_health :: integer, GenServer.name()) :: {:ok, pid()}
  def start_link(max_health, name \\ BossServer) do
    GenServer.start_link(BossServer, max_health, name: name)
  end

  @spec child_spec(max_health :: integer) :: Supervisor.child_spec()
  def child_spec(max_health) do
    %{
      id: BossServer,
      start: {BossClick.Boss, :start_link, [max_health]}
    }
  end

  @spec current_state(GenServer.name()) :: state()
  def current_state(server \\ BossServer) do
    GenServer.call(server, :current_state)
  end

  @spec damage(integer(), GenServer.name()) :: :ok
  def damage(amount, server \\ BossServer) do
    GenServer.cast(server, {:damage, amount})
  end
end
