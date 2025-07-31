defmodule OttrWeb.Dashboard.Playground.NodeActions do
  use Phoenix.Component

  def node_actions(assigns) do
    ~H"""
    <div x-data="toggleNodeActions()" x-init="init()" class="relative">
      <button @click.stop="open = !open" class="text-gray-300 hover:text-gray-500 transition-colors">
        <Heroicons.ellipsis_horizontal class="w-5 h-5 text-zinc-600" />
      </button>

      <div
        x-show="open"
        @click.away="open = false"
        x-bind:class="position === 'top'
    ? 'absolute right-0 bottom-full mb-2 w-48 bg-white border border-border shadow-lg z-20 text-sm rounded-sm'
    : 'absolute right-0 top-full mt-2 w-48 bg-white border border-border shadow-lg z-20 text-sm rounded-sm'
    "
        x-ref="actions"
      >
        <ul class="py-1 text-xs text-zinc-800">
          <li>
            <button class="w-full text-left px-4 py-2 hover:bg-zinc-50 flex items-center gap-2">
              <Heroicons.adjustments_vertical class="w-4 h-4 text-zinc-500" /> Configure
            </button>
          </li>

          <li>
            <button class="w-full text-left px-4 py-2 hover:bg-zinc-50 flex items-center gap-2">
              <Heroicons.document_duplicate class="w-4 h-4 text-zinc-500" /> Duplicate
            </button>
          </li>

          <li>
            <button class="w-full text-left px-4 py-2 hover:bg-zinc-50 flex items-center gap-2">
              <Heroicons.pause class="w-4 h-4 text-zinc-500" /> Disable
            </button>
          </li>

          <li>
            <hr class="my-1 border-gray-200" />
          </li>

          <li>
            <button class="w-full text-left px-4 py-2 text-red-600 hover:bg-red-100 flex items-center gap-2">
              <Heroicons.trash class="w-4 h-4 text-red-500" /> Delete
            </button>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
