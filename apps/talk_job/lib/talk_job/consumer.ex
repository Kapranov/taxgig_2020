defmodule TalkJob.Consumer do
  @moduledoc """
  The Consumer
  """

  use GenStage
  require Logger

  alias TalkJob.Consumer

  @name __MODULE__

  @spec start_link(pid, User.t()) :: {:ok, pid}
  def start_link(state, current_user) do
    {:via, Registry, {Consumer.Registry, name = current_user.id}}
    GenStage.start_link(@name, state, name: via_tuple(name))
  end

  @spec init(User.t()) :: String.t() | {:consumer, User.t()}
  def init(state) do
    Logger.info("Consumer init")
    {:consumer, state, subscribe_to: [via_name(state)]}
  end

  @spec handle_events([User.t()], any(), term()) :: [User.t()] | {:noreply, [], term()}
  def handle_events(events, _from, state) do
    Process.sleep(3000)
    IO.inspect(events)
    {:noreply, [], state}
  end

  @spec via_tuple(String.t()) :: atom()
  defp via_tuple(name) do
    name <> "_consumer"
    |> String.to_atom
  end

  @spec via_name(pid) :: atom()
  defp via_name(state) do
    Process.info(state)
    |> Keyword.get(:registered_name)
    |> Atom.to_string
    |> String.replace("_consumer", "")
    |> String.to_atom
  end
end
