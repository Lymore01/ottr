defmodule OttrWeb.Dashboard.Workflows.Playground.PlaygroundLive do
  use OttrWeb, :live_view

  import OttrWeb.Dashboard.Playground
  import OttrWeb.Dashboard.Playground.ConfigPanel

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
      |> assign(
        nodes: [
          %{
            id: "node-1",
            type: "action",
            category: "email",
            title: "Send Email",
            description: "Dispatches an email to a given address",
            placeholder: "e.g. tralala@brainrot.com",
            icon: "gmail.svg",
            position: %{x: 120, y: 200},
            ports: [
              %{type: "input", key: "in"},
              %{type: "output", key: "out"}
            ],
            config: %{
              to: "",
              subject: "",
              body: ""
            },
            required_fields: ["to", "subject"],
            form_schema: [
              %{
                name: "to",
                label: "Recipient Email",
                type: "email",
                required: true
              },
              %{
                name: "subject",
                label: "Subject",
                type: "text",
                required: true
              },
              %{
                name: "body",
                label: "Message Body",
                type: "textarea",
                required: false
              }
            ],
            # "running", "success", "error"
            status: "idle",
            depends_on: [],
            next_nodes: [],
            retries: 0,
            timeout: nil,
            is_collapsed: false,
            editable: true,
            draggable: true
          },
          %{
            id: "node-2",
            type: "transform",
            category: "transform",
            title: "Format Name",
            description: "Capitalizes and trims user name input",
            placeholder: "e.g. john doe → John Doe",
            icon: "transform.svg",
            position: %{x: 400, y: 200},
            ports: [
              %{type: "input", key: "in"},
              %{type: "output", key: "out"}
            ],
            config: %{
              input_field: "name",
              output_field: "formatted_name",
              capitalization: "titlecase"
            },
            required_fields: ["input_field", "output_field"],
            form_schema: [
              %{
                name: "input_field",
                label: "Input Field Key",
                type: "text",
                required: true
              },
              %{
                name: "output_field",
                label: "Output Field Key",
                type: "text",
                required: true
              },
              %{
                name: "capitalization",
                label: "Capitalization Style",
                type: "select",
                required: false,
                options: ["uppercase", "lowercase", "titlecase"]
              }
            ],
            status: "idle",
            depends_on: ["node-1"],
            next_nodes: [],
            retries: 0,
            timeout: nil,
            is_collapsed: false,
            editable: true,
            draggable: true
          },
          %{
            id: "node-3",
            type: "action",
            category: "slack",
            title: "Send Slack Message",
            description: "Posts a message to a Slack channel",
            placeholder: "#general",
            icon: "slack.svg",
            position: %{x: 700, y: 200},
            ports: [
              %{type: "input", key: "in"},
              %{type: "output", key: "out"}
            ],
            config: %{
              channel: "#general",
              message: "",
              mention_user: false
            },
            required_fields: ["channel", "message"],
            form_schema: [
              %{
                name: "channel",
                label: "Slack Channel",
                type: "text",
                required: true
              },
              %{
                name: "message",
                label: "Message Text",
                type: "textarea",
                required: true
              },
              %{
                name: "mention_user",
                label: "Mention User?",
                type: "checkbox",
                required: false
              }
            ],
            status: "idle",
            depends_on: ["node-2"],
            next_nodes: [],
            retries: 0,
            timeout: nil,
            is_collapsed: false,
            editable: true,
            draggable: true
          },
          %{
            id: "node-4",
            type: "action",
            category: "github",
            title: "Create GitHub Issue",
            description: "Opens a new issue in a specified GitHub repository",
            placeholder: "Repo: octocat/hello-world",
            icon: "github.svg",
            position: %{x: 900, y: 300},
            ports: [
              %{type: "input", key: "in"},
              %{type: "output", key: "out"}
            ],
            config: %{
              repository: "octocat/hello-world",
              title: "",
              body: "",
              labels: []
            },
            required_fields: ["repository", "title"],
            form_schema: [
              %{
                name: "repository",
                label: "Repository",
                type: "text",
                required: true
              },
              %{
                name: "title",
                label: "Issue Title",
                type: "text",
                required: true
              },
              %{
                name: "body",
                label: "Description",
                type: "textarea",
                required: false
              },
              %{
                name: "labels",
                label: "Labels (comma-separated)",
                type: "text",
                required: false
              }
            ],
            status: "idle",
            depends_on: ["node-3"],
            next_nodes: [],
            retries: 0,
            timeout: nil,
            is_collapsed: false,
            editable: true,
            draggable: true
          }
        ]
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
