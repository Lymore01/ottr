defmodule OttrWeb.Dashboard.Playground do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Dashboard.Playground.{BurstNode}


  def connection_line(assigns) do
    ~H"""
    <div class="z-[300] absolute top-0 left-0 w-full h-full pointer-events-none">
      <svg class="w-full h-full" x-ref="svg">
        <defs>
          <marker
            id="arrow"
            markerWidth="8"
            markerHeight="8"
            refX="7"
            refY="3"
            orient="auto"
            markerUnits="strokeWidth"
          >
            <path d="M0,0 L0,6 L8,3 z" fill="#2563eb" />
          </marker>


          <marker
            id="arrow-gray"
            markerWidth="8"
            markerHeight="8"
            refX="7"
            refY="3"
            orient="auto"
            markerUnits="strokeWidth"
          >
            <path d="M0,0 L0,6 L8,3 z" fill="#94a3b8" />
          </marker>

          <marker
            id="arrow-green"
            markerWidth="8"
            markerHeight="8"
            refX="7"
            refY="3"
            orient="auto"
            markerUnits="strokeWidth"
          >
            <path d="M0,0 L0,6 L8,3 z" fill="#22c55e" />
          </marker>

          <marker
            id="arrow-red"
            markerWidth="8"
            markerHeight="8"
            refX="7"
            refY="3"
            orient="auto"
            markerUnits="strokeWidth"
          >
            <path d="M0,0 L0,6 L8,3 z" fill="#ef4444" />
          </marker>

          <marker
            id="arrow-purple"
            markerWidth="8"
            markerHeight="8"
            refX="7"
            refY="3"
            orient="auto"
            markerUnits="strokeWidth"
          >
            <path d="M0,0 L0,6 L8,3 z" fill="#8b5cf6" />
          </marker>

          <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
            <feGaussianBlur stdDeviation="3" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" /> <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>

          <filter id="dropshadow" x="-20%" y="-20%" width="140%" height="140%">
            <feDropShadow dx="0" dy="2" stdDeviation="2" flood-color="rgba(0,0,0,0.1)" />
          </filter>
        </defs>
      </svg>
    </div>
    """
  end

  def playground(assigns) do
    ~H"""
    <div
      class="relative w-full h-full overflow-hidden flex items-center justify-center"
      style="touch-action: none;"
      x-bind:style="{
    'transform': currentMode === 'collapsed'
      ? 'translateX(60px) translateY(60px)'
      : (currentMode === 'hover' && hover === true || currentMode === 'expanded')
        ? 'translateX(220px) translateY(60px)'
        : 'translateX(60px) translateY(60px)'
    }"
      x-data={"workflowPlayground(#{Jason.encode!(@nodes)})"}
    >
      <div class="relative w-full h-full p-6 overflow-auto">
        <.connection_line />
        <%= for node <- @nodes do %>
          <.burst_node id={node.id} node={node} />
        <% end %>
      </div>
    </div>
    """
  end
end
