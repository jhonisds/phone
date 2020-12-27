defmodule Phone do
  @moduledoc """
  Documentation for `Phone`.
  """

  @doc """
  Create files.

  ## Examples

      iex> Phone.start()
      [:ok, :ok]

  """
  def start do
    # Using capture function.
    ["pos.txt", "pre.txt"]
    |> Enum.map(&File.write(&1, :erlang.term_to_binary([])))
  end

  @doc """
  Create assign

  ## Examples

      iex> Phone.create_subscribe("jhoni", "123", "123", :pre)
      {:ok, "Subscription jhoni successfully registred!"}

  """
  def create_subscribe(name, number, document, plan) do
    Subscribe.create(name, number, document, plan)
  end

  def list_subscribe, do: Subscribe.list_subscribe()
  def list_subscribe_pre, do: Subscribe.list_pre()
  def list_subscribe_pos, do: Subscribe.list_pos()

  def do_call(number, plan, date, duration) do
    cond do
      plan == :pre -> Pre.do_call(number, date, duration)
      plan == :pos -> Pos.do_call(number, date, duration)
    end
  end

  def recharge(number, date, value), do: Recharge.new(date, value, number)

  def get_by_number(number, plan \\ :all), do: Subscribe.get_number(number, plan)

  def print(month, year) do
    Subscribe.list_pre()
    |> Enum.each(fn sub ->
      sub = Pre.print(month, year, sub.number)
      IO.puts("Account subscribe: #{sub.name}")
      IO.puts("Number: #{sub.number}")
      IO.puts("Calls:")
      IO.inspect(sub.call)
      IO.puts("Recharge:")
      IO.inspect(sub.plan.recharge)
      IO.puts("Total calls: #{Enum.count(sub.call)}")
      IO.puts("Total recharge: #{Enum.count(sub.plan.recharge)}")
      IO.puts("======================================")
    end)

    Subscribe.list_pos()
    |> Enum.each(fn sub ->
      sub = Pos.print(month, year, sub.number)
      IO.puts("Account subscribe: #{sub.name}")
      IO.puts("Number: #{sub.number}")
      IO.puts("Calls:")
      IO.inspect(sub.call)
      IO.puts("Total calls: #{Enum.count(sub.call)}")
      IO.puts("Total value: #{sub.plan.value}")
      IO.puts("======================================")
    end)
  end
end
