defmodule OttrTest do
  use ExUnit.Case, async: false
  import Mox

  @queue "test_queue"

  setup do
    OttrTest.Mocks.EmailSender
    |> stub(:handle, fn args ->
      send(self(), {:mock_email_sender_called, args})

      :ok
    end)

    Ottr.create_queue(@queue)

    :ok
  end

  describe "Task Handler Resolution" do
    test "email sender task resolves and calls the mock email handler" do
      task = %{
        id: 55,
        data: %{
          "type" => "email_sender",
          "args" => %{
            "body" => "Hello, world!",
            "subject" => "Greetings",
            "to" => "test@example.com"
          }
        }
      }

      Ottr.insert(@queue, task)

      Ottr.process_task(@queue, task)

      # debug
      IO.inspect(Process.info(self(), :messages), label: "Messages")

      assert_receive {:mock_email_sender_called, _task},
                     1000
    end
  end
end
