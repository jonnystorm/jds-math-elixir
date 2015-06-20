defmodule Information do
  defp log_2(num) do
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
