defmodule TaskWorker do
  def start_link(_) do
    Task.start_link(fn -> loop() end)
  end

  defp loop do
    receive do
      {:process, fun} ->
        fun.()
        loop()
    end
  end
end
