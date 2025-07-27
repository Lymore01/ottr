defmodule OttrWeb.Ui.FilterComponent do
  use Phoenix.LiveComponent

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full max-w-full mx-auto">
      <div class="flex flex-wrap gap-3 mb-6">
        <%= for category <- @categories do %>
          <button
            type="button"
            class="px-4 py-1 rounded-full transition whitespace-nowrap text-xs"
            x-bind:class={"selectedCategory === '#{String.downcase(category)}' ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200' : 'bg-zinc-100 text-zinc-700 hover:bg-zinc-200'"}
            @click={"selectedCategory = '#{String.downcase(category)}'"}
            phx-click="filter_category"
            phx-value-category={String.downcase(category)}
          >
            {category}
          </button>
        <% end %>

        <span class="text-xs text-blue-600 hover:underline font-medium flex items-center gap-1">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-4 h-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          More
        </span>
      </div>

    <!-- Popular Tools -->
      <div class="flex flex-wrap gap-4">
        <%= for tool <- @tools do %>
          <button
            type="button"
            class="flex items-center gap-2 px-3 py-2 rounded-lg border border-zinc-300 text-xs font-medium shadow-sm"
            phx-click="filter_tools"
            phx-value-tool={tool.name}
            x-bind:class={"selectedTools.includes('#{tool.name}') ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200' : 'bg-white hover:bg-zinc-50 transition'"}
            @click={"selectedTools.includes('#{tool.name}') ? selectedTools = selectedTools.filter(t => t !== '#{tool.name}') : selectedTools.push('#{tool.name}');"}
          >
            <img src={tool.icon} alt={tool.name} class="w-5 h-5" /> {tool.name}
          </button>
        <% end %>

        <span class="text-xs text-blue-600 hover:underline font-medium flex items-center gap-1">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="w-4 h-4"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
          </svg>
          More
        </span>
      </div>
    </div>
    """
  end
end
