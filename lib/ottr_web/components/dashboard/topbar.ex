defmodule OttrWeb.Dashboard.Topbar do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def topbar(assigns) do
    ~H"""
    <nav
      x-data="topbar"
      class="fixed w-screen top-0 bg-white/30 backdrop-blur-lg border-b border-zinc-200 shadow-sm flex flex-row justify-between max-h-[50px] py-2 transition-all duration-300 ease-in-out"
      x-bind:style="{
    'transform': currentMode === 'collapsed'
      ? 'translateX(60px)'
      : (currentMode === 'hover' && hover === true || currentMode === 'expanded')
        ? 'translateX(220px)'
        : 'translateX(60px)'
    }"
    >
      <div
        class="w-full h-full flex items-center ml-4 justify-between"
        x-bind:style="{
    'margin-right': currentMode === 'collapsed'
      ? '80px'
      : (currentMode === 'hover' && hover === true || currentMode === 'expanded')
        ? '240px'
      : '80px'
    }"
      >
        <!-- Workflow Name -->
        <div class="flex items-center gap-2 relative">
          <span class="font-medium text-zinc-700 text-sm capitalize">
            Community Engagement Workflow
          </span>

          <div
            class="flex items-center justify-center p-2 hover:bg-emerald-50 cursor-pointer transition-colors duration-200 rounded-md"
            @click="workflowOptionPanel = true"
            x-ref="workflowOptionsTrigger"
          >
            <Heroicons.chevron_up_down class="w-5 h-5 cursor-pointer text-zinc-700 hover:text-emerald-600 transition-colors duration-200" />
          </div>

          <template x-teleport="body">
            <div x-show="workflowOptionPanel" x-transition @click.outside="workflowOptionPanel = false">
              hello
            </div>
          </template>
        </div>

        <div class="flex gap-4 items-center">
          <div class="relative flex gap-4 p-2 border border-border rounded-full hover:bg-zinc-100 transition-colors duration-200">
            <Heroicons.moon class="w-5 h-5 cursor-pointer text-zinc-700 hover:text-emerald-600 transition-colors duration-200" />
            <Heroicons.bell_alert class="w-5 h-5 cursor-pointer text-zinc-700 hover:text-emerald-600 transition-colors duration-200" />
          </div>
           <%!-- user avatar --%>
          <div class="relative">
            <img
              src="https://avatars.githubusercontent.com/u/130097627?v=4"
              alt="Kelly Limo"
              class="w-10 h-10 rounded-full object-cover border-2 border-zinc-200 hover:ring-2 hover:ring-emerald-600 transition-all duration-200 cursor-pointer"
            />
            <span class="absolute top-0 right-0 block w-2.5 h-2.5 bg-red-500 rounded-full ring-2 ring-white">
            </span>
          </div>
        </div>
      </div>
    </nav>
    """
  end
end
