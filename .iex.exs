Application.put_env(:elixir, :ansi_enabled, true)

IO.puts IO.ANSI.magenta()
        # <> IO.ANSI.light_black_background()
        <> IO.ANSI.bright()
        <> IO.ANSI.underline()
        <> IO.ANSI.blink_slow()
        <> "Using global .iex.exs (located in ~/.iex.exs)" <> IO.ANSI.reset()

queue_length = fn ->
  self()
  |> Process.info()
  |> Keyword.get(:message_queue_len)
end

prefix = IO.ANSI.light_black_background() <> IO.ANSI.magenta() <> "%prefix"
         <> IO.ANSI.reset()
counter = IO.ANSI.light_black_background() <> IO.ANSI.black() <> "-%node-(%counter)"
          <> IO.ANSI.reset()
info = IO.ANSI.light_blue() <> "✉ #{queue_length.()}" <> IO.ANSI.reset()
last = IO.ANSI.yellow() <> "➤➤➤" <> IO.ANSI.reset()
alive = IO.ANSI.bright() <> IO.ANSI.yellow() <> IO.ANSI.blink_rapid() <> "⚡"
        <> IO.ANSI.reset()

default_prompt = prefix <> counter <> " | " <> info <> " | " <> last
alive_prompt = prefix <> counter <> " | " <> info <> " | " <> alive <> last

inspect_limit = 150
history_size = 1_000_000_000

eval_result = [:green, :bright]
eval_error = [:red, :bright]
eval_info = [:blue, :bright]

IEx.configure [
  inspect: [limit: inspect_limit],
  history_size: history_size,
  colors: [
    eval_result: eval_result,
    eval_error: eval_error,
    eval_info: eval_info,
  ],
  default_prompt: default_prompt,
  alive_prompt: alive_prompt
]

import_if_available Plug.Conn
import_if_available Phoenix.HTML

phoenix_app = :application.info()
  |> Keyword.get(:running)
  |> Enum.reject(fn {_x, y} ->
    y == :undefined
  end)
  |> Enum.find(fn {x, _y} ->
    x |> Atom.to_string() |> String.match?(~r{_web})
  end)

case phoenix_app do
  nil -> IO.puts "No Phoenix App found"
  {app, _pid} ->
    IO.puts "Phoenix app found: #{app}"
    ecto_app = app
      |> Atom.to_string()
      |> (&Regex.split(~r{_web}, &1)).()
      |> Enum.at(0)
      |> String.to_atom()

    exists = :application.info()
      |> Keyword.get(:running)
      |> Enum.reject(fn {_x, y} ->
        y == :undefined
      end)
      |> Enum.map(fn {x, _y} -> x end)
      |> Enum.member?(ecto_app)

    case exists do
      false -> IO.puts "Ecto app #{ecto_app} doesn't exist or isn't running"
      true ->
        IO.puts "Ecto app found: #{ecto_app}"

        import_if_available Ecto.Query
        import_if_available Ecto.Changeset

        repo = ecto_app |> Application.get_env(:ecto_repos) |> Enum.at(0)
        quote do
          alias unquote(repo), as: Repo
        end
    end
end

######################################################################
######################################################################

:timer.sleep(8000);

clear
######################################################################

defmodule LetMeSee do
  @moduledoc """
  Open N+1 in a terminal
  Open regular in another terminal

  iex> mix ecto.reset
  iex> iex -S mix

  cmd+r
  """

  IO.puts(
    "\nAaron - This is your self from the past. Remember to reset the DB! mix ecto.reset.repo then do setup\n"
  )
end
