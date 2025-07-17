defmodule OttrWeb.UserResetPasswordLive do
  use OttrWeb, :live_view

  alias Ottr.Accounts

  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:page, "reset_password")
      |> assign(check_errors: false)
      |> assign_user_and_token(params)
      |> assign(
        page_title: "Reset Password",
        page_title_suffix: " | Ottr Auth"
      )

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply,
         socket |> assign(check_errors: true) |> assign_form(Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)

    if changeset.valid? do
      {:noreply,
       socket
       |> assign(check_errors: false)
       |> assign_form(Map.put(changeset, :action, :validate))}
    else
      {:noreply,
       socket
       |> assign(check_errors: true)
       |> assign_form(Map.put(changeset, :action, :validate))}
    end
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token, check_errors: false)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
