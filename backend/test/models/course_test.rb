require "test_helper"

class CourseTest < ActiveSupport::TestCase
  def setup
    @group = Group.create(name: "example group", password: "abc123", password_confirmation: "abc123")
    @course = @group.courses.new(name: "test course")
  end

  test "set-up course should save" do
    assert @course.save, "set-up course did not save"
  end

  test "course should not save without group" do
    indepenent_course = Course.new(name: "independent course")
    assert_not indepenent_course.save, "course saved without group"
  end

  test "course should not save without name" do
    @course.name = nil
    assert_not @course.save, "course saved without name"
  end
  
  test "course's name should be unique in its group" do
    @course.name = "identical name"
    @course.save
    another_course = @group.courses.new(name: "identical name")
    assert_not another_course.save, "course saved with name already used in group"
  end

  test "course name uniqueness must be forced only in group" do
    @course.name = "identical name"
    @course.save
    another_group = Group.create(name: "another group", password: "abc123", password_confirmation: "abc123")
    another_course = another_group.courses.new(name: "identical name")
    assert another_course.save
  end
end
