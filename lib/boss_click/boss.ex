defmodule BossClick.Boss do
  @moduledoc false

  @spec start_link(max_health :: integer, GenServer.name()) :: {:ok, pid()}
  def start_link(max_health, name \\ BossClick.Boss.BossServer) do
    GenServer.start_link(BossClick.Boss.BossServer, max_health, name: name)
  end

  @spec child_spec(max_health :: integer) :: Supervisor.child_spec()
  def child_spec(max_health) do
    %{
      id: BossClick.Boss.BossServer,
      start: {BossClick.Boss, :start_link, [max_health]}
    }
  end

  @spec current_state(GenServer.name()) :: BossClick.Boss.BossState.t()
  def current_state(server \\ BossClick.Boss.BossServer) do
    GenServer.call(server, :current_state)
  end

  @spec damage(integer(), GenServer.name()) :: :ok
  def damage(amount, server \\ BossClick.Boss.BossServer) do
    GenServer.cast(server, {:damage, amount})
  end
end
