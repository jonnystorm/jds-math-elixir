defmodule MathTest do
  use ExUnit.Case, async: true

  import Math

  test "mod(x, 0) raises error" do
    x = 1

    assert_raise ArgumentError, fn -> mod(x, 0) end
  end
  test "mod(0, m) = 0" do
    m = 2

    assert mod(0, m) == 0
  end
  test "mod(x, 1) = 0" do
    x = 2

    assert mod(x, 1) == 0
  end
  test "mod(x, -1) = 0" do
    x = 2

    assert mod(x, -1) == 0
  end
  test "mod(x, x) = 0" do
    x = 2

    assert mod(x, x) == 0
  end
  test "mod(-x, x) = 0" do
    x = 2

    assert mod(-x, x) == 0
  end
  test "mod(x, -x) = 0" do
    x = 2

    assert mod(x, -x) == 0
  end
  test "mod(x, m) = x when 0 < x < m" do
    x = 1
    m = 2

    assert 0 < x
    assert     x < m
    assert mod(x, m) == x
  end
  test "-m < mod(x, m) < 0 when -m < x < 0" do
    x = -1
    m = 4

    result = mod(x, m)

    assert -m < x
    assert      x < 0
    assert -m < result
    assert      result < 0
    assert result == x
  end

  test "positive_mod(x, 0) raises error" do
    x = 1

    assert_raise ArgumentError, fn -> positive_mod(x, 0) end
  end
  test "positive_mod(0, m) = 0" do
    m = 2

    assert positive_mod(0, m) == 0
  end
  test "positive_mod(x, 1) = 0" do
    x = 2

    assert positive_mod(x, 1) == 0
  end
  test "positive_mod(x, -1) = 0" do
    x = 2

    assert positive_mod(x, -1) == 0
  end
  test "positive_mod(x, x) = 0" do
    x = 2

    assert positive_mod(x, x) == 0
  end
  test "positive_mod(-x, x) = 0" do
    x = 2

    assert positive_mod(-x, x) == 0
  end
  test "positive_mod(x, -x) = 0" do
    x = 2

    assert positive_mod(x, -x) == 0
  end
  test "positive_mod(x, m) = x when 0 < x < m" do
    x = 1
    m = 2

    assert 0 < x
    assert     x < m
    assert positive_mod(x, m) == x
  end
  test "0 < positive_mod(x, m) < m when -m < x < 0" do
    x = -1
    m = 4

    result = positive_mod(x, m)

    assert -m < x
    assert      x < 0
    assert 0 < result
    assert     result < m
    assert result == 3
  end

  test "pow(0, 0) = 1" do
    assert pow(0, 0) == 1
  end
  test "pow(x, 0) = 1" do
    x = 42

    assert pow(x, 0) == 1
  end
  test "pow(-x, 0) = 1" do
    x = 42

    assert pow(-x, 0) == 1
  end
  test "pow(0, x) = 0" do
    x = 42

    assert pow(0, x) == 0
  end
  test "pow(x, -y) raises error" do
    assert_raise ArgumentError, fn -> pow(2, -42) end
  end
  test "pow(0, -y) raises error" do
    assert_raise ArgumentError, fn -> pow(0, -42) end
  end
  test "pow(-x, -y) raises error" do
    assert_raise ArgumentError, fn -> pow(-2, -42) end
  end
  test "pow(x, y) raises error when x is a float" do
    assert_raise FunctionClauseError, fn -> pow(2.0, 42) end
  end
  test "pow(x, y) raises error when y is a float" do
    assert_raise FunctionClauseError, fn -> pow(2, 42.0) end
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
  test "expands 0b1000 to [1, 0, 0, 0] when dimension is 4" do
    assert expand(0b1000, 2, 4) == [1, 0, 0, 0]
  end
  test "expanding 0b1000 with dimension 3 raises ArgumentError" do
    assert_raise ArgumentError, fn -> expand 0b1000, 2, 3 end
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
