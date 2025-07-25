defmodule OttrWeb.Ui.DotGradient do
  use Phoenix.Component

  use OttrWeb, :verified_routes

  def dot_gradient(assigns) do
    ~H"""
    <div
      class="absolute top-0 left-0 w-full h-full z-0"
      style="
    background-image:
      radial-gradient(circle, rgba(0, 0, 0, 0.15) 1px, transparent 1px),
      radial-gradient(circle, rgba(0, 0, 0, 0.15) 1px, transparent 1px);
    background-size: 24px 24px;
    background-position: 7px 7px, 7px 7px;
    "
    >
    </div>
    """
  end
end
