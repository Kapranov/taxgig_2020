defmodule Core.Services.BookKeepingTypeClientTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BookKeepingTypeClient
  }

  describe "book_keeping_type_client by role's Tp" do
    test "requires user_id via role's Tp" do
      changeset = BookKeepingTypeClient.changeset(%BookKeepingTypeClient{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingTypeClient{}
        |> BookKeepingTypeClient.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_type_clients/0 returns all book_keeping_type_clients" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_type_client, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_type_client()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_type_client!/1 returns the book_keeping_type_client with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_type_client, book_keepings: book_keeping)
      data = Services.get_book_keeping_type_client!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_type_client/1 with valid data creates a book_keeping_type_client" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "C-Corp / Corporation",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_type_client} = Services.create_book_keeping_type_client(params)
      assert book_keeping_type_client.name                         == :"C-Corp / Corporation"
      assert book_keeping_type_client.price                        == nil
      assert book_keeping_type_client.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_type_client == 60
    end

    test "create_book_keeping_type_client/1 with invalid attrs for creates a book_keeping_type_client" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)

      params = %{
        name: "some name",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_type_client(params)
    end

    test "create_book_keeping_type_client/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_type_client(params)
    end

    test "update_book_keeping_type_client/2 with valid data updates the book_keeping_type_client" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_type_client, book_keepings: book_keeping)

      params = %{
        name: "S-Corp",
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingTypeClient{} = updated} =
        Services.update_book_keeping_type_client(struct, params)

      assert updated.name                                          == :"S-Corp"
      assert updated.price                                         == nil
      assert updated.book_keeping_id                               == book_keeping.id
      assert match_value_relate.match_for_book_keeping_type_client == 60
    end

    test "update_book_keeping_type_client/2 with invalid data returns not error changeset" do
      struct = insert(:tp_book_keeping_type_client)
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_type_client(struct, params)
    end

    test "delete_book_keeping_type_client/1 deletes the book_keeping_type_client" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_type_client, book_keepings: book_keeping)
      assert {:ok, %BookKeepingTypeClient{}} = Services.delete_book_keeping_type_client(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_type_client!(struct.id) end
    end

    test "change_book_keeping_type_client/1 returns a book_keeping_type_client changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:tp_book_keeping_type_client, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_type_client(struct)
    end
  end

  describe "book_keeping_type_client by role's Pro" do
    test "requires user_id via role's Pro" do
      changeset = BookKeepingTypeClient.changeset(%BookKeepingTypeClient{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:book_keeping_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil}
      {result, changeset} =
        %BookKeepingTypeClient{}
        |> BookKeepingTypeClient.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:book_keeping_id, "can't be blank")
      changeset |> assert_error_message(:name, "can't be blank")
    end

    test "list_book_keeping_type_clients/0 returns all book_keeping_type_clients" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_type_client, book_keepings: book_keeping)
      [data] = Services.list_book_keeping_type_client()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_book_keeping_type_client!/1 returns the book_keeping_type_client with given id" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_type_client, book_keepings: book_keeping)
      data = Services.get_book_keeping_type_client!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_book_keeping_type_client/1 with valid data creates a book_keeping_type_client" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)

      params = %{
        name: :"S-Corp",
        price: 22,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %{} = book_keeping_type_client} = Services.create_book_keeping_type_client(params)
      assert book_keeping_type_client.name                         == :"S-Corp"
      assert book_keeping_type_client.price                        == 22
      assert book_keeping_type_client.book_keeping_id              == book_keeping.id
      assert match_value_relate.match_for_book_keeping_type_client == 60
    end

    test "create_book_keeping_type_client/1 with invalid data returns error changeset" do
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_book_keeping_type_client(params)
    end

    test "update_book_keeping_type_client/2 with valid data updates the book_keeping_type_client" do
      match_value_relate = insert(:match_value_relat)
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_type_client, book_keepings: book_keeping)

      params = %{
        name: "Partnership",
        price: 33,
        book_keeping_id: book_keeping.id
      }

      assert {:ok, %BookKeepingTypeClient{} = updated} =
        Services.update_book_keeping_type_client(struct, params)

      assert updated.name                                          == :"Partnership"
      assert updated.price                                         == 33
      assert updated.book_keeping_id                               == book_keeping.id
      assert match_value_relate.match_for_book_keeping_type_client == 60
    end

    test "update_book_keeping_type_client/2 with invalid data returns not error changeset" do
      struct = insert(:pro_book_keeping_type_client)
      params = %{book_keeping_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.update_book_keeping_type_client(struct, params)
    end

    test "delete_book_keeping_type_client/1 deletes the book_keeping_type_client" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      struct = insert(:pro_book_keeping_type_client, book_keepings: book_keeping)
      assert {:ok, %BookKeepingTypeClient{}} = Services.delete_book_keeping_type_client(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_book_keeping_type_client!(struct.id) end
    end

    test "change_book_keeping_type_client/1 returns a book_keeping_type_client changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      struct = insert(:pro_book_keeping_type_client, book_keepings: book_keeping)
      assert %Ecto.Changeset{} = Services.change_book_keeping_type_client(struct)
    end
  end
end
