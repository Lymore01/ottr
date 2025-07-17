defmodule OttrWeb.UserForgotPasswordLive do
  use OttrWeb, :live_view

  alias Ottr.Accounts

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page, "forgot_password")
      |> assign(
        page_title: "Forgot Password",
        page_title_suffix: " | Ottr Auth"
      )
      |> assign(form: to_form(%{}, as: "user"))

    {:ok, socket}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
