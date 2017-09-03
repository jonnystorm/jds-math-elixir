# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

defmodule Math.Binary do
  use Bitwise

  @spec pow2(integer)
    :: pos_integer
  def pow2(exponent),
    do: Math.pow(2, exponent)

  defp _bits(number, {exponent, bit_value})
      when bit_value > number,
    do: exponent

  defp _bits(number, {exponent, bit_value})
      when bit_value <= number,
    do: _bits(number, {exponent + 1, bit_value * 2})

  @spec bits(integer)
    :: non_neg_integer
  def bits(0),
    do: 1

  def bits(number),
    do: _bits(number, {0, 1})

  @spec choose_bits(pos_integer, pos_integer)
    :: [non_neg_integer]
  def choose_bits(n, k) do
    0..(n - 1)
    |> Enum.to_list
    |> Math.Combinatorial.choose(k)
    |> Enum.map(fn exponents ->
      Enum.reduce exponents, 0, fn(exponent, acc) ->
        pow2(exponent) + acc
      end
    end)
  end

  defp _ones({0, acc}),
    do: acc

  defp _ones({number, acc}),
    do: _ones {bsr(number, 1), rem(number, 2) + acc}

  @spec ones(integer)
    :: non_neg_integer
  def ones(number),
    do: _ones {number, 0}

  @spec euclidean_norm(integer)
    :: float
  def euclidean_norm(number),
    do: :math.sqrt ones(number)

  @spec hamming_weight(integer)
    :: non_neg_integer
  def hamming_weight(number),
    do: ones number

  @spec hamming_distance(integer, integer)
    :: non_neg_integer
  def hamming_distance(p, q),
    do: ones bxor(p, q)

  @spec hamming_shell(integer, pos_integer, pos_integer)
    :: [non_neg_integer]
  def hamming_shell(center, radius, dimensions) do
    for choose <- choose_bits(dimensions, radius),
      do: bxor(center, choose)
  end

  @spec hamming_sphere(integer, pos_integer, pos_integer)
    :: list
  def hamming_sphere(center, radius, dimensions) do
    1..radius
    |> Enum.to_list
    |> Enum.reduce([center], fn(r, acc) ->
      acc ++ hamming_shell(center, r, dimensions)
    end)
  end

  @spec hamming_face?(integer, integer, integer)
    :: boolean
  def hamming_face?(a, b, c) do
    [a, b, c]
    |> Math.Combinatorial.choose(2)
    |> Enum.map(fn [p, q] -> hamming_distance(p, q) end)
    |> Math.Combinatorial.permute
    |> Enum.member?([1, 1, 2])
  end

  @spec hamming_face(integer, integer, integer)
    :: [integer]
     | {:error, String.t}
  def hamming_face(a, b, c) do
    if hamming_face?(a, b, c) do
      d = a |> bxor(b) |> bxor(c)

      [a, b, c, d]
    else
      {:error, "No Hamming face formed by #{a}, #{b}, #{c}"}
    end
  end

  @spec hamming_face(integer, integer)
    :: [integer]
     | {:error, String.t}
  def hamming_face(a, d) do
    case hamming_distance(a, d) do
      h when h == 2 ->
        difference = bxor(a, d)

        [low_bit|_tail] =
          [ band(difference, difference >>> 1),
            band(difference, a),
            band(difference, d),
          ] |> Enum.filter(& &1 != 0)

        [a, bxor(low_bit, a), bxor(low_bit, d), d]

      h when h < 2 ->
        {:error, "No unique Hamming face for #{a}, #{d}"}

      h when h > 2 ->
        {:error, "No Hamming face shared by #{a}, #{d}"}
    end
  end

  @spec hamming_distance_histogram([integer], integer)
    :: %{non_neg_integer => [integer]}
  def hamming_distance_histogram(p_list, q \\ 0),
    do: Enum.group_by(p_list, &hamming_distance(q, &1))

  def longest_matching_prefix(p, q) do
    dimension =
      [p, q]
      |> Enum.map(&bits/1)
      |> Enum.max

    p_bits = Math.expand(p, 2, dimension)
    q_bits = Math.expand(q, 2, dimension)

    p_bits
    |> Stream.zip(q_bits)
    |> Enum.reduce_while([], fn
      ({b, b}, acc) -> {:cont, [b|acc]}
      ({_, _}, acc) -> {:halt,    acc }
    end)
    |> Enum.reverse
  end

  def tree_distance(p, q) do
    dimension = max(bits(p), bits(q))

    common_prefix_length =
      length longest_matching_prefix(p, q)

    2 * (dimension - common_prefix_length)
  end

  def tree_distance_histogram(p_list, q \\ 0),
    do: Enum.group_by(p_list, &tree_distance(q, &1))
end
