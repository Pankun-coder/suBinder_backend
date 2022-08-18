require "test_helper"

class StepTest < ActiveSupport::TestCase
  def setup
    @group = groups(:one)
    @course = courses(:one)
    @step = @course.steps.new(name: "example step", step_order: @course.steps.length)
  end

  test "set-up step should save" do
    assert @step.save, "set-up step did not save"
  end

  test "step should not save without course" do
    @step.course = nil
    assert_not @step.save, "step saved without course"
  end

  test "step shold not save without name" do
    @step.name = nil
    assert_not @step.save, "step saved without name"
  end

  test "step_order should be auto-filled if not given" do
    @step.save
    another_step = @course.steps.create(name: "another step")
    assert another_step.step_order == @step.step_order + 1, "autfilling step_order seems not working correctly"
  end

  test "step_order should be distinct in course" do
    @step.save
    another_step = @course.steps.new(name: "another step", step_order: @step.step_order)
    assert_not another_step.save, "step saved with not distinct step_order in course"
  end
end
