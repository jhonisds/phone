defmodule Accounts do
  @moduledoc """
  Documentation for module `Accounts`
  """

  def print(month, year, number, plan) do
    subscriber = Subscribe.get_number(number)
    call_by_month = get_elements(subscriber.call, month, year)

    cond do
      plan == :pre ->
        recharge = get_elements(subscriber.plan.recharge, month, year)
        plan = %Pre{subscriber.plan | recharge: recharge}
        %Subscribe{subscriber | call: call_by_month, plan: plan}

      plan == :pos ->
        %Subscribe{subscriber | call: call_by_month}
    end
  end

  def get_elements(elements, month, year) do
    elements
    |> Enum.filter(&(&1.date.year == year && &1.date.month == month))
  end
end
