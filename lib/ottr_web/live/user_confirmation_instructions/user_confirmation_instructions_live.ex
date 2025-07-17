defmodule OttrWeb.UserConfirmationInstructionsLive do
  use OttrWeb, :live_view

  alias Ottr.Accounts

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page, "confirmation_instructions")
      |> assign(form: to_form(%{}, as: "user"))
      |> assign(
        page_title: "Confirm",
        page_title_suffix: " | Ottr Auth"
      )

    {:ok, socket}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
