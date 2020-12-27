defmodule PosTest do
  use ExUnit.Case
  doctest Pos

  @files ["pos.txt", "pre.txt"]

  setup do
    @files
    |> Enum.map(&File.write(&1, :erlang.term_to_binary([])))

    on_exit(fn ->
      @files
      |> Enum.map(&File.rm(&1))
    end)
  end

  describe "call/3" do
    test "return struct for call" do
      expected = %Pos{value: 0}
      assert expected == %Pos{}
    end

    test "make call" do
      Subscribe.create("test", "123", "123", :pos)

      expected = {:ok, "Call success. Duration 3 minuts."}
      result = Pos.do_call("123", DateTime.utc_now(), 3)

      assert expected == result
    end
  end

  describe "print/3" do
    test "return values by month" do
      Subscribe.create("test", "123", "123", :pos)
      date = DateTime.utc_now()
      Pos.do_call("123", date, 3)

      result = Pos.print(date.month, date.year, "123")

      assert "123" == result.number
      assert 1 == Enum.count(result.call)
      assert 4.199999999999999 == result.plan.value
    end
  end
end
