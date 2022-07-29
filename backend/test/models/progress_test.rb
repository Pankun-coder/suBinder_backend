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

  test "progress should not save with identical student and identical step" do
    progresses(:one).save
    assert_not Progress.new(student: progresses(:one).student, step: progresses(:one).step).save, "progress saved with identical student and identical step"
  end
end
