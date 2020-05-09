defmodule BankersAlgo.Server do
  use GenServer
  require Logger

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

  def handle_call({:init, %{"A" => _, "B" => _, "C" => _, "D" => _} = max_resource}, _from, state) do
    reply = Map.merge(state, max_resource, fn _, v1, v2 -> v1 - v2 end)
    {:reply, max_resource, reply}
  end

  # check resource
  def handle_call({:request, %{"A" => _, "B" => _, "C" => _, "D" => _} = request}, _from, state) do
    Logger.info("Received request: #{inspect(request)}")
    reply = Map.merge(state, request, fn _, v1, v2 -> v1 - v2 end)
    Logger.info("Updated sever state: #{inspect(reply)}")
    {:reply, is_unsafe(Map.keys(state), reply), reply}
  end

  def handle_call({:state}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:return, %{"A" => _, "B" => _, "C" => _, "D" => _} = return}, state) do
    merge_state = Map.merge(state, return, fn _, v1, v2 -> v1 + v2 end)
    Logger.info("Received resource and merge: #{inspect(merge_state)}")
    {:noreply, merge_state}
  end

  defp is_unsafe([], reply), do: {:ok, reply}
  defp is_unsafe([head | tail], reply) do
    if Map.get(reply, head) >= 0 do
      is_unsafe(tail, reply)
    else
      {:unsafe, reply}
    end
  end
end
