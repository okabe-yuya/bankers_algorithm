defmodule BankersAlgo do
  alias BankersAlgo.Server
  require Logger

  def main(scenario_map) do
    {init_state, init_each_resource, scenario} = get_values(scenario_map)
    # launch GenServer
    {:ok, pid} = GenServer.start_link(Server, init_state)
    # request GenServer allocate init resource
    Enum.map(init_each_resource, fn req -> GenServer.call(pid, {:init, req}) end)
    |> genserver_request(scenario, pid)
  end

  # call to GenServer, check to resource
  defp genserver_request([], [], _pid), do: :ok
  defp genserver_request([init_resource | i_tail], [max_resource | m_tail], pid) do
    # distract
    request = Map.merge(init_resource, max_resource, fn _k, v1, v2 -> v2 - v1 end)
    case GenServer.call(pid, {:request, request}) do
      {:ok, _} ->
        # return resource
        GenServer.cast(pid, {:return, max_resource})
        genserver_request(i_tail, m_tail, pid)
      {:unsafe, _} -> :unsafe
    end
  end

  # get values from map and check same length
  defp get_values(%{
    "init_state" => init_state,
    "init_each_resource" => init_each_resource,
    "scenario" => scenario
    }
  ) when length(init_each_resource) == length(scenario) do
    {init_state, init_each_resource, scenario}
  end
  defp get_values(_), do: {:error, nil, nil}
end
