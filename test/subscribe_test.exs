defmodule SubscribeTest do
  use ExUnit.Case
  doctest Subscribe

  @files ["pos.txt", "pre.txt"]

  setup do
    Enum.map(@files, &File.write(&1, :erlang.term_to_binary([])))

    on_exit(fn ->
      Enum.map(@files, &File.rm(&1))
    end)
  end

  describe "create/4" do
    test "returns struct" do
      expected = %Subscribe{name: nil, number: nil, document: nil, plan: nil}

      assert expected === %Subscribe{}
    end

    test "create pre account" do
      subscribe = Subscribe.create("teste", "1", "1", :pre)
      expected = {:ok, "Subscription teste successfully registred!"}

      assert expected === subscribe
    end

    test "returns error when subscriber already exists" do
      Subscribe.create("teste", "123", "123", :pre)

      subscribe = Subscribe.create("teste", "123", "123", :pre)
      expected = {:error, "Subscriber already exist!"}

      assert expected == subscribe
    end
  end

  describe "get_number/2" do
    test "returns list of pre" do
      Subscribe.create("teste", "123", "123", :pre)
      expected = "teste"
      plan_type = Pre

      assert expected == Subscribe.get_number("123", :pre).name
      assert plan_type == Subscribe.get_number("123", :pre).plan.__struct__
    end

    test "returns list of pos" do
      Subscribe.create("teste", "123", "123", :pos)
      expected = "123"

      assert expected == Subscribe.get_number("123", :pos).number
    end
  end

  describe "delete/1" do
    test "remove the subscriber" do
      Subscribe.create("test", "123", "123", :pre)
      expected = {:ok, "Subscriber test removed!"}

      assert expected === Subscribe.delete("123")
    end
  end
end
