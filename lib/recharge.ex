defmodule Recharge do
  @moduledoc """
  Documentation for module `Recharge`
  """
  defstruct date: nil, value: nil

  def new(date, value, number) do
    subscribe = Subscribe.get_number(number, :pre)
    plan = subscribe.plan

    plan = %Pre{
      plan
      | credits: plan.credits + value,
        recharge: plan.recharge ++ [%__MODULE__{date: date, value: value}]
    }

    subscribe = %Subscribe{subscribe | plan: plan}
    Subscribe.update(number, subscribe)
    {:ok, "Recharge successful"}
  end
end
