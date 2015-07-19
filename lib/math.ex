defmodule Math do
  @spec mod(integer, non_neg_integer) :: non_neg_integer
  @spec mod(integer, neg_integer) :: neg_integer | 0
  def mod(_, 0) do
    raise ArgumentError, message: "Cannot accept zero modulus"
  end
  def mod(integer, modulus) do
    trunc(integer - modulus * Float.floor(integer / modulus))
  end
end
