defmodule OttrWeb.Landing.Navbar do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Landing.{CtaButtons}

  def navbar(assigns) do
    ~H"""
    <header class="w-full relative ">
      <nav class="flex justify-between items-center">
        <div class="flex items-center w-full">
          <h1 class="font-semibold text-lg tracking-tighter text-brand">Ottr.</h1>

          <ul class="flex items-center gap-8 text-sm ml-20 text-zinc-800">
            <li class="flex items-center gap-1 transition-colors duration-200 hover:text-zinc-600 cursor-pointer">
              Solution
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
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </li>

            <li class="flex items-center gap-1 transition-colors duration-200 hover:text-zinc-600 cursor-pointer">
              Customers
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
                  d="M19 9l-7 7-7-7"
                />
              </svg>
            </li>

            <li class="transition-colors duration-200 hover:text-zinc-600 cursor-pointer">
              Pricing
            </li>
          </ul>
        </div>

        <.cta_buttons>
          <.link
            href={~p"/users/log_out"}
            method="delete"
            class="phx-submit-loading:opacity-75 bg-[white] hover:bg-[white]/80 text-[#004838] text-sm px-4 py-2 font-semibold rounded-sm shadow-none transition-colors text-nowrap"
          >
            Log out
          </.link>
        </.cta_buttons>
      </nav>
    </header>
    """
  end
end
