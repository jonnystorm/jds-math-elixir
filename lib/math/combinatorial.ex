# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

defmodule Math.Combinatorial do

  @spec cartesian_product(list, list)
    :: [tuple]
  def cartesian_product(coll1, coll2) do
    for item1 <- coll1,
        item2 <- coll2,
      do: {item1, item2}
  end

  @spec choose(list, pos_integer)
    :: list
  def choose([], _k),
    do: []

  def choose(items, 1) when is_list(items),
    do: Enum.map(items, &([&1]))

  def choose([head|tail], k) do
    choose(tail, k - 1)
    |> Enum.map(& [head|&1])
    |> Enum.concat(choose(tail, k))
  end

  @spec choose(pos_integer, pos_integer)
    :: pos_integer
  def choose(n, k) when n > 0,
    do: div(factorial(n), factorial(k) * factorial(n - k))

  @spec factorial(non_neg_integer)
    :: pos_integer
  def factorial(0),
    do: 1

  def factorial(1),
    do: 1

  def factorial(n) when is_integer(n) and n > 1,
    do: Enum.reduce(2..n, 1, &(&1 * &2))

  @spec permute(list)
    :: [list]
  def permute([]),
    do: [[]]

  def permute(items) do
    for head <- items,
        tail <- permute(items -- [head]),
      do: [head|tail]
  end
end

