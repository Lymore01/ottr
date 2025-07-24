defmodule OttrWeb.Landing.Solutions do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Landing.{UseCases}

  def solutions(assigns) do
    ~H"""
    <div x-show="openItem === 'solution'" class="space-y-2">
      <h2 class="text-2xl font-semibold leading-tight tracking-tight text-[#073127]">
        Our Solutions
      </h2>

      <p class="text-sm text-zinc-600">
        Details about the solution we offer, key features, and benefits.
      </p>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-10 text-sm text-zinc-700">
        <!-- Solutions Column -->
        <div class="mt-4">
          <h3 class="text-xs font-semibold text-zinc-600 mb-3 uppercase">What Ottr Can Do</h3>

          <ul class="space-y-5">
            <!-- Feature 1 -->
            <li class="flex items-start gap-4">
              <div class="bg-emerald-50 p-2 rounded-md">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="size-6 text-emerald-600"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M3.75 6A2.25 2.25 0 0 1 6 3.75h2.25A2.25 2.25 0 0 1 10.5 6v2.25a2.25 2.25 0 0 1-2.25 2.25H6a2.25 2.25 0 0 1-2.25-2.25V6ZM3.75 15.75A2.25 2.25 0 0 1 6 13.5h2.25a2.25 2.25 0 0 1 2.25 2.25V18a2.25 2.25 0 0 1-2.25 2.25H6A2.25 2.25 0 0 1 3.75 18v-2.25ZM13.5 6a2.25 2.25 0 0 1 2.25-2.25H18A2.25 2.25 0 0 1 20.25 6v2.25A2.25 2.25 0 0 1 18 10.5h-2.25a2.25 2.25 0 0 1-2.25-2.25V6ZM13.5 15.75a2.25 2.25 0 0 1 2.25-2.25H18a2.25 2.25 0 0 1 2.25 2.25V18A2.25 2.25 0 0 1 18 20.25h-2.25A2.25 2.25 0 0 1 13.5 18v-2.25Z"
                  />
                </svg>
              </div>

              <div>
                <p class="font-medium text-zinc-900">Visual Workflow Builder</p>

                <p class="text-sm text-zinc-700">
                  With drag-and-drop — no code needed
                </p>
              </div>
            </li>
            
    <!-- Feature 2 -->
            <li class="flex items-start gap-4">
              <div class="bg-emerald-50 p-2 rounded-md">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="size-6 text-emerald-600"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="m3.75 13.5 10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75Z"
                  />
                </svg>
              </div>

              <div>
                <p class="font-medium text-zinc-900">Real-Time Adaptation</p>

                <p class="text-sm text-zinc-700">
                  Automatically adapt flows based on live data changes.
                </p>
              </div>
            </li>
            
    <!-- Feature 3 -->
            <li class="flex items-start gap-4">
              <div class="bg-emerald-50 p-2 rounded-md">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="size-6 text-emerald-600"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0 3.181 3.183a8.25 8.25 0 0 0 13.803-3.7M4.031 9.865a8.25 8.25 0 0 1 13.803-3.7l3.181 3.182m0-4.991v4.99"
                  />
                </svg>
              </div>

              <div>
                <p class="font-medium text-zinc-900">Bulletproof Task Retries</p>

                <p class="text-sm text-zinc-700">
                  Auto-retry failed tasks with smart backoff logic.
                </p>
              </div>
            </li>
            
    <!-- Feature 4 -->
            <li class="flex items-start gap-4">
              <div class="bg-emerald-50 p-2 rounded-md">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="size-6 text-emerald-600"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M12 6v6h4.5m4.5 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
                  />
                </svg>
              </div>

              <div>
                <p class="font-medium text-zinc-900">Delay & Schedule Execution</p>

                <p class="text-sm text-zinc-700">
                  Run tasks later or on a set schedule.
                </p>
              </div>
            </li>
            
    <!-- Feature 5 -->
            <li class="flex items-start gap-4">
              <div class="bg-emerald-50 p-2 rounded-md">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="size-6 text-emerald-600"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M9.813 15.904 9 18.75l-.813-2.846a4.5 4.5 0 0 0-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 0 0 3.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 0 0 3.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 0 0-3.09 3.09ZM18.259 8.715 18 9.75l-.259-1.035a3.375 3.375 0 0 0-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 0 0 2.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 0 0 2.456 2.456L21.75 6l-1.035.259a3.375 3.375 0 0 0-2.456 2.456ZM16.894 20.567 16.5 21.75l-.394-1.183a2.25 2.25 0 0 0-1.423-1.423L13.5 18.75l1.183-.394a2.25 2.25 0 0 0 1.423-1.423l.394-1.183.394 1.183a2.25 2.25 0 0 0 1.423 1.423l1.183.394-1.183.394a2.25 2.25 0 0 0-1.423 1.423Z"
                  />
                </svg>
              </div>

              <div>
                <p class="font-medium text-zinc-900">AI-Augmented Actions</p>

                <p class="text-sm text-zinc-700">
                  Use AI to enrich, route, or classify data effortlessly.
                </p>
              </div>
            </li>
          </ul>
        </div>
        
    <!-- Use Cases Column -->
        <.use_cases />
      </div>
    </div>
    """
  end
end
