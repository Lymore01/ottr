defmodule OttrWeb.Dashboard.Templates.TemplateLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.Templates.{TemplateCard}

  def list_templates do
  [
    %{
      id: "slack-notification",
      logo: "/images/logos/slack.svg",
      title: "Slack Notification Template",
      description: "A template for sending notifications to Slack channels.",
      category: "communication",
      button_text: "Use Template",
      steps: [
        "Trigger: An event occurs in your app.",
        "Format the notification message.",
        "Send the message to the specified Slack channel."
      ]
    },
    %{
      id: "instagram-post",
      logo: "/images/logos/mailchimp.svg",
      title: "Mailchimp Campaign Template",
      description: "A template for creating email campaigns in Mailchimp.",
      category: "marketing",
      button_text: "Use Template",
      steps: [
        "Trigger: New content is ready to share.",
        "Design the email campaign in Mailchimp.",
        "Send the campaign to your audience."
      ]
    },
    %{
      id: "github-issue",
      logo: "/images/logos/github.svg",
      title: "GitHub Issue Template",
      description: "A template for standardizing GitHub issues in your repository.",
      category: "development",
      button_text: "Use Template",
      steps: [
        "Trigger: A bug or feature request is identified.",
        "Fill out the issue template with required details.",
        "Submit the issue to the GitHub repository."
      ]
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

  def get_template_by_id(id) do
    Enum.find(list_templates(), fn template -> template.id == id end)
  end

  def get_template_by_id!(id) do
    case get_template_by_id(id) do
      nil -> raise "Template not found"
      template -> template
    end
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: "Templates",
        page_title_suffix: " | Ottr",
        current_path: "/dashboard/templates",
        workflows: [],
        categories: list_categories(),
        templates: list_templates(),
        selected_template: nil
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
  template = get_template_by_id!(id)

  socket =
    socket
    |> assign(:selected_template, template)

  {:noreply, socket}
end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, selected_template: nil)}
  end

  def handle_event("show_template", %{"id" => id}, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/templates/#{id}")}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/templates")}
  end
end
