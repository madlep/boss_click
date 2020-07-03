defmodule BossClick.Boss do
  @moduledoc false

  alias __MODULE__

  @type t() :: %Boss{
          health: integer(),
          health_percent: integer(),
          max_health: integer(),
          state: :alive | :defeated
        }
  defstruct [:health, :health_percent, :max_health, :state]

  @spec new(integer()) :: t()
  def new(max_health) do
    %Boss{
      health: max_health,
      health_percent: 100,
      max_health: max_health,
      state: :alive
    }
  end

  @spec damage(t(), integer()) :: t()
  def damage(boss, damage), do: update(boss, damage * -1)

  @spec heal(t(), integer()) :: t()
  def heal(boss, healing), do: update(boss, healing)

  @spec update(t(), integer()) :: t()
  defp update(boss, health_change) do
    boss
    |> change_health(health_change)
    |> update_state()
  end

  @spec change_health(t(), integer()) :: t()
  defp change_health(boss = %Boss{state: :defeated}, _change) do
    boss
  end

  defp change_health(boss = %Boss{health: health, max_health: max_health, state: :alive}, amount) do
    new_health =
      (health + amount)
      |> max(0)
      |> min(max_health)

    new_health_percent = (new_health / max_health * 100) |> round
    %Boss{boss | health: new_health, health_percent: new_health_percent}
  end

  @spec update_state(t()) :: t()
  defp update_state(boss = %Boss{health: 0}) do
    %Boss{boss | state: :defeated}
  end

  defp update_state(boss) do
    boss
  end
end
