defmodule ZigNifTest do
  use ExUnit.Case

  test "add works" do
    assert ZigNif.add(1, 2) == 3
    assert ZigNif.add(2, 1) == 3
    assert ZigNif.add(1, 1) == 2
  end
end
