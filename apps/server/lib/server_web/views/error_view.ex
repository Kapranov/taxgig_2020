defmodule ServerWeb.ErrorView do
  use ServerWeb, :view

  alias Phoenix.Controller

  @spec template_not_found(atom, map) :: String.t()
  def template_not_found(template, _assigns) do
    %{
      errors: %{
        detail: Controller.status_message_from_template(template)
      }
    }
  end
end
