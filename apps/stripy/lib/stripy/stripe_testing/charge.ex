defmodule Stripy.StripeTesting.Charge do
  @moduledoc false

  alias Stripy.StripeTesting.Helpers

  def retrieve(id, _opts) do
    {:ok, Helpers.load_fixture(id)}
  end
end
