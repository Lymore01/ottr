defmodule OttrWeb.Dashboard.Topbar do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def topbar(assigns) do
    ~H"""
    <nav
      x-data="topbarToggle"
      class="fixed top-0 bg-white/30 backdrop-blur-lg border-b border-zinc-200 shadow-sm flex flex-row justify-between max-h-[60px] py-2 transition-all duration-300 ease-in-out"
      x-bind:style="{
    marginLeft: currentMode === 'collapsed'
      ? '60px'
      : (currentMode === 'hover' && hover === true || currentMode === 'expanded')
        ? '220px'
        : '60px',
    width: (currentMode === 'hover' && hover === true) || currentMode === 'expanded'
      ? 'calc(100vw - 220px)'
      : 'calc(100vw - 60px)'
    }"
    >
      <div
        class="w-full h-full flex items-center ml-4 justify-between"
        x-bind:style="{
    marginRight: (currentMode === 'hover' && hover === true) || currentMode === 'expanded'
    ? '20px'
    : '20px'
    }"
      >
        <!-- Workflow Name -->
        <%= if String.starts_with?(@current_path, "/dashboard") && String.ends_with?(@current_path, "/playground") do %>
          <div class="flex items-center gap-2 relative ml-4">
            <div
              x-data="{
      editing: false,
      name: 'Community Engagement Workflow',
      tempName: ''
    }"
              class="flex items-center gap-2 relative"
            >
              <div class="relative max-w-80">
                <span
                  x-show="!editing"
                  @click="tempName = name; editing = true; $nextTick(() => $refs.input.focus())"
                  class="block truncate overflow-hidden whitespace-nowrap font-medium text-zinc-700 text-sm capitalize cursor-pointer leading-6"
                  x-text="name"
                  x-ref="span"
                >
                </span>

                <input
                  x-show="editing"
                  x-model="tempName"
                  @blur="name = tempName; editing = false"
                  @keydown.enter.prevent="name = tempName; editing = false"
                  type="text"
                  class="rounded-none border-b border-t-0 border-r-0 border-l-0 border-border outline-none focus:outline-none focus:ring-0 text-sm text-zinc-600 w-64"
                  x-ref="input"
                />
              </div>

    <!-- Chevron -->
              <div
                class="flex items-center justify-center p-2 cursor-pointer hover:bg-zinc-100 transition-colors duration-200 rounded-md group/chevron"
                @click="toggleWorkflowOption"
                x-ref="workflowOptionsTrigger"
              >
                <Heroicons.chevron_up_down class="w-5 h-5 text-zinc-700 transition-colors duration-200 group-hover/chevron:text-emerald-600" />
              </div>

              <%!-- todo: add autosave indicator phx-debounce --%>
            </div>

            <template x-teleport="body">
              <div
                x-show="workflowPanelOpen"
                x-transition
                @click.outside="workflowPanelOpen = false"
                class="fixed z-50 w-80 rounded-sm border bg-white border-border text-sm text-muted-foreground shadow-lg"
                x-bind:style="`left: ${workflowPanelX}px; top: ${workflowPanelY}px`"
              >
                <div class="flex items-center px-4 py-2 border-b border-border">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="h-4 w-4 text-zinc-400 mr-2"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    stroke-width="2"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M21 21l-4.35-4.35m0 0A7.5 7.5 0 1011 18.5a7.5 7.5 0 005.65-2.85z"
                    />
                  </svg>

                  <input
                    type="text"
                    required
                    class="rounded-none border-0 outline-none focus:outline-none focus:ring-0 focus:border-transparent w-full text-xs py-2 -ml-2"
                    placeholder="Find workflows..."
                    autocomplete="off"
                  />
                </div>

                <p class="text-xs font-semibold text-zinc-700 border-b border-border px-4 py-3">
                  All Your Workflows
                </p>

                <ul class="max-h-60 overflow-y-auto">
                  <%= for workflow <- @workflows do %>
                    <li
                      @click={"selectWorkflow(#{workflow.id})"}
                      class="px-4 py-2 hover:bg-zinc-50 cursor-pointer text-xs text-zinc-800 transition"
                    >
                      {workflow.name}
                    </li>
                  <% end %>

                  <% if Enum.empty?(@workflows) do %>
                    <li class="px-4 py-2 text-xs text-zinc-400">
                      No workflows found.
                    </li>
                  <% end %>
                </ul>

    <!-- Add New Workflow Button -->
                <div class="border-t border-border px-4 py-3">
                  <button
                    @click="createNewWorkflow()"
                    type="button"
                    class="w-full text-xs text-blue-600 hover:underline font-medium flex items-center gap-1"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      class="h-4 w-4"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 4v16m8-8H4"
                      />
                    </svg>
                    New Workflow
                  </button>
                </div>
              </div>
            </template>
          </div>
        <% else %>
          <div class="ml-4 flex">
            <h1 class="font-medium text-sm text-[#073127]">
              {@current_path
              |> String.split("/")
              |> Enum.reject(&(&1 == ""))
              |> List.last()
              |> String.capitalize()}
            </h1>
          </div>
        <% end %>

        <div class="flex gap-4 items-center">
          <div class="relative flex gap-2 p-1 border border-border rounded-full transition-colors duration-200">
            <button class="py-1 px-2 rounded-full text-xs border border-border cursor-pointer bg-zinc-200 hover:bg-emerald-700 hover:text-white">
              Feedback
            </button>
            <div class="flex items-center px-1">
              <Heroicons.moon class="w-5 h-5 cursor-pointer text-zinc-700 hover:text-emerald-600 transition-colors duration-200" />
            </div>
          </div>
          <%!-- user avatar --%>
          <div class="relative" @click="toggleAccount" x-ref="accountTrigger">
            <img
              src="https://avatars.githubusercontent.com/u/130097627?v=4"
              alt="Kelly Limo"
              class="w-10 h-10 rounded-full object-cover border-2 border-zinc-200 hover:ring-2 hover:ring-emerald-600 transition-all duration-200 cursor-pointer"
            />
            <span class="absolute top-0 right-0 block w-2.5 h-2.5 bg-red-500 rounded-full ring-2 ring-white">
            </span>
          </div>
          <template x-teleport="body">
            <div
              x-show="accountPanelOpen"
              x-transition
              @click.outside="accountPanelOpen = false"
              class="fixed z-50 w-48 rounded-sm border bg-white border-border text-sm text-muted-foreground shadow-lg"
              x-bind:style="`right: ${accountPanelX}px; top: ${accountPanelY}px`"
            >
              <div class="px-4 py-3 border-b border-border">
                <p class="text-xs text-zinc-700 font-semibold">Account</p>
              </div>

    <!-- Account Options -->
              <ul class="divide-y divide-border">
                <li>
                  <a
                    href="/account/notifications"
                    class="flex items-center gap-2 px-2 py-3 hover:bg-zinc-50 transition text-xs text-zinc-800"
                  >
                    <Heroicons.bell_alert class="h-4 w-4 text-zinc-500" /> Notifications
                  </a>
                </li>
                <li>
                  <a
                    href="/account/preferences"
                    class="flex items-center gap-2 px-2 py-3 hover:bg-zinc-50 transition text-xs text-zinc-800"
                  >
                    <Heroicons.user class="h-4 w-4 text-zinc-500" /> Preferences
                  </a>
                </li>
                <li>
                  <a
                    href="/account/billing"
                    class="flex items-center gap-2 px-2 py-3 hover:bg-zinc-50 transition text-xs text-zinc-800"
                  >
                    <Heroicons.credit_card class="h-4 w-4 text-zinc-500" /> Billing
                  </a>
                </li>
                <li>
                  <a
                    href="/account/security"
                    class="flex items-center gap-2 px-2 py-3 hover:bg-zinc-50 transition text-xs text-zinc-800"
                  >
                    <Heroicons.lock_closed class="h-4 w-4 text-zinc-500" /> Security Settings
                  </a>
                </li>
              </ul>

    <!-- Logout Button -->
              <div class="border-t border-border px-4 py-3">
                <button
                  type="button"
                  @click="logoutUser()"
                  class="w-full text-left text-xs text-red-600 hover:underline font-medium"
                >
                  Log out
                </button>
              </div>
            </div>
          </template>
        </div>
      </div>
    </nav>
    """
  end
end
