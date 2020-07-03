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
    {:ok, assign(socket, :boss, Boss.new(123))}
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

  @impl true
  @spec render(Socket.assigns()) :: LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div class="bossClick" phx-click="attack">
      <svg viewBox="0 0 1000 500">
        <defs>
          <linearGradient id="red_grad" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0" stop-color="#dbd9d9" stop-opacity="0.99219"/>
            <stop offset="0.15" stop-color="#ff0000" stop-opacity="0.99609"/>
            <stop offset="0.85" stop-color="#ff0000"/>
            <stop offset="1" stop-color="#601313" stop-opacity="0.99219"/>
          </linearGradient>
          <linearGradient id="black_grad" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0" stop-color="#000000" stop-opacity="0.99219"/>
            <stop offset="0.15" stop-color="#3d3a3a" stop-opacity="0.99219"/>
            <stop offset="0.85" stop-color="#3d3a3a" stop-opacity="0.99219"/>
            <stop offset="1" stop-color="#dbd9d9" stop-opacity="0.98828"/>
          </linearGradient>
        </defs>
        <g class="boss_health">
          <g class="layer" id="svg_2">
            <rect x="98" y="48"  width="804"             height="54" id="boss_health_border"     fill="#ffffff" stroke="#000000" stroke-linecap="round" stroke-linejoin="bevel" stroke-width="2"/>
            <rect x="100" y="50" width="800"             height="50" id="boss_health_background" fill="url(#black_grad)"/>
            <rect x="100" y="50" width="<%= @boss.health_percent * 8 %>" height="50" id="boss_health_level"      fill="url(#red_grad)"/>
          </g>
          <text x="500" y="89" fill="#ffffff" font-family="Helvetica" font-size="40" font-weight="bold" id="boss_health_text" stroke="#000000" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" text-anchor="middle" xml:space="preserve">
            <%= @boss.health %>/<%= @boss.max_health %>      <%= @boss.health_percent %>%
          </text>
        </g>
      </svg>
    </div>
    """
  end
end
