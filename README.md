# BankersAlgo
銀行家のアルゴリズムの実装と検証アプリケーション

## Architecture
### language
```
Erlang/OTP 22 [erts-10.6.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Elixir 1.9.4 (compiled with Erlang/OTP 22)
```

- Elixir process
- Erlang/OTP GenServer

## Usage
clone repository  

> git clone https://github.com/okabe-yuya/bankers_algorithm.git  

current directory  

> cd bankers_algorithm  

execute verification  

> mix test  

```elixir
00:20:19.837 [info]  Set init state: %{"A" => 6, "B" => 4, "C" => 7, "D" => 6}

00:20:19.843 [info]  Available resource: %{"A" => 3, "B" => 0, "C" => 1, "D" => 2}

00:20:19.843 [info]  ---> process request: P1

00:20:19.843 [info]  Received request: %{"A" => 2, "B" => 1, "C" => 0, "D" => 1}

00:20:19.843 [info]  Updated sever state: %{"A" => 1, "B" => -1, "C" => 1, "D" => 1}
.
00:20:20.845 [info]  Set init state: %{"A" => 6, "B" => 4, "C" => 7, "D" => 6}

00:20:20.846 [info]  Available resource: %{"A" => 3, "B" => 1, "C" => 1, "D" => 2}

00:20:20.846 [info]  ---> process request: P1

00:20:20.846 [info]  Received request: %{"A" => 2, "B" => 1, "C" => 0, "D" => 1}

00:20:20.846 [info]  Updated sever state: %{"A" => 1, "B" => 0, "C" => 1, "D" => 1}

00:20:20.846 [info]  Return resource: %{"A" => 3, "B" => 3, "C" => 2, "D" => 2}

00:20:20.846 [info]  Received resource and merge: %{"A" => 4, "B" => 3, "C" => 3, "D" => 3}

00:20:20.846 [info]  ---> process request: P2

00:20:20.846 [info]  Received request: %{"A" => 0, "B" => 2, "C" => 0, "D" => 1}

00:20:20.846 [info]  Updated sever state: %{"A" => 4, "B" => 1, "C" => 3, "D" => 2}

00:20:20.846 [info]  Return resource: %{"A" => 1, "B" => 2, "C" => 3, "D" => 4}

00:20:20.846 [info]  Received resource and merge: %{"A" => 5, "B" => 3, "C" => 6, "D" => 6}

00:20:20.847 [info]  ---> process request: P3

00:20:20.847 [info]  Received request: %{"A" => 0, "B" => 0, "C" => 4, "D" => 0}

00:20:20.847 [info]  Updated sever state: %{"A" => 5, "B" => 3, "C" => 2, "D" => 6}

00:20:20.847 [info]  Return resource: %{"A" => 1, "B" => 1, "C" => 5, "D" => 0}

00:20:20.847 [info]  Received resource and merge: %{"A" => 6, "B" => 4, "C" => 7, "D" => 6}
.

Finished in 2.0 seconds
2 tests, 0 failures
```

## add case
write test case in `./lib/bankers_algo_test.exs`  
and define scenario data structure  

how to write scenaio data structure  
```elixir
%{
  # `init_state` is A + Σ1~N(Cp)
  "init_state" => %{"A" => 6, "B" => 4, "C" => 7, "D" => 6},

  # Cp
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

  # flow
  "scenario" => [
    %{
      # request process name
      "process" => "P1",
      # Mp(verification scenario)
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
```

## 参考
[銀行家のアルゴリズム wikipedia](https://ja.wikipedia.org/wiki/%E9%8A%80%E8%A1%8C%E5%AE%B6%E3%81%AE%E3%82%A2%E3%83%AB%E3%82%B4%E3%83%AA%E3%82%BA%E3%83%A0)