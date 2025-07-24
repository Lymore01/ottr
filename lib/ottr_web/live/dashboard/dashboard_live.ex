defmodule OttrWeb.Dashboard.DashboardLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.{Sidebar, Topbar}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: "Dashboard",
        page_title_suffix: " | Ottr",
        current_path: "/dashboard",
        workflows: [
          %{id: 1, name: "Daily Sync"},
          %{id: 2, name: "Marketing Campaign"},
          %{id: 3, name: "Customer Onboarding"},
          %{id: 4, name: "Weekly Report Automation"},
          %{id: 5, name: "Sales Follow-Up"},
          %{id: 6, name: "Bug Triage"},
          %{id: 7, name: "Feature Launch Prep"}
        ]
      )

    {:ok, socket}
  end
end
