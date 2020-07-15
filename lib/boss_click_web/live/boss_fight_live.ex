defmodule BossClickWeb.BossFightLive do
  @moduledoc false

  alias Phoenix.LiveView
  alias Phoenix.LiveView.Socket

  alias BossClick.Boss

  use Phoenix.LiveView

  @impl true
  @spec mount(LiveView.unsigned_params() | :not_mounted_at_router, map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(BossClick.PubSub, "boss:1")
    {:ok, assign(socket, :boss, Boss.current_state())}
  end

  @impl true
  @spec handle_event(binary(), LiveView.unsigned_params(), Socket.t()) :: {:noreply, Socket.t()}
  def handle_event("attack", _params, socket) do
    Boss.damage(1)

    {:noreply, socket}
  end

  @impl true
  @spec handle_info(term(), Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({:boss_state, boss_state}, socket) do
    {:noreply, assign(socket, :boss, boss_state)}
  end
end
