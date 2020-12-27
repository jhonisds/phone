defmodule Call do
  @moduledoc """
  Documentation for module `Call`.
  """

  defstruct date: nil, duration: nil

  def register(subscriber, date, duration) do
    sub_updated = %Subscribe{
      subscriber
      | call: subscriber.call ++ [%__MODULE__{date: date, duration: duration}]
    }

    subscriber = Subscribe.update(subscriber.number, sub_updated)
  end
end
