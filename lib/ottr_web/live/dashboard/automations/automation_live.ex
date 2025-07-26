defmodule OttrWeb.Dashboard.Automations.AutomationLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.Automations.{AutomationCard}

  def list_automations do
    [
      %{
        id: 1,
        from_logo: "/images/logos/slack.svg",
        to_logo: "/images/logos/stripe.svg",
        title: "Send Slack alerts for Stripe payments",
        description: "Get instant Slack notifications whenever you receive a new Stripe payment.",
        category: "financial",
        button_text: "Activate",
        steps: [
          "Trigger: A new payment is received via Stripe.",
          "Extract payment details (amount, customer, time).",
          "Send a formatted message to the designated Slack channel."
        ],
        use_cases: [
          "Notify your finance team of successful payments.",
          "Monitor high-value transactions in real-time.",
          "Alert customer success teams when premium accounts are activated."
        ],
        setup_time: "5–10 minutes"
      },
      %{
        id: 2,
        from_logo: "/images/logos/discord.svg",
        to_logo: "/images/logos/mailchimp.svg",
        title: "Notify Discord on Mailchimp campaigns",
        description:
          "Post updates to your Discord channel when a new Mailchimp campaign is sent.",
        category: "marketing",
        button_text: "Activate",
        steps: [
          "Trigger: A Mailchimp campaign is sent.",
          "Retrieve campaign summary (subject, audience, time).",
          "Post a formatted notification to a Discord channel."
        ],
        use_cases: [
          "Keep your community updated on newsletters.",
          "Announce promotional campaigns to internal teams.",
          "Track campaign engagement in a shared channel."
        ],
        setup_time: "5–8 minutes"
      },
      %{
        id: 3,
        from_logo: "/images/logos/github.svg",
        to_logo: "/images/logos/jira.svg",
        title: "Create Jira tickets from GitHub issues",
        description:
          "Automatically create Jira tickets for new GitHub issues in your repository.",
        category: "development",
        button_text: "Activate",
        steps: [
          "Trigger: A new GitHub issue is created.",
          "Extract issue title and description.",
          "Create a corresponding ticket in Jira with mapped fields."
        ],
        use_cases: [
          "Sync development tasks between platforms.",
          "Ensure no issue is missed in sprint planning.",
          "Centralize work tracking in Jira while using GitHub issues."
        ],
        setup_time: "7–12 minutes"
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

  def get_automation_by_id(id) do
    Enum.find(list_automations(), fn automation -> automation.id == id end)
  end

  def get_automation_by_id!(id) do
    case get_automation_by_id(id) do
      nil -> raise "Automation with ID #{id} not found"
      automation -> automation
    end
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: "Automation",
        page_title_suffix: " | Ottr",
        current_path: "/dashboard/automations",
        categories: list_categories(),
        automations: list_automations(),
        selected_automation: nil
      )
      |> assign(workflows: [])

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    automation = get_automation_by_id!(String.to_integer(id))
    socket = assign(socket, :selected_automation, automation)
    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, selected_automation: nil)}
  end

  def handle_event("show_automation", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/automations/#{id}")}
  end

  def handle_event("close_automation_modal", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/automations")}
  end
end
