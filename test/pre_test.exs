defmodule PreTest do
  use ExUnit.Case
  doctest Pre

  @files ["pos.txt", "pre.txt"]

  setup do
    @files
    |> Enum.map(&File.write(&1, :erlang.term_to_binary([])))

    on_exit(fn ->
      @files
      |> Enum.map(&File.rm(&1))
    end)
  end

  describe "call/0" do
    test "return struct for call" do
      expected = %Pre{credits: 0, recharge: []}
      assert expected == %Pre{}
    end

    test "make call" do
      Subscribe.create("test", "123", "123", :pre)
      Recharge.new(DateTime.utc_now(), 10, "123")

      expected = {:ok, "This call cost: $4.35. Your current credit: $5.65"}
      result = Pre.do_call("123", DateTime.utc_now(), 3)

      assert expected == result
    end

    test "make call with no credits" do
      Subscribe.create("test", "123", "123", :pre)

      expected = {:error, "You don't have enough credits, make a recharge."}
      result = Pre.do_call("123", DateTime.utc_now(), 10)

      assert expected == result
    end
  end

  describe "print/3" do
    test "return values by month" do
      Subscribe.create("test", "123", "123", :pre)
      date = DateTime.utc_now()
      Recharge.new(date, 10, "123")
      Pre.do_call("123", date, 3)

      result = Pre.print(date.month, date.year, "123")

      assert "123" == result.number
      assert 1 == Enum.count(result.call)
      assert 1 == Enum.count(result.plan.recharge)
    end
  end
end
