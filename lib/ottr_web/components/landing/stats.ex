defmodule OttrWeb.Landing.Stats do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def stats(assigns) do
    ~H"""
    <section class="bg-[#EBEDE8] relative text-foreground px-6 sm:px-16 py-24 max-w-8xl w-[90%] flex flex-col gap-10 items-center overflow-hidden rounded-lg mx-auto">
      <div class="w-full flex justify-center gap-24 text-center items-center mx-auto">
        <div>
          <h2 class="text-4xl font-extrabold text-[#073127]">10,000+</h2>

          <p class="mt-2 text-sm text-zinc-600 tracking-wide">Workflows Created</p>
        </div>

        <div>
          <h2 class="text-4xl font-extrabold text-[#073127]">15 Hours</h2>

          <p class="mt-2 text-sm text-zinc-600 tracking-wide">Time Saved Weekly</p>
        </div>

        <div>
          <h2 class="text-4xl font-extrabold text-[#073127]">99.9%</h2>

          <p class="mt-2 text-sm text-zinc-600 tracking-wide">Retry Success Rate</p>
        </div>
      </div>
    </section>
    """
  end
end
