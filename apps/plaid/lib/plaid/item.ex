defmodule Plaid.Item do
  @moduledoc """
  Functions for Plaid `item` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct error: nil,
            item_id: nil,
            request_id: nil

  @type t :: %__MODULE__{
          error: String.t() | nil,
          item_id: String.t(),
          request_id: String.t()
        }

  @type params :: %{required(atom) => String.t()}
  @type config :: %{required(atom) => String.t()}

  @endpoint_a  :sandbox
  @endpoint_b  :item

  @doc """
  Creates a public token. To be used to put Plaid Link into update mode.

  Parameters
  ```
  %{
    initial_products: [""],
    institution_id: "",
    options: %{webhook: ""},
    public_key: ""
  }
  ```

  Response
  ```
  {:ok, %{public_token: "access-env-identifier", expiration: 3600, request_id: "kg414f"}}
  ```
  """
  @spec create_public_token(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def create_public_token(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint_a}/public_token/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint_a)
  end

  @doc """
  Exchanges a public token for an access token and item id.

  Parameters
  ```
  %{public_token: "public-env-identifier"}
  ```

  Response
  ```
  {:ok, %{access_token: "access-env-identifier", item_id: "some-id", request_id: "f24wfg"}}
  ```
  """
  @spec exchange_public_token(params, config | nil) :: {:ok, map} | {:error, Plaid.Error.t()}
  def exchange_public_token(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint_b}/public_token/exchange"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint_b)
  end
end
