defmodule OttrWeb.Landing.WorkflowIllustration do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def workflow_illustration(assigns) do
    ~H"""
    <div class="w-1/3 grid grid-cols-3 grid-rows-2 gap-2 place-items-center relative">
      <!-- Top Left: Trigger -->
      <div class="size-[80px] border-2 border-[#073127] bg-white z-10 flex items-center justify-center">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-6 w-6 text-[#073127]"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M13 10V3L4 14h7v7l9-11h-7z"
          />
        </svg>
      </div>

      <div class="size-[80px] border-2 border-[#073127] bg-white z-10 flex items-center justify-center">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-6 w-6 text-[#073127]"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M4.5 12a7.5 7.5 0 0113.4-4.5M18 7.5H13m5 0V3m1.5 9a7.5 7.5 0 01-13.4 4.5M6 16.5h5m-5 0v4.5"
          />
        </svg>
      </div>

      <div class="size-[80px] border-2 border-[#073127] bg-white z-10 flex items-center justify-center">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="size-6"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="m21 7.5-2.25-1.313M21 7.5v2.25m0-2.25-2.25 1.313M3 7.5l2.25-1.313M3 7.5l2.25 1.313M3 7.5v2.25m9 3 2.25-1.313M12 12.75l-2.25-1.313M12 12.75V15m0 6.75 2.25-1.313M12 21.75V19.5m0 2.25-2.25-1.313m0-16.875L12 2.25l2.25 1.313M21 14.25v2.25l-2.25 1.313m-13.5 0L3 16.5v-2.25"
          />
        </svg>
      </div>

      <div></div>

      <div class="size-[80px] border-2 border-[#073127] bg-white z-10 flex items-center justify-center">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          class="size-6"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M12 16.5V9.75m0 0 3 3m-3-3-3 3M6.75 19.5a4.5 4.5 0 0 1-1.41-8.775 5.25 5.25 0 0 1 10.233-2.33 3 3 0 0 1 3.758 3.848A3.752 3.752 0 0 1 18 19.5H6.75Z"
          />
        </svg>
      </div>

      <div></div>

      <div class="absolute top-[40px] left-[10%] right-[10%] h-px bg-[#073127] z-0"></div>

      <div class="absolute top-[80px] left-1/2 transform -translate-x-1/2 h-[40px] w-px bg-[#073127] z-0">
      </div>
    </div>
    """
  end
end
