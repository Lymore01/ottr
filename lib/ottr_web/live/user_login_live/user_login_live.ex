defmodule OttrWeb.UserLoginLive do
  use OttrWeb, :live_view

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")

    socket =
      socket
      |> assign(:page, "login")
      |> assign(:form, form)
      |> assign(
        page_title: "Log In",
        page_title_suffix: " | Ottr Auth"
      )

    {:ok, socket, temporary_assigns: [form: form]}
  end
end
