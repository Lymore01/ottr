defmodule OttrWeb.Dashboard.Integrations.IntegrationLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.Integrations.{IntegrationCard}

  def fetch_integrations do
  [
    %{
      id: "slack",
      name: "Slack",
      logo: "/images/logos/slack.svg",
      description: "Collaborate with your team and receive instant notifications in Slack channels.",
      category: "communication",
      tagline: "Automate team notifications and updates.",
      status: "Popular",
      automations_count: 5,
      templates_count: 2,
      connected: true,
      features: ["Send messages", "Receive alerts", "Automate workflows"],
      triggers: ["New message", "New channel", "Mention"],
      actions: ["Send message", "Create channel"],
      last_updated: "2024-07-01",
      author: "Ottr Team",
      docs_url: "/docs/integrations/slack"
    },
    %{
      id: "notion",
      name: "Notion",
      logo: "/images/logos/notion.svg",
      description: "Organize your notes, docs, and projects with Notion’s all-in-one workspace.",
      category: "productivity",
      tagline: "Sync docs and automate project management.",
      status: "Beta",
      automations_count: 3,
      templates_count: 1,
      connected: false,
      features: ["Sync pages", "Create tasks", "Database automation"],
      triggers: ["New page", "Database updated"],
      actions: ["Create page", "Update database"],
      last_updated: "2024-06-15",
      author: "Ottr Team",
      docs_url: "/docs/integrations/notion"
    },
    %{
      id: "stripe",
      name: "Stripe",
      logo: "/images/logos/stripe.svg",
      description: "Accept payments, manage subscriptions, and automate your business finances with Stripe.",
      category: "financial",
      tagline: "Automate payment alerts and financial workflows.",
      status: "Popular",
      automations_count: 4,
      templates_count: 2,
      connected: false,
      features: ["Payment alerts", "Subscription management", "Financial reporting"],
      triggers: ["New payment", "Subscription created"],
      actions: ["Send alert", "Create invoice"],
      last_updated: "2024-07-10",
      author: "Ottr Team",
      docs_url: "/docs/integrations/stripe"
    }
  ]
end

  def list_categories do
    [
      %{label: "All", value: "all"},
      %{label: "Financial", value: "financial"},
      %{label: "Marketing", value: "marketing"},
      %{label: "Development", value: "development"},
      %{label: "Project Management", value: "project management"},
      %{label: "Productivity", value: "productivity"},
      %{label: "Communication", value: "communication"},
      %{label: "Data Management", value: "data management"},
      %{label: "Social", value: "social"}
    ]
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: "Integrations",
        page_title_suffix: " | Ottr",
        current_path: "/dashboard/integrations",
        categories: list_categories(),
        integrations: fetch_integrations(),
        selected_integration: nil
      )
      |> assign(workflows: [])

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    integration = Enum.find(socket.assigns.integrations, fn i -> i.id == id end)

    if integration do
      socket = assign(socket, :selected_integration, integration)
      {:noreply, socket}
    else
      {:noreply, push_patch(socket, to: ~p"/dashboard/integrations")}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, selected_integration: nil)}
  end

  def handle_event("show_integration", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/integrations/#{id}")}
  end

  def handle_event("close_integration_modal", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/integrations")}
  end
end
