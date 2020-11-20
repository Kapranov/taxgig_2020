defmodule Core.Services.ServiceLinkTest do
  use Core.DataCase

  alias Core.{
    Services,
    Services.ServiceLink
  }

  describe "service_link by role's Tp" do
    test "ensures service with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{id: id, book_keeping_id: nil, business_tax_return_id: nil, individual_tax_return_id: nil, sale_tax_id: nil}
      {result, changeset} =
        %ServiceLink{}
        |> ServiceLink.changeset(attrs)
        |> Repo.insert

      assert result == :ok
      changeset
    end

    test "list_service_link/0 returns all service_links" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      project = insert(:tp_project)
      struct = insert(:tp_service_link, book_keeping: book_keeping, business_tax_return: business_tax_return, individual_tax_return: individual_tax_return, sale_tax: sale_tax, project: project)
      [data] = Services.list_service_link()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_service_link!/1 returns the service_link with given id" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      project = insert(:tp_project)
      struct = insert(:tp_service_link, book_keeping: book_keeping, business_tax_return: business_tax_return, individual_tax_return: individual_tax_return, sale_tax: sale_tax, project: project)
      attrs = [:password, :password_cofirmation]
      data = Services.get_service_link!(struct.id)
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_service_link/1 with valid data creates a service_link" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      project = insert(:tp_project)
      params = %{
        book_keeping_id: book_keeping.id,
        business_tax_return_id: business_tax_return.id,
        individual_tax_return_id: individual_tax_return.id,
        project_id: project.id,
        sale_tax_id: sale_tax.id
      }

      assert {:ok, created} = Services.create_service_link(params)
      assert created.book_keeping_id          == book_keeping.id
      assert created.business_tax_return_id   == business_tax_return.id
      assert created.individual_tax_return_id == individual_tax_return.id
      assert created.project_id               == project.id
      assert created.sale_tax_id              == sale_tax.id
   end

    test "create_service_link/1 with invalid data returns error changeset" do
      params = %{}
      assert {:error, %Ecto.Changeset{}} != Services.create_service_link(params)
    end

    test "update_service_link/2 with valid data updates the service_link" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      project = insert(:tp_project)
      struct = insert(:tp_service_link, book_keeping: book_keeping, business_tax_return: business_tax_return, individual_tax_return: individual_tax_return, sale_tax: sale_tax, project: project)
      params = %{project_id: nil}

      assert {:ok, %ServiceLink{} = updated} =
        Services.update_service_link(struct, params)
      assert updated.book_keeping_id          == book_keeping.id
      assert updated.business_tax_return_id   == business_tax_return.id
      assert updated.individual_tax_return_id == individual_tax_return.id
      assert updated.sale_tax_id              == sale_tax.id
    end

    test "update_service_link/2 with invalid data returns error changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      project = insert(:tp_project)
      struct = insert(:tp_service_link, book_keeping: book_keeping, business_tax_return: business_tax_return, individual_tax_return: individual_tax_return, sale_tax: sale_tax, project: project)
      params = %{}
      assert {:error, %Ecto.Changeset{}} != Services.update_service_link(struct, params)
    end

    test "delete_service_link/1 deletes the service_link" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      project = insert(:tp_project)
      struct = insert(:tp_service_link, book_keeping: book_keeping, business_tax_return: business_tax_return, individual_tax_return: individual_tax_return, sale_tax: sale_tax, project: project)
      assert {:ok, %ServiceLink{}} = Services.delete_service_link(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_service_link!(struct.id) end
    end

    test "change_service_link/1 returns a service_link changeset" do
      user = insert(:tp_user)
      book_keeping = insert(:tp_book_keeping, user: user)
      business_tax_return = insert(:tp_business_tax_return, user: user)
      individual_tax_return = insert(:tp_individual_tax_return, user: user)
      sale_tax = insert(:tp_sale_tax, user: user)
      project = insert(:tp_project)
      struct = insert(:tp_service_link, book_keeping: book_keeping, business_tax_return: business_tax_return, individual_tax_return: individual_tax_return, sale_tax: sale_tax, project: project)
      assert %Ecto.Changeset{} = Services.change_service_link(struct)
    end
  end

  describe "service_link by role's Pro" do
    test "ensures user with specified id actually exists" do
      id = FlakeId.get()
      attrs = %{
        id: id,
        book_keeping_id: nil,
        business_tax_return_id: nil,
        individual_tax_return_id: nil,
        sale_tax_id: nil
      }
      {result, changeset} =
        %ServiceLink{}
        |> ServiceLink.changeset(attrs)
        |> Repo.insert

      assert result == :ok
      changeset
    end

    test "list_service_link/0 returns all service_links" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_service_link, book_keepings: book_keeping, business_tax_returns: business_tax_return, individual_tax_returns: individual_tax_return, sale_taxes: sale_tax)
      [data] = Services.list_service_link()
      attrs = [:password, :password_cofirmation]
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "get_service_link!/1 returns the service_link with given id" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_service_link, book_keepings: book_keeping, business_tax_returns: business_tax_return, individual_tax_returns: individual_tax_return, sale_taxes: sale_tax)
      attrs = [:password, :password_cofirmation]
      data = Services.get_service_link!(struct.id)
      assert Map.take(data, attrs) == Map.take(struct, attrs)
    end

    test "create_sale_tax_industry/1 with valid data creates a sale_tax_industry" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      params = %{
        book_keeping_id: book_keeping.id,
        business_tax_return_id: business_tax_return.id,
        individual_tax_return_id: individual_tax_return.id,
        sale_tax_id: sale_tax.id
      }

      assert {:ok, %ServiceLink{} = service_link} = Services.create_service_link(params)
      assert service_link.book_keeping_id          == book_keeping.id
      assert service_link.business_tax_return_id   == business_tax_return.id
      assert service_link.individual_tax_return_id == individual_tax_return.id
      assert service_link.sale_tax_id              == sale_tax.id
    end

    test "create_service_link/1 with invalid data returns error changeset" do
      params = %{}
      assert {:error, %Ecto.Changeset{}} != Services.create_service_link(params)
    end

    test "update_service_link/2 with valid data updates the service_link" do
      user = insert(:pro_user)
      insert(:pro_book_keeping, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_service_link, book_keepings: nil, business_tax_returns: business_tax_return, individual_tax_returns: individual_tax_return, sale_taxes: sale_tax)
      params = %{book_keeping_id: nil}

      assert {:ok, %ServiceLink{} = updated} =
        Services.update_service_link(struct, params)
      assert struct.book_keeping_id          == nil
      assert struct.business_tax_return_id   == business_tax_return.id
      assert struct.individual_tax_return_id == individual_tax_return.id
      assert struct.sale_tax_id              == sale_tax.id
    end

    test "update_service_link/2 with invalid data returns error changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_service_link, book_keepings: book_keeping, business_tax_returns: business_tax_return, individual_tax_returns: individual_tax_return, sale_taxes: sale_tax)
      params = %{}
      assert {:error, %Ecto.Changeset{}} != Services.update_service_link(struct, params)
    end

    test "delete_service_link/1 deletes the service_link" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_service_link, book_keepings: book_keeping, business_tax_returns: business_tax_return, individual_tax_returns: individual_tax_return, sale_taxes: sale_tax)
      assert {:ok, %ServiceLink{}} = Services.delete_service_link(struct)
      assert_raise Ecto.NoResultsError, fn -> Services.get_service_link!(struct.id) end
    end

    test "change_service_link/1 returns a service_link changeset" do
      user = insert(:pro_user)
      book_keeping = insert(:pro_book_keeping, user: user)
      business_tax_return = insert(:pro_business_tax_return, user: user)
      individual_tax_return = insert(:pro_individual_tax_return, user: user)
      sale_tax = insert(:pro_sale_tax, user: user)
      struct = insert(:pro_service_link, book_keepings: book_keeping, business_tax_returns: business_tax_return, individual_tax_returns: individual_tax_return, sale_taxes: sale_tax)
      assert %Ecto.Changeset{} = Services.change_service_link(struct)
    end
  end
end
