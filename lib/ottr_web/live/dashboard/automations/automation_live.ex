defmodule OttrWeb.Dashboard.Automations.AutomationLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.Automations.{AutomationCard}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        page_title: "Automation",
        page_title_suffix: " | Ottr",
        current_path: "/dashboard/automations",
        categories: [
          %{label: "All", value: "all"},
          %{label: "Financial", value: "financial"},
          %{label: "Marketing", value: "marketing"},
          %{label: "Development", value: "development"},
          %{label: "Project Management", value: "project management"},
          %{label: "Productivity", value: "productivity"},
          %{label: "Communication", value: "communication"},
          %{label: "Data Management", value: "data management"},
          %{label: "Social", value: "social"},

        ],
        automations: [
          %{
            from_logo: "/images/logos/slack.svg",
            to_logo: "/images/logos/stripe.svg",
            title: "Send Slack alerts for Stripe payments",
            description:
              "Get instant Slack notifications whenever you receive a new Stripe payment.",
            category: "financial",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/discord.svg",
            to_logo: "/images/logos/mailchimp.svg",
            title: "Notify Discord on Mailchimp campaigns",
            description:
              "Post updates to your Discord channel when a new Mailchimp campaign is sent.",
            category: "marketing",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/github.svg",
            to_logo: "/images/logos/jira.svg",
            title: "Create Jira tickets from GitHub issues",
            description:
              "Automatically create Jira tickets for new GitHub issues in your repository.",
            category: "development",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/trello.svg",
            to_logo: "/images/logos/asana.svg",
            title: "Sync Trello cards to Asana tasks",
            description:
              "Keep your Trello boards and Asana projects in sync with automatic updates.",
            category: "project management",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/slack.svg",
            to_logo: "/images/logos/google-calendar.svg",
            title: "Create Google Calendar events from Slack messages",
            description:
              "Turn important Slack messages into Google Calendar events with one click.",
            category: "productivity",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/stripe.svg",
            to_logo: "/images/logos/paypal.svg",
            title: "Send PayPal invoices for Stripe payments",
            description:
              "Automatically generate PayPal invoices for every new Stripe payment received.",
            category: "financial",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/mailchimp.svg",
            to_logo: "/images/logos/salesforce.svg",
            title: "Add Mailchimp subscribers to Salesforce",
            description: "Sync new Mailchimp subscribers directly to your Salesforce contacts.",
            category: "marketing",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/zoom.svg",
            to_logo: "/images/logos/slack.svg",
            title: "Post Zoom meeting summaries to Slack",
            description: "Automatically share Zoom meeting summaries in your Slack channel.",
            category: "communication",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/airtable.svg",
            to_logo: "/images/logos/google-sheets.svg",
            title: "Sync Airtable records to Google Sheets",
            description: "Keep your Airtable data up-to-date in Google Sheets automatically.",
            category: "data management",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/github.svg",
            to_logo: "/images/logos/slack.svg",
            title: "Notify Slack on GitHub pull requests",
            description:
              "Get instant Slack notifications for new GitHub pull requests in your repositories.",
            category: "development",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/discord.svg",
            to_logo: "/images/logos/google-drive.svg",
            title: "Share Google Drive files in Discord",
            description: "Automatically post Google Drive file links in your Discord channels.",
            category: "communication",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/stripe.svg",
            to_logo: "/images/logos/slack.svg",
            title: "Send Stripe payment alerts to Slack",
            description: "Receive real-time Slack notifications for every new Stripe payment.",
            category: "financial",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/jira.svg",
            to_logo: "/images/logos/confluence.svg",
            title: "Create Confluence pages from Jira issues",
            description: "Automatically generate Confluence pages for new Jira issues.",
            category: "project management",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/trello.svg",
            to_logo: "/images/logos/slack.svg",
            title: "Post Trello card updates to Slack",
            description: "Get notified in Slack whenever a Trello card is updated.",
            category: "project management",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/mailchimp.svg",
            to_logo: "/images/logos/slack.svg",
            title: "Notify Slack on Mailchimp campaign sends",
            description: "Receive Slack notifications when a new Mailchimp campaign is sent.",
            category: "marketing",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/zoom.svg",
            to_logo: "/images/logos/google-calendar.svg",
            title: "Create Google Calendar events from Zoom meetings",
            description:
              "Automatically create Google Calendar events for scheduled Zoom meetings.",
            category: "productivity",
            button_text: "Activate"
          },
          %{
            from_logo: "/images/logos/wordpress.svg",
            to_logo: "/images/logos/instagram.svg",
            title: "Auto-post new blog articles to instagram",
            description:
              "Automatically share your latest WordPress blog posts to your instagram feed.",
            category: "social",
            type: "social media",
            button_text: "Activate"
          }
        ]
      )
      |> assign(workflows: [])

    {:ok, socket}
  end
end
