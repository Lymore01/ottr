defmodule OttrWeb.Dashboard.Playground do
  use Phoenix.Component

  use OttrWeb, :verified_routes

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
      x-data
      x-init="
    panzoom = Panzoom($refs.playground, { maxScale: 5, minScale: 0.5, step: 0.2 });
    $refs.playground.parentElement.addEventListener('wheel', e => {
      if (e.ctrlKey) panzoom.zoomWithWheel(e);
      else panzoom.pan(e);
    });
    "
    >
      <div x-ref="playground" class="items-center justify-center flex w-full h-full">
        <!-- Your workflow diagram goes here, e.g., SVG, cards, connectors -->
        <div class="text-foreground cursor-grab grid place-content-center bg-[#004838] rounded-md p-6">
          Node A
        </div>
      </div>
    </div>
    """
  end
end
