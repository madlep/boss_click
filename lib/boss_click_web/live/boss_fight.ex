defmodule BossClickWeb.BossFight do
  @moduledoc false

  alias Phoenix.LiveView
  alias Phoenix.LiveView.Socket

  alias BossClick.Boss

  use Phoenix.LiveView

  @impl true
  @spec mount(LiveView.unsigned_params() | :not_mounted_at_router, map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :boss, Boss.new(13))}
  end

  @impl true

  @spec handle_event(binary(), LiveView.unsigned_params(), Socket.t()) :: {:noreply, Socket.t()}
  def handle_event("attack", _params, socket) do
    {:noreply, update(socket, :boss, &Boss.damage(&1, 1))}
  end

  @impl true
  def handle_event("heal", _params, socket) do
    {:noreply, update(socket, :boss, &Boss.heal(&1, 1))}
  end
end
