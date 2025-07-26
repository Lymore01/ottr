defmodule OttrWeb.Landing.PricingModal do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def pricing_modal(assigns) do
    ~H"""
    <div
      x-show="showPricingModal"
      x-transition
      @keydown.escape.window="showPricingModal = false"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
    >
      <div
        @click.away="showPricingModal = false"
        class="bg-white p-6 rounded-lg shadow-xl max-w-sm w-full text-center"
      >
        <h2 class="text-xl font-semibold text-[#073127] mb-3">🎉 You’re in luck!</h2>

        <p class="text-zinc-700 mb-4 text-sm leading-relaxed">
          Ottr is <span class="font-semibold text-green-700">completely free</span>
          right now...no credit card, no catch, no awkward sales calls.<br /><br />
          While you're here early, you get:
        </p>

        <ul class="text-left text-zinc-700 text-sm space-y-2 mb-4">
          <li>✅ Unlimited workflow runs (yes, really)</li>

          <li>✅ Access to our powerful visual builder</li>

          <li>✅ Smart task retries with zero config</li>

          <li>✅ AI-assisted actions baked right in</li>

          <li>✅ Priority support (because you're special)</li>
        </ul>

        <p class="text-zinc-600 text-xs italic mb-5">
          We're still in early access - so take advantage while it's free!
        </p>

        <p class="text-sm font-medium text-green-800 mb-5">
          Nothing beats an Ottr Burst...not even a Jet2 holiday. 😉
        </p>

        <button
          @click="showPricingModal = false"
          class="w-full phx-submit-loading:opacity-75 bg-[#073127] hover:bg-[#004838] text-[#E2FB6C] text-sm px-4 py-4 font-semibold rounded-sm shadow-none transition-colors"
        >
          Love it. Let’s gooo! 🚀
        </button>
      </div>
    </div>
    """
  end
end
