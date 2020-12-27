defmodule PhoneTest do
  use ExUnit.Case
  doctest Phone

  @files ["pos.txt", "pre.txt"]

  setup do
    @files
    |> Enum.map(&File.write(&1, :erlang.term_to_binary([])))

    on_exit(fn ->
      @files
      |> Enum.map(&File.rm(&1))
    end)
  end

  describe "start/0" do
    test "create files" do
      expected = [:ok, :ok]

      assert expected == Phone.start()
    end
  end

  describe "create_subscribe/4" do
    test "returns the subscribe created" do
      subscribe = Phone.create_subscribe("teste", "1234", "1234", :pre)
      expected = {:ok, "Subscription teste successfully registred!"}

      assert expected == subscribe
    end
  end

  describe "list_subscribe/0" do
    test "returns all subscriber" do
      Phone.create_subscribe("teste", "1", "123", :pre)
      Phone.create_subscribe("teste", "2", "123", :pos)

      result = [
        Subscribe.get_number("1"),
        Subscribe.get_number("2")
      ]

      expected = Phone.list_subscribe()

      assert expected == result
      assert 2 == Enum.count(result)
    end

    test "returns pre subscriber" do
      Phone.create_subscribe("teste", "1", "123", :pre)
      Phone.create_subscribe("teste", "2", "123", :pre)
      Phone.create_subscribe("teste", "3", "123", :pre)

      result = [
        Subscribe.get_number("1"),
        Subscribe.get_number("2"),
        Subscribe.get_number("3")
      ]

      expected = Phone.list_subscribe_pre()

      assert expected == result
      assert 3 == Enum.count(result)
    end

    test "returns pos subscriber" do
      Phone.create_subscribe("teste", "1", "123", :pos)

      result = [
        Subscribe.get_number("1")
      ]

      expected = Phone.list_subscribe_pos()

      assert expected == result
      assert 1 == Enum.count(result)
    end
  end

  describe "do_call/3" do
    test "returns pre call" do
      Phone.create_subscribe("teste", "1", "123", :pre)
      Recharge.new(DateTime.utc_now(), 10, "1")

      expected = Phone.do_call("1", :pre, DateTime.utc_now(), 5)
      result = {:ok, "This call cost: $7.25. Your current credit: $2.75"}

      assert expected == result
    end

    test "returns pos call" do
      Phone.create_subscribe("teste", "1", "123", :pos)

      expected = Phone.do_call("1", :pos, DateTime.utc_now(), 5)
      result = {:ok, "Call success. Duration 5 minuts."}

      assert expected == result
    end
  end

  describe "recharge/3" do
    test "returns recharge" do
      Phone.create_subscribe("teste", "1", "123", :pre)

      expected = Phone.recharge("1", DateTime.utc_now(), 100)
      result = {:ok, "Recharge successful"}

      assert expected == result
    end
  end

  describe "get_by_number/2" do
    test "returns subscriber by number" do
      Phone.create_subscribe("teste", "1", "123", :pre)
      expected = Phone.get_by_number("1")

      result = %Subscribe{
        call: [],
        document: "123",
        name: "teste",
        number: "1",
        plan: %Pre{credits: 0, recharge: []}
      }

      assert expected == result
    end
  end

  describe "print/2" do
    test "returns print of subscriber" do
      Phone.create_subscribe("teste", "1", "123", :pre)
      Phone.create_subscribe("teste", "2", "123", :pos)

      expected = Phone.print(12, 2020)
      result = Pre.print(12, 2020, "1")

      assert expected == :ok
      assert "1" == result.number
    end
  end
end
