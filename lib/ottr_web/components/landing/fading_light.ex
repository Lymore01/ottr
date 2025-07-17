defmodule OttrWeb.Landing.FadingLight do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def fading_light(assigns) do
    ~H"""
    <div class="pointer-events-none absolute inset-y-0 left-0 w-16 bg-gradient-to-r from-[#073127] to-transparent z-10">
    </div>

    <div class="pointer-events-none absolute inset-y-0 right-0 w-16 bg-gradient-to-l from-[#073127] to-transparent z-10">
    </div>
    """
  end
end
