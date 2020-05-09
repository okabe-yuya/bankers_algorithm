defmodule BankersAlgo do
  alias BankersAlgo.Server
  alias BankersAlgo.Utils
  require Logger
  @allowed_keys BankersAlgo.Constants.allowed_keys()

  def launch(total_process, init_state) do
    # launch GenServer process
    case GenServer.start_link(Server, init_state) do
      # launch child processes
      {:ok, pid} ->
        res = task(pid, init_state, total_process)
        state = GenServer.call(pid, {:state})
        if res == :ok do
          Logger.info("All processing was passed with no problem: #{inspect(state)}")
        else
          Logger.error("Failed processing: #{inspect(state)}")
        end
        res
      {:error, _} -> :error
    end
  end

  def task(_, _, 0), do: :ok
  def task(pid, init_state, num) do
    Logger.info("Request resource by #{inspect(self())}", ansi_color: :blue)
    # fetch init resource from GenServer
    own_src = GenServer.call(pid, {:init})
    # check resource
    request = request_resource(init_state)

    case GenServer.call(pid, {:request, request}) do
      {:ok, _} ->
        # merge map
        return = Map.merge(own_src, request, fn _k, v1, v2 -> v1 + v2 end)
        # return resource
        GenServer.cast(pid, {:return, return})
        # check resource
        task(pid, init_state, num-1)
      {:unsafe, _} -> :unsafe
    end
  end

  def request_resource(init_state) do
    Enum.reduce(@allowed_keys, %{}, fn k, acc ->
      decided_num =
        Map.get(init_state, k)
        |> Utils.random_deciede_number()
      Map.put(acc, k, decided_num)
    end)
  end
end
