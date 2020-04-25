defmodule Core.Lookup.StateTest do
  use Core.DataCase

  alias Core.Lookup

  describe "states" do
    alias Core.Lookup.State

    @valid_attrs %{
      abbr: "some abbr",
      name: "some name"
    }
    @update_attrs %{
      abbr: "some updated abbr",
      name: "some updated name"
    }
    @invalid_attrs %{
      abbr: nil,
      name: nil
    }

    def state_fixture(attrs \\ %{}) do
      {:ok, state} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lookup.create_state()

      state
    end

    test "list_states/0 returns all states" do
      state = state_fixture()
      assert Lookup.list_state() == [state]
    end

    test "get_state!/1 returns the state with given id" do
      state = state_fixture()
      assert Lookup.get_state!(state.id) == state
    end

    test "create_state/1 with valid data creates a state" do
      assert {:ok, %State{} = state} = Lookup.create_state(@valid_attrs)
      assert state.abbr == "some abbr"
      assert state.name == "some name"
    end

    test "create_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lookup.create_state(@invalid_attrs)
    end

    test "update_state/2 with valid data updates the state" do
      state = state_fixture()
      assert {:ok, %State{} = state} = Lookup.update_state(state, @update_attrs)
      assert state.abbr == "some updated abbr"
      assert state.name == "some updated name"
    end

    test "update_state/2 with invalid data returns error changeset" do
      state = state_fixture()
      assert {:error, %Ecto.Changeset{}} = Lookup.update_state(state, @invalid_attrs)
      assert state == Lookup.get_state!(state.id)
    end

    test "delete_state/1 deletes the state" do
      state = state_fixture()
      assert {:ok, %State{}} = Lookup.delete_state(state)
      assert_raise Ecto.NoResultsError, fn -> Lookup.get_state!(state.id) end
    end

    test "change_state/1 returns a state changeset" do
      state = state_fixture()
      assert %Ecto.Changeset{} = Lookup.change_state(state)
    end
  end
end
