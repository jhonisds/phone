defmodule Pre do
  @moduledoc """
  Documentation for `Pre`.
  Pre module for create calls and maganer the cost.
  """
  defstruct credits: 0, recharge: []

  @price_minute 1.45

  def do_call(number, date, duration) do
    sub = Subscribe.get_number(number, :pre)

    cost = @price_minute * duration

    cond do
      cost <= sub.plan.credits ->
        plan = %__MODULE__{sub.plan | credits: sub.plan.credits - cost}

        %Subscribe{sub | plan: plan}
        |> Call.register(date, duration)

        {:ok, "This call cost: $#{cost}. Your current credit: $#{plan.credits}"}

      true ->
        {:error, "You don't have enough credits, make a recharge."}
    end
  end

  def print(month, year, number) do
    Accounts.print(month, year, number, :pre)
  end
end
