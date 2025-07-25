defmodule OttrWeb.Dashboard.MoreButton do
  use Phoenix.Component

  attr :navigate, :string, required: true
  attr :title, :string, default: "Browse all automations"
  attr :aria_label, :string, default: "Browse all automations"

  def more_button(assigns) do
    ~H"""
    <.link
      class="text-xs text-blue-600 hover:underline font-medium flex items-center gap-1"
      navigate={@navigate}
      title={@title}
      aria-label={@aria_label}
      role="button"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="w-4 h-4"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
      </svg>
      More
    </.link>
    """
  end
end
