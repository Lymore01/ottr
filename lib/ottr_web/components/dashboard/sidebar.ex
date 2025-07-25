defmodule OttrWeb.Dashboard.Sidebar do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  alias OttrWeb.Helpers.Sidebar

  def sidebar(assigns) do
    ~H"""
    <aside
      id="sidebar"
      @mouseenter="setHover(true)"
      @mouseleave="setHover(false)"
      class={[
        "group fixed top-0 h-screen left-0 z-30 bg-white/30 backdrop-blur-lg border-r border-zinc-200 shadow-sm flex flex-col justify-between px-2 py-4 transition-all duration-300 ease-in-out"
      ]}
      x-bind:class="{
        'w-[60px]': currentMode === 'collapsed',
        'w-[60px] hover:w-[220px]': currentMode === 'hover',
        'w-[220px]': currentMode === 'expanded'
      }"
    >
      <div class="space-y-6">
        <div class="border-b border-border pb-4 flex gap-3 max-w-full overflow-x-hidden">
          <div
            class="grid size-10 shrink-0 place-content-center rounded-md bg-[#004838] cursor-pointer"
            x-transition:enter="transition-all ease-in-out duration-300"
            x-transition:leave="transition-all ease-in-out duration-300"
          >
            <svg
              width="24"
              height="auto"
              viewBox="0 0 36 40"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
              class="fill-slate-50"
            >
              <path
                fillRule="evenodd"
                clipRule="evenodd"
                d="M0 15V31H5C5.52527 31 6.04541 31.1035 6.53076 31.3045C7.01599 31.5055 7.45703 31.8001 7.82837 32.1716C8.19983 32.543 8.49451 32.984 8.69556 33.4693C8.89648 33.9546 9 34.4747 9 35V40H21L36 25V9H31C30.4747 9 29.9546 8.89655 29.4692 8.69553C28.984 8.49451 28.543 8.19986 28.1716 7.82843C27.8002 7.457 27.5055 7.01602 27.3044 6.53073C27.1035 6.04544 27 5.5253 27 5V0H15L0 15ZM17 30H10V19L19 10H26V21L17 30Z"
                fill="#FFFFF"
              >
              </path>
            </svg>
          </div>
          <%!-- TODO(Fix Me): text ellipsis not displaying, group-hover/user not working --%>
          <div
            x-bind:class="{
              'hidden': currentMode === 'collapsed',
              'hidden group-hover:block': currentMode === 'hover',
              'block': currentMode === 'expanded'
            }"
            class="group"
            x-transition:enter="transition-opacity ease-in-out duration-300 opacity-0 group-hover:opacity-100"
            x-transition:leave="transition-opacity ease-in-out duration-300 opacity-0"
          >
            <div class="flex items-center cursor-pointer">
              <div class="text-sm">
                <span class="block font-medium text-zinc-800 group-hover:text-zinc-600 truncate whitespace-nowrap">
                  Tralalero Tralala
                </span>

                <span class="block text-xs text-zinc-600 truncate whitespace-nowrap">
                  tralala@brainrot.com
                </span>
              </div>
            </div>
          </div>
        </div>

    <!-- Nav -->
        <div class="space-y-1 border-b border-border pb-4">
          <%!-- <p
            class={["text-xs text-zinc-500 mb-2 px-3 uppercase"]}
            x-bind:class="{
              'hidden': currentMode === 'collapsed',
              'hidden group-hover:block': currentMode === 'hover',
              'block': currentMode === 'expanded'
            }"
            x-transition:enter="transition-all ease-in-out duration-300"
            x-transition:leave="transition-all ease-in-out duration-300"
          >
            Navigation
          </p> --%>
          <%= for item <- Sidebar.nav_items() do %>
            <.link
              navigate={item.href}
              class={[
                "flex items-center gap-3 px-3 py-2 rounded-md text-xs transition-colors w-full h-10 ",
                Sidebar.current_path?(@current_path, item.href) && " bg-emerald-50 text-emerald-600",
                !Sidebar.current_path?(@current_path, item.href) &&
                  "text-zinc-600 hover:text-emerald-600 hover:bg-emerald-50"
              ]}
            >
              <%= case item.icon do %>
                <% :home -> %>
                  <Heroicons.home class="w-5 h-5 shrink-0" />
                <% :arrows_right_left -> %>
                  <Heroicons.fire class="w-5 h-5 shrink-0" />
                <% :puzzle_piece -> %>
                  <Heroicons.puzzle_piece class="w-5 h-5 shrink-0" />
                <% :cog_6_tooth -> %>
                  <Heroicons.cog_6_tooth class="w-5 h-5 shrink-0" />
                <% :document -> %>
                  <Heroicons.document class="w-5 h-5 shrink-0" />
                <% _ -> %>
                  <Heroicons.question_mark_circle class="w-5 h-5 text-gray-400" />
              <% end %>

              <span
                class="whitespace-nowrap"
                x-bind:class="{
                  'hidden': currentMode === 'collapsed',
                  'hidden group-hover:block': currentMode === 'hover',
                  'inline': currentMode === 'expanded'
                }"
                x-transition:enter="transition-opacity ease-in-out duration-300 opacity-0 group-hover:opacity-100"
                x-transition:leave="transition-opacity ease-in-out duration-300 opacity-0"
              >
                {item.label}
              </span>
            </.link>
          <% end %>
        </div>
      </div>

      <div class="flex flex-col px-3 relative">
        <!-- Trigger Button -->
        <button x-ref="triggerBtn" @click="togglePanel" class="p-1 rounded transition">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <rect width="18" height="18" x="3" y="3" rx="2" /> <path d="M15 3v18" />
          </svg>
        </button>

        <template x-teleport="body">
          <div
            x-show="panelOpen"
            x-ref="panel"
            x-transition
            @click.outside="panelOpen = false"
            class="fixed z-50 w-48 rounded-md border bg-white border border-border text-sm text-muted-foreground"
            x-bind:style="`left: ${panelX}px; top: ${panelY}px`"
          >
            <p class="text-xs font-semibold text-zinc-700 border-b border-border px-4 py-3">
              Sidebar mode
            </p>

            <div class="py-3">
              <template x-for="mode in ['collapsed', 'hover', 'expanded']" x-bind:key="mode">
                <label class="flex items-center gap-4 cursor-pointer px-4 py-1 rounded-md text-xs hover:bg-white/60">
                  <input
                    type="radio"
                    name="sidebar-mode"
                    x-bind:value="mode"
                    x-bind:checked="mode === currentMode"
                    @change="setMode(mode)"
                    class="size-4 accent-emerald-600"
                  /> <span x-text="mode.charAt(0).toUpperCase() + mode.slice(1)"></span>
                </label>
              </template>
            </div>
          </div>
        </template>
      </div>
    </aside>
    """
  end
end
