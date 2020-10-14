defmodule Stripy.StripeTesting.Charge do
  @moduledoc false

  import Stripy.StripeTesting.Helpers

  def retrieve(id, _opts) do
    {:ok, load_fixture(id)}
  end
end
