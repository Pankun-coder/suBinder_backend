require "test_helper"

class ProgressTest < ActiveSupport::TestCase
  test "fixture progress should save" do
    assert progresses(:one).save, "set-up progress did not save"
  end

  test "progress should not save without step" do
    progresses(:one).step = nil
    assert_not progresses(:one).save, "progress saved without step"
  end

  test "progress should not save without student" do
    progresses(:one).student = nil
    assert_not progresses(:one).save, "progress saved without student"
  end

  test "progress should not save without is_completed" do
    progresses(:one).is_completed = nil
    assert_not progresses(:one).save, "progress saved without is_completed info"
  end
end
