defmodule BossClickWeb.BossFight do
  @moduledoc false

  alias Phoenix.LiveView
  alias Phoenix.LiveView.Socket

  alias BossClick.Boss

  use Phoenix.LiveView

  @starting_health 13

  @impl true
  @spec mount(LiveView.unsigned_params() | :not_mounted_at_router, map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :boss, Boss.new(@starting_health))}
  end

  @impl true

  @spec handle_event(binary(), LiveView.unsigned_params(), Socket.t()) :: {:noreply, Socket.t()}
  def handle_event("attack", _params, socket) do
    boss = socket.assigns[:boss] |> Boss.damage(1)

    if boss.state == :defeated do
      Process.send_after(self(), :respawn, 3_000)
    end

    {:noreply, assign(socket, :boss, boss)}
  end

  @impl true
  def handle_event("heal", _params, socket) do
    {:noreply, update(socket, :boss, &Boss.heal(&1, 1))}
  end

  @impl true
  @spec handle_info(term(), Socket.t()) :: {:noreply, Socket.t()}
  def handle_info(:respawn, socket) do
    {:noreply, assign(socket, :boss, Boss.new(@starting_health))}
  end
end
