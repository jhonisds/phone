defmodule Pos do
  @moduledoc """
  Documentation for `Pos`.
  Pos module for create calls and maganer the cost.
  """
  defstruct value: 0

  @price_minute 1.40

  def do_call(number, date, duration) do
    Subscribe.get_number(number, :pos)
    |> Call.register(date, duration)

    {:ok, "Call success. Duration #{duration} minuts."}
  end

  def print(month, year, number) do
    subscribe = Accounts.print(month, year, number, :pos)

    total =
      subscribe.call
      |> Enum.map(&(&1.duration * @price_minute))
      |> Enum.sum()

    %Subscribe{subscribe | plan: %__MODULE__{value: total}}
  end
end
