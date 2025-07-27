# Todo: update the dropdown functionality
defmodule OttrWeb.Dashboard.Workflows.WorkflowCard do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import Timex

  attr :id, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: false, default: ""
  attr :category, :string, default: nil
  attr :modified_at, :any, required: true
  attr :tools, :list, default: []
  attr :navigate, :string

  def workflow_card(assigns) do
    ~H"""
    <li
      id={"workflow-card-#{@id}"}
      class="p-3 bg-zinc-50 border border-zinc-200 rounded-lg hover:bg-white transition flex items-center justify-between group/recent relative"
    >
      <.link
        class="flex flex-grow items-center gap-4 cursor-pointer truncate w-[100%]"
        navigate={@navigate}
        phx-value-id={@id}
      >
        <div class="flex flex-col w-full max-w-[50%] truncate">
          <span class="text-sm font-medium text-zinc-800">{@title}</span>
          <p class="text-xs text-zinc-500">Last edited {format_modified(@modified_at)}</p>
        </div>

        <%= if @description != "" do %>
          <p class="text-xs text-zinc-600 mt-1 flex-1 mx-4 truncate">{@description}</p>
        <% end %>

        <div class="flex gap-2 items-center justify-start flex-grow">
          <%= for tool <- Enum.take(@tools, 3) do %>
            <div class="p-2 group-hover/recent:bg-zinc-50 bg-white rounded-lg flex items-center justify-center">
              <img src={tool.icon} alt={tool.name} class="w-6 h-6" />
            </div>
          <% end %>

          <%= if length(@tools) > 3 do %>
            <div class="p-2 group-hover/recent:bg-zinc-50 bg-white rounded-lg flex items-center justify-center">
              <span class="text-xs text-zinc-500 font-medium">+{length(@tools) - 3} more</span>
            </div>
          <% end %>
        </div>
      </.link>

      <div class="relative ml-4 flex items-center">
        <button
          type="button"
          aria-haspopup="true"
          aria-expanded="false"
          id={"actions-menu-button-#{@id}"}
          phx-click={toggle_dropdown("actions-dropdown-#{@id}")}
          class="p-1 rounded-full hover:bg-zinc-200 focus:outline-none focus:ring-2 focus:ring-emerald-400"
          phx-click-away={JS.hide(to: "##{"actions-dropdown-#{@id}"}")}
        >
          <Heroicons.ellipsis_vertical class="w-5 h-5 text-zinc-600" />
          <span class="sr-only">Open actions menu</span>
        </button>

        <div
          id={"actions-dropdown-#{@id}"}
          class="hidden absolute right-4 mt-2 w-40 bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5 z-20"
          role="menu"
          aria-orientation="vertical"
          aria-labelledby={"actions-menu-button-#{@id}"}
          tabindex="-1"
        >
          <a
            href="#"
            phx-click="edit_workflow"
            phx-value-id={@id}
            class="block px-4 py-2 text-sm text-zinc-700 hover:bg-emerald-100"
            role="menuitem"
            tabindex="-1"
          >
            Edit
          </a>

          <a
            href="#"
            phx-click="duplicate_workflow"
            phx-value-id={@id}
            class="block px-4 py-2 text-sm text-zinc-700 hover:bg-emerald-100"
            role="menuitem"
            tabindex="-1"
          >
            Duplicate
          </a>

          <a
            href="#"
            phx-click="delete_workflow"
            phx-value-id={@id}
            class="block px-4 py-2 text-sm text-red-600 hover:bg-red-100"
            role="menuitem"
            tabindex="-1"
          >
            Delete
          </a>
        </div>
      </div>
    </li>
    """
  end

  defp format_modified(%NaiveDateTime{} = datetime) do
    Timex.format!(datetime, "{Mshort} {D}, {YYYY}")
  end

  defp format_modified(_), do: "Unknown"

  defp toggle_dropdown(dropdown_id) do
    JS.toggle(to: "##{dropdown_id}")
  end
end
