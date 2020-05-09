defmodule BankersAlgo do
  alias BankersAlgo.Server
  require Logger

  def main(scenario_map) do
    {init_state, init_each_resource, scenario} = get_values(scenario_map)
    # launch GenServer
    {:ok, pid} = GenServer.start_link(Server, init_state)
    # request GenServer allocate init resource
    Enum.each(init_each_resource, fn {_, req} -> GenServer.call(pid, {:init, req}) end)

    Logger.info("Available resource: #{inspect(GenServer.call(pid, {:state}))}")
    genserver_request(scenario, init_each_resource, pid)
  end

  # call to GenServer, check to resource
  defp genserver_request([], _init, _pid), do: :ok
  defp genserver_request([scenario | tail], init_each_resource, pid) do
    # distract
    {process, init} = get_init_resource(scenario, init_each_resource)
    Logger.info("---> process request: #{process}")
    max = Map.get(scenario, "request")
    request = Map.merge(max, init, fn _k, v1, v2 -> v1 - v2 end)
    case GenServer.call(pid, {:request, request}) do
      {:ok, _} ->
        # return resource
        GenServer.call(pid, {:return, max})
        # clear process resource
        updated_init = update_init_resource(init_each_resource, process)
        genserver_request(tail, updated_init, pid)
      {:unsafe, _} -> :unsafe
    end
  end

  # get values from map and check same length
  defp get_values(%{
    "init_state" => init_state,
    "init_each_resource" => init_each_resource,
    "scenario" => scenario
    }
  ) do
    {init_state, init_each_resource, scenario}
  end
  defp get_values(_), do: {:error, nil, nil}

  # get process init value and update
  defp get_init_resource(scenario, init_each_process) do
    process = Map.get(scenario, "process")
    init = Map.get(init_each_process, process)
    {process, init}
  end

  # update init resource
  defp update_init_resource(init_each_resource, process) do
    Map.put(
      init_each_resource,
      process,
      Enum.reduce(
        Map.get(init_each_resource, process),
        %{},
        fn {k, _}, acc ->
          Map.put(acc, k, 0)
        end
      )
    )
  end
end
