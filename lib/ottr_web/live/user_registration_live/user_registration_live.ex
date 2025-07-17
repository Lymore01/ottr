defmodule OttrWeb.UserRegistrationLive do
  use OttrWeb, :live_view
  require Logger

  alias Ottr.Accounts
  alias Ottr.Accounts.User

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(:page, "register")
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)
      |> assign(
        page_title: "Sign Up",
        page_title_suffix: " | Ottr Auth"
      )

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        case Accounts.deliver_user_confirmation_instructions(
               user,
               &url(~p"/users/confirm/#{&1}")
             ) do
          {:ok, _} ->
            {:noreply,
             socket
             |> put_flash(:info, "Account created! Check your email to confirm it.")
             |> redirect(to: ~p"/users/confirm")}

          {:error, reason} ->
            Logger.warning("Email not sent: #{inspect(reason)}")

            {:noreply,
             socket
             |> put_flash(:error, "User registered but email not sent.")
             |> redirect(to: ~p"/")}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(check_errors: true)
         |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)

    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
