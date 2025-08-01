defmodule OttrWeb.Dashboard.Playground.BurstNode do
  use Phoenix.Component
  import OttrWeb.Dashboard.Playground.NodeActions

  # Connector Port
  def node_connector(assigns) do
    ~H"""
    <div
      class={
        "absolute top-1/2 transform -translate-y-1/2 w-4 h-4 bg-blue-500 border-2 border-white shadow-md rounded-full cursor-pointer connector-port " <>
        if @port == "input", do: "left-[-8px]", else: "right-[-8px]"
      }
      x-bind:class={
        "errorPorts.some(p => p.nodeId === '#{@node_id}' && p.portType === '#{@port}') ? 'error' : ''"
      }
      data-node-id={@node_id}
      data-port-type={@port}
      x-on:mousedown.stop={"startConnection('#{@node_id}', '#{@port}')"}
      x-on:mouseup.stop={"completeConnection('#{@node_id}', '#{@port}')"}
      title={@title}
    >
    </div>
    """
  end

  # Main Node Component
  def burst_node(assigns) do
    assigns =
      assigns
      |> assign_new(:node, fn -> %{} end)
      |> assign(:node_type, assigns.node.type || "action")
      |> assign(
        :type_class,
        case assigns.node.type do
          "transform" -> "bg-purple-100 border-purple-300 border-dashed border-2"
          "trigger" -> "bg-green-100 border-green-300"
          "action" -> "bg-blue-100 border-blue-300"
          _ -> "bg-gray-100 border-gray-300"
        end
      )

    ~H"""
    <div
      id={@id}
      x-data="{ isActive: false }"
      x-on:mousedown.stop={"startDrag('#{@node.id}', $event)"}
      x-on:mouseup.window="stopDrag"
      x-on:mousemove.window="onDrag($event)"
      x-bind:style={"{ transform: `translate(${getNodePosition('" <> @node.id <> "').x}px, ${getNodePosition('" <> @node.id <> "').y}px)` }"}
      class={"workflow-node absolute w-64 rounded-xl shadow-sm p-4 text-sm hover:shadow-md transition-shadow duration-200 group select-none border #{@type_class}"}
      x-ref="burst_node"
      @close-node-sheet.window="isActive = false"
      @dblclick={"
      isActive = true;
      $dispatch('open-node-sheet', {
        nodeId: '#{@node.id}',
        nodeType: '#{@node.category}',
        nodeData: { url: 'https://api.example.com', method: 'GET' }
      });
    "}
      x-bind:class="isActive ? 'bg-emerald-100 border-emerald-400 ring-2 ring-emerald-500 shadow-md scale-[1.02]' : ''"
      style="cursor: grab;"
      x-bind:style="{
      transform: `translate(${getNodePosition('#{@node.id}').x}px, ${getNodePosition('#{@node.id}').y}px)`,
      cursor: dragging && activeNode?.id === '#{@node.id}' ? 'grabbing' : 'grab'
    }"
    >
      <div class="flex justify-between items-center mb-2">
        <div class="flex items-center gap-2 font-medium text-gray-800">
          <img src={"/images/logos/#{@node.icon || "default.svg"}"} alt="Icon" class="h-5 w-5" /> {@node.title ||
            "Untitled Node"}
        </div>
         <.node_actions />
      </div>

      <%= if @node.type == "transform" do %>
        <div class="text-xs font-mono text-purple-700 bg-purple-50 p-2 rounded">
          {@node.config.input_field} → {@node.config.output_field}
        </div>
      <% else %>
        <div class="text-xs font-mono text-blue-700 bg-blue-50 p-2 rounded">
          {@node.placeholder || "No placeholder provided"}
        </div>
      <% end %>

      <div class="text-xs text-gray-600 space-y-1">
        <%= if Map.has_key?(@node.config || %{}, "to") do %>
          <div>
            To: <span class="font-medium text-gray-800">{@node.config.to}</span>
          </div>
        <% end %>

        <%= if Map.has_key?(@node.config || %{}, "subject") do %>
          <div>
            Subject: <span class="font-medium text-gray-800">{@node.config.subject}</span>
          </div>
        <% end %>
      </div>
       <.node_connector title="Input Port" port="input" node_id={@node.id} />
      <.node_connector title="Output Port" port="output" node_id={@node.id} />
    </div>
    """
  end
end
