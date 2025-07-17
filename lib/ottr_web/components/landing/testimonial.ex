defmodule OttrWeb.Landing.Testimonial do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def testimonial(assigns) do
    ~H"""
    <section class="relative text-foreground px-6 sm:px-16 py-24 max-w-8xl w-full flex flex-col gap-4 items-center overflow-hidden">
      <div class="text-6xl text-[#073127] italic font-mono leading-none">
        "
      </div>

      <div class="max-w-2xl text-center">
        <p class="text-xl sm:text-2xl font-medium leading-8 tracking-tight text-[#073127]">
          "Ottr completely changed the way we build internal tools. What used to take our dev team days now takes minutes and without writing a single line of code. The visual builder is intuitive, the retries are bulletproof, and honestly, it just works. We set it, forget it, and Ottr handles the rest."
        </p>
      </div>

      <div class="mt-8 flex flex-col items-center gap-2">
        <img
          src="https://i.pravatar.cc/100?img=12"
          alt="Reviewer photo"
          class="w-16 h-16 rounded-full object-cover shadow-md"
        />
        <p class="text-base font-semibold text-[#073127]">Tung Sahur</p>

        <p class="text-sm text-zinc-600">Head of Operations @ Trackify</p>
      </div>
    </section>
    """
  end
end
