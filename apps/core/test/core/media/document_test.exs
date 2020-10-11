defmodule Core.Media.DocumentTest do
  use Core.DataCase

  alias Core.Media
  alias Decimal, as: D

  describe "documents by role's Tp" do
    alias Core.Media.Document

    test "requires user_id via role's Tp" do
      changeset = Document.changeset(%Document{}, %{})
      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %Document{}
        |> Document.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_document/0 returns all documents" do
      user = insert(:tp_user)
      struct = insert(:tp_document, user: user)
      [data] = Media.list_document()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_document!/1 returns the document with given id" do
      user = insert(:tp_user)
      struct = insert(:tp_document, user: user)
      data = Media.get_document!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_document/1 with valid data creates the document" do
      user = insert(:tp_user)
      params = %{
        access_granted:                 true,
        category:                       22,
        document_link:                  "https://taxgig.com",
        format:                         22,
        name:                           22,
        signature_required_from_client: true,
        signed_by_client:               true,
        signed_by_pro:                  true,
        size:                           1.99,
        user_id:                        user.id
      }

      assert {:ok, %{} = created} = Media.create_document(params)
      assert created.access_granted                 == true
      assert created.category                       ==  22
      assert created.document_link                  == "https://taxgig.com"
      assert created.format                         == 22
      assert created.name                           == 22
      assert created.signature_required_from_client == true
      assert created.signed_by_client               == true
      assert created.signed_by_pro                  == true
      assert created.size                           == D.new("1.99")
      assert created.user_id                        == user.id
    end

    test "create_document/1 with invalid attrs for creates the document" do
      insert(:tp_user)
      params = %{
        access_granted:                 true,
        category:                       22,
        document_link:                  "https://taxgig.com",
        format:                         22,
        name:                           22,
        signature_required_from_client: true,
        signed_by_client:               true,
        signed_by_pro:                  true,
        size:                           1.99,
        user_id:                        nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Media.create_document(params)
    end

    test "create_document/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Media.create_document(params)
    end

    test "update_document/2 with valid data updates the document" do
      user = insert(:tp_user)
      struct = insert(:tp_document, user: user)
      params = %{
        access_granted:                 false,
        category:                       44,
        document_link:                  "https://api.taxgig.com",
        format:                         44,
        name:                           44,
        signature_required_from_client: false,
        signed_by_client:               false,
        signed_by_pro:                  false,
        size:                           9.99,
        user_id:                        user.id,
      }
      assert {:ok, %Document{} = uploaded} =
        Media.update_document(struct, params)

      assert uploaded.access_granted                 == false
      assert uploaded.category                       == 44
      assert uploaded.document_link                  == "https://api.taxgig.com"
      assert uploaded.format                         == 44
      assert uploaded.name                           == 44
      assert uploaded.signature_required_from_client == false
      assert uploaded.signed_by_client               == false
      assert uploaded.signed_by_pro                  == false
      assert uploaded.size                           == D.new("9.99")
      assert uploaded.user_id                        == user.id
    end

    test "update_book_keeping_additional_need/2 with invalid data returns not error changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_document, user: user)
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Media.update_document(struct, params)
    end

    test "delete_document/1 deletes the document" do
      user = insert(:tp_user)
      struct = insert(:tp_document, user: user)
      assert {:ok, %Document{}} = Media.delete_document(struct)
      assert_raise Ecto.NoResultsError, fn -> Media.get_document!(struct.id) end
    end

    test "change_document/1 returns the document changeset" do
      user = insert(:tp_user)
      struct = insert(:tp_document, user: user)
      assert %Ecto.Changeset{} = Media.change_document(struct)
    end
  end

  describe "documents by role's Pro" do
    alias Core.Media.Document

    test "requires user_id via role's Pro" do
      changeset = Document.changeset(%Document{}, %{})
      refute changeset.valid?
      changeset |> assert_validation_triggered(:user_id, :required)
    end

    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, user_id: nil}
      {result, changeset} =
        %Document{}
        |> Document.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:user_id, "can't be blank")
    end

    test "list_document/0 returns all documents" do
      user = insert(:pro_user)
      struct = insert(:pro_document, user: user)
      [data] = Media.list_document()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_document!/1 returns the document with given id" do
      user = insert(:pro_user)
      struct = insert(:pro_document, user: user)
      data = Media.get_document!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_document/1 with valid data creates the document" do
      user = insert(:pro_user)
      params = %{
        access_granted:                 true,
        category:                       22,
        document_link:                  "https://taxgig.com",
        format:                         22,
        name:                           22,
        signature_required_from_client: true,
        signed_by_client:               true,
        signed_by_pro:                  true,
        size:                           1.99,
        user_id:                        user.id
      }

      assert {:ok, %{} = created} = Media.create_document(params)
      assert created.access_granted                 == true
      assert created.category                       ==  22
      assert created.document_link                  == "https://taxgig.com"
      assert created.format                         == 22
      assert created.name                           == 22
      assert created.signature_required_from_client == true
      assert created.signed_by_client               == true
      assert created.signed_by_pro                  == true
      assert created.size                           == D.new("1.99")
      assert created.user_id                        == user.id
    end

    test "create_document/1 with invalid attrs for creates the document" do
      insert(:pro_user)
      params = %{
        access_granted:                 true,
        category:                       22,
        document_link:                  "https://taxgig.com",
        format:                         22,
        name:                           22,
        signature_required_from_client: true,
        signed_by_client:               true,
        signed_by_pro:                  true,
        size:                           1.99,
        user_id:                        nil
      }

      assert {:error, %Ecto.Changeset{}} =
        Media.create_document(params)
    end

    test "create_document/1 with invalid data returns error changeset" do
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Media.create_document(params)
    end

    test "update_document/2 with valid data updates the document" do
      user = insert(:pro_user)
      struct = insert(:pro_document, user: user)
      params = %{
        access_granted:                 false,
        category:                       44,
        document_link:                  "https://api.taxgig.com",
        format:                         44,
        name:                           44,
        signature_required_from_client: false,
        signed_by_client:               false,
        signed_by_pro:                  false,
        size:                           9.99,
        user_id:                        user.id,
      }
      assert {:ok, %Document{} = uploaded} =
        Media.update_document(struct, params)

      assert uploaded.access_granted                 == false
      assert uploaded.category                       == 44
      assert uploaded.document_link                  == "https://api.taxgig.com"
      assert uploaded.format                         == 44
      assert uploaded.name                           == 44
      assert uploaded.signature_required_from_client == false
      assert uploaded.signed_by_client               == false
      assert uploaded.signed_by_pro                  == false
      assert uploaded.size                           == D.new("9.99")
      assert uploaded.user_id                        == user.id
    end

    test "update_book_keeping_additional_need/2 with invalid data returns not error changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_document, user: user)
      params = %{user_id: nil}
      assert {:error, %Ecto.Changeset{}} =
        Media.update_document(struct, params)
    end

    test "delete_document/1 deletes the document" do
      user = insert(:pro_user)
      struct = insert(:pro_document, user: user)
      assert {:ok, %Document{}} = Media.delete_document(struct)
      assert_raise Ecto.NoResultsError, fn -> Media.get_document!(struct.id) end
    end

    test "change_document/1 returns the document changeset" do
      user = insert(:pro_user)
      struct = insert(:pro_document, user: user)
      assert %Ecto.Changeset{} = Media.change_document(struct)
    end
  end
end
