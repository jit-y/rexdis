defmodule RexdisObjects.Value do
  @moduledoc """
  value object
  """

  use GenServer

  def start_link(key, options) do
    GenServer.start_link(__MODULE__, [key, options], name: __MODULE__)
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def set(pid, key, value) do
    GenServer.cast(pid, {:set, key, value})
  end

  def ttl(pid, key) do
    GenServer.call(pid, {:ttl, key})
  end

  def reset(pid, key) do
    GenServer.call(pid, {:reset, key})
  end

  def init(key, options) do
    GenServer.cast(self(), {:init, key, options})
    {:ok, %{}}
  end

  def handle_cast({:init, key, options}, state) do
    {:noreply, %{state | key: parse_key(key), options: parse_options(options)}}
  end

  def handle_cast({:set, _key, _value}, state) do
    {:noreply, state}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, key, state}
  end

  def handle_call({:ttl, key}, _from, state) do
    {:reply, key, state}
  end

  def handle_call({:reset, key}, _from, state) do
    {:reply, key, state}
  end

  defp parse_key(key) when is_binary(key), do: key
  defp parse_key(_), do: raise ArgumentError, "Inappropriate key"
  defp parse_options(options) when is_map(options), do: options
  defp parse_options(_), do: raise ArgumentError, "Inappropriate options"
end
