ExUnit.start()

Mox.defmock(OttrTest.Mocks.EmailSender, for: Ottr.Behaviours.Handlers)
Application.put_env(:ottr, :email_sender_handler, OttrTest.Mocks.EmailSender)

# Ecto.Adapters.SQL.Sandbox.mode(Ottr.Repo, :manual)
