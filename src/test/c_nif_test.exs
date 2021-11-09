defmodule CNifTest do
  use ExUnit.Case

  test "fast compare works" do
    assert CNif.fast_compare(1, 2) == -1
    assert CNif.fast_compare(2, 1) == 1
    assert CNif.fast_compare(1, 1) == 0
  end
end
