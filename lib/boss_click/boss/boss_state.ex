defmodule BossClick.Boss.BossState do
  @moduledoc false

  alias __MODULE__

  @type t() :: %__MODULE__{
          health: integer(),
          max_health: integer(),
          state: :alive | :defeated
        }
  defstruct [:health, :max_health, :state]

  @spec new(integer()) :: t()
  def new(max_health) do
    %BossState{
      health: max_health,
      max_health: max_health,
      state: :alive
    }
  end

  @spec respawn(t()) :: t()
  def respawn(%BossState{max_health: max_health}), do: BossState.new(max_health)

  @spec damage(t(), integer()) :: t()
  def damage(boss_state, damage), do: update(boss_state, damage * -1)

  @spec heal(t(), integer()) :: t()
  def heal(boss_state, healing), do: update(boss_state, healing)

  @spec update(t(), integer()) :: t()
  defp update(boss_state, health_change) do
    boss_state
    |> change_health(health_change)
    |> update_state()
  end

  @spec change_health(t(), integer()) :: t()
  defp change_health(boss_state = %BossState{state: :defeated}, _change) do
    boss_state
  end

  defp change_health(
         boss_state = %BossState{health: health, max_health: max_health, state: :alive},
         amount
       ) do
    new_health =
      (health + amount)
      |> max(0)
      |> min(max_health)

    %BossState{boss_state | health: new_health}
  end

  @spec update_state(t()) :: t()
  defp update_state(boss_state = %BossState{health: 0}) do
    %BossState{boss_state | state: :defeated}
  end

  defp update_state(boss) do
    boss
  end
end
