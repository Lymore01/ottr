defmodule OttrWeb.Landing.Integrations do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Landing.{Marquee}

  def integrations(assigns) do
    ~H"""
    <section class="relative text-white px-6 sm:px-16 py-24 max-w-8xl w-full flex flex-col items-center bg-[#073127] overflow-hidden">
      <div
        class="absolute top-0 left-0 w-full h-[400px] z-0"
        style="
      background-image:
        linear-gradient(rgba(255, 255, 255, 0.07) 1px, transparent 1px),
        linear-gradient(to right, rgba(255, 255, 255, 0.07) 1px, transparent 1px);
      background-size: 60px 40px;
      background-position: center;
      mask-image: radial-gradient(circle at center, black 30%, transparent 100%);
      -webkit-mask-image: radial-gradient(circle at center, black 30%, transparent 100%);
    "
      >
      </div>

      <div class="relative z-10 w-full flex items-center justify-center">
        <div class="flex items-center gap-3">
          <div class="relative flex h-3 w-3">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75">
            </span> <span class="relative inline-flex rounded-full h-3 w-3 bg-green-500"></span>
          </div>

          <h2 class="text-sm font-medium tracking-tight text-green-100 uppercase">Integrations</h2>
        </div>
      </div>

      <div class="relative z-10 space-y-4 mt-8 w-full max-w-3xl text-center">
        <h1 class="text-2xl sm:text-3xl font-semibold leading-tight tracking-tight text-white">
          Don’t Replace. Integrate Seamlessly.
        </h1>

        <p class="text-base leading-relaxed font-light text-zinc-200">
          Connect Ottr with the tools you already use. From Slack to PostgreSQL to your
          <br class="hidden sm:inline" /> internal APIs — your workflow, your way.
        </p>
      </div>
      <.marquee />
    </section>
    """
  end
end
