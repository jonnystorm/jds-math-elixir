# Copyright © 2015 Jonathan Storm <the.jonathan.storm@gmail.com>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING.WTFPL file for more details.

defmodule Math.Information do
  def log_2(num) do
    :math.log(num) / :math.log(2)
  end

  defp count_characters(binary) do
    binary
    |> :binary.bin_to_list
    |> Enum.group_by(&(&1))
    |> Enum.map(fn {key, list} -> {key, length list} end)
  end

  def shannon_entropy(binary) do
    binary
    |> count_characters
    |> Enum.map(fn {char, count} -> {char, count / byte_size binary} end)
    |> Enum.map(fn {_, probability} -> probability * log_2(probability) end)
    |> Enum.sum
    |> (fn s -> -s end).()
  end
end
