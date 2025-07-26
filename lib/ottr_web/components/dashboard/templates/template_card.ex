defmodule OttrWeb.Dashboard.Templates.TemplateCard do
   use Phoenix.Component

  attr :logo, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true
  attr :category, :string, required: false
  attr :button_text, :string, default: "Use Template"
  attr :id, :string, required: true

  def template_card(assigns) do
    ~H"""
    <div class="bg-white border border-zinc-200 rounded-xl shadow-sm hover:shadow-lg transition group p-6 flex flex-col gap-4">
      <div class="flex items-center gap-3">
        <img src={@logo} alt="Logo" class="h-7 w-7" />
        <%= if @category do %>
          <span class="ml-auto px-3 py-1 rounded-full text-xs font-semibold bg-blue-50 text-blue-700 border border-blue-100">
            {String.capitalize(@category)}
          </span>
        <% end %>
      </div>

      <div>
        <h2 class="font-semibold text-lg text-[#073127] group-hover:text-blue-700 transition">
          {@title}
        </h2>

        <p class="text-zinc-500 text-sm mt-1">
          {@description}
        </p>
      </div>

      <button class="mt-auto px-4 py-2 rounded-lg bg-blue-600 text-white font-medium hover:bg-blue-700 transition"
        phx-click="show_template"
        phx-value-id={@id}
      >
        {@button_text}
      </button>
      </div>
    """
  end
end
