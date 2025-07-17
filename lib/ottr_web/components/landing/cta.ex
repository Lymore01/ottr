defmodule OttrWeb.Landing.Cta do
  use Phoenix.Component

  use OttrWeb, :verified_routes

   import OttrWeb.Landing.{CtaButtons}

  def cta(assigns) do
    ~H"""
    <section class="bg-[#004838] text-white py-20 px-6 sm:px-16 mt-16">
      <div class="flex items-center justify-between">
        <div class="w-1/2">
          <h2 class="text-2xl sm:text-3xl font-medium leading-tight tracking-tight text-balance">
            Ready to Automate
            <span class="relative">
              Smarter
              <span class="absolute left-0 bottom-0 w-full h-1 bg-gradient-to-r from-green-400 to-[#E2FB6C] rounded">
              </span>
            </span>
            , <br class="hidden sm:inline" /> Not Harder?
          </h2>
        </div>

        <.cta_buttons />
      </div>
    </section>
    """
  end
end
