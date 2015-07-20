# Copyright © 2015 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule Math.Binary do
  use Bitwise

  @spec pow2(integer) :: pos_integer
  def pow2(exponent) do
    :math.pow(2, exponent) |> trunc
  end

  defp _bits(num, {exponent, bit_value}) when bit_value > num do
    exponent
  end
  defp _bits(num, {exponent, bit_value}) when bit_value <= num do
    _bits num, {exponent + 1, bit_value * 2}
  end

  @spec bits(integer) :: non_neg_integer
  def bits(num) do
    _bits num, {0, 1}
  end

  @spec choose_bits(pos_integer, pos_integer) :: [non_neg_integer]
  def choose_bits(n, k) do
    0..(n - 1)
    |> Enum.to_list
    |> Math.Combinatorial.choose(k)
    |> Enum.map(fn exponents ->
      Enum.reduce(exponents, 0, fn(exponent, acc) ->
        pow2(exponent) + acc
      end)
    end)
  end

  defp _ones({0, acc}) do
    acc
  end
  defp _ones({val, acc}) do
    {bsr(val, 1), rem(val, 2) + acc} |> _ones
  end

  @spec ones(integer) :: non_neg_integer
  def ones(num) do
    {num, 0} |> _ones
  end

  @spec euclidean_norm(integer) :: float
  def euclidean_norm(num) do
    num |> ones |> :math.sqrt
  end

  @spec hamming_weight(integer) :: non_neg_integer
  def hamming_weight(num) do
    ones(num)
  end

  @spec hamming_distance(integer, integer) :: non_neg_integer
  def hamming_distance(p, q) do
    bxor(p, q) |> ones
  end

  @spec hamming_shell(integer, pos_integer, pos_integer) :: [non_neg_integer]
  def hamming_shell(center, radius, dimensions) do
    for choose <- choose_bits(dimensions, radius) do
      bxor(center, choose)
    end
  end

  @spec hamming_sphere(integer, pos_integer, pos_integer) :: list
  def hamming_sphere(center, radius, dimensions) do
    1..radius
    |> Enum.to_list
    |> Enum.reduce([center], fn(r, acc) ->
      acc ++ hamming_shell(center, r, dimensions)
    end)
  end

  @spec hamming_face?(integer, integer, integer) :: boolean
  def hamming_face?(a, b, c) do
    [a, b, c]
    |> Math.Combinatorial.choose(2)
    |> Enum.map(fn [p, q] -> hamming_distance(p, q) end)
    |> Math.Combinatorial.permute
    |> Enum.member?([1, 1, 2])
  end

  @spec hamming_face(integer, integer, integer) :: [integer] | {:error, String.t}
  def hamming_face(a, b, c) do
    if hamming_face?(a, b, c) do
      d = a |> bxor(b) |> bxor(c)

      [a, b, c, d]
    else
      {:error, "No Hamming face formed by #{a}, #{b}, #{c}"}
    end
  end
  @spec hamming_face(integer, integer) :: [integer] | {:error, String.t}
  def hamming_face(a, d) do
    case hamming_distance(a, d) do
      h when h == 2 ->
        difference = bxor(a, d)

        [low_bit|_tail] = [
          band(difference, difference >>> 1),
          band(difference, a), band(difference, d)
        ] |> Enum.filter(&(&1 != 0))

        [a, bxor(low_bit, a), bxor(low_bit, d), d]
      h when h < 2 ->
        {:error, "No unique Hamming face for #{a}, #{d}"}
      h when h > 2 ->
        {:error, "No Hamming face shared by #{a}, #{d}"}
    end
  end

  @spec hamming_distance_histogram([integer], integer) :: %{non_neg_integer => [integer]}
  def hamming_distance_histogram(p_list, q \\ 0) do
    Enum.group_by(p_list, &hamming_distance(q, &1))
  end
end

