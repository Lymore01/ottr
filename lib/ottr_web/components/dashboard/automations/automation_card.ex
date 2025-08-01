defmodule OttrWeb.Dashboard.Automations.AutomationCard do
  use Phoenix.Component

  attr :from_logo, :string, required: true
  attr :to_logo, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :category, :string, required: false
  attr :button_text, :string, default: "Activate"
  attr :id, :integer, required: true

  def automation_card(assigns) do
    ~H"""
    <div class="bg-white border border-zinc-200 rounded-xl shadow-sm hover:shadow-lg transition group p-6 flex flex-col gap-4">
      <div class="flex items-center gap-3">
        <img src={@from_logo} alt="From" class="h-7 w-7" />
        <Heroicons.arrow_right class="w-5 h-5 text-zinc-400" />
        <img src={@to_logo} alt="To" class="h-7 w-7" />
        <%= if @category do %>
          <span class="ml-auto px-3 py-1 rounded-full text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-100">
            {String.capitalize(@category)}
          </span>
        <% end %>
      </div>

      <div>
        <h2 class="font-semibold text-lg text-[#073127] group-hover:text-emerald-700 transition">
          {@title}
        </h2>

        <p class="text-zinc-500 text-sm mt-1">
          {@description}
        </p>
      </div>

      <button class="mt-auto px-4 py-2 rounded-lg bg-emerald-600 text-white font-medium hover:bg-emerald-700 transition"
        phx-click="show_automation"
        phx-value-id={@id}
      >
        {@button_text}
      </button>
    </div>
    """
  end
end
