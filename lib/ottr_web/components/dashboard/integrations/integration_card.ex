defmodule OttrWeb.Dashboard.Integrations.IntegrationCard do
  use Phoenix.Component

  attr :logo, :string, required: true
  attr :name, :string, required: true
  attr :description, :string, required: true
  attr :category, :string, required: false
  attr :id, :string, required: true
  # attr :on_click, :any, default: nil

  def integration_card(assigns) do
    ~H"""
    <div
      class="bg-white border border-zinc-200 rounded-xl shadow-sm hover:shadow-lg transition group p-6 flex flex-col gap-4 cursor-pointer"
      phx-click="show_integration"
      phx-value-id={@id}
    >
      <div class="flex items-center gap-3">
        <img src={@logo} alt={@name} class="h-9 w-9 rounded bg-zinc-50 p-1 shadow" />
        <div class="flex flex-col">
          <span class="font-semibold text-lg text-[#073127] group-hover:text-emerald-700 transition">
            {@name}
          </span>
          <%= if @category do %>
            <span class="mt-1 px-2 py-0.5 rounded-full text-xs font-medium bg-emerald-50 text-emerald-700 border border-emerald-100">
              {String.capitalize(@category)}
            </span>
          <% end %>
        </div>
      </div>

      <p class="text-zinc-500 text-sm mt-2">
        {@description}
      </p>
    </div>
    """
  end
end
