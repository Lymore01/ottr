defmodule OttrWeb.Dashboard.Workflows.WorkflowLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.Workflows.WorkflowCard

  @impl true
  def mount(_params, _session, socket) do
    workflows = [
      %{
        id: 1,
        title: "Slack Bot Setup",
        category: "DevOps",
        description: "Automate your daily standups in Slack using bot commands.",
        modified_at: ~N[2025-07-22 12:30:00],
        tools: [
          %{name: "Slack", icon: "/images/logos/slack.svg"},
          %{name: "Zapier", icon: "/images/logos/zapier.svg"},
          %{name: "GitHub", icon: "/images/logos/github.svg"}
        ]
      },
      %{
        id: 2,
        title: "Instagram Growth Tracker",
        category: "Marketing",
        description: "Track follower growth and engagement in real-time.",
        modified_at: ~N[2025-07-20 09:15:00],
        tools: [
          %{name: "Instagram", icon: "/images/logos/instagram.svg"},
          %{name: "Hootsuite", icon: "/images/logos/hootsuite.svg"},
          %{name: "Google Analytics", icon: "/images/logos/google-analytics.svg"}
        ]
      },
      %{
        id: 3,
        title: "CRM Sync Pipeline",
        category: "Sales",
        description: "Sync leads from your landing page into your CRM effortlessly.",
        modified_at: ~N[2025-07-18 11:00:00],
        tools: [
          %{name: "HubSpot", icon: "/images/logos/hubspot2.svg"},
          %{name: "Salesforce", icon: "/images/logos/salesforce.svg"},
          %{name: "Zapier", icon: "/images/logos/zapier.svg"}
        ]
      },
      %{
        id: 4,
        title: "Daily Focus Planner",
        category: "Productivity",
        description: "Create daily focus cards from Notion and push to Trello.",
        modified_at: ~N[2025-07-19 10:45:00],
        tools: [
          %{name: "Notion", icon: "/images/logos/notion.svg"},
          %{name: "Trello", icon: "/images/logos/trello.svg"},
          %{name: "Google Calendar", icon: "/images/logos/google-calendar.svg"},
          %{name: "Google Calendar", icon: "/images/logos/google-calendar.svg"}
        ]
      }
    ]

    categories = ["All", "Marketing", "DevOps", "Sales", "Productivity"]

    available_tools = [
      %{name: "Slack", icon: "/images/logos/slack.svg"},
      %{name: "Zapier", icon: "/images/logos/zapier2.svg"},
      %{name: "GitHub", icon: "/images/logos/github.svg"},
      %{name: "Instagram", icon: "/images/logos/instagram.svg"},
      %{name: "Google Analytics", icon: "/images/logos/google-analytics.svg"},
      %{name: "Hootsuite", icon: "/images/logos/hootsuite.svg"},
      %{name: "HubSpot", icon: "/images/logos/hubspot2.svg"},
      %{name: "Salesforce", icon: "/images/logos/salesforce.svg"},
      %{name: "Notion", icon: "/images/logos/notion.svg"},
      %{name: "Trello", icon: "/images/logos/trello.svg"},
      %{name: "Google Calendar", icon: "/images/logos/google-calendar.svg"}
    ]

    socket =
      socket
      |> assign(
        page_title: "Bursts",
        page_title_suffix: " | Ottr",
        current_path: "/dashboard/workflows",
        workflows: workflows,
        all_workflows: workflows,
        categories: categories,
        available_tools: available_tools,
        selected_category: "all",
        selected_tools: [],
        selected_date: "all",
        search_term: ""
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("filter_category", %{"category" => category}, socket) do
    filtered =
      filter_workflows(
        socket.assigns.all_workflows,
        category,
        socket.assigns.selected_tools,
        socket.assigns.search_term
      )

    {:noreply,
     assign(socket,
       selected_category: category,
       workflows: filtered
     )}
  end

  def handle_event("filter_tools", %{"tool" => tool}, socket) do
    selected = socket.assigns.selected_tools

    new_selected =
      if tool in selected do
        List.delete(selected, tool)
      else
        [tool | selected]
      end

    filtered =
      filter_workflows(
        socket.assigns.all_workflows,
        socket.assigns.selected_category,
        new_selected,
        socket.assigns.search_term
      )

    {:noreply,
     assign(socket,
       selected_tools: new_selected,
       workflows: filtered
     )}
  end

  def handle_event("search", %{"search_term" => term}, socket) do
    filtered =
      filter_workflows(
        socket.assigns.all_workflows,
        socket.assigns.selected_category,
        socket.assigns.selected_tools,
        term
      )
    socket =
      socket |> assign(search_term: term)
    |> assign(workflows: filtered)
    |> push_event("search_done", %{})

    {:noreply, socket}
  end

  defp filter_workflows(workflows, category, selected_tools, search_term) do
    workflows
    |> Enum.filter(fn wf ->
      (category == "all" or String.downcase(wf.category) == String.downcase(category)) and
        (search_term == "" or
           String.contains?(String.downcase(wf.title), String.downcase(search_term))) and
        (Enum.empty?(selected_tools) or Enum.any?(wf.tools, fn t -> t.name in selected_tools end))
    end)
  end
end
