# Copyright © 2015 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule Math.Combinatorial do

  @spec cartesian_product(list, list) :: [tuple]
  def cartesian_product(coll1, coll2) do
    for item1 <- coll1, item2 <- coll2, do: {item1, item2}
  end

  @spec choose(list, pos_integer) :: list
  def choose([], _k) do
    []
  end
  def choose(items, 1) when is_list items do
    Enum.map items, &([&1])
  end
  def choose([head|tail], k) do
    Enum.map(choose(tail, k - 1), fn subchoose ->
      [head|subchoose]
    end) ++ choose(tail, k)
  end

  @spec choose(pos_integer, pos_integer) :: pos_integer
  def choose(n, k) when n > 0 do
    div factorial(n), factorial(k) * factorial(n - k)
  end

  @spec factorial(non_neg_integer) :: pos_integer
  def factorial(0) do
    1
  end
  def factorial(1) do
    1
  end
  def factorial(n) when is_integer(n) and n > 1 do
    Enum.reduce 2..n, 1, &(&1 * &2)
  end

  @spec permute(list) :: [list]
  def permute([]) do
    [[]]
  end
  def permute(items) do
    for head <- items, tail <- permute(items -- [head]) do
      [head|tail]
    end
  end
end

