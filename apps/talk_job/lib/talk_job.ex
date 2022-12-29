defmodule TalkJob do
  @moduledoc false

  def open(current_user) do
    case DynamicSupervisor.start_child(TalkJob.ProducerSupervisor, {TalkJob.Producer, current_user}) do
      {:ok, pid} ->
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        {:ok, pid}
      error ->
        error
    end
  end
end
