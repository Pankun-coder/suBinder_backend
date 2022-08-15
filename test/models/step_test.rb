require "test_helper"

class StepTest < ActiveSupport::TestCase
  def setup
    @group = Group.create(name: "example group", password: "abc123", password_confirmation: "abc123")
    @course = @group.courses.create(name: "example course")
    @step = @course.steps.new(name: "example step", step_order: 0)
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

  test "step shold not save with name already used in course" do
    @step.name = "identical name"
    @step.save
    another_step = @course.steps.new(name: "identical name", step_order: 1)
    assert_not another_step.save, "step saved with not distinct name in course"
  end

  test "step name uniqueness must be forced in same course" do
    @step.name = "identical name"
    @step.save
    another_course = @group.courses.create(name: "another course")
    another_step = another_course.steps.new(name: "identical name", step_order: 0)
    assert another_step.save, "step did not saved with distinct step_order only in group"
  end

  test "step_order should be auto-filled if not given" do
    @step.save
    another_step = @course.steps.create(name: "another step")
    assert another_step.step_order == @step.step_order + 1, "autfilling step_order seems not working correctly"
  end

  test "step_order should be distinct in course" do
    @step.save
    another_step = @course.steps.new(name: "another step", step_order: 0)
    assert_not another_step.save, "step saved with not distinct step_order in course"
  end
end
