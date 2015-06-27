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
  def choose(items, 1) when is_list(items) do
    for item <- items, do: [item]
  end
  def choose([head|tail], k) do
    (for subchoose <- choose(tail, k - 1) do
      [head|subchoose]
    end) ++ choose(tail, k)
  end

  @spec choose(pos_integer, pos_integer) :: pos_integer
  def choose(n, k) when n > 0 do
    1..n
    |> Enum.to_list
    |> choose(k)
    |> length
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

