defmodule BankersAlgoTest do
  use ExUnit.Case
  doctest BankersAlgo

  test "banker's algorithm check: safety" do
    res = %{
      "init_state" => %{"A" => 6, "B" => 4, "C" => 7, "D" => 6},
      "init_each_resource" => [
        %{"A" => 1, "B" => 2, "C" => 2, "D" => 1},
        %{"A" => 1, "B" => 0, "C" => 0, "D" => 3},
        %{"A" => 1, "B" => 1, "C" => 1, "D" => 0},
      ],
      "scenario" => [
        %{"A" => 3, "B" => 3, "C" => 2, "D" => 2},
        %{"A" => 1, "B" => 2, "C" => 3, "D" => 4},
        %{"A" => 1, "B" => 1, "C" => 5, "D" => 0},
      ]
    }
    |> BankersAlgo.main()

    Process.sleep(1000)
    assert res == :ok
  end

  test "banker's algorithm check: unsafety" do
    res = %{
      "init_state" => %{"A" => 6, "B" => 4, "C" => 7, "D" => 6},
      "init_each_resource" => [
        %{"A" => 1, "B" => 2, "C" => 2, "D" => 1},
        %{"A" => 1, "B" => 0, "C" => 0, "D" => 3},
        %{"A" => 1, "B" => 1, "C" => 1, "D" => 0},
        %{"A" => 1, "B" => 1, "C" => 1, "D" => 0},
      ],
      "scenario" => [
        %{"A" => 3, "B" => 3, "C" => 2, "D" => 2},
        %{"A" => 1, "B" => 2, "C" => 3, "D" => 4},
        %{"A" => 1, "B" => 1, "C" => 5, "D" => 0},
      ]
    }
    |> BankersAlgo.main()

    Process.sleep(1000)
    assert res == :ok
  end
end
