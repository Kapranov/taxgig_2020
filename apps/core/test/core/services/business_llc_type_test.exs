defmodule Core.Services.BusinessLlcTypeTest do
  use Core.DataCase

  alias Core.{
    Repo,
    Services,
    Services.BusinessLlcType
  }

  describe "business_llc_types by role's Tp" do
    test "requires name and business_tax_return_id via role's Tp" do
      changeset = BusinessLlcType.changeset(%BusinessLlcType{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessLlcType{}
        |> BusinessLlcType.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "list_business_llc_types/0 returns all business_llc_types" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      [data] = Services.list_business_llc_type()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_business_llc_type!/1 returns the business_llc_types with given id" do
      struct = insert(:tp_business_llc_type)
      data = Services.get_business_llc_type!(struct.id)
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_business_llc_type/1 with valid data creates a business_llc_type" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)

      params = %{
        name: "C-Corp / Corporation",
        business_tax_return_id: business_tax_return.id
      }

      assert {:ok, %BusinessLlcType{} = business_llc_type} =
        Services.create_business_llc_type(params)
      assert %Ecto.Association.NotLoaded{} = business_llc_type.business_tax_returns

      [loaded] =
        Repo.preload([business_llc_type], [:business_tax_returns])

      assert loaded.name                                                     == :"C-Corp / Corporation"
      assert loaded.inserted_at                                              == business_llc_type.inserted_at
      assert loaded.updated_at                                               == business_llc_type.updated_at
      assert loaded.business_tax_return_id                                   == business_tax_return.id
    end

    test "create_business_llc_type/1 with invalid data returns error changeset" do
      params = %{business_tax_return_id: nil, name: nil}
      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_llc_type(params)
    end

    test "update_business_llc_type/2 with valid data updates the business_llc_type" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)

      params = %{name: "S-Corp", business_tax_return_id: business_tax_return.id}

      assert {:ok, %BusinessLlcType{} = updated} =
        Services.update_business_llc_type(struct, params)

      assert updated.name                                                     == :"S-Corp"
      assert updated.inserted_at                                              == struct.inserted_at
      assert updated.updated_at                                               == struct.updated_at
      assert updated.business_tax_return_id                                   == business_tax_return.id
    end

    test "update_business_llc_type/2 with invalid data returns error changeset" do
      struct = insert(:tp_business_llc_type)
      params = %{name: nil, business_tax_return_id: nil}
      attrs = [:password, :password_cofirmation]
      data = Services.get_business_llc_type!(struct.id)
      assert {:error, %Ecto.Changeset{}} =
        Services.update_business_llc_type(struct, params)
      assert Map.take(struct, attrs) == assert Map.take(data, attrs)
    end

    test "delete_business_llc_type/1 deletes the business_llc_type" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      assert {:ok, %BusinessLlcType{}} =
        Services.delete_business_llc_type(struct)
      assert_raise Ecto.NoResultsError, fn ->
        Services.get_business_llc_type!(struct.id)
      end
    end

    test "change_business_llc_type/1 returns a business_llc_type.changeset" do
      user = insert(:tp_user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      struct = insert(:tp_business_llc_type, business_tax_returns: business_tax_return)
      assert %Ecto.Changeset{} =
        Services.change_business_llc_type(struct)
    end
  end

  describe "business_llc_types by role's Pro" do
    test "requires name and business_tax_return_id via role's Pro" do
      changeset = BusinessLlcType.changeset(%BusinessLlcType{}, %{})

      refute changeset.valid?
      changeset |> assert_validation_triggered(:name, :required)
      changeset |> assert_validation_triggered(:business_tax_return_id, :required)
    end

    test "ensures business_tax_return with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, business_tax_return_id: nil}
      {result, changeset} =
        %BusinessLlcType{}
        |> BusinessLlcType.changeset(attrs)
        |> Repo.insert

      assert result == :error
      refute changeset.valid?
      changeset |> assert_error_message(:business_tax_return_id, "can't be blank")
    end

    test "create_business_llc_type/1 with valid data returns error changeset" do
      user = insert(:pro_user)
      business_tax_return = insert(:pro_business_tax_return, user: user)

      params = %{
        name: "C-Corp / Corporation",
        business_tax_return_id: business_tax_return.id
      }

      assert {:error, %Ecto.Changeset{}} =
        Services.create_business_llc_type(params)
    end
  end
end
