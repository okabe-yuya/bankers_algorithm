defmodule BankersAlgoTest do
  use ExUnit.Case
  doctest BankersAlgo

  test "banker's algorithm check" do
    status = %{"A" => 10, "B" => 10, "C" => 10, "D" => 10}
    res = BankersAlgo.launch(2, status)

    Process.sleep(1000)
    assert res == :ok
  end
end
