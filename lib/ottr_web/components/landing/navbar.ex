defmodule OttrWeb.Landing.Navbar do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Landing.{CtaButtons, Solutions, Products, PricingModal}

  def navbar(assigns) do
    ~H"""
    <header class="w-full relative" x-data=" { openItem : null, showPricingModal: false } ">
      <nav class="flex justify-between items-center">
        <div class="flex items-center w-full">
          <h1 class="font-semibold text-lg tracking-tighter text-brand">Ottr.</h1>

          <ul class="flex items-center gap-6 text-sm ml-20 text-zinc-800">
            <li
              class="flex items-center gap-1 transition-colors duration-200 hover:text-zinc-600 cursor-pointer hover:bg-[white]/50 cursor-pointer p-2 rounded-sm"
              x-bind:class="openItem === 'solution' ? 'bg-emerald-50 text-emerald-600 transition-colors hover:bg-emerald-50 hover:text-emerald-600' : 'bg-transparent'"
              @click="openItem = openItem === 'solution' ? null : 'solution'"
            >
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

            <li
              class="flex items-center gap-1 transition-colors duration-200 hover:text-zinc-600 cursor-pointer hover:bg-[white]/50 cursor-pointer p-2 rounded-sm"
              x-bind:class="openItem === 'products' ? 'bg-emerald-50 text-emerald-600 transition-colors hover:bg-emerald-50 hover:text-emerald-600' : 'bg-transparent'"
              @click="openItem = openItem === 'products' ? null : 'products'"
            >
              Products
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

            <li
              class="transition-colors duration-200 hover:text-zinc-600 hover:bg-[white]/50 cursor-pointer p-2 rounded-sm"
              @click="showPricingModal = true"
            >
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
      <!-- Dropdown Panel -->
      <div
        class="absolute top-full left-0 w-full bg-white shadow p-6 border-t z-10 mt-2 rounded-lg"
        x-show="openItem"
        x-transition
      >
        <.solutions /> <.products />
      </div>
      <.pricing_modal />
    </header>
    """
  end
end
