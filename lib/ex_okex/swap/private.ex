defmodule ExOkex.Swap.Private do
  @moduledoc """
  Swap account client.

  [API docs](https://www.okex.com/docs/en/#swap-README)
  """

  import ExOkex.Api.Private

  @type params :: map
  @type config :: map | nil
  @type response :: ExOkex.Api.response()

  @prefix "/api/swap/v3"

  @doc """
  Place a new order.

  ## Examples

  iex> ExOkex.Swap.Private.create_order(%{
    instrument_id: "BTC-USD-SWAP",
    leverage: "10",
    type: "1",
    price: "432.11",
    size: "2",
    match_price: "0"
  })
  {:ok,
   %{
     "client_oid" => nil,
     "error_code" => "0",
     "error_message" => "",
     "order_id" => "465681883218518016",
     "result" => "true"
   }}
  """
  @spec create_order(params, config) :: response
  def create_order(params, config \\ nil) do
    post("#{@prefix}/order", params, config)
  end

  @doc """
  Place multiple orders for specific trading pairs (up to 4 trading pairs, maximum 4 orders each)

  https://www.okex.com/docs/en/#swap-swap---batch

  ## Examples

  iex> ExOkex.Swap.Private.create_bulk_orders([
    %{"instrument_id":"BTC-USD-SWAP",
      "type":"1",
      "price":"432.11",
      "size":"2",
      "match_price":"0",
      "leverage":"10" },
    ])

    # TODO: Add response sample

  """
  @spec create_bulk_orders(params, config) :: response
  def create_bulk_orders(params, config \\ nil) do
    post("#{@prefix}/orders", params, config)
  end

  defdelegate create_batch_orders(params, config \\ nil), to: __MODULE__, as: :create_bulk_orders

  @doc """
  Batch cancelling unfilled orders.

  https://www.okex.com/docs/en/#swap-swap---revocation

  ## Example

      iex> ExOkex.Swap.Private.cancel_orders("BTC-USD-SWAP", [465681883218518016, 465681883218518017])

      %{
        "client_oids" => [],
        "error_code" => "0",
        "error_message" => "",
        "ids" => ["465681883218518016", 465681883218518017],
        "instrument_id" => "BTC-USD-SWAP",
        "result" => "true"
      }}
  """
  def cancel_orders(instrument_id, order_ids \\ [], params \\ %{}, config \\ nil) do
    new_params = Map.merge(params, %{ids: order_ids})
    post("#{@prefix}/cancel_batch_orders/#{instrument_id}", new_params, config)
  end

  @doc """
  Cancelling unfilled order.

  https://www.okex.com/docs/en/#swap-swap---revocation

  ## Example

      iex> ExOkex.Swap.Private.cancel_order("BTC-USD-SWAP", 465681883218518016)

      {:ok,
       %{
         "error_code" => "0",
         "error_message" => "",
         "order_id" => "465688276882628608",
         "result" => "true"
       }}
  """
  @spec cancel_order(any, any, config) :: response
  def cancel_order(instrument_id, order_id, config \\ nil) do
    post("#{@prefix}/cancel_order/#{instrument_id}/#{order_id}", %{order_id: order_id}, config)
  end

  @doc """
  Get the swap account info of all token.

  https://www.okex.com/docs/en/#swap-singleness

  ## Examples

      iex(3)> ExOkex.Swap.Private.list_accounts()

      {:ok,
       %{
         "info" => [
           %{
             "currency" => "BTC",
             "equity" => "0.0200",
             "fixed_balance" => "0.0000",
             "instrument_id" => "BTC-USD-SWAP",
             "maint_margin_ratio" => "0.0050",
             "margin" => "0.0000",
             "margin_frozen" => "0.0000",
             "margin_mode" => "crossed",
             "margin_ratio" => "10000",
             "max_withdraw" => "0.0200",
             "realized_pnl" => "0.0000",
             "timestamp" => "2020-03-29T08:47:21.104Z",
             "total_avail_balance" => "0.0200",
             "underlying" => "BTC-USD",
             "unrealized_pnl" => "0.0000"
           },
           %{
             "currency" => "LTC",
      ...
  """
  def list_accounts(config \\ nil) do
    get("#{@prefix}/accounts", %{}, config)
  end

  @doc """
  Get the information of holding positions of a contract.

  https://www.okex.com/docs/en/#swap-hold_information

  ## Examples

      iex(3)> ExOkex.Swap.Private.get_position("BTC-USD-SWAP")

  """
  def get_position(instrument_id, config \\ nil) do
    get("#{@prefix}/#{instrument_id}/position", %{}, config)
  end

  def get_positions(config \\ nil) do
    get("#{@prefix}/position", %{}, config)
  end

  def get_leverage(instrument_id, config \\ nil) do
    get("#{@prefix}/accounts/#{instrument_id}/settings", %{}, config)
  end
end
