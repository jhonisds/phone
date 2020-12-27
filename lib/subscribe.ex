defmodule Subscribe do
  @moduledoc """
  Documentation for `Subscribe`.
  Subscriber module for create `pre` and `pos` accounts.
  The main function in this module is `create/4`.
  """

  # Destruct
  defstruct name: nil, number: nil, document: nil, plan: nil, call: []

  # Module variable
  @sub %{:pre => "pre.txt", :pos => "pos.txt"}

  def create(name, number, document, :pre), do: create(name, number, document, %Pre{})
  def create(name, number, document, :pos), do: create(name, number, document, %Pos{})

  @doc """
  Function to create subscriber.

  ## Parameters

  - name: name
  - number: code number
  - document: document id
  - plan: :pre or :pos

  ## Examples

      iex> Subscribe.create("jhoni", "123", "123", :pre)
      {:ok, "Subscription jhoni successfully registred!"}

  """
  def create(name, number, document, plan) do
    case get_number(number) do
      nil ->
        subscriber = %__MODULE__{name: name, number: number, document: document, plan: plan}

        (read(get_plan(subscriber)) ++ [subscriber])
        |> :erlang.term_to_binary()
        |> write(get_plan(subscriber))

        {:ok, "Subscription #{name} successfully registred!"}

      _assing ->
        {:error, "Subscriber already exist!"}
    end
  end

  defp get_plan(subscriber) do
    case subscriber.plan.__struct__ == Pre do
      true -> :pre
      false -> :pos
    end
  end

  defp write(list, plan) do
    File.write(@sub[plan], list)
  end

  defp read(plan) do
    case File.read(@sub[plan]) do
      {:ok, result} ->
        result
        |> :erlang.binary_to_term()

      {:error, :ennoent} ->
        {:error, "Invalid file"}
    end
  end

  @doc """
  Function to returns a list of subscribers.

  ## Parameters

  - number: code number
  - key: optional `:all`, `:pre` or `:pos`

  ## Examples

      iex> Subscribe.get_number("123")
      nil

  """
  def get_number(number, key \\ :all), do: get_subscribe(number, key)

  defp get_subscribe(number, :pre), do: filter(list_pre(), number)
  defp get_subscribe(number, :pos), do: filter(list_pos(), number)
  defp get_subscribe(number, :all), do: filter(list_subscribe(), number)

  # Anonimous function
  # |> Enum.find(fn sub -> sub.number == number end)
  defp filter(list, number), do: Enum.find(list, &(&1.number == number))

  def list_subscribe(), do: read(:pre) ++ read(:pos)
  def list_pre(), do: read(:pre)
  def list_pos(), do: read(:pos)

  def delete(number) do
    {subscriber, new_list} = delete_item(number)

    new_list
    |> :erlang.term_to_binary()
    |> write(get_plan(subscriber))

    {:ok, "Subscriber #{subscriber.name} removed!"}
  end

  def delete_item(number) do
    subscriber = get_number(number)

    new_list =
      read(get_plan(subscriber))
      |> List.delete(subscriber)

    {subscriber, new_list}
  end

  def update(number, sub) do
    {sub_old, new_list} = delete_item(number)

    case sub.plan.__struct__ == sub_old.plan.__struct__ do
      true ->
        (new_list ++ [sub])
        |> :erlang.term_to_binary()
        |> write(get_plan(sub))

      false ->
        {:error, "Not allow to update plan."}
    end
  end
end
