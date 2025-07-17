defmodule OttrWeb.Landing.CtaButtons do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  attr :rest, :global, include: ~w(style)
  slot :inner_block, required: false

  def cta_buttons(assigns) do
    ~H"""
    <div class="flex gap-4 items-center" @rest>
      <div>
        {render_slot(@inner_block)}
      </div>

      <.link
        href={~p"/users/log_in"}
        class="phx-submit-loading:opacity-75 bg-[white] hover:bg-[white]/80 text-[#004838] text-sm px-4 py-2 font-semibold rounded-sm shadow-none transition-colors text-nowrap"
      >
        Log In
      </.link>

      <.link
        href={~p"/users/register"}
        class="phx-submit-loading:opacity-75 bg-[#073127] hover:bg-[#004838] text-[#E2FB6C] text-sm px-4 py-2 font-light rounded-sm shadow-none transition-colors text-nowrap"
      >
        Start for Free
      </.link>
    </div>
    """
  end
end
