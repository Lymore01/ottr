defmodule OttrWeb.Dashboard.Workflows.Playground.PlaygroundLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.Playground

  def mount(%{"id" => id} = _params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Playground")
      |> assign(:workflows, [])
      |> assign(
        page_title: "Playground",
        page_title_suffix: " | Ottr",
        current_path: ~p"/dashboard/workflows/#{id}/playground"
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    socket =
      socket
      |> assign(:workflow_id, id)
      |> assign(:page_title, "Playground - #{id}")

    {:noreply, socket}
  end
end
