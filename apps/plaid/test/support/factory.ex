defmodule Plaid.Factory do
  @moduledoc false

  def http_response_body(:error) do
    %{
      "error_type" => "INVALID_REQUEST",
      "error_code" => "MISSING_FIELDS",
      "error_message" => "Something went bad wrong.",
      "display_message" => "lol wut",
      "request_id" => "h12lD"
    }
  end

  def http_response_body(:create_link_token) do
    %{
      "link_token" => "link-sandbox-cc8a09fe-e6a1-49ee-a533-074d12027cf4",
      "expiration" => "2021-05-26T22:10:29Z",
      "request_id" => "3IEVhOxceZKRBlK"
    }
  end
end
