defmodule BossClick.Boss.BossServer do
  @moduledoc false

  use GenServer

  alias BossClick.Boss.BossState

  @heal_amount 1
  @heal_ms 250

  @impl true
  def init(max_health) do
    Phoenix.PubSub.subscribe(BossClick.PubSub, "boss:1")
    Process.send_after(self(), {:heal, @heal_amount}, @heal_ms)
    {:ok, BossState.new(max_health)}
  end

  @impl true
  def handle_call(:current_state, _from, boss_state) do
    {:reply, boss_state, boss_state}
  end

  @impl true
  def handle_cast({:damage, amount}, boss_state) do
    new_boss_state = boss_state |> BossState.damage(amount)

    if new_boss_state.state == :defeated do
      Process.send_after(self(), :respawn, 3000)
    end

    broadcast_state(new_boss_state)

    {:noreply, new_boss_state}
  end

  @impl true
  def handle_info({:heal, amount}, boss_state) do
    Process.send_after(self(), {:heal, amount}, @heal_ms)
    new_boss_state = boss_state |> BossState.heal(amount)
    broadcast_state(new_boss_state)
    {:noreply, new_boss_state}
  end

  def handle_info(:respawn, boss_state) do
    new_boss_state = boss_state |> BossState.respawn()
    broadcast_state(new_boss_state)
    {:noreply, new_boss_state}
  end

  defp broadcast_state(boss_state) do
    Phoenix.PubSub.broadcast_from(BossClick.PubSub, self(), "boss:1", {:boss_state, boss_state})
  end
end
