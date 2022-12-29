defmodule TalkJob.ProducerConsumer do
  @moduledoc """
  A Producer-Consumer
  """

  use GenStage
  require Logger

  alias TalkJob.{
    ProducerConsumer,
    Queries,
    Repo,
    Talk.Message,
    Talk.Room
  }

  @name __MODULE__

  @spec start_link(pid, User.t()) :: {:ok, pid}
  def start_link(state, current_user) do
    {:via, Registry, {ProducerConsumer.Registry, name = current_user.id}}
    GenStage.start_link(@name, state, name: via_tuple(name))
  end

  @spec init(User.t()) :: String.t() | {:producer_consumer, User.t()}
  def init(state) do
    Logger.info("ProducerConsumer init")
    {:producer_consumer, state, subscribe_to: [{via_name(state), min_demand: 0, max_demand: 1}]}
  end

  @spec handle_events([User.t()], any(), term()) :: {:noreply, [User.t()], term()}
  def handle_events(events, _from, state) do
    data =
      Enum.reduce(events, [], fn(struct, acc) ->
        counter =
          Queries.aggregate_for_message_is_read(Room, Message, struct.id)
          |> Enum.count

        attrs = %{unread_msg: counter}

        {:ok, updated} =
          struct
          |> Room.updated_changeset(attrs)
          |> Repo.update()
        [updated | acc]
      end)
    {:noreply, data, state}
  end

  @spec via_tuple(String.t()) :: atom()
  defp via_tuple(name) do
    name <> "_producerConsumer"
    |> String.to_atom
  end

  @spec via_name(pid) :: atom()
  defp via_name(state) do
    Process.info(state)
    |> Keyword.get(:registered_name)
    |> Atom.to_string
    |> String.replace("_producerConsumer", "")
    |> String.to_atom
  end
end
