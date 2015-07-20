defmodule Math do
  @spec mod(integer, non_neg_integer) :: non_neg_integer
  @spec mod(integer, neg_integer) :: neg_integer | 0
  def mod(_, 0) do
    raise ArgumentError, message: "Cannot accept zero modulus"
  end
  def mod(integer, modulus) do
    trunc(integer - modulus * Float.floor(integer / modulus))
  end

  def _expand_decimal_to_positional_elements(0, _base, acc) do
    acc
  end
  def _expand_decimal_to_positional_elements(decimal, base, acc) do
    digit = rem(decimal, base)
    new_decimal = div(decimal - digit, base)

    _expand_decimal_to_positional_elements(new_decimal, base, [digit|acc])
  end
  def expand_decimal_to_positional_elements(decimal, base \\ 10) do
    _expand_decimal_to_positional_elements(decimal, base, [])
  end
end
