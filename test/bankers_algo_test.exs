defmodule BankersAlgoTest do
  use ExUnit.Case
  doctest BankersAlgo

  test "banker's algorithm check: safety" do
    res = %{
      "init_state" => %{"A" => 6, "B" => 4, "C" => 7, "D" => 6},
      "init_each_resource" => %{
        "P1" => %{
          "A" => 1,
          "B" => 2,
          "C" => 2,
          "D" => 1
        },
        "P2" => %{
          "A" => 1,
          "B" => 0,
          "C" => 3,
          "D" => 3
        },
        "P3" => %{
          "A" => 1,
          "B" => 1,
          "C" => 1,
          "D" => 0
        }
      },
      "scenario" => [
        %{
          "process" => "P1",
          "request" => %{"A" => 3, "B" => 3, "C" => 2, "D" => 2}
        },
        %{
          "process" => "P2",
          "request" => %{"A" => 1, "B" => 2, "C" => 3, "D" => 4}
        },
        %{
          "process" => "P3",
          "request" => %{"A" => 1, "B" => 1, "C" => 5, "D" => 0}
        }
      ]
    }
    |> BankersAlgo.main()

    Process.sleep(1000)
    assert res == :ok
  end

  test "banker's algorithm check: unsafety" do
    res = %{
      "init_state" => %{"A" => 6, "B" => 4, "C" => 7, "D" => 6},
      "init_each_resource" => %{
        "P1" => %{
          "A" => 1,
          "B" => 2,
          "C" => 2,
          "D" => 1
        },
        "P2" => %{
          "A" => 1,
          "B" => 1,
          "C" => 3,
          "D" => 3
        },
        "P3" => %{
          "A" => 1,
          "B" => 1,
          "C" => 1,
          "D" => 0
        }
      },
      "scenario" => [
        %{
          "process" => "P1",
          "request" => %{"A" => 3, "B" => 3, "C" => 2, "D" => 2}
        },
        %{
          "process" => "P2",
          "request" => %{"A" => 1, "B" => 2, "C" => 3, "D" => 4}
        },
        %{
          "process" => "P3",
          "request" => %{"A" => 1, "B" => 1, "C" => 5, "D" => 0}
        }
      ]
    }
    |> BankersAlgo.main()

    Process.sleep(1000)
    assert res == :unsafe
  end
end
