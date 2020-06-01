defmodule Macroware do
  defmacro __using__(_) do
    quote do
      defoverridable call: 1

      def call(value) do
        super(value + 1)
      end
    end
  end
end

defmodule MacroServer do
  def call(i) do
    i
  end

  for _ <- 1..1000 do
    use Macroware
  end
end

1000 = MacroServer.call(0)

defmodule Middleware do
  def call(value, [next | rest]) do
    next.call(value + 1, rest)
  end
end

defmodule Server do
  def call(value, []) do
    value
  end
end

stack = for(_ <- 1..999, do: Middleware) ++ [Server]
1000 = Middleware.call(0, stack)

fibonacci =
  Enum.map([2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711], fn range ->
    1
    |> Range.new(range)
    |> Enum.reduce([], &([&1 | &2]))
  end)

Benchee.run(%{
  "macro" => fn -> MacroServer.call(0) end,
  "stack" => fn -> Middleware.call(0, stack) end
})

Benchee.run(%{
  "registry" => fn ->
    Enum.each(fibonacci, fn list ->
      list
      |> Task.async_stream(fn index ->
        index
        |> to_string()
      end, ordered: false, max_concurrency: Enum.count(list))
      |> Stream.run()
    end)
  end
})
