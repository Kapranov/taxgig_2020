defmodule Core.ConfigTest do
  use ExUnit.Case

  alias Core.Config
  alias ServerWeb.Endpoint

  test "get/1 with an atom" do
    assert Config.get(:instance) == Application.compile_env(:core, :instance)
    assert Config.get(:azertyuiop) == nil
    assert Config.get(:azertyuiop, true) == true
  end

  test "get/1 with a list of keys" do
    assert Config.get([:instance, :upload_limit]) ==
      Keyword.get(Application.compile_env(:core, :instance), :upload_limit)
    assert Config.get([Endpoint, :render_errors, :view]) ==
      get_in(Application.compile_env(:core, Endpoint), [:render_errors, :view])
    assert Config.get([:azerty, :uiop]) == nil
    assert Config.get([:azerty, :uiop], true) == true
  end

  test "get/1 when value is false" do
    Config.put([:instance, :false_test], false)
    Config.put([:instance, :nested], [])
    Config.put([:instance, :nested, :false_test], false)
    assert Config.get([:instance, :false_test]) == false
    assert Config.get([:instance, :nested, :false_test]) == false
  end

  test "get!/1" do
    assert Config.get!(:instance) == Application.compile_env(:core, :instance)
    assert Config.get!([:instance, :upload_limit]) ==
      Keyword.get(Application.compile_env(:core, :instance), :upload_limit)
  end

  test "get!/1 when value is false" do
    Config.put([:instance, :false_test], false)
    Config.put([:instance, :nested], [])
    Config.put([:instance, :nested, :false_test], false)
    assert Config.get!([:instance, :false_test]) == false
    assert Config.get!([:instance, :nested, :false_test]) == false
  end

  test "put/2 with a key" do
    Config.put(:config_test, true)
    assert Config.get(:config_test) == true
  end

  test "put/2 with a list of keys" do
    Config.put([:instance, :config_test], true)
    Config.put([:instance, :config_nested_test], [])
    Config.put([:instance, :config_nested_test, :x], true)
    assert Config.get([:instance, :config_test]) == true
    assert Config.get([:instance, :config_nested_test, :x]) == true
  end

  test "delete/1 with a key" do
    Config.put([:delete_me], :delete_me)
    Config.delete([:delete_me])
    assert Config.get([:delete_me]) == nil
  end

  test "delete/2 with a list of keys" do
    Config.put([:delete_me], hello: "world", world: "Hello")
    Config.delete([:delete_me, :world])
    assert Config.get([:delete_me]) == [hello: "world"]
    Config.put([:delete_me, :delete_me], hello: "world", world: "Hello")
    Config.delete([:delete_me, :delete_me, :world])
    assert Config.get([:delete_me, :delete_me]) == [hello: "world"]
  end
end
