defmodule RechargeTest do
  use ExUnit.Case
  doctest Recharge

  @files ["pos.txt", "pre.txt"]

  setup do
    @files
    |> Enum.map(&File.write(&1, :erlang.term_to_binary([])))

    on_exit(fn ->
      @files
      |> Enum.map(&File.rm(&1))
    end)
  end

  describe "new/3" do
    test "returns struct for recharge" do
      expected = %Recharge{date: nil, value: nil}

      assert expected == %Recharge{}
    end

    test "returns success when making recharge" do
      Subscribe.create("test", "123", "123", :pre)

      expected = {:ok, "Recharge successful"}
      {:ok, result} = Recharge.new(DateTime.utc_now(), 30, "123")
      plan = Subscribe.get_number("123", :pre).plan

      assert expected == {:ok, result}
      assert 30 == plan.credits
      assert 1 == Enum.count(plan.recharge)
    end
  end
end
