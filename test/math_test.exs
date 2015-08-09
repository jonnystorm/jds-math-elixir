defmodule MathTest do
  use ExUnit.Case, async: true

  import Math

  test "mod(x, 0) raises error" do
    assert_raise ArgumentError, fn -> mod(1, 0) end
  end
  test "mod(x, modulus) returns 0 when x is 0" do
    assert mod(0, 2) == 0
  end
  test "mod(x, modulus) returns 0 when modulus is 1" do
    assert mod(2, 1) == 0
  end
  test "mod(x, modulus) returns 0 when modulus is -1" do
    assert mod(2, -1) == 0
  end
  test "mod(x, modulus) returns 0 for an x equal to the modulus" do
    assert mod(2, 2) == 0
  end
  test "mod(x, modulus) returns 0 for an x equal to the modulus when x is negative" do
    assert mod(-2, 2) == 0
  end
  test "mod(x, modulus) returns 0 for an x equal to the modulus when the modulus is negative" do
    assert mod(2, -2) == 0
  end
  test "mod(x, modulus) returns x for a modulus greater than x" do
    assert mod(1, 2) == 1
  end

  test "raises error when expanding with zero base" do
    assert_raise ArgumentError, fn -> expand(1, 0) end
  end
  test "expands 0 to [0]" do
    assert expand(0) == [0]
  end
  test "expands 1020 to [1, 0, 2, 0]" do
    assert expand(1020, 10) == [1, 0, 2, 0]
  end
  test "expands 0b1010 to [1, 0, 1, 0]" do
    assert expand(0b1010, 2) == [1, 0, 1, 0]
  end
  test "expands 0 to [0, 0, 0, 0] when dimension is 4" do
    assert expand(0, 10, 4) == [0, 0, 0, 0]
  end

  test "raises error when collapsing with zero base" do
    assert_raise ArgumentError, fn -> collapse([1], 0) end
  end
  test "collapses [1, 0, 2, 0] to 1020" do
    assert collapse([1, 0, 2, 0], 10) == 1020
  end
  test "collapses [1, 0, 1, 0] (base 2) to 10" do
    assert collapse([1, 0, 1, 0], 2) == 10
  end
end
