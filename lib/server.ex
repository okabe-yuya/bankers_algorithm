defmodule BankersAlgo.Server do
  use GenServer
  require Logger
  alias BankersAlgo.Utils
  @allowed_keys BankersAlgo.Constants.allowed_keys()

  # lauch GenServer(behavior)
  # init_status = A(現在利用可能な資源)
  # data structure
  # {
  #   "A" => int,
  #   "B" => int,
  #   "C" => int,
  #   "D" => int
  # }
  # return: {:ok, pid}
  def init(%{"A" => _, "B" => _, "C" => _, "D" => _} = resource) do
    Logger.info("Set init state: #{inspect(resource)}")
    {:ok, resource}
  end
  # return {:error, string(reason)}
  def init(_) do
    reason = "Unvalid init status. allowed status is %{'A'=> int, 'B' => int, 'C' => int, 'D' => int}"
    Logger.error(reason)
    {:error, reason}
  end

  def handle_call({:init}, _from, state) do
    {init_src, state} = Enum.reduce(@allowed_keys, {%{}, state}, fn k, acc ->
      limit_num = Map.get(state, k)
      decided_num = Utils.random_deciede_number(limit_num)
      {n_acc, n_state} = acc
      next_acc = Map.put(n_acc, k, decided_num)
      next_state = Map.put(n_state, k, limit_num - decided_num)
      {next_acc, next_state}
    end)
    Logger.info("Gave resource: #{inspect(init_src)}")
    {:reply, init_src, state}
  end

  # check resource
  def handle_call({:request, %{"A" => _, "B" => _, "C" => _, "D" => _} = request}, _from, state) do
    Logger.info("Received request: #{inspect(request)}")
    reply = check_and_update_state(@allowed_keys, state, request)
    {_, next_state} = reply
    Logger.info("Updated sever state: #{inspect(next_state)}")
    {:reply, reply, next_state}
  end

  def handle_call({:state}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:return, %{"A" => _, "B" => _, "C" => _, "D" => _} = return}, state) do
    merge_state = Enum.reduce(["A", "B", "C", "D"], state, fn k, acc ->
      Map.put(acc, k, Map.get(acc, k) + Map.get(return, k))
    end)
    Logger.info("Received resource and merge: #{inspect(merge_state)}")
    {:noreply, merge_state}
  end

  # keyの存在証明はvalidateによって成されていることが前提
  def check_and_update_state([], state, _), do: {:ok, state}
  def check_and_update_state([head | tail], state, request) do
    state_src = Map.get(state, head)
    src = Map.get(request, head)
    if state_src - src >= 0 do
      check_and_update_state(tail, Map.put(state, head, state_src - src), request)
    else
      {:unsafe, Map.put(state, head, state_src - src)}
    end
  end
end
