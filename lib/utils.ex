defmodule BankersAlgo.Utils do
  alias BankersAlgo.Constants
  @judge_parameter Constants.judge_parameter()

  def random_deciede_number(0), do: 0
  def random_deciede_number(limit_num) do
    # 普通にやってると値が大きくなりすぎるのでparamaterを使って微調整
    judge = :rand.uniform()
    _random_deciede_number(judge, @judge_parameter, limit_num)
  end

  defp _random_deciede_number(judge, param, limit_num) when judge >= param do
    :rand.uniform(limit_num)
  end
  defp _random_deciede_number(_, _, limit_num) do
    :rand.uniform(limit_num) / 2 |> trunc()
  end
end
