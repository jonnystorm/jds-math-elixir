# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

defmodule Math do
  use Bitwise

  @spec mod(0, integer) :: 0
  @spec mod(pos_integer, pos_integer) :: pos_integer
  @spec mod(neg_integer, pos_integer) :: pos_integer
  @spec mod(pos_integer, neg_integer) :: neg_integer
  @spec mod(neg_integer, neg_integer) :: neg_integer
  def mod(_, 0) do
    raise ArgumentError,
      message: "Cannot accept zero modulus"
  end

  def mod(0, _),              do: 0
  def mod(x, x),              do: 0
  def mod(x, y) when x == -y, do: 0

  def mod(integer, modulus) when modulus > 0,
    do: rem(integer, modulus)

  def mod(integer, modulus) when modulus < 0,
    do: -1 * rem(integer, modulus)

  @spec positive_mod(0, integer) :: 0
  @spec positive_mod(pos_integer, integer) :: pos_integer
  @spec positive_mod(neg_integer, integer) :: pos_integer
  def positive_mod(_, 0) do
    raise ArgumentError,
      message: "Cannot accept zero modulus"
  end

  def positive_mod(0, _),              do: 0
  def positive_mod(x, x),              do: 0
  def positive_mod(x, y) when x == -y, do: 0

  def positive_mod(integer, modulus),
    do: rem(rem(integer, modulus) + modulus, modulus)

  defp _pow(_base, 0, acc),
    do: acc

  defp _pow(base, exponent, acc)
      when rem(exponent, 2) == 0,
    do: _pow(base * base, bsr(exponent, 1), acc)

  defp _pow(base, exponent, acc)
      when rem(exponent, 2) == 1,
    do: _pow(base * base, bsr(exponent, 1), acc * base)

  @spec pow(number, 0) :: 1
  @spec pow(0, pos_integer) :: 0
  @spec pow(pos_integer, pos_integer) :: pos_integer
  @spec pow(neg_integer, pos_integer) :: integer
  def pow(_, exponent)
      when exponent < 0
  do
    raise ArgumentError,
      message: "Cannot accept negative exponent"
  end
  def pow(0, 0), do: 1
  def pow(_, 0), do: 1
  def pow(0, _), do: 0
  def pow(base, exponent)
      when is_integer(base)
       and is_integer(exponent)
       and (base > 0)
       and (exponent > 0),
    do: _pow(base, exponent, 1)

  defp _expand_decimal_to_positional_elements(
    0,
    _base,
    []
  ), do: [0]
  defp _expand_decimal_to_positional_elements(
    0,
    _base,
    acc
  ), do: acc
  defp _expand_decimal_to_positional_elements(
    decimal,
    base,
    acc
  ) do
    digit       = rem(decimal, base)
    new_decimal = div(decimal - digit, base)

    _expand_decimal_to_positional_elements(
      new_decimal,
      base,
      [digit|acc]
    )
  end

  def expand_decimal_to_positional_elements(_, 0) do
    raise ArgumentError,
      message: "Cannot accept zero base"
  end

  def expand_decimal_to_positional_elements(decimal, 1) do
    List.duplicate(1, decimal)
  end

  def expand_decimal_to_positional_elements(
    decimal,
    base
  ) do
    _expand_decimal_to_positional_elements(
      decimal,
      base,
      []
    )
  end

  defp _collapse_positional_elements_to_decimal(
    [],
    _base,
    acc
  ), do: acc

  defp _collapse_positional_elements_to_decimal(
    [head|tail],
    base,
    acc
  ) do
    position = length tail
    value    = head * pow(base, position)

    _collapse_positional_elements_to_decimal(
      tail,
      base,
      value + acc
    )
  end

  def collapse_positional_elements_to_decimal(_, 0) do
    raise ArgumentError,
      message: "Cannot accept zero base"
  end

  def collapse_positional_elements_to_decimal(elements, 1)
  do
    length elements
  end

  def collapse_positional_elements_to_decimal(
    elements,
    base
  ) do
    _collapse_positional_elements_to_decimal(
      elements,
      base,
      0
    )
  end

  defp pad_list_head_with_zeros(list, size)
      when length(list) < size
  do
    pad = List.duplicate(0, size - length(list))

    List.flatten [pad|list]
  end

  defp pad_list_head_with_zeros(list, size)
      when length(list) == size,
    do: list

  def expand(decimal, base \\ 10)
  def expand(decimal, base),
    do: expand_decimal_to_positional_elements(decimal, base)

  def expand(decimal, base, dimension) do
    try do
      decimal
      |> expand_decimal_to_positional_elements(base)
      |> pad_list_head_with_zeros(dimension)

    rescue
      _ in FunctionClauseError ->
        raise ArgumentError,
          message: "Decimal expansion exceeds given dimension"
    end
  end

  def collapse(elements, base \\ 10) do
    collapse_positional_elements_to_decimal(elements, base)
  end
end
