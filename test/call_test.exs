defmodule CallTest do
  use ExUnit.Case
  doctest Call

  describe "register/3" do
    test "returns fileds struct for call" do
      expected = %Call{date: nil, duration: nil}
      assert expected === %Call{}
    end

    test "returns duration for call" do
      expected = %Call{date: DateTime.utc_now(), duration: 30}.duration
      assert expected === 30
    end
  end
end
