require "test_helper"

class ProgressTest < ActiveSupport::TestCase
  def setup
    @step = steps(:for_testing_progress)
    @student = students(:one)
    @progress = Progress.new(step: @step, student: @student, is_completed: false)
  end
  test "set-up progress should save" do
    assert @progress.save, "set-up progress did not save"
  end

  test "progress should not save without step" do
    @progress.step = nil
    assert_not @progress.save, "progress saved without step"
  end

  test "progress should not save without student" do
    @progress.student = nil
    assert_not @progress.save, "progress saved without student"
  end

  test "progress should not save without is_completed" do
    @progress.is_completed = nil
    assert_not @progress.save, "progress saved without is_completed info"
  end

  test "progress should not save with identical student and identical step" do
    @progress.save
    assert_not Progress.new(student: @progress.student, step: @progress.step).save, "progress saved with identical student and identical step"
  end
end
