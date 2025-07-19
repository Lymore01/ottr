defmodule OttrWeb.Dashboard.DashboardLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.{Sidebar, Topbar}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: "Dashboard",
        page_title_suffix: " | Ottr",
        current_path: "/dashboard"
      )

    {:ok, socket}
  end
end
