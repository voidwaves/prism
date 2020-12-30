defmodule PrismTest do
  use ExUnit.Case

  test "completes without errors" do
    {status, _} = Prism.example()
    assert(status == :ok)
  end
end
