defmodule BankAccount do
  use GenServer

  @moduledoc """
  A bank account that supports access from multiple processes.
  """
  defstruct balance: 0, opened: true

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = GenServer.start_link(__MODULE__, nil)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    GenServer.cast(account, :close_account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    GenServer.call(account, :get_balance)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    GenServer.call(account, {:update_balance, amount})
  end

  # Server-side
  def init(_), do: {:ok, %BankAccount{balance: 0, opened: true}}

  def handle_call(:get_balance, _, state = %{opened: false}) do
    {:reply, {:error, :account_closed}, state}
  end

  def handle_call(:get_balance, _, state = %{balance: balance}), do: {:reply, balance, state}

  def handle_call({:update_balance, _}, _, state = %{opened: false}) do
    {:reply, {:error, :account_closed}, state}
  end

  def handle_call({:update_balance, amount}, _, state = %{balance: balance}) do
    {:reply, :ok, %{state | balance: balance + amount}}
  end

  def handle_cast(:close_account, state) do
    {:noreply, %{state | opened: false}}
  end
end
