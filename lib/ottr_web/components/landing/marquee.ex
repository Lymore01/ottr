defmodule OttrWeb.Landing.Marquee do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  import OttrWeb.Landing.{MarqueeLayerOne, MarqueeLayerTwo, FadingLight}

  def marquee(assigns) do
    ~H"""
    <section class="relative w-full overflow-hidden py-8 ">
      <.fading_light />
      <div class="flex flex-col gap-4">
        <.marquee_layer_one /> <.marquee_layer_two />
      </div>
    </section>
    """
  end
end
