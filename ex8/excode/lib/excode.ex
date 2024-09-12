defmodule Excode do
  @moduledoc """
  Documentation for `Excode`.
  """

  # Same name, different ariety, good practice
  defp fact(1, k), do: k
  defp fact(n, k), do: fact(n - 1, k * n)

  @doc """
  Factorial function, only integer values are allowed.
  """
  def fact(n) when is_integer(n) do
    fact(n, 1)
  end

  defp pow(1, _, k), do: k
  defp pow(n, m, k), do: pow(n - 1, m, k * m)

  @doc """
  pow function. Arguments must be inegers
  """
  def pow(n, m) when is_integer(n) and is_integer(m), do: pow(n, m, m)

  defp minl([], k), do: k
  defp minl([h | t], :none), do: minl(t, h)
  defp minl([h | t], k) when h < k, do: minl(t, h)
  defp minl([_ | t], k), do: minl(t, k)

  @doc """
  Compute the minimum element of a list
  """
  def minl(l) when is_list(l), do: minl(l, :none)

  defp compn([], []), do: :eq
  defp compn([h1 | t1], [h1 | t2]), do: compn(t1, t2)
  defp compn(_, _), do: :neq

  defp compbn(<<>>, <<>>), do: :eq
  defp compbn(<<h, t1::binary>>, <<h, t2::binary>>), do: compbn(t1, t2)
  defp compbn(_, _), do: :neq

  @doc """
  List comparison function
  """
  def comp(l1, l2) when is_list(l1) and is_list(l2), do: compn(l1, l2)
  def comp(b1, b2) when is_binary(b1) and is_binary(b2), do: compbn(b1, b2)

  defp vec_prodp([], []), do: []
  defp vec_prodp([h1 | t1], [h2 | t2]), do: [h1 * h2 | vec_prodp(t1, t2)]

  defp vec_prod(l1, l2) when is_list(l1) and is_list(l2) and length(l1) == length(l2),
    do: vec_prodp(l1, l2)

  defp dot_prod([], [], k), do: k
  defp dot_prod([h1 | t1], [h2 | t2], k), do: dot_prod(t1, t2, k + h1 * h2)

  defp dot_prod(l1, l2) when is_list(l1) and is_list(l2) and length(l1) == length(l2),
    do: dot_prod(l1, l2, 0)

  defp i_prod({a, b}, {c, d}), do: {a * c - b * d, a * d + b * c}
  defp i_sum({a, b}, {c, d}), do: {a + c, b + d}
  defp i_diff({a, b}, {c, d}), do: {a - c, b - d}

  # dispatch for basic operations
  defp times(a, b) when is_number(a) and is_number(b), do: a * b
  defp times(a, b) when is_list(a) and is_list(b), do: vec_prod(a, b)
  defp times(a, b) when is_tuple(a) and is_tuple(b), do: i_prod(a, b)

  defp sum(a, b) when is_integer(a) and is_integer(b), do: a + b
  defp sum(a, b) when is_tuple(a) and is_tuple(b), do: i_sum(a, b)

  defp diff(a, b) when is_integer(a) and is_integer(b), do: a - b
  defp diff(a, b) when is_tuple(a) and is_tuple(b), do: i_diff(a, b)

  # Operation tree
  defp eval({:+, a, b}), do: sum(eval(a), eval(b))
  defp eval({:*, a, b}), do: times(eval(a), eval(b))
  defp eval({:-, a, b}), do: diff(eval(a), eval(b))
  defp eval({:!, a}), do: a |> eval |> fact
  defp eval({:^, a, b}), do: pow(eval(a), eval(b))
  defp eval({:., a, b}), do: dot_prod(eval(a), eval(b))

  # basic types
  defp eval(v) when is_integer(v), do: v
  defp eval(v) when is_list(v), do: v
  # imaginary numbers
  defp eval({a, b}), do: {a, b}

  @doc """
  Polish notation calculator
  """
  def calc(tree) when is_tuple(tree), do: eval(tree)

  def put(map, [key | []], val) do
    Map.put(map, key, val)
  end

  def put(map, [key | sub], val) do
    Map.put(map, key, put(Map.get(map, key, %{}), sub, val))
  end

  def to_map(list) do
    Enum.reduce(list, %{}, fn {path, val}, acc ->
      put(acc, String.split(path, "/", trim: true), val)
    end)
  end

  def zipsort([], l), do: l
  def zipsort(l, []), do: l
  def zipsort([h1 | t1], [h1 | t2]), do: [h1, h1] ++ zipsort(t1, t2)
  def zipsort([h1 | t1], [h2 | t2]) when h1 < h2, do: [h1, h2] ++ zipsort(t1, t2)
  def zipsort([h1 | t1], [h2 | t2]), do: [h2, h1] ++ zipsort(t1, t2)
end
