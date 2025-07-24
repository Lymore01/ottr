defmodule OttrWeb.Landing.Features do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Landing.{WorkflowIllustration}

  def features(assigns) do
    ~H"""
    <section class="text-foreground h-auto px-16 py-24 max-w-8xl w-full flex flex-col items-center">
      <div class="w-full flex items-center justify-center">
        <div class="flex items-center gap-3">
          <div class="relative flex h-3 w-3">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-500 opacity-75">
            </span> <span class="relative inline-flex rounded-full h-3 w-3 bg-[#073127]"></span>
          </div>

          <h1 class="text-sm font-semibold leading-6 tracking-tighter text-[#073127] uppercase">
            Features
          </h1>
        </div>
      </div>

      <div class="space-y-4 mt-6 w-full max-w-3xl mx-auto">
        <h1 class="text-2xl sm:text-3xl font-semibold leading-tight tracking-tight text-[#073127] text-center">
          Features That Make Automation <br class="hidden sm:inline" /> Feel Like Magic
        </h1>

        <p class="text-base leading-relaxed text-zinc-600 text-center">
          From drag-and-drop building to bulletproof retries, Ottr gives you the power<br class="hidden sm:inline" />
          to automate anything without breaking a sweat.
        </p>
      </div>
      <%!-- features --%>
      <div
        class="max-w-6xl w-full mt-10 space-y-4 h-auto"
        style="
    position: relative;
    background-image:
    linear-gradient(rgba(0, 0, 0, 0.03) 1px, transparent 1px),
    linear-gradient(to right, rgba(0, 0, 0, 0.03) 1px, transparent 1px);
    background-size: 40px 40px;
    background-position: center;
    background-repeat: repeat;


    "
      >
        <div class="w-full px-6 py-8 justify-between flex">
          <div class="flex flex-col gap-4 w-1/2">
            <h3 class="text-lg font-medium leading-tight tracking-tight text-[#073127]">
              Visual Workflow Builder
            </h3>

            <p class="text-base leading-relaxed text-zinc-600 text-balance">
              Drag, drop, and automate 👉 no code required. Build complex workflows with ease.
            </p>

            <button class="w-fit mt-16 phx-submit-loading:opacity-75 bg-[#073127] hover:bg-[#004838] text-[#E2FB6C] text-sm px-4 py-2 font-light rounded-sm shadow-none transition-colors">
              Explore More
            </button>
          </div>
          <.workflow_illustration />
        </div>

        <div class="w-full flex gap-4 px-6 py-8 ">
          <div class="flex flex-col gap-4">
            <div class=" gap-4 flex flex-col">
              <h3 class="text-lg font-semibold text-[#073127]">Reliable Retry System</h3>

              <p class="text-base leading-relaxed text-zinc-600 text-balance">
                Automatically retries failed tasks with smart backoff logic ensuring nothing slips through the cracks.
              </p>
            </div>

            <button class="w-fit mt-16 phx-submit-loading:opacity-75 bg-[#073127] hover:bg-[#004838] text-[#E2FB6C] text-sm px-4 py-2 font-light rounded-sm shadow-none transition-colors">
              Learn More
            </button>
          </div>

          <div class="flex flex-col gap-4">
            <div class=" gap-4 flex flex-col">
              <h3 class="text-lg font-semibold text-[#073127]">Built-In Scheduling</h3>

              <p class="text-base leading-relaxed text-zinc-600 text-balance">
                Delay tasks or run them on a schedule perfect for reminders, timed triggers, or off-peak automation.
              </p>
            </div>

            <button class="w-fit mt-16 phx-submit-loading:opacity-75 bg-[#073127] hover:bg-[#004838] text-[#E2FB6C] text-sm px-4 py-2 font-light rounded-sm shadow-none transition-colors">
              Learn More
            </button>
          </div>
        </div>
      </div>
    </section>
    """
  end
end
